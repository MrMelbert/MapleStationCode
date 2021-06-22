// -- Pain for bodyparts --
/mob/living
	/// A paint controller datum, to track and deal with pain. Only initialized on humans.
	var/datum/pain/pain_controller

/mob/living/carbon/human/Initialize()
	. = ..()
	pain_controller = new(src)

/mob/living/carbon/human/Destroy()
	if(pain_controller)
		QDEL_NULL(pain_controller)
	return ..()

/datum/pain
	/// The parent mob we're tracking.
	var/mob/living/carbon/human/parent
	/// Total pain across all bodyparts
	var/total_pain = 0
	/// Max total pain (sum of all body part [max_pain]s)
	var/total_pain_max = 0
	/// Modifier applied to all [adjust_pain] amounts
	var/pain_modifier = 1
	/// List of all pain modifiers we have
	var/list/pain_mods = list()
	/// Assoc list [zones] to [references to bodyparts]
	var/list/body_zones = list()
	/// Natural amount of decay given to each limb per 5 ticks of process
	var/natural_pain_decay = -0.2
	/// Counter to track pain decay. Pain decay is only done once every 5 ticks.
	var/natural_decay_counter = 0
	/// Cooldown to track the last time we lost pain.
	COOLDOWN_DECLARE(time_since_last_pain_loss)
	var/debugging = FALSE

/datum/pain/New(mob/living/carbon/human/new_parent)
	if(!iscarbon(new_parent))
		return INITIALIZE_HINT_QDEL

	parent = new_parent
	for(var/obj/item/bodypart/parent_bodypart in parent.bodyparts)
		limb_added(parent, parent_bodypart, TRUE)

	if(!body_zones.len)
		stack_trace("Pain datum failed to find any body_zones to track!")
		return INITIALIZE_HINT_QDEL

	RegisterParentSignals()
	if(new_parent.stat == CONSCIOUS)
		start_pain_processing()

/datum/pain/Destroy()
	for(var/part in body_zones)
		body_zones -= part
	stop_pain_processing()
	UnregisterParentSignals()
	parent = null
	return ..()

/datum/pain/proc/RegisterParentSignals()
	RegisterSignal(parent, COMSIG_CARBON_ATTACH_LIMB, .proc/limb_added)
	RegisterSignal(parent, COMSIG_CARBON_REMOVE_LIMB, .proc/limb_removed)
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, .proc/add_damage_pain)
	RegisterSignal(parent, COMSIG_CARBON_GAIN_WOUND, .proc/add_wound_pain)
	RegisterSignal(parent, COMSIG_CARBON_LOSE_WOUND, .proc/remove_wound_pain)
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, .proc/start_pain_processing)
	RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/stop_pain_processing)
	RegisterSignal(parent, COMSIG_LIVING_POST_FULLY_HEAL, .proc/remove_all_pain)

/datum/pain/proc/UnregisterParentSignals()
	UnregisterSignal(parent, list(
		COMSIG_CARBON_ATTACH_LIMB,
		COMSIG_CARBON_REMOVE_LIMB,
		COMSIG_MOB_APPLY_DAMGE,
		COMSIG_CARBON_GAIN_WOUND,
		COMSIG_CARBON_LOSE_WOUND,
		COMSIG_LIVING_REVIVE,
		COMSIG_LIVING_DEATH,
		COMSIG_LIVING_POST_FULLY_HEAL,
	))

/datum/pain/proc/limb_added(mob/living/carbon/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER

	total_pain_max += new_limb.max_pain
	body_zones[new_limb.body_zone] = new_limb

	if(special)
		new_limb.pain = 0
	else
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, BODY_ZONE_CHEST, new_limb.pain / 3)
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, new_limb.body_zone, new_limb.pain)

/datum/pain/proc/limb_removed(mob/living/carbon/source, obj/item/bodypart/lost_limb, special, dismembered)
	SIGNAL_HANDLER

	total_pain_max -= lost_limb.max_pain
	total_pain -= lost_limb.pain

	if(!special)
		var/limb_removed_pain = dismembered ? PAIN_LIMB_DISMEMBERED : PAIN_LIMB_REMOVED
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, BODY_ZONE_CHEST, limb_removed_pain)
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, BODY_ZONE_HEAD, limb_removed_pain / 4)
		lost_limb.pain = initial(lost_limb.pain)
		lost_limb.max_stamina_damage = initial(lost_limb.max_stamina_damage)

	body_zones[lost_limb.body_zone] = null
	body_zones -= lost_limb

