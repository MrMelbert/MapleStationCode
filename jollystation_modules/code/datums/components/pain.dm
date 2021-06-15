// -- Pain for bodyparts --

/// Add or subtract to a bodypart's pain. (def_zone, amount)
#define COMSIG_CARBON_ADJUST_BODYPART_PAIN "cause_pain"
/// Set bodypart's pain. (def_zone, amount)
#define COMSIG_CARBON_SET_BODYPART_PAIN "set_pain"
/// Add a pain modifier. (key, amount)
#define COMSIG_CARBON_ADD_PAIN_MODIFIER "add_pain_mod"
/// Remove a pain modifier. (key)
#define COMSIG_CARBON_REMOVE_PAIN_MODIFIER "remove_pain_mod"

#define BODY_ZONES_ALL list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

#define PAIN_LIMB_DISMEMBERED 45
#define PAIN_LIMB_REMOVED 10

#define PAIN_MOD_CHEMS "chems"
#define PAIN_MOD_DRUNK "drunk"
#define PAIN_MOD_SLEEP "asleep"
#define PAIN_MOD_DROWSY "drowsy"
#define PAIN_MOD_NEAR_DEATH "near-death"

/datum/component/pain
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

/datum/component/pain/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/carbon_parent = parent
	for(var/obj/item/bodypart/parent_bodypart in carbon_parent.bodyparts)
		limb_added(carbon_parent, parent_bodypart, TRUE)

	if(!body_zones.len)
		stack_trace("Pain component failed to find any body_zones to track!")
		return COMPONENT_INCOMPATIBLE
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
	RegisterSignal(parent, COMSIG_LIVING_POST_FULLY_HEAL, .proc/remove_all_pain)

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
		COMSIG_LIVING_POST_FULLY_HEAL,
	))

/datum/component/pain/Destroy()
	for(var/part in body_zones)
		body_zones -= part
	STOP_PROCESSING(SSpain, src)
	return ..()

/datum/component/pain/proc/limb_added(datum/source, obj/item/bodypart/new_limb, special)
	SIGNAL_HANDLER

	total_pain_max += new_limb.max_pain
	body_zones[new_limb.body_zone] = new_limb

	if(special)
		new_limb.pain = 0
		new_limb.last_pain = 0
	else
		adjust_bodypart_pain(source, BODY_ZONE_CHEST, new_limb.pain / 3)
		adjust_bodypart_pain(source, new_limb.body_zone, new_limb.pain)

/datum/component/pain/proc/limb_removed(datum/source, obj/item/bodypart/lost_limb, special, dismembered)
	SIGNAL_HANDLER

	total_pain_max -= lost_limb.max_pain
	total_pain -= lost_limb.pain

	if(!special)
		var/limb_removed_pain = dismembered ? PAIN_LIMB_DISMEMBERED : PAIN_LIMB_REMOVED
		adjust_bodypart_pain(source, BODY_ZONE_CHEST, limb_removed_pain)
		adjust_bodypart_pain(source, BODY_ZONE_HEAD, limb_removed_pain / 4)
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

