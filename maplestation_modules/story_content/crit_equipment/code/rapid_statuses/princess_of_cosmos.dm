/datum/story_rapid_status/cosmos/bound_princess
	name = "Bound Princess"
	selectable = TRUE

/datum/story_rapid_status/cosmos/bound_princess/apply(mob/living/carbon/human/selected)
	ADD_TRAIT(selected, TRAIT_FULL_PSIONIC, REF(selected))
	ADD_TRAIT(selected, TRAIT_SWORD_PSIONIC, REF(selected))
	ADD_TRAIT(selected, TRAIT_DEVIL_WEBBED, REF(selected))

	return TRUE


/datum/story_rapid_status/cosmos/bound_princess/princess_of_cosmos
	name = "Princess of Cosmos"

/datum/story_rapid_status/cosmos/bound_princess/princess_of_cosmos/apply(mob/living/carbon/human/selected)
	. = ..()
	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/pointed/projectile/star_blast,
		/datum/action/cooldown/spell/touch/star_touch,
	)

	grant_spell_list(selected, spells_to_grant, TRUE)

	clawify(selected, BODY_ZONE_R_ARM, 10, 15, 20)

	return TRUE
