// -- Bodypart pain definitions. --
/obj/item/bodypart
	/// The amount of pain this limb is experiencing (A bit for default)
	var/pain = 15
	/// The max amount of pain this limb can experience
	var/max_pain = 70
	var/first_pain_threshold = 25
	var/second_pain_threshold = 50
	var/third_pain_threshold = 65

/obj/item/bodypart/proc/on_gain_pain_effects(amount)
	if(!owner)
		return FALSE

	var/base_max_stamina_damage = initial(max_stamina_damage)

	switch(pain)
		if(10 to first_pain_threshold)
			max_stamina_damage = base_max_stamina_damage / 1.2
		if(first_pain_threshold to second_pain_threshold)
			max_stamina_damage = base_max_stamina_damage / 1.5
		if(second_pain_threshold to third_pain_threshold)
			max_stamina_damage = base_max_stamina_damage / 2
		if(third_pain_threshold to INFINITY)
			if(can_be_disabled && !HAS_TRAIT_FROM(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS))
				to_chat(owner, span_userdanger("Your [name] goes numb from the pain!"))
				ADD_TRAIT(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
				update_disabled()

	return TRUE

/obj/item/bodypart/proc/on_lose_pain_effects(amount)
	if(!owner)
		return FALSE

	var/base_max_stamina_damage = initial(max_stamina_damage)
	switch(pain)
		if(0 to 10)
			max_stamina_damage = base_max_stamina_damage
		if(10 to first_pain_threshold)
			max_stamina_damage = base_max_stamina_damage / 1.2
		if(first_pain_threshold to second_pain_threshold)
			max_stamina_damage = base_max_stamina_damage / 1.5
	if(pain < third_pain_threshold && HAS_TRAIT_FROM(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS))
		to_chat(owner, span_green("You can feel your [name] again!"))
		REMOVE_TRAIT(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
		update_disabled()

	return TRUE

/obj/item/bodypart/proc/processed_pain_effects(delta_time)
	if(!owner || !pain)
		return FALSE

	return TRUE

/obj/item/bodypart/proc/pain_message(delta_time, healing_pain)
	if(!owner || !pain)
		return FALSE

	if(!owner.has_status_effect(STATUS_EFFECT_DETERMINED))
		return FALSE

	var/scream_prob = 0
	var/picked_emote = pick(PAIN_EMOTES)
	switch(pain)
		if(10 to first_pain_threshold)
			to_chat(owner, span_danger("Your [name] aches[healing_pain ? ", but it's getting better" : ""]."))
		if(first_pain_threshold to second_pain_threshold)
			owner.emote(picked_emote)
			if(healing_pain)
				to_chat(owner, span_danger("Your [name] hurts, but it's starting to die down."))
			else
				scream_prob = 5
				to_chat(owner, span_danger("Your [name] hurts!"))
		if(second_pain_threshold to third_pain_threshold)
			owner.emote(picked_emote)
			if(healing_pain)
				to_chat(owner, span_danger("Your [name] really hurts, but the stinging is stopping."))
			else
				scream_prob = 10
				to_chat(owner, span_danger("Your [name] really hurts!"))
		if(third_pain_threshold to INFINITY)
			scream_prob = 25
			to_chat(owner, span_danger("Your [name] is numb from the pain[healing_pain ? ", but the feeling is returning." : "!"]"))
	if(DT_PROB(scream_prob, delta_time))
		owner.emote("scream")

	return TRUE

/obj/item/bodypart/chest
	max_pain = 120
	first_pain_threshold = 40
	second_pain_threshold = 75
	third_pain_threshold = 110

/obj/item/bodypart/head
	max_pain = 100
	first_pain_threshold = 30
	second_pain_threshold = 60
	third_pain_threshold = 90

/obj/item/bodypart/head/on_gain_pain_effects(amount)
	. = ..()
	if(!.)
		return FALSE

	if(amount > 10)
		owner.apply_damage(pain / 3, BRAIN)

	return TRUE

/obj/item/bodypart/r_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(50, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE

/obj/item/bodypart/l_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(50, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE
