/datum/skill/eva
	name = "EVA"
	title = "EVA Training"
	blurb = "Space is long and dark and empty."
	grants_you = "more effective use of EVA gear"
	modifiers = list(
		// EVA gear speed modifier
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.1,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 0.9,
			SKILL_LEVEL_EXPERT = 0.8,
			SKILL_LEVEL_MASTER = 0.75,
			SKILL_LEVEL_LEGENDARY = 0.5,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/eva/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	mind.current?.update_equipment_speed_mods()

/datum/skill/eva/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	mind.current?.update_equipment_speed_mods()

/// Getter for item slowdown
/obj/item/proc/get_slowdown(mob/living/for_who)
	return slowdown

/obj/item/clothing/suit/space/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/clothing/head/helmet/space/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/clothing/head/mod/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/clothing/suit/mod/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/clothing/shoes/mod/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/clothing/gloves/mod/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)

/obj/item/mod/control/get_slowdown(mob/living/for_who)
	return slowdown * for_who.get_skill_modifier(/datum/skill/eva, SKILL_SPEED_MODIFIER)
