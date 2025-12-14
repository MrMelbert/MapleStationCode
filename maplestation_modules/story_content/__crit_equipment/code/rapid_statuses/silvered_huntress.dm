/datum/story_rapid_status/silvered_huntress
	name = "The Silvered Huntress"
	selectable = TRUE


/datum/story_rapid_status/silvered_huntress/apply(mob/living/carbon/human/selected)
	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/smoke/tevetia,
	)

	grant_spell_list(selected, spells_to_grant, TRUE)

	selected.physiology.brute_mod = 0.4
	selected.physiology.burn_mod = 0.4
	selected.physiology.tox_mod = 0.5
	selected.physiology.oxy_mod = 0.5
	selected.physiology.stamina_mod = 0.5
	selected.physiology.stun_mod = 0.5
	selected.physiology.bleed_mod = 0.2
	selected.set_pain_mod("badmin", 0.6)
	selected.add_consciousness_modifier("badmin", 30)

	strengthen(selected, BODY_ZONE_L_ARM)
	strengthen(selected, BODY_ZONE_R_ARM)
	strengthen(selected, BODY_ZONE_L_LEG)
	strengthen(selected, BODY_ZONE_R_LEG)

	ADD_TRAIT(selected, TRAIT_SLEEPIMMUNE, REF(selected)) //needed to prevent chem cheese using wellcheers and sulfonal

	return TRUE

//pending unique martial arts
/datum/story_rapid_status/silvered_huntress/proc/strengthen(mob/living/carbon/human/selected, bodyzone)
	var/obj/item/bodypart/selected_bodypart = selected.get_bodypart(bodyzone)
	selected_bodypart.unarmed_damage_low = 25
	selected_bodypart.unarmed_damage_high = 25
	selected_bodypart.unarmed_effectiveness = 30
