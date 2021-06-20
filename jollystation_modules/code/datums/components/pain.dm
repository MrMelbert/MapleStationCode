// -- Pain for bodyparts --
/datum/component/pain

	/// Total pain across all bodyparts
	var/total_pain = 0
	/// Previous set total_pain, when changed
	var/last_total_pain = 0
	/// Max total pain (sum of all body part [max_pain]s)
	var/total_pain_max = 0
	/// Modifier applied to all [adjust_pain] amounts
	var/pain_modifier = 1
	/// List of all pain modifiers we have
	var/list/pain_mods = list()
	/// Assoc list [zones] to [references to bodyparts]
	var/list/body_zones = list()
	/// Natural amount of decay given to each limb per process
	var/natural_pain_decay = -0.2

	var/natural_decay_counter = 0

	COOLDOWN_DECLARE(time_since_last_pain_loss)

	var/debugging = FALSE

/datum/component/pain/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/carbon_parent = parent
	for(var/obj/item/bodypart/parent_bodypart in carbon_parent.bodyparts)
		limb_added(carbon_parent, parent_bodypart, TRUE)

	if(!body_zones.len)
		stack_trace("Pain component failed to find any body_zones to track!")
		return COMPONENT_INCOMPATIBLE
	if(carbon_parent.stat == CONSCIOUS)
		START_PROCESSING(SSpain, src)

/datum/component/pain/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CARBON_ATTACH_LIMB, .proc/limb_added)
	RegisterSignal(parent, COMSIG_CARBON_REMOVE_LIMB, .proc/limb_removed)
	RegisterSignal(parent, COMSIG_CARBON_ADJUST_BODYPART_PAIN, .proc/adjust_bodypart_pain)
	RegisterSignal(parent, COMSIG_CARBON_SET_BODYPART_PAIN, .proc/set_bodypart_pain)
	RegisterSignal(parent, COMSIG_CARBON_ADD_PAIN_MODIFIER, .proc/set_pain_modifier)
	RegisterSignal(parent, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, .proc/unset_pain_modifier)
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, .proc/add_damage_pain)
	RegisterSignal(parent, COMSIG_CARBON_GAIN_WOUND, .proc/add_wound_pain)
	RegisterSignal(parent, COMSIG_CARBON_LOSE_WOUND, .proc/remove_wound_pain)
	RegisterSignal(parent, COMSIG_LIVING_REVIVE, .proc/renew_pain_processing)
	RegisterSignal(parent, COMSIG_LIVING_POST_FULLY_HEAL, .proc/remove_all_pain)
	RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/halt_pain_processing)

/datum/component/pain/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_CARBON_ATTACH_LIMB,
		COMSIG_CARBON_REMOVE_LIMB,
		COMSIG_CARBON_ADJUST_BODYPART_PAIN,
		COMSIG_CARBON_SET_BODYPART_PAIN,
		COMSIG_CARBON_ADD_PAIN_MODIFIER,
		COMSIG_CARBON_REMOVE_PAIN_MODIFIER,
		COMSIG_MOB_APPLY_DAMGE,
		COMSIG_CARBON_GAIN_WOUND,
		COMSIG_CARBON_LOSE_WOUND,
		COMSIG_LIVING_REVIVE,
		COMSIG_LIVING_POST_FULLY_HEAL,
		COMSIG_LIVING_DEATH,
	))

/datum/component/pain/Destroy()
	for(var/part in body_zones)
		body_zones -= part
	STOP_PROCESSING(SSpain, src)
	return ..()

/datum/component/pain/proc/limb_added(mob/living/carbon/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER

	total_pain_max += new_limb.max_pain
	body_zones[new_limb.body_zone] = new_limb

	if(special)
		new_limb.pain = 0
		new_limb.last_pain = 0
	else
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, BODY_ZONE_CHEST, new_limb.pain / 3)
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, new_limb.body_zone, new_limb.pain)

