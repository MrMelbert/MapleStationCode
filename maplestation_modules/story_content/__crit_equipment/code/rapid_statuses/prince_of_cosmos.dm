/datum/story_rapid_status/cosmos/prince_of_cosmos
	name = "Prince of Cosmos"
	selectable = TRUE

/datum/story_rapid_status/cosmos/prince_of_cosmos/apply(mob/living/carbon/human/selected)
	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/jaunt/shadow_walk,
		/datum/action/cooldown/spell/pointed/projectile/star_blast,
		/datum/action/cooldown/spell/touch/star_touch,
		/datum/action/cooldown/spell/shadow_cloak,
	)

	grant_spell_list(selected, spells_to_grant, TRUE)

	clawify(selected, BODY_ZONE_L_ARM, 10, 15, 20)

	return TRUE