/datum/pain/proc/set_pain_modifier(key, amount)
	if(!pain_mods[key] || pain_mods[key] < amount)
		pain_mods[key] = amount
		update_pain_modifier()

/datum/pain/proc/unset_pain_modifier(key)
	if(pain_mods[key])
		pain_mods -= key
		update_pain_modifier()

/datum/pain/proc/update_pain_modifier()
	pain_modifier = 1
	for(var/mod in pain_mods)
		pain_modifier *= pain_mods[mod]

/datum/pain/proc/adjust_bodypart_pain(list/def_zones, amount)
	if(!amount)
		return

	if(!islist(def_zones))
		def_zones = list(def_zones)

	if(amount > 0)
		amount *= pain_modifier

	amount = round(amount, 0.05)
	for(var/zone in def_zones)
		var/obj/item/bodypart/adjusted_bodypart = body_zones[zone]
		if(!adjusted_bodypart)
			CRASH("Pain component attempted to adjust_bodypart_pain of untracked or invalid zone [zone].")
		if(amount < 0 && !adjusted_bodypart.pain)
			continue
		if(amount > 0 && adjusted_bodypart.pain >= adjusted_bodypart.max_pain)
			continue
		adjusted_bodypart.pain = clamp(adjusted_bodypart.pain + amount, 0, adjusted_bodypart.max_pain)
		total_pain = clamp(total_pain + amount, 0, total_pain_max)

		if(amount > 0)
			INVOKE_ASYNC(src, .proc/on_pain_gain, adjusted_bodypart, amount)
		else if(COOLDOWN_FINISHED(src, time_since_last_pain_loss))
			INVOKE_ASYNC(src, .proc/on_pain_loss, adjusted_bodypart, amount)

		if(debugging)
			message_admins("DEBUG: [parent] recived [amount] pain to [adjusted_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/pain/proc/set_bodypart_pain(list/def_zones, amount)
	if(!islist(def_zones))
		def_zones = list(def_zones)

	if(amount < 0)
		CRASH("Pain component attempted to set_bodypart_pain to negative number? Use adjust_bodypart_pain instead!")

	for(var/zone in def_zones)
		var/obj/item/bodypart/set_bodypart = body_zones[zone]
		if(!set_bodypart)
			CRASH("Pain component attempted to set_bodypart_pain of untracked or invalid zone [zone].")
		set_bodypart.pain = clamp(amount, 0, set_bodypart.max_pain)
		total_pain = clamp(total_pain + amount, 0, total_pain_max)
		if(debugging)
			message_admins("DEBUG: [parent] set pain to [amount] on [set_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/pain/proc/on_pain_gain(obj/item/bodypart/affected_part, amount)
	affected_part.on_gain_pain_effects(amount)
	SEND_SIGNAL(parent, COMSIG_CARBON_PAIN_GAINED, affected_part, amount)
	COOLDOWN_START(src, time_since_last_pain_loss, 60 SECONDS)

	if(amount > 10 && prob(20))
		parent.emote("scream")
	else if(amount > 6 && prob(25))
		var/picked_shock_emote = pick("gasp", "wince", "grimace")
		parent.emote(picked_shock_emote)

	switch(total_pain)
		if(0 to 100)
			parent.remove_movespeed_modifier(MOVESPEED_ID_PAIN)
			parent.remove_actionspeed_modifier(ACTIONSPEED_ID_PAIN)
		if(100 to 200)
			parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/light)
			parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/light)
		if(200 to 300)
			parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/medium)
			parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/medium)
		if(300 to 400)
			parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/heavy)
			parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/heavy)
		if(400 to 500)
			parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/crippling)
			parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/crippling)

/datum/pain/proc/on_pain_loss(obj/item/bodypart/affected_part, amount)
	affected_part.on_lose_pain_effects(amount)
	SEND_SIGNAL(parent, COMSIG_CARBON_PAIN_LOST, affected_part, amount)

