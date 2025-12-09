#define MANA_POOL_REPLACE_ALL_ATTUNEMENTS (1<<2)

/// the lowest decimal place we round to during dispersion
/// keep this to one decimal place unless you know what you're doing because anything more causes tomfoolery and really ugly decimals
#define MANA_DECIMAL_FLOOR 0.1

/* DESIGN NOTES
* This exists because mana will eventually have attunemenents and alignments that will incresae their efficiency in being used
* on spells/by people with corresponding attunements/alignments, vice versa for conflicting.
*
*/

/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_pool
	var/atom/movable/parent = null

	// As attunements on mana is actually a tangible thing, and not just a preference, mana attunements should never go below zero.
	/// A abstract representation of the attunements of [amount]. This is just an abstraction of the overall bias of all stored mana - in reality, every Vol has its own attunement.
	var/list/datum/attunement/attunements

	// In vols
	/// The absolute maximum [amount] we can hold. Under no circumstances should [amount] ever exceed this value.
	var/maximum_mana_capacity = BASE_MANA_CAPACITY
	/// The abstract representation of how many "Vols" this mana pool currently contains.
	/// Capped at [maximum_mana_capacity], begins decaying exponentially when above [softcap].
	var/amount = 100 // placeholder. This should be replaced during process.
	/// The threshold at which mana begins decaying exponentially.
	// TODO: convert to some kind of list for multiple softcaps?
	var/softcap = BASE_MANA_SOFTCAP
	/// The divisor used in exponential decay when [amount] surpasses [softcap]. Lower = A steeper decay curve.
	var/exponential_decay_divisor = BASE_MANA_EXPONENTIAL_DIVISOR

	/// The maximum mana we can transfer per second. [donation_budget_per_tick] is set to this, times seconds_per_tick, every process tick.
	var/max_donation_rate_per_second = BASE_MANA_DONATION_RATE
	/// The maximum mana we can transfer for this tick. Is used to cap our mana output per tick. Calculated with [max_donation_rate_per_second] * seconds_per_tick.
	VAR_PROTECTED/donation_budget_this_tick = 149 // same with amount. this gets replaced on process.

	/// List of (mana_pool -> transfer rate)
	var/list/datum/mana_pool/transfer_rates = list()
	/// List of (mana_pool -> max mana we will give)
	var/list/datum/mana_pool/transfer_caps = list()
	/// List of (mana_pool -> mana_pool_process_bitflags). Holds pools we are transferring to.
	var/list/datum/mana_pool/transferring_to = list()
	/// List of mana_pools transferring to us
	var/list/datum/mana_pool/transferring_from = list()
	/// The priority method we will use to transfer mana to all that we are trying to transfer into. Uses defines from magic_charge_bitflags.dm
	var/transfer_method = MANA_SEQUENTIAL

	/// If true, if no cap is specified, we only go up to the softcap of the target when transferring
	var/transfer_default_softcap = TRUE

	/// The natural regen rate, detached from transferrals. Mana generated via this comes from nothing. Has nothing to do with the ethereal species.
	var/ethereal_recharge_rate = 0
	/// If we have an ethereal recharge rate,i ths is the attunement set that will be given to the generated mana.
	var/list/datum/attunement/attunements_to_generate = list()

	/// The mana pool types we will try to discharge excess mana (from exponential decay) into. Uses defines from magic_charge_bitflags.dm.
	var/discharge_destinations = MANA_ALL_LEYLINES
	/// The priority method we will use to transfer mana to [discharge_destination] mana pools. Any given type does not guarantee all destinations will receive mana if they are full.
	/// Uses defines from magic_charge_bitflags.dm.
	var/discharge_method = MANA_SEQUENTIAL

	/// The intrinsic sources of mana we will constantly try to draw from. Uses defines from magic_charge_bitflags.dm.
	var/intrinsic_recharge_sources = MANA_ALL_LEYLINES

	/// what ruleset do we need before we can transfer? flags in magic_bitflags.dm
	var/mana_transfer_ruleset = MANA_TRANSFER_ANARCHY

	/// used by MANA_TRANSFER_MANUAL_RULES so these do nothing unless you're using that transfer ruleset.
	/// and if so, what is that cap?
	var/cap_transfer_limit = 999

/datum/mana_pool/New(atom/parent = null)
	. = ..()
	donation_budget_this_tick = max_donation_rate_per_second
	set_parent(parent)

	update_intrinsic_recharge()

	START_PROCESSING(SSmagic, src)

