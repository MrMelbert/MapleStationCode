/datum/skill/bartending
	name = "Bartending"
	title = "Bartender"
	blurb = "It's time to mix drinks and change lives."
	earned_by = "mixing drinks"
	// grants_you = "tastier drinks"
	modifiers = list()
	skill_flags = SKILL_ALWAYS_PRINT

/**
 * Grants xp to the user for initiating a reaction
 *
 * * mixer - The user who initiated the reaction, asserted to have a mind
 */
/datum/reagents/proc/award_mixing_exp(mob/living/mixer)
	for(var/datum/equilibrium/reaction as anything in reaction_list)
		if(reaction.reaction.reaction_tags & REACTION_TAG_DRINK)
			if(reaction.reaction.reaction_tags & REACTION_TAG_EASY)
				mixer.mind.adjust_experience(/datum/skill/bartending, 10)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_MODERATE)
				mixer.mind.adjust_experience(/datum/skill/bartending, 50)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_HARD)
				mixer.mind.adjust_experience(/datum/skill/bartending, 100)

		if(reaction.reaction.reaction_tags & REACTION_TAG_FOOD)
			if(reaction.reaction.reaction_tags & REACTION_TAG_EASY)
				mixer.mind.adjust_experience(/datum/skill/cooking, 10)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_MODERATE)
				mixer.mind.adjust_experience(/datum/skill/cooking, 50)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_HARD)
				mixer.mind.adjust_experience(/datum/skill/cooking, 100)

		if(reaction.reaction.reaction_tags & (REACTION_TAG_DRUG|REACTION_TAG_HEALING))
			if(reaction.reaction.reaction_tags & REACTION_TAG_EASY)
				mixer.mind.adjust_experience(/datum/skill/chemistry, 10)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_MODERATE)
				mixer.mind.adjust_experience(/datum/skill/chemistry, 50)
			else if(reaction.reaction.reaction_tags & REACTION_TAG_HARD)
				mixer.mind.adjust_experience(/datum/skill/chemistry, 100)