/datum/pain/proc/add_damage_pain(mob/living/carbon/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER

	if(damage <= 0)
		return
	if(isbodypart(def_zone))
		var/obj/item/bodypart/targeted_part = def_zone
		def_zone = targeted_part.body_zone
	else
		def_zone = check_zone(def_zone)

	var/pain = damage
	switch(damagetype)
		// Brute pain is dealt to the target zone
		// pain = the damage divided by a random number
		if(BRUTE)
			pain = damage / rand(1.5, 3)

		// Burn pain is dealt to the target zone
		// pain = lower for weaker burns, but scales up for more damaging burns
		if(BURN)
			switch(damage)
				if(1 to 10)
					pain = damage / 4
				if(11 to 15)
					pain = damage / 3
				if(16 to 20)
					pain = damage / 2
				if(21 to INFINITY)
					pain = damage / 1.2

		// Toxins pain is dealt to the chest (stomach and liver)
		// pain = divided by the liver's tox tolerance, liver damage, stomach damage, and more for higher total toxloss
		if(TOX)
			def_zone = BODY_ZONE_CHEST
			var/obj/item/organ/liver/our_liver = source.getorganslot(ORGAN_SLOT_LIVER)
			var/obj/item/organ/stomach/our_stomach = source.getorganslot(ORGAN_SLOT_STOMACH)
			if(our_liver)
				pain = damage / our_liver.toxTolerance
				switch(our_liver.damage)
					if(20 to 50)
						pain += 1
					if(51 to 80)
						pain += 2
					if(81 to INFINITY)
						pain += 3
			else
				pain = damage * 2

			if(our_stomach)
				switch(our_stomach.damage)
					if(20 to 50)
						pain += 1
					if(51 to 80)
						pain += 2
					if(81 to INFINITY)
						pain += 3
			else
				pain += 3

			switch(source.toxloss)
				if(33 to 66)
					pain += 1
				if(66 to INFINITY)
					pain += 3

		// Oxy pain is dealt to the head and chest
		// pain = more for hurt lungs, more for higher total oxyloss
		if(OXY)
			def_zone = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
			var/obj/item/organ/lungs/our_lungs = source.getorganslot(ORGAN_SLOT_LUNGS)
			if(our_lungs)
				switch(our_lungs.damage)
					if(20 to 50)
						pain += 1
					if(51 to 80)
						pain += 2
					if(81 to INFINITY)
						pain += 3
			else
				pain += 5

			switch(parent.oxyloss)
				if(0 to 20)
					pain = 0
				if(21 to 50)
					pain += 1
				if(51 to INFINITY)
					pain += 3

		// Cellular pain is dealt to all bodyparts
		// pain = damage (very ouchy)
		if(CLONE)
			def_zone = BODY_ZONES_ALL

		// No pain from stamina loss
		if(STAMINA)
			return

		// Head pain causes brain damage, so brain damage causes no pain (to prevent death spirals)
		if(BRAIN)
			return

	if(!def_zone || !pain)
		return

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, def_zone, pain)

/datum/pain/proc/add_wound_pain(mob/living/carbon/source, datum/wound/applied_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, wounded_limb.body_zone, applied_wound.severity * 10)

/datum/pain/proc/remove_wound_pain(mob/living/carbon/source, datum/wound/removed_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, wounded_limb.body_zone, -removed_wound.severity * 5)

/datum/pain/process(delta_time)

	check_pain_modifiers(parent)

	var/display_message = TRUE
	// our entire body is in massive amounts of pain
	if(total_pain >= total_pain_max - 100)
		// Change in total pain since last tick. Negative = losing pain
		if(DT_PROB(5, delta_time) && COOLDOWN_FINISHED(src, time_since_last_pain_loss))
			to_chat(parent, span_green("You feel the pain start to dull!"))

		if(!parent.has_status_effect(STATUS_EFFECT_DETERMINED))
			if(DT_PROB(3, delta_time))
				display_message = FALSE
				to_chat(parent, span_userdanger(pick("Stop the pain!", "Everything hurts!")))
				parent.emote("wince")
			if(DT_PROB(2, delta_time) && parent.staminaloss <= 90)
				display_message = FALSE
				parent.apply_damage(30 * pain_modifier, STAMINA)
				parent.visible_message(span_warning("[parent] doubles over in pain!"))
				parent.emote("gasp")
			if(DT_PROB(2, delta_time))
				display_message = FALSE
				parent.Knockdown(15 * pain_modifier)
				parent.visible_message(span_warning("[parent] collapses from pain!"))
			if(DT_PROB(1, delta_time))
				parent.vomit(50)
			if(DT_PROB(1, delta_time))
				display_message = FALSE
				parent.emote("scream")
				parent.Jitter(15)
			if(DT_PROB(5, delta_time))
				var/obj/item/held_item = parent.get_active_held_item()
				if(held_item && parent.dropItemToGround(held_item))
					display_message = FALSE
					to_chat(parent, span_danger("Your fumble though the pain and drop [held_item]!"))
					parent.visible_message(span_warning("[parent] fumbles around and drops [held_item]!"), ignored_mobs = parent)
					parent.emote("gasp")

	var/list/shuffled_zones = shuffle(body_zones)

	for(var/part in shuffled_zones)
		var/obj/item/bodypart/checked_bodypart = body_zones[part]
		checked_bodypart.processed_pain_effects(delta_time)

		if(DT_PROB((checked_bodypart.pain/12), delta_time) && display_message && pain_modifier > 0.5)
			display_message = FALSE
			checked_bodypart.pain_feedback(delta_time, COOLDOWN_FINISHED(src, time_since_last_pain_loss))

	natural_decay_counter++
	if(natural_decay_counter % 5 == 0) // every 10 seconds
		natural_decay_counter = 0
		if(COOLDOWN_FINISHED(src, time_since_last_pain_loss))
			natural_pain_decay = max(natural_pain_decay - 0.05, -2) // 20 seconds = 0.1 increase, 5 minutes of no pain = -1.5
		else
			natural_pain_decay = initial(natural_pain_decay)

		var/pain_modified_decay = min(-1 + natural_pain_decay + pain_modifier, 0)
		adjust_bodypart_pain(BODY_ZONES_ALL, pain_modified_decay)

