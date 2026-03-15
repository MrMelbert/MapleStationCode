/datum/skill/bartending
	name = "Mixology"
	title = "Mixologist"
	blurb = "It's time to mix drinks and change lives."
	earned_by = "mixing drinks"
	// grants_you = "tastier drinks" // to implement when fermichem is gone
	modifiers = list()

/**
 * Grants xp to the user for initiating a reaction
 *
 * * mixer - The user who initiated the reaction, asserted to have a mind
 */
/datum/reagents/proc/award_mixing_exp(datum/chemical_reaction/reaction, amount_created = 10)
	var/lastkey = my_atom?.fingerprintslast
	if(!lastkey)
		return
	var/mob/living/mixer = get_mob_by_ckey(lastkey)
	var/turf/mix_turf = get_turf(my_atom)
	if(!istype(mixer) || mixer.incapacitated(ALL) || isnull(mixer.mind) || !can_see(mixer, mix_turf, 5))
		return

	if(reaction.reaction_tags & REACTION_TAG_DRINK)
		var/xp_mod = (amount_created / 50)
		if(reaction.reaction_tags & REACTION_TAG_EASY)
			mixer.adjust_skill_experience(/datum/skill/bartending, 10 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_MODERATE)
			mixer.adjust_skill_experience(/datum/skill/bartending, 25 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_HARD)
			mixer.adjust_skill_experience(/datum/skill/bartending, 50 * xp_mod)

	if(reaction.reaction_tags & REACTION_TAG_FOOD)
		var/xp_mod = (amount_created / 50)
		if(istype(reaction, /datum/chemical_reaction/food))
			var/datum/chemical_reaction/food/food_reaction = reaction
			if(food_reaction.resulting_food_path)
				xp_mod *= 5 // bonus for making actual food

		if(reaction.reaction_tags & REACTION_TAG_EASY)
			mixer.adjust_skill_experience(/datum/skill/cooking, 10 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_MODERATE)
			mixer.adjust_skill_experience(/datum/skill/cooking, 25 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_HARD)
			mixer.adjust_skill_experience(/datum/skill/cooking, 50 * xp_mod)

	if(reaction.reaction_tags & (REACTION_TAG_DRUG|REACTION_TAG_HEALING))
		var/xp_mod = (amount_created / 50)
		if(reaction.reaction_tags & REACTION_TAG_EASY)
			mixer.adjust_skill_experience(/datum/skill/chemistry, 10 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_MODERATE)
			mixer.adjust_skill_experience(/datum/skill/chemistry, 25 * xp_mod)
		else if(reaction.reaction_tags & REACTION_TAG_HARD)
			mixer.adjust_skill_experience(/datum/skill/chemistry, 50 * xp_mod)

// This blows
/datum/chemical_reaction/drink/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	. = ..()
	holder.award_mixing_exp(src, created_volume)

/datum/chemical_reaction/food/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	. = ..()
	holder.award_mixing_exp(src, created_volume)

/datum/chemical_reaction/medicine/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	. = ..()
	holder.award_mixing_exp(src, created_volume)

/datum/chemical_reaction/drug/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	. = ..()
	holder.award_mixing_exp(src, created_volume)
