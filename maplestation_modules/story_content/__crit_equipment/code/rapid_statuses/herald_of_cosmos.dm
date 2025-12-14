/datum/story_rapid_status/cosmos/herald_of_cosmos
	name = "Herald of Cosmos"
	selectable = TRUE

/datum/story_rapid_status/cosmos/herald_of_cosmos/apply(mob/living/carbon/human/selected)
	selected?.mind.add_antag_datum(/datum/antagonist/heretic)
	var/datum/antagonist/heretic/our_heretic = selected?.mind.has_antag_datum(/datum/antagonist/heretic)
	var/list/knowledges_to_grant = list( // cosmic heretic with a sidepath, some void spells and no ascension
		/datum/heretic_knowledge/limited_amount/starting/base_cosmic,
		/datum/heretic_knowledge/cosmic_grasp,
		/datum/heretic_knowledge/spell/cosmic_runes,
		/datum/heretic_knowledge/mark/cosmic_mark,
		/datum/heretic_knowledge/spell/star_touch,
		/datum/heretic_knowledge/spell/star_blast,
		/datum/heretic_knowledge/blade_upgrade/cosmic,
		/datum/heretic_knowledge/spell/cosmic_expansion,
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/spell/void_pull,
		/datum/heretic_knowledge/spell/space_phase,
	)
	if(our_heretic) // in case this entire chain broke along the way
		our_heretic.ascended = TRUE
		for(var/i in knowledges_to_grant)
			our_heretic.gain_knowledge(i)

		// the cosmic heretic ascension upgrades
		var/datum/heretic_knowledge/blade_upgrade/cosmic/blade_upgrade = our_heretic.get_knowledge(/datum/heretic_knowledge/blade_upgrade/cosmic)
		blade_upgrade.combo_duration = 10 SECONDS
		blade_upgrade.combo_duration_amount = 10 SECONDS
		blade_upgrade.max_combo_duration = 30 SECONDS
		blade_upgrade.increase_amount = 2 SECONDS

		var/datum/action/cooldown/spell/touch/star_touch/star_touch_spell = locate() in selected.actions
		if(star_touch_spell)
			star_touch_spell.ascended = TRUE

		var/datum/action/cooldown/spell/conjure/cosmic_expansion/cosmic_expansion_spell = locate() in selected.actions
		cosmic_expansion_spell?.ascended = TRUE

	selected.physiology.brute_mod = 0.25
	selected.physiology.burn_mod = 0.25
	selected.physiology.tox_mod = 0.5
	selected.physiology.oxy_mod = 0.5
	selected.physiology.stamina_mod = 0.5
	selected.physiology.stun_mod = 0.5
	selected.physiology.bleed_mod = 0
	selected.set_pain_mod("badmin", 0.6)
	selected.add_consciousness_modifier("badmin", 30)

	clawify(selected, BODY_ZONE_L_ARM, 25, 25, 30)
	clawify(selected, BODY_ZONE_R_ARM, 25, 25, 30)

	var/obj/item/bodypart/leg/left_leg = selected.get_bodypart(BODY_ZONE_L_LEG) // weaker, but allows proper damage after downing somebody
	left_leg.unarmed_damage_low = 18
	left_leg.unarmed_damage_high = 18
	left_leg.unarmed_effectiveness = 20

	var/obj/item/bodypart/leg/right_leg = selected.get_bodypart(BODY_ZONE_R_LEG)
	right_leg.unarmed_damage_low = 18
	right_leg.unarmed_damage_high = 18
	right_leg.unarmed_effectiveness = 20

	ADD_TRAIT(selected, TRAIT_SLEEPIMMUNE, REF(selected)) //needed to prevent chem cheese using wellcheers and sulfonal

	return TRUE
