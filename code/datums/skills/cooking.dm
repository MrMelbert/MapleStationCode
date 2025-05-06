/datum/skill/cooking
	name = "Cooking"
	title = "Chef"
	blurb = "Everyone can cook."
	earned_by = "cooking and mixing food"
	grants_you = "tastier food"
	modifiers = list(
		// modifiers food reagent purity in cooked products
		// with poor skill, you make fantastic ingredients good, and mediocre ingredients bad
		// but with high skill, you can make bad ingredients good, and the best is even better
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = 0.75,
			SKILL_LEVEL_NOVICE = 0.9,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 1,
			SKILL_LEVEL_EXPERT = 1.1,
			SKILL_LEVEL_MASTER = 1.2,
			SKILL_LEVEL_LEGENDARY = 1.3,
		),
		// flat addition to food quality
		// with poor skill "nice" food becomes "normal"
		// but with high skill "nice" food becomes "very nice" or even "fantastic"
		SKILL_RANDS_MODIFIER = list(
			SKILL_LEVEL_NONE = -1,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 0.5,
			SKILL_LEVEL_EXPERT = 1,
			SKILL_LEVEL_MASTER = 1.5,
			SKILL_LEVEL_LEGENDARY = 2,
		),
	)

/// Mark a food item as "made by a chef", modify its quality
/proc/handle_chef_made_food(obj/item/food, obj/item/source, datum/mind/chef, xp_mod = 1)
	modify_food_quality(food, chef)
	if(isnull(chef))
		return
	if(HAS_TRAIT(source, TRAIT_FOOD_MUST_INHERIT_CHEF_MADE) && !HAS_TRAIT(source, TRAIT_FOOD_CHEF_MADE))
		return
	ADD_TRAIT(food, TRAIT_FOOD_CHEF_MADE, REF(chef))
	chef.adjust_experience(/datum/skill/cooking, 20 * xp_mod)

/// When given some item with reagents (normally food),
/// modifies the quality of the reagents according to the passed chef's mind's cooking skill
/proc/modify_food_quality(obj/item/food, datum/mind/chef)
	if(isnull(food?.reagents))
		return

	var/purity_modifier = chef?.get_skill_modifier(/datum/skill/cooking, SKILL_VALUE_MODIFIER) || 1
	var/quality_modifier = chef?.get_skill_modifier(/datum/skill/cooking, SKILL_RANDS_MODIFIER) || -1

	for(var/datum/reagent/consumable/nutri in food.reagents.reagent_list)
		// purity in food models how quality the ingredient is
		// we reduce the purtiy based on the chef's skill to model wasting quality parts of the ingredients
		nutri.purity *= purity_modifier
		// we store this in the reagent data to read it later
		LAZYSET(nutri.data, "quality_modifier", quality_modifier)
