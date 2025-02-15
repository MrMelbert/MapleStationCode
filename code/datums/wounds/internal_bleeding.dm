/datum/wound_pregen_data/internal_bleeding
	abstract = FALSE
	wound_path_to_generate = /datum/wound/bleed_internal
	ignore_cannot_bleed = FALSE
	required_limb_biostate = BIO_BLOODED
	required_wounding_types = list(WOUND_BLUNT, WOUND_SLASH, WOUND_PIERCE)
	threshold_minimum = 45

/datum/wound/bleed_internal
	name = "Internal Bleeding"
	desc = "The patient is bleeding internally, causing severe pain and difficulty breathing."
	treat_text = "May heal over time through rest, but can be repaired surgically. \
		Blood clotting medication may slow the bleeding, but only very rare and advanced medication can repair it on its own."
	treat_text_short = "Rest or repair surgically."
	examine_desc = ""
	scar_keyword = ""
	severity = WOUND_SEVERITY_TRIVIAL
	simple_treat_text = "Surgery."
	homemade_treat_text = "Taking a <b>blood clotting</b> pill or shot may help slow the bleeding. \
		Alternatively, an <b>iron supplement</b> may help your body replenish lost blood faster."
	processes = TRUE
	wound_flags = NONE
	/// How much blood lost per life tick, gets modified by severity.
	var/bleed_amount = 0.3
	/// Cooldown between when the wound can be allowed to worsen
	COOLDOWN_DECLARE(worsen_cd)
	/// Tracks the highest severity the wound has been.
	var/highest_severity = WOUND_SEVERITY_TRIVIAL

/datum/wound/bleed_internal/apply_wound(obj/item/bodypart/L, silent, datum/wound/old_wound, smited, attack_direction, wound_source, replacing, injury_roll)
	. = ..()
	if(injury_roll > 60)
		upgrade_severity(WOUND_SEVERITY_MODERATE)

/datum/wound/bleed_internal/second_wind()
	return

/datum/wound/bleed_internal/get_self_check_description(mob/user)
	return span_warning("It feels tense to the touch.") // same as rib fracture!

/datum/wound/bleed_internal/proc/upgrade_severity(new_severity)
	if(new_severity == severity)
		return
	if(new_severity > highest_severity)
		highest_severity = new_severity

	severity = new_severity
	bleed_amount = initial(bleed_amount)
	if(severity == WOUND_SEVERITY_TRIVIAL)
		treat_text_short = initial(treat_text_short)
		treat_text = initial(treat_text)
	else
		treat_text_short = "Surgical repair required."
		treat_text = "Surgical repair of the affected vein is necessary. \
			Blood clotting medical will slow the bleeding, but only very rare and advanced medication can repair it on its own."

/datum/wound/bleed_internal/handle_process(seconds_per_tick, times_fired)
	if(!victim || victim.stat == DEAD || HAS_TRAIT(victim, TRAIT_STASIS) || !victim.needs_heart())
		return
	var/severity_mod = (severity + 1)
	victim.bleed(bleed_amount * severity_mod * seconds_per_tick, drip = FALSE)
	if(severity == WOUND_SEVERITY_TRIVIAL)
		heal_percent(0.01 * seconds_per_tick)
		if(QDELETED(src))
			return

	switch(limb.body_zone)
		if(BODY_ZONE_HEAD)
			if(SPT_PROB(2, seconds_per_tick))
				victim.adjust_dizzy(2 SECONDS * severity_mod)
			if(SPT_PROB(1, seconds_per_tick))
				victim.adjust_eye_blur(1 SECONDS * severity_mod)
			if(SPT_PROB(1, seconds_per_tick))
				victim.adjust_drowsiness(1 SECONDS * severity_mod)
			if(SPT_PROB(2, seconds_per_tick))
				victim.add_consciousness_modifier(type, -1.25 * severity_mod)
				addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, remove_consciousness_modifier), type), rand(1, 4) * severity_mod * 1 SECONDS)

		if(BODY_ZONE_CHEST)
			if(SPT_PROB(2, seconds_per_tick))
				victim.adjust_dizzy(2 SECONDS * severity_mod)
			if(SPT_PROB(2, seconds_per_tick))
				victim.losebreath += (1 / ((WOUND_SEVERITY_CRITICAL + 1) / severity_mod))
			if(SPT_PROB(1, seconds_per_tick))
				victim.emote("cough")
				victim.visible_message(
					span_warning("[victim] coughs up blood."),
					span_warning("You cough up blood."),
					vision_distance = COMBAT_MESSAGE_RANGE,
					visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
				)
			if(SPT_PROB(2, seconds_per_tick))
				victim.adjust_disgust(5 * severity_mod)
			if(SPT_PROB(0.1, seconds_per_tick))
				victim.adjust_disgust(10 * severity_mod)
				victim.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 0)

		else
			if(SPT_PROB(2, seconds_per_tick))
				to_chat(victim, span_warning("Your [limb.plaintext_zone] feels [pick("tense", "sore", "weak")] as you move it."))

	if(SPT_PROB(2, seconds_per_tick))
		victim.sharp_pain(limb.body_zone, amount = (severity_mod * 3), duration = 30 SECONDS, return_mod = 0.5)

/datum/wound/bleed_internal/on_xadone(power)
	heal_percent(power / 10)

/datum/wound/bleed_internal/wound_injury(datum/wound/old_wound, attack_direction)
	COOLDOWN_START(src, worsen_cd, 5 SECONDS)

/datum/wound/bleed_internal/receive_damage(wounding_type, wounding_dmg, wound_bonus, attack_direction, damage_source)
	if(isnull(victim) || wounding_type == WOUND_BURN || wound_bonus == CANT_WOUND )
		return
	if(severity == WOUND_SEVERITY_CRITICAL || !COOLDOWN_FINISHED(src, worsen_cd))
		return
	var/new_damage_roll = wounding_dmg + wound_bonus + rand(-10, 30) - victim.getarmor(limb, WOUND)
	if(new_damage_roll < 45)
		return
	upgrade_severity(min(severity + (new_damage_roll > 60 ? 2 : 1), WOUND_SEVERITY_CRITICAL))
	COOLDOWN_START(src, worsen_cd, 6 SECONDS)

/datum/wound/bleed_internal/proc/heal_amount(amount)
	bleed_amount -= amount
	if(bleed_amount > 0)
		return
	if(severity <= WOUND_SEVERITY_TRIVIAL)
		qdel(src)
		return
	upgrade_severity(severity - 1)

/datum/wound/bleed_internal/proc/heal_percent(percent)
	heal_amount(initial(bleed_amount) * percent)