/datum/component/pain/proc/limb_removed(mob/living/carbon/source, obj/item/bodypart/lost_limb, special, dismembered)
	SIGNAL_HANDLER

	total_pain_max -= lost_limb.max_pain
	last_total_pain = total_pain
	total_pain -= lost_limb.pain

	if(!special)
		var/limb_removed_pain = dismembered ? PAIN_LIMB_DISMEMBERED : PAIN_LIMB_REMOVED
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, BODY_ZONE_CHEST, limb_removed_pain)
		INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, BODY_ZONE_HEAD, limb_removed_pain / 4)
		lost_limb.pain = initial(lost_limb.pain)
		lost_limb.last_pain = initial(lost_limb.last_pain)
		lost_limb.max_stamina_damage = initial(lost_limb.max_stamina_damage)

	body_zones[lost_limb.body_zone] = null
	body_zones -= lost_limb

/datum/component/pain/proc/set_pain_modifier(datum/source, key, amount)
	SIGNAL_HANDLER

	if(!pain_mods[key] || pain_mods[key] < amount)
		pain_mods[key] = amount
		update_pain_modifier()

/datum/component/pain/proc/unset_pain_modifier(datum/source, key)
	SIGNAL_HANDLER

	if(pain_mods[key])
		pain_mods -= key
		update_pain_modifier()

/datum/component/pain/proc/update_pain_modifier()
	pain_modifier = 1
	for(var/mod in pain_mods)
		pain_modifier *= pain_mods[mod]

