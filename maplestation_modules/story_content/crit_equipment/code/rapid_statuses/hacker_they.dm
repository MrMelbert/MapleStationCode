/datum/story_rapid_status/hacker_they
	name = "Hacker They"
	selectable = TRUE

/datum/story_rapid_status/hacker_they/apply(mob/living/carbon/human/selected)
	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/pointed/unlock_chromatic_world,
		/datum/action/cooldown/spell/spiders_webs,
	)

	grant_spell_list(selected, spells_to_grant, TRUE)

	return TRUE
