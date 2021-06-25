// -- Bodypart pain definitions. --
/obj/item/bodypart
	/// The amount of pain this limb is experiencing (A bit for default)
	var/pain = 15
	/// The min amount of pain this limb can experience
	var/min_pain = 0
	/// The max amount of pain this limb can experience
	var/max_pain = 70
	/// Modifier applied to pain that this part recieves
	var/bodypart_pain_modifier = 1

/obj/item/bodypart/receive_damage(brute = 0, burn = 0, stamina = 0, blocked = 0, updating_health = TRUE, required_status = null, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE)
	. = ..()
	if(!.)
		return

	var/can_inflict = max_damage - get_damage()
	var/total_damage = brute + burn
	if(total_damage > can_inflict && total_damage > 0)
		brute = round(brute * (can_inflict / total_damage), DAMAGE_PRECISION)
		burn = round(burn * (can_inflict / total_damage), DAMAGE_PRECISION)

	if(can_inflict > 0)
		owner?.cause_pain(body_zone, body_damage_coeff * (brute + burn))

/*
 * Effects on this bodypart has when pain is gained.
 *
 * amount - amount of pain gained
 */
/obj/item/bodypart/proc/on_gain_pain_effects(amount)
	if(!owner)
		return FALSE

	var/base_max_stamina_damage = initial(max_stamina_damage)

	switch(pain)
		if(10 to 25)
			max_stamina_damage = base_max_stamina_damage / 1.2
		if(26 to 50)
			max_stamina_damage = base_max_stamina_damage / 1.5
		if(51 to 65)
			max_stamina_damage = base_max_stamina_damage / 2
		if(66 to INFINITY)
			if(can_be_disabled && !HAS_TRAIT_FROM(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS))
				to_chat(owner, span_userdanger("Your [name] goes numb from the pain!"))
				ADD_TRAIT(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
				update_disabled()

	return TRUE

/*
 * Effects on this bodypart has when pain is lost and some time passes without any pain gain.
 *
 * amount - amount of pain lost
 */
/obj/item/bodypart/proc/on_lose_pain_effects(amount)
	if(!owner)
		return FALSE

	var/base_max_stamina_damage = initial(max_stamina_damage)
	switch(pain)
		if(0 to 10)
			max_stamina_damage = base_max_stamina_damage
		if(11 to 25)
			max_stamina_damage = base_max_stamina_damage / 1.2
		if(26 to 50)
			max_stamina_damage = base_max_stamina_damage / 1.5
	if(pain < 65 && HAS_TRAIT_FROM(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS))
		to_chat(owner, span_green("You can feel your [name] again!"))
		REMOVE_TRAIT(src, TRAIT_PARALYSIS, PAIN_LIMB_PARALYSIS)
		update_disabled()

	return TRUE

/*
 * Effects on this bodypart when pain is processed (every 2 seconds)
 */
/obj/item/bodypart/proc/processed_pain_effects(delta_time)
	if(!owner || !pain)
		return FALSE

	return TRUE

/*
 * Feedback messages from this limb when it is sustaining pain.
 *
 * healing_pain - if TRUE, the bodypart has gone some time without recieving pain, and is healing.
 */
/obj/item/bodypart/proc/pain_feedback(delta_time, healing_pain)
	if(!owner || !pain)
		return FALSE

	if(owner.has_status_effect(STATUS_EFFECT_DETERMINED))
		return FALSE

	var/scream_prob = 0
	var/picked_emote = pick(PAIN_EMOTES + "mumble")
	var/feedback = ""
	switch(pain)
		if(10 to 25)
			owner.flash_pain_overlay(1)
			feedback = "Your [name] aches[healing_pain ? ", but it's getting better" : ""]."
		if(26 to 50)
			owner.emote(picked_emote)
			owner.flash_pain_overlay(1)
			if(healing_pain)
				feedback = "Your [name] hurts, but it's starting to die down."
			else
				scream_prob = 5
				feedback = "Your [name] hurts!"
		if(51 to 65)
			owner.emote(picked_emote)
			owner.flash_pain_overlay(2)
			if(healing_pain)
				feedback = "Your [name] really hurts, but the stinging is stopping."
			else
				scream_prob = 10
				feedback = "Your [name] really hurts!"
		if(66 to INFINITY)
			scream_prob = 25
			owner.flash_pain_overlay(2, 2 SECONDS)
			feedback = "Your [name] is numb from the pain[healing_pain ? ", but the feeling is returning." : "!"]"

	if(DT_PROB(scream_prob, delta_time))
		owner.emote("scream")
	to_chat(owner, span_danger(feedback))
	return TRUE

// --- Chest ---
/obj/item/bodypart/chest
	max_pain = 120

/obj/item/bodypart/chest/robot
	pain = 160
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/chest/pain_feedback(delta_time, healing_pain)
	if(!owner || !pain)
		return FALSE

	if(owner.has_status_effect(STATUS_EFFECT_DETERMINED))
		return FALSE

	var/picked_emote = pick(PAIN_EMOTES + "groan")
	var/feedback = ""
	switch(pain)
		if(10 to 40)
			feedback = "Your [name] aches[healing_pain ? ", for a short time" : ""]."
			owner.flash_pain_overlay(1)
		if(41 to 75)
			owner.emote(picked_emote)
			owner.flash_pain_overlay(1, 2 SECONDS)
			feedback = pick("Your [name] feels sore", "Your [name] hurts", "Your side hurts", "Your ribs hurt")
			if(healing_pain)
				feedback += pick(", but it's getting better", ", but it's feeling better", ", but it's improving", ", but it stops shortly")
			feedback += "."
		if(76 to 110)
			owner.emote(picked_emote)
			owner.flash_pain_overlay(2, 2 SECONDS)
			feedback = pick("Your [name] really hurts", "Your feel a sharp pain in your side", "You breathe in and feel pain in your ribs")
			if(healing_pain)
				feedback += pick(", but the stinging is stopping", ", but it's feeling better", ", but it quickly subsides")
			feedback += "!"
		if(111 to INFINITY)
			owner.flash_pain_overlay(2, 3 SECONDS)
			feedback = "You feel your ribs jostle in your [name]!"
			owner.emote(pick("groan", "scream"))

	to_chat(owner, span_danger(feedback))
	return TRUE

// --- Head ---
/obj/item/bodypart/head
	max_pain = 100

/obj/item/bodypart/head/robot
	pain = 120
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/head/on_gain_pain_effects(amount)
	. = ..()
	if(!.)
		return FALSE

	if(amount > 10)
		owner.apply_damage(pain / 3, BRAIN)

	return TRUE

/obj/item/bodypart/head/pain_feedback(delta_time, healing_pain)
	if(!owner || !pain)
		return FALSE

	var/feedback = ""
	switch(pain)
		if(10 to 30)
			feedback = "Your [name] aches[healing_pain ? ", but it's getting better" : ""]."
			owner.flash_pain_overlay(1)
		if(31 to 60)
			owner.flash_pain_overlay(1)
			if(healing_pain)
				feedback = "Your [name] hurts, but it's starting to die down."
			else
				feedback = "Your [name] hurts!"
		if(61 to 90)
			owner.flash_pain_overlay(2)
			if(healing_pain)
				feedback = "Your [name] really hurts, but the stinging is stopping."
			else
				feedback = "Your [name] really hurts!"
		if(91 to INFINITY)
			owner.flash_pain_overlay(2, 2 SECONDS)
			feedback = "Your [name] is numb from the pain[healing_pain ? ", but the feeling is returning." : "!"]"

	to_chat(owner, span_danger(feedback))
	return TRUE

// --- Right Leg ---
/obj/item/bodypart/r_leg/robot
	pain = 100
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/r_leg/robot/surplus
	pain = 40
	bodypart_pain_modifier = 0.8

/obj/item/bodypart/r_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(25, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE

// --- Left Leg ---
/obj/item/bodypart/l_leg/robot
	pain = 100
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/l_leg/robot/surplus
	pain = 40
	bodypart_pain_modifier = 0.8

/obj/item/bodypart/l_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(25, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE

// --- Right Arm ---
/obj/item/bodypart/r_arm/robot
	pain = 100
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/r_arm/robot/surplus
	pain = 40
	bodypart_pain_modifier = 0.8

// --- Left Arm ---
/obj/item/bodypart/l_arm/robot
	pain = 100
	bodypart_pain_modifier = 0.5

/obj/item/bodypart/l_arm/robot/surplus
	pain = 40
	bodypart_pain_modifier = 0.8