/datum/mana_pool/Destroy(force, ...)
	attunements = null
	attunements_to_generate = null

	transfer_rates.Cut()
	transfer_caps.Cut()
	for (var/datum/mana_pool/pool_to_detach as anything in transferring_to)
		stop_transfer(pool_to_detach, TRUE)
	for (var/datum/mana_pool/pool_to_detach as anything in transferring_from)
		pool_to_detach.stop_transfer(src, TRUE)

	STOP_PROCESSING(SSmagic, src)

	if (parent.mana_pool != src)
		stack_trace("[parent].mana_pool was not [src] when src had parent registered!")
	else
		parent.mana_pool = null
	parent = null

	return ..()

/datum/mana_pool/proc/set_parent(atom/parent)
	src.parent = parent
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(mana_status_report))

/datum/mana_pool/proc/mana_status_report(datum/source, list/status_tab)
	SIGNAL_HANDLER

	var/general_amount_estimate
	var/sc_very_low = (softcap * 0.1)
	var/sc_low = (softcap * 0.3)
	var/sc_medium = (softcap * 0.6)
	var/sc_high = (softcap * 0.8)

	//determines what the status displays, it'll be a generic/non-obvious value as a design choice
	if(amount)
		if (amount <= sc_very_low)
			general_amount_estimate = "VERY LOW"
		else if (amount > sc_very_low && amount < sc_low)
			general_amount_estimate = "LOW"
		else if (amount > sc_low && amount < sc_medium)
			general_amount_estimate = "MEDIUM"
		else if (amount > sc_medium && amount < sc_high)
			general_amount_estimate = "HIGH"
		else if (amount > sc_high && amount <= softcap)
			general_amount_estimate = "VERY HIGH"
		else if (amount > softcap)
			general_amount_estimate = "OVERLOADED"
	else
		general_amount_estimate = "ERROR"

	status_tab += "Mana Count: [general_amount_estimate]"

/datum/mana_pool/proc/generate_initial_attunements()
	RETURN_TYPE(/list/datum/attunement)

	return GLOB.default_attunements.Copy()

// order of operations is as follows:
// 1. we recharge
// 2. we transfer mana
// 3. we discharge excess mana
/datum/mana_pool/process(seconds_per_tick)
	var/donation_this_tick = (max_donation_rate_per_second * seconds_per_tick)
	donation_budget_this_tick = FLOOR(donation_this_tick, MANA_DECIMAL_FLOOR)//TODO: stop float imprecision but harder because i added a round? or not?

	if (ethereal_recharge_rate != 0)
		adjust_mana(ethereal_recharge_rate * seconds_per_tick, attunements_to_generate)
	if (length(transferring_to) > 0)
		switch (transfer_method)
			if (MANA_SEQUENTIAL)
				for (var/datum/mana_pool/iterated_pool as anything in transferring_to)
					if (amount <= 0 || donation_budget_this_tick <= 0)
						break
					if(!check_rulesets(iterated_pool, (get_transfer_rate_for(iterated_pool) * seconds_per_tick)))
						continue
					if (transferring_to[iterated_pool] & MANA_POOL_SKIP_NEXT_TRANSFER)
						transferring_to[iterated_pool] &= ~MANA_POOL_SKIP_NEXT_TRANSFER
						continue

					transfer_mana_to(iterated_pool, seconds_per_tick)

			if (MANA_DISPERSE_EVENLY)
				var/budgeted_mana_to_disperse = SAFE_DIVIDE(donation_budget_this_tick, length(transferring_to))
				var/mana_to_disperse = (FLOOR(budgeted_mana_to_disperse, MANA_DECIMAL_FLOOR))

				for (var/datum/mana_pool/iterated_pool as anything in transferring_to)
					if (amount <= 0 || donation_budget_this_tick <= 0)
						break
					if(!check_rulesets(iterated_pool, mana_to_disperse))
						continue
					if (transferring_to[iterated_pool] & MANA_POOL_SKIP_NEXT_TRANSFER)
						transferring_to[iterated_pool] &= ~MANA_POOL_SKIP_NEXT_TRANSFER
						continue

					transfer_specific_mana(iterated_pool, mana_to_disperse)
			// ...

	if (parent)
		if (amount > parent.mana_overload_threshold)
			var/effect_mult = (((amount / parent.mana_overload_threshold) - 1) * parent.mana_overload_coefficient)
			parent.process_mana_overload(effect_mult, seconds_per_tick)
		else if (parent.mana_overloaded)
			parent.stop_mana_overload()

	if (amount > softcap)
	// exponential decay
	// exponentially decays amount when amount surpasses softcap, with [exponential_decay_divisor] being the (inverse) decay factor
	// can only decay however much amount we are over softcap
	// imperfect as of now (need to test)
		var/exponential_decay = (max(-((((NUM_E**((amount - softcap)/exponential_decay_divisor)) + 1)) * seconds_per_tick), (softcap - amount)))
		// in desmos: f\left(x\right)=\max\left(\left(\left(-\left(e\right)^{\left(\frac{\left(x-t\right)}{c}\right)}\right)+1\right),\ \left(t-x\right)\right)\ \left\{x\ge t\right\}
		// t=50
		// c=150
		if (discharge_destinations)
			var/list/datum/mana_pool/pools_to_discharge_into = list()
			if (discharge_destinations & MANA_ALL_LEYLINES)
				pools_to_discharge_into += get_accessable_leylines()

			switch (discharge_method)
				if (MANA_DISPERSE_EVENLY)
					var/mana_to_disperse = (exponential_decay / length(pools_to_discharge_into))

					for (var/datum/mana_pool/iterated_pool as anything in pools_to_discharge_into)
						transfer_specific_mana(iterated_pool, -mana_to_disperse, FALSE)

				if (MANA_SEQUENTIAL)
					for (var/datum/mana_pool/iterated_pool as anything in pools_to_discharge_into)
						exponential_decay -= transfer_specific_mana(iterated_pool, -exponential_decay, FALSE)
						if (exponential_decay <= 0)
							break

		adjust_mana(exponential_decay) //just to be safe, in case we have any left over or didnt have a discharge destination