/datum/pain/proc/check_pain_modifiers(mob/living/carbon/carbon_parent)
	if(carbon_parent.drunkenness > 10)
		set_pain_modifier(PAIN_MOD_DRUNK, 0.9)
	else
		unset_pain_modifier(PAIN_MOD_DRUNK)

	if(carbon_parent.drowsyness > 10)
		set_pain_modifier(PAIN_MOD_DROWSY, 0.95)
	else
		unset_pain_modifier(PAIN_MOD_DROWSY)

	if(carbon_parent.IsSleeping())
		var/sleeping_turf = get_turf(carbon_parent)
		var/sleeping_modifier = 0.8
		if(locate(/obj/structure/bed) in sleeping_turf)
			sleeping_modifier -= 0.2
		if(locate(/obj/item/bedsheet) in sleeping_turf)
			sleeping_modifier -= 0.2
		if(locate(/obj/structure/table/optable) in sleeping_turf)
			sleeping_modifier -= 0.1
		if(istype(carbon_parent.back, /obj/item/tank/internals/anesthetic))
			sleeping_modifier -= 0.5

		sleeping_modifier = max(sleeping_modifier, 0.1)
		set_pain_modifier(PAIN_MOD_SLEEP, sleeping_modifier)
	else
		unset_pain_modifier(PAIN_MOD_SLEEP)

	if(IS_IN_STASIS(carbon_parent)) // Is this a cop-out?
		set_pain_modifier(PAIN_MOD_STASIS, 0)
	else
		unset_pain_modifier(PAIN_MOD_STASIS)

/datum/pain/proc/remove_all_pain(datum/source, adminheal)
	SIGNAL_HANDLER

	set_bodypart_pain(BODY_ZONES_ALL, 0)
	for(var/part in body_zones)
		var/obj/item/bodypart/healed_bodypart = body_zones[part]
		REMOVE_TRAIT(healed_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
	//for(var/mod in pain_mods)
	//	unset_pain_modifier(source, mod)

/datum/pain/proc/start_pain_processing(datum/source)
	SIGNAL_HANDLER

	START_PROCESSING(SSpain, src)

/datum/pain/proc/stop_pain_processing(datum/source)
	SIGNAL_HANDLER

	STOP_PROCESSING(SSpain, src)

/datum/pain/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("debug_pain", "Debug Pain")
	VV_DROPDOWN_OPTION("max_pain", "Max Out Pain")

/datum/pain/vv_do_topic(href_list)
	. = ..()
	if(href_list["debug_pain"])
		debug_print_pain()
	if(href_list["max_pain"])
		max_pain()

/datum/pain/proc/debug_print_pain()
	debugging = !debugging
	if(debugging)
		message_admins("Debugging pain enabled. DEBUG PRINTOUT: [src]")
		message_admins("[parent] has a pain modifier of [pain_modifier].")
		message_admins(" - - - - ")
		for(var/part in body_zones)
			var/obj/item/bodypart/checked_bodypart = body_zones[part]

			message_admins("[parent] has [checked_bodypart.pain] pain in [checked_bodypart.name].")
			message_admins(" * [checked_bodypart.name] has a max pain of [checked_bodypart.max_pain].")

		message_admins(" - - - - ")
		for(var/mod in pain_mods)
			message_admins("[parent] has pain mod [mod], value [pain_mods[mod]].")
	else
		message_admins("Debugging pain disabled.")

/datum/pain/proc/max_pain()
	for(var/part in body_zones)
		var/obj/item/bodypart/checked_bodypart = body_zones[part]
		set_bodypart_pain(part, checked_bodypart.max_pain - 5)
	message_admins("[parent]'s pain has been fully maximized.")