/datum/component/pain/proc/adjust_bodypart_pain(datum/source, list/def_zones, amount)
	SIGNAL_HANDLER

	if(!islist(def_zones))
		def_zones = list(def_zones)

	amount *= pain_modifier
	for(var/zone in def_zones)
		var/obj/item/bodypart/adjusted_bodypart = body_zones[zone]
		if(!adjusted_bodypart)
			CRASH("Pain component attempted to adjust_bodypart_pain of untracked or invalid zone [zone].")
		adjusted_bodypart.last_pain = adjusted_bodypart.pain
		adjusted_bodypart.pain = clamp(adjusted_bodypart.pain + amount, 0, adjusted_bodypart.max_pain)
		total_pain = clamp(total_pain + amount, 0, total_pain_max)
		message_admins("DEBUG: [parent] recived [amount] pain to [adjusted_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/component/pain/proc/set_bodypart_pain(datum/source, list/def_zones, amount)
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
		total_pain -= set_bodypart.last_pain
		total_pain = clamp(total_pain + amount, 0, total_pain_max)
		message_admins("DEBUG: [parent] set pain to [amount] on [set_bodypart]. Total pain: [total_pain]")

	return TRUE

/datum/component/pain/proc/add_damage_pain(datum/source, damage, damagetype, def_zone)
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
			pain = damage / rand(2, 4)

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

		// Brain pain is done to the head, if the damage is severe enough
		// pain = more based on how much brain damage is had
		if(BRAIN)
			def_zone = BODY_ZONE_HEAD
			var/mob/living/carbon/human_source = source
			if(istype(human_source))
				var/obj/item/organ/brain/our_brain = human_source.getorganslot(ORGAN_SLOT_BRAIN)
				switch(our_brain.damage)
					if(0 to 50)
						pain = 0
					if(51 to 100)
						pain += 1
					if(101 to 150)
						pain += 3
					if(151 to INFINITY)
						pain += 5

	if(!def_zone || !pain)
		return

	adjust_bodypart_pain(source, def_zone, pain)

/datum/component/pain/proc/add_wound_pain(mob/living/carbon/source, datum/wound/applied_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	adjust_bodypart_pain(source, wounded_limb.body_zone, applied_wound.severity * 10)

/datum/component/pain/proc/remove_wound_pain(mob/living/carbon/source, datum/wound/removed_wound, obj/item/bodypart/wounded_limb)
	SIGNAL_HANDLER

	adjust_bodypart_pain(source, wounded_limb.body_zone, -removed_wound.severity * 10)

/datum/component/pain/process(delta_time)

	check_pain_modifiers(parent)

	var/list/shuffled_zones = shuffle(body_zones)
	var/display_message = TRUE
	for(var/part in shuffled_zones)

		var/obj/item/bodypart/checked_bodypart = body_zones[part]
		var/first_pain_threshold = checked_bodypart.max_pain / 3
		var/second_pain_threshold = first_pain_threshold * 2
		var/third_pain_threshold = checked_bodypart.max_pain - 10
		var/delta_pain = checked_bodypart.pain - checked_bodypart.last_pain
		var/base_max_stamina_damage = initial(checked_bodypart.max_stamina_damage)

		if(delta_pain < 0)
			if(checked_bodypart.pain > 0 && checked_bodypart.pain <= 10)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage
			else if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.2
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.5
			if(HAS_TRAIT_FROM(checked_bodypart, TRAIT_PARALYSIS, "pain") && checked_bodypart.pain < third_pain_threshold)
				to_chat(parent, span_green("You can feel your [checked_bodypart.name] again!"))
				REMOVE_TRAIT(checked_bodypart, TRAIT_PARALYSIS, "pain")
				checked_bodypart.update_disabled()
		else
			if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.2
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 1.5
			else if(checked_bodypart.pain > second_pain_threshold && checked_bodypart.pain <= third_pain_threshold)
				checked_bodypart.max_stamina_damage = base_max_stamina_damage / 2
			else if(checked_bodypart.pain > third_pain_threshold)
				if(checked_bodypart.can_be_disabled && !HAS_TRAIT_FROM(checked_bodypart, TRAIT_PARALYSIS, "pain"))
					to_chat(parent, span_boldwarning("Your [checked_bodypart.name] goes numb from the pain!"))
					ADD_TRAIT(checked_bodypart, TRAIT_PARALYSIS, "pain")
					checked_bodypart.update_disabled()

		if(display_message && pain_modifier > 0.5 && DT_PROB((checked_bodypart.pain/25), delta_time))
			display_message = FALSE
			if(checked_bodypart.pain > 10 && checked_bodypart.pain <= first_pain_threshold)
				to_chat(parent, span_warning("Your [checked_bodypart.name] aches[delta_pain < 0 ? ", but it's getting better" : ""]."))
			else if(checked_bodypart.pain > first_pain_threshold && checked_bodypart.pain <= second_pain_threshold)
				to_chat(parent, span_warning("Your [checked_bodypart.name] hurts[delta_pain < 0 ? ", but it's starting to die down." : "!"]"))
			else if(checked_bodypart.pain > second_pain_threshold && checked_bodypart.pain <= third_pain_threshold)
				to_chat(parent, span_warning("Your [checked_bodypart.name] really hurts[delta_pain < 0 ? ", but the stinging is stopping." : "!"]"))
			else if(checked_bodypart.pain > third_pain_threshold)
				to_chat(parent, span_warning("Your [checked_bodypart.name] is numb from the pain[delta_pain < 0 ? ", but the feeling is returning." : "!"]"))


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
		set_pain_modifier(carbon_parent, PAIN_MOD_SLEEP, 0.1)
	else
		unset_pain_modifier(carbon_parent, PAIN_MOD_SLEEP)

/datum/component/pain/proc/remove_all_pain(datum/source, adminheal)
	SIGNAL_HANDLER

	set_bodypart_pain(source, BODY_ZONES_ALL, 0)
	for(var/part in body_zones)
		var/obj/item/bodypart/healed_bodypart = body_zones[part]
		REMOVE_TRAIT(healed_bodypart, TRAIT_PARALYSIS, "pain")
	for(var/mod in pain_mods)
		unset_pain_modifier(source, mod)

/datum/component/pain/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("debug_pain", "Debug Pain")

/datum/component/pain/vv_do_topic(href_list)
	. = ..()
	if(href_list["debug_pain"])
		debug_print_pain()

/datum/component/pain/proc/debug_print_pain()
	message_admins("DEBUG PRINTOUT: [src]")
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