// apply the rulesets we have
/datum/mana_pool/proc/check_rulesets(datum/mana_pool/target_pool, transferred_mana) // pretty mean overhead on this one
	var/softcap_check = (target_pool.amount >= target_pool.softcap)
	var/softcap_pass_check = ((target_pool.amount + transferred_mana) > target_pool.softcap)

	switch (mana_transfer_ruleset)
		if (MANA_TRANSFER_SOFTCAP)
			if (softcap_check)
				return FALSE
		if (MANA_TRANSFER_SOFTCAP_NO_PASS)
			if ((softcap_check) || softcap_pass_check)
				return FALSE
		if (MANA_TRANSFER_MANUAL_RULES)
			if (target_pool.amount >= cap_transfer_limit)
				return FALSE
	return TRUE

/// Perform a "natural" transfer where we use the default transfer rate, capped by the usual math
/datum/mana_pool/proc/transfer_mana_to(datum/mana_pool/target_pool, seconds_per_tick = 1)
	return transfer_specific_mana(target_pool, get_transfer_rate_for(target_pool) * seconds_per_tick)

/// Returns the amount of mana we want to give in a given tick
/datum/mana_pool/proc/get_transfer_rate_for(datum/mana_pool/target_pool)
	var/cached_rate = transfer_rates[target_pool]
	return min((cached_rate ? min(cached_rate, donation_budget_this_tick) : donation_budget_this_tick), get_maximum_transfer_for(target_pool))

/datum/mana_pool/proc/get_maximum_transfer_for(datum/mana_pool/target_pool)
	var/cached_cap = transfer_caps[target_pool]
	return (cached_cap || (transfer_default_softcap ? target_pool.softcap : target_pool.maximum_mana_capacity))

/datum/mana_pool/proc/transfer_specific_mana(datum/mana_pool/other_pool, amount_to_transfer, decrement_budget = TRUE)
	// ensure we dont give more than we hold and dont give more than they CAN hold
	var/adjusted_amount = min(min(amount_to_transfer, maximum_mana_capacity), (other_pool.maximum_mana_capacity - other_pool.amount))
	// ^^^^ TODO THIS ISNT THA TGOOD I DONT LIKE IT we should instead have remainders returned on adjust mana and plug it into the OTHER adjust mana

	if (decrement_budget)
		donation_budget_this_tick -= amount_to_transfer

	adjust_mana(-adjusted_amount)
	return other_pool.adjust_mana(adjusted_amount, attunements)

/datum/mana_pool/proc/start_transfer(datum/mana_pool/target_pool, force_process = FALSE)

	if (target_pool == src)
		stack_trace("start_transfer called where target_pool was src!")
		return MANA_POOL_CANNOT_TRANSFER

	if (!can_transfer(target_pool))
		return MANA_POOL_CANNOT_TRANSFER

	if (target_pool in transferring_to)
		return MANA_POOL_ALREADY_TRANSFERRING

	transferring_to += target_pool
	target_pool.incoming_transfer_start(src)

	if (force_process)
		transferring_to[target_pool] |= MANA_POOL_SKIP_NEXT_TRANSFER
		transfer_mana_to(target_pool) // you can potentially get all you need instantly

	return MANA_POOL_TRANSFER_START

/datum/mana_pool/proc/stop_transfer(datum/mana_pool/target_pool, forced = FALSE)

	if (!forced && !QDELETED(target_pool) && (transferring_to[target_pool] & MANA_POOL_SKIP_NEXT_TRANSFER))
		return MANA_POOL_TRANSFER_SKIP_ACTIVE // nope!

	transferring_to -= target_pool
	target_pool.incoming_transfer_end(src)

	return MANA_POOL_TRANSFER_STOP