/datum/component/pain/proc/adjust_bodypart_pain(mob/living/carbon/source, list/def_zones, amount)
	SIGNAL_HANDLER

	if(!amount)
		return

	if(!islist(def_zones))
		def_zones = list(def_zones)

	if(amount > 0)
		amount *= pain_modifier

	for(var/zone in def_zones)
		var/obj/item/bodypart/adjusted_bodypart = body_zones[zone]
		if(!adjusted_bodypart)
			CRASH("Pain component attempted to adjust_bodypart_pain of untracked or invalid zone [zone].")
		if(amount < 0 && !adjusted_bodypart.pain)
			continue
		if(amount > 0 && adjusted_bodypart.pain >= adjusted_bodypart.max_pain)
			continue
		adjusted_bodypart.last_pain = adjusted_bodypart.pain
		adjusted_bodypart.pain = clamp(adjusted_bodypart.pain + amount, 0, adjusted_bodypart.max_pain)
		last_total_pain = total_pain
		total_pain = clamp(total_pain + amount, 0, total_pain_max)

		if(amount > 0)
			INVOKE_ASYNC(src, .proc/on_pain_gain, source, adjusted_bodypart, amount)
		else
			INVOKE_ASYNC(src, .proc/on_pain_loss, source, adjusted_bodypart, amount)

		if(debugging)
			message_admins("DEBUG: [parent] recived [amount] pain to [adjusted_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/component/pain/proc/set_bodypart_pain(mob/living/carbon/source, list/def_zones, amount)
	SIGNAL_HANDLER

	if(!islist(def_zones))
		def_zones = list(def_zones)

	if(amount < 0)
		CRASH("Pain component attempted to set_bodypart_pain to negative number? Use adjust_bodypart_pain instead!")

	for(var/zone in def_zones)
		var/obj/item/bodypart/set_bodypart = body_zones[zone]
		if(!set_bodypart)
			CRASH("Pain component attempted to set_bodypart_pain of untracked or invalid zone [zone].")
		set_bodypart.last_pain = set_bodypart.pain
		set_bodypart.pain = clamp(amount, 0, set_bodypart.max_pain)
		last_total_pain = total_pain
		total_pain -= set_bodypart.last_pain
		total_pain = clamp(total_pain + amount, 0, total_pain_max)
		if(debugging)
			message_admins("DEBUG: [parent] set pain to [amount] on [set_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/component/pain/proc/on_pain_gain(mob/living/carbon/source, obj/item/bodypart/affected_part, amount)

	if(amount > 10 && prob(20))
		source.emote("scream")
	else if(amount > 6 && prob(25))
		var/picked_shock_emote = pick("gasp", "wince", "grimace")
		source.emote(picked_shock_emote)

	affected_part.on_gain_pain_effects(amount)
	SEND_SIGNAL(source, COMSIG_CARBON_PAIN_GAINED, affected_part, amount)
	COOLDOWN_START(src, time_since_last_pain_loss, 60 SECONDS)

/datum/component/pain/proc/on_pain_loss(mob/living/carbon/source, obj/item/bodypart/affected_part, amount)
	affected_part.on_lose_pain_effects(amount)
	SEND_SIGNAL(source, COMSIG_CARBON_PAIN_LOST, affected_part, amount)

/datum/component/pain/proc/add_damage_pain(mob/living/carbon/source, damage, damagetype, def_zone)
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
				if(10 to 15)
					pain = damage / 3
				if(15 to 20)
					pain = damage / 2
				if(25 to INFINITY)
					pain = damage / 1.2

		// Toxins pain is dealt to the chest (stomach and liver)
		// pain = divided by the liver's tox tolerance, liver damage, stomach damage, and more for higher total toxloss
		if(TOX)
			def_zone = BODY_ZONE_CHEST
			var/mob/living/carbon/human_source = source
			if(istype(human_source))
				var/obj/item/organ/liver/our_liver = human_source.getorganslot(ORGAN_SLOT_LIVER)
				var/obj/item/organ/stomach/our_stomach = human_source.getorganslot(ORGAN_SLOT_STOMACH)
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

				switch(human_source.toxloss)
					if(33 to 66)
						pain += 1
					if(66 to INFINITY)
						pain += 3

		// Oxy pain is dealt to the head and chest
		// pain = more for hurt lungs, more for higher total oxyloss
		if(OXY)
			def_zone = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
			var/mob/living/carbon/human_source = source
			if(istype(human_source))
				var/obj/item/organ/lungs/our_lungs = human_source.getorganslot(ORGAN_SLOT_LUNGS)
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

				switch(human_source.oxyloss)
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

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, def_zone, pain)

/datum/component/pain/proc/add_wound_pain(mob/living/carbon/source, datum/wound/applied_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, wounded_limb.body_zone, applied_wound.severity * 10)

/datum/component/pain/proc/remove_wound_pain(mob/living/carbon/source, datum/wound/removed_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/adjust_bodypart_pain, source, wounded_limb.body_zone, -removed_wound.severity * 5)

/datum/component/pain/process(delta_time)

	check_pain_modifiers(parent)

	var/mob/living/carbon/human/human_parent = parent
	// our entire body is in massive amounts of pain
	switch(total_pain)
		if(0 to 100)
			human_parent.remove_movespeed_modifier(MOVESPEED_ID_PAIN)
			human_parent.remove_actionspeed_modifier(ACTIONSPEED_ID_PAIN)
		if(100 to 200)
			human_parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/light)
			human_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/light)
		if(200 to 300)
			human_parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/medium)
			human_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/medium)
		if(300 to 400)
			human_parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/heavy)
			human_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/heavy)
		if(400 to 500)
			human_parent.add_movespeed_modifier(/datum/movespeed_modifier/pain/crippling)
			human_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/pain/crippling)
			// Change in total pain since last tick. Negative = losing pain
			var/delta_total_pain = total_pain - last_total_pain
			if(DT_PROB(5, delta_time) && delta_total_pain < 0 && COOLDOWN_FINISHED(src, time_since_last_pain_loss))
				to_chat(parent, span_green("You feel the pain start to dull!"))

			if(!human_parent.has_status_effect(STATUS_EFFECT_DETERMINED))
				if(DT_PROB(5, delta_time))
					var/very_pained_messages = pick("Stop the pain!", "Everything hurts!", "Why, why?!", "AAAAAAAH!!")
					to_chat(parent, span_userdanger("[very_pained_messages]"))
					human_parent.visible_message(span_warning("[human_parent] winces from pain!"), ignored_mobs = human_parent)
					human_parent.emote("scream")
				if(DT_PROB(2, delta_time) && human_parent.staminaloss <= 90)
					human_parent.apply_damage(30 * pain_modifier, STAMINA)
					human_parent.visible_message(span_warning("[human_parent] doubles over in pain!"))
					human_parent.emote("gasp")
				if(DT_PROB(2, delta_time))
					human_parent.Knockdown(15 * pain_modifier)
					human_parent.visible_message(span_warning("[human_parent] collapses in pain!"))
				if(DT_PROB(1, delta_time))
					human_parent.vomit(50)
				if(DT_PROB(4, delta_time))
					var/obj/item/held_item = human_parent.get_active_held_item()
					if(held_item && human_parent.dropItemToGround(held_item))
						to_chat(human_parent, span_danger("Your fumble though the pain and drop [held_item]!"))
						human_parent.visible_message(span_warning("[human_parent] fumbles around and drops [held_item]!"), ignored_mobs = human_parent)
						human_parent.emote("gasp")

	var/list/shuffled_zones = shuffle(body_zones)
	var/display_message = TRUE

	for(var/part in shuffled_zones)
		var/obj/item/bodypart/checked_bodypart = body_zones[part]
		// 1st threshold: max_pain / 3 (~25, for reference)
		var/first_pain_threshold = checked_bodypart.max_pain / 3
		// 2nd threshold: 2 * max_pain / 3 (~50)
		var/second_pain_threshold = first_pain_threshold * 2
		// 3rd threshold: max_pain - 10 (~65)
		var/third_pain_threshold = checked_bodypart.max_pain - 10
		// Change in limb pain since last tick. Negative = losing pain
		var/delta_pain = checked_bodypart.pain - checked_bodypart.last_pain
		var/base_max_stamina_damage = initial(checked_bodypart.max_stamina_damage)

		var/healing_pain = ((delta_pain < 0) && (COOLDOWN_FINISHED(src, time_since_last_pain_loss)))

		if(healing_pain)
			if(checked_bodypart.pain > 0 && checked_bodypart.pain <= 10)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage
			else if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.2
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.5
			if(HAS_TRAIT_FROM(checked_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS) && checked_bodypart.pain < third_pain_threshold)
				to_chat(parent, span_green("You can feel your [checked_bodypart.name] again!"))
				REMOVE_TRAIT(checked_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
				checked_bodypart.update_disabled()
		else
			if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.2
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.5
			else if(checked_bodypart.pain > second_pain_threshold && checked_bodypart.pain <= third_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 2
			else if(checked_bodypart.pain > third_pain_threshold)
				if(checked_bodypart.can_be_disabled && !HAS_TRAIT_FROM(checked_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS))
					to_chat(parent, span_userdanger("Your [checked_bodypart.name] goes numb from the pain!"))
					ADD_TRAIT(checked_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
					checked_bodypart.update_disabled()

			checked_bodypart.processed_pain_effects(delta_time)

		if(display_message && pain_modifier > 0.5 && !human_parent.has_status_effect(STATUS_EFFECT_DETERMINED) && DT_PROB((checked_bodypart.pain/12), delta_time))
			display_message = FALSE
			var/scream_prob = 0
			var/picked_emote = pick(PAIN_EMOTES)
			if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				to_chat(parent, span_danger("Your [checked_bodypart.name] aches[healing_pain ? ", but it's getting better" : ""]."))
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				human_parent.emote(picked_emote)
				if(healing_pain)
					to_chat(parent, span_danger("Your [checked_bodypart.name] hurts, but it's starting to die down."))
				else
					scream_prob = 5
					to_chat(parent, span_danger("Your [checked_bodypart.name] hurts!"))
			else if(checked_bodypart.pain > second_pain_threshold && checked_bodypart.pain <= third_pain_threshold)
				human_parent.emote(picked_emote)
				if(healing_pain)
					to_chat(parent, span_danger("Your [checked_bodypart.name] really hurts, but the stinging is stopping."))
				else
					scream_prob = 10
					to_chat(parent, span_danger("Your [checked_bodypart.name] really hurts!"))
			else if(checked_bodypart.pain > third_pain_threshold)
				scream_prob = 25
				to_chat(parent, span_danger("Your [checked_bodypart.name] is numb from the pain[healing_pain ? ", but the feeling is returning." : "!"]"))
			if(DT_PROB(scream_prob, delta_time))
				human_parent.emote("scream")

	natural_decay_counter++
	if(natural_decay_counter % 5 == 0) // every 10 seconds
		natural_decay_counter = 0
		if(COOLDOWN_FINISHED(src, time_since_last_pain_loss))
			natural_pain_decay = max(natural_pain_decay - 0.05, -2) // 20 seconds = 0.1 increase, 5 minutes of no pain = -1.5
		else
			natural_pain_decay = initial(natural_pain_decay)

		adjust_bodypart_pain(parent, BODY_ZONES_ALL, natural_pain_decay + pain_modifier - 1)

/datum/component/pain/proc/check_pain_modifiers(mob/living/carbon/carbon_parent)
	if(carbon_parent.drunkenness > 10)
		set_pain_modifier(carbon_parent, PAIN_MOD_DRUNK, 0.9)
	else
		unset_pain_modifier(carbon_parent, PAIN_MOD_DRUNK)

	if(carbon_parent.drowsyness > 10)
		set_pain_modifier(carbon_parent, PAIN_MOD_DROWSY, 0.95)
	else
		unset_pain_modifier(carbon_parent, PAIN_MOD_DROWSY)

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
		set_pain_modifier(carbon_parent, PAIN_MOD_SLEEP, sleeping_modifier)
	else
		unset_pain_modifier(carbon_parent, PAIN_MOD_SLEEP)

	if(IS_IN_STASIS(carbon_parent)) // Is this a cop-out?
		set_pain_modifier(carbon_parent, PAIN_MOD_STASIS, 0)
	else
		unset_pain_modifier(carbon_parent, PAIN_MOD_STASIS)

/datum/component/pain/proc/remove_all_pain(datum/source, adminheal)
	SIGNAL_HANDLER

	set_bodypart_pain(source, BODY_ZONES_ALL, 0)
	for(var/part in body_zones)
		var/obj/item/bodypart/healed_bodypart = body_zones[part]
		REMOVE_TRAIT(healed_bodypart, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
	for(var/mod in pain_mods)
		unset_pain_modifier(source, mod)

/datum/component/pain/proc/renew_pain_processing(datum/source)
	SIGNAL_HANDLER

	START_PROCESSING(SSpain, src)

/datum/component/pain/proc/halt_pain_processing(datum/source)
	SIGNAL_HANDLER

	STOP_PROCESSING(SSpain, src)

/datum/component/pain/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("debug_pain", "Debug Pain")
	VV_DROPDOWN_OPTION("max_pain", "Max Out Pain")

/datum/component/pain/vv_do_topic(href_list)
	. = ..()
	if(href_list["debug_pain"])
		debug_print_pain()
	if(href_list["max_pain"])
		max_pain()

/datum/component/pain/proc/debug_print_pain()
	debugging = !debugging
	if(debugging)
		message_admins("Debugging pain enabled. DEBUG PRINTOUT: [src]")
		message_admins("[parent] has a pain modifier of [pain_modifier].")
		message_admins(" - - - - ")
		for(var/part in body_zones)
			var/obj/item/bodypart/checked_bodypart = body_zones[part]

			message_admins("[parent] has [checked_bodypart.pain] pain in [checked_bodypart.name].")
			message_admins(" * [checked_bodypart.name] has a max pain of [checked_bodypart.max_pain].")
			message_admins(" * [checked_bodypart.name] has delta pain of [checked_bodypart.pain - checked_bodypart.last_pain].")

		message_admins(" - - - - ")
		for(var/mod in pain_mods)
			message_admins("[parent] has pain mod [mod], value [pain_mods[mod]].")
	else
		message_admins("Debugging pain disabled.")

/datum/component/pain/proc/max_pain()
	for(var/part in body_zones)
		var/obj/item/bodypart/checked_bodypart = body_zones[part]
		set_bodypart_pain(parent, part, checked_bodypart.max_pain - 5)
	message_admins("[parent]'s pain has been fully maximized.")