/datum/mana_pool/proc/incoming_transfer_start(datum/mana_pool/donator)
	transferring_from += donator

/datum/mana_pool/proc/incoming_transfer_end(datum/mana_pool/donator)
	transferring_from -= donator

// TODO BIG FUCKING WARNING THIS EQUATION DOSENT WORK AT ALL
// Should be fine as long as nothing actually has any attunements
/// The proc used to modify the mana composition of a mana pool. Should modify attunements in proportion to the ratio
/// between the current amount of mana we have and the mana coming in/being removed, as well as the attunements.
/// Mana pools in general will eventually be refactored to be lists of individual mana pieces with unchanging attunements,
/// so this is not permanent.
/// Returns how much of "amount" was used.
/datum/mana_pool/proc/adjust_mana(amount, list/incoming_attunements)
	if (amount == 0)
		return amount

	var/result = clamp(src.amount + amount, 0, maximum_mana_capacity)
	. = result - src.amount // Return the amount that was used
	src.amount = result

/// Returns an adjusted amount of "effective" mana, affected by the attunements.
/// Will always return a minimum of zero and a maximum of the total amount of mana we can give multiplied by the mults.
/datum/mana_pool/proc/get_attuned_amount(list/datum/attunement/incoming_attunements, atom/caster, amount_to_adjust = src.amount)
	var/mult = get_overall_attunement_mults(incoming_attunements, caster)

	return clamp(SAFE_DIVIDE(amount_to_adjust, mult), 0, amount*mult)

/// Returns the combined attunement mults of all entries in the argument.
/datum/mana_pool/proc/get_overall_attunement_mults(list/attunements, atom/caster)
	return get_total_attunement_mult(src.attunements, attunements, caster)

/datum/mana_pool/proc/can_transfer(datum/mana_pool/target_pool)
	SHOULD_BE_PURE(TRUE)

	return TRUE

/datum/mana_pool/proc/set_intrinsic_recharge(new_bitflags)
	var/old_flags = intrinsic_recharge_sources
	intrinsic_recharge_sources |= new_bitflags
	update_intrinsic_recharge(old_flags)

/datum/mana_pool/proc/update_intrinsic_recharge(previous_recharge_sources = NONE)
	if (intrinsic_recharge_sources & MANA_ALL_LEYLINES)
		for (var/datum/mana_pool/leyline/entry as anything in (get_accessable_leylines() - src))

			if (entry.start_transfer(src) & MANA_POOL_ALREADY_TRANSFERRING)
				continue

			transferring_from[entry] |= MANA_POOL_INTRINSIC

	else if (previous_recharge_sources & MANA_ALL_LEYLINES)
		for (var/datum/mana_pool/leyline/entry in transferring_from)

			if (!(transferring_from[entry] & MANA_POOL_INTRINSIC))
				continue

			entry.stop_transfer(src)

	SEND_SIGNAL(src, COMSIG_MANA_POOL_INTRINSIC_RECHARGE_UPDATE, previous_recharge_sources)

/datum/mana_pool/proc/set_natural_recharge(new_value)
	ethereal_recharge_rate = new_value
	if ((ethereal_recharge_rate > 0) && isnull(attunements_to_generate))
		attunements_to_generate = get_default_attunements_to_generate()

/datum/mana_pool/proc/get_default_attunements_to_generate()
	RETURN_TYPE(/list/datum/attunement)

	return GLOB.default_attunements.Copy()

/datum/mana_pool/proc/set_max_mana(new_max, change_amount = FALSE, change_softcap = TRUE)
	var/percent = get_percent_to_max() //originally this was a duplicate redefinition- see change_amount
	var/softcap_percent = get_percent_of_softcap_to_max()

	if (change_softcap)
		softcap_percent = get_percent_of_softcap_to_max() // originally softcap_percent was defined here
		softcap = new_max * (softcap_percent / 100)

	if (change_amount)
		percent = get_percent_to_max() // this used to be var/percent. why?
		amount = new_max * (percent / 100)

	maximum_mana_capacity = new_max

/datum/mana_pool/proc/get_percent_to_max()
	SHOULD_BE_PURE(TRUE)

	return (amount / maximum_mana_capacity) * 100

/datum/mana_pool/proc/get_percent_to_softcap()
	SHOULD_BE_PURE(TRUE)

	return (amount / softcap) * 100

/datum/mana_pool/proc/get_percent_of_softcap_to_max()
	SHOULD_BE_PURE(TRUE)

	return (softcap / maximum_mana_capacity) * 100

#undef MANA_POOL_REPLACE_ALL_ATTUNEMENTS
