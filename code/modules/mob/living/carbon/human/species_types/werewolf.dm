/datum/species/werewolf
	name = "werewolf"
	id = SPECIES_WEREWOLF
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	mutanttongue = /obj/item/organ/internal/tongue/werewolf
	mutantears = /obj/item/organ/internal/ears/werewolf
 	mutanteyes = /obj/item/organ/internal/eyes/werewolf
	external_organs = list(
		/obj/item/organ/external/tail/cat = "Cat",
	)
	skinned_type = /obj/item/stack/sheet/animalhide/human
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.1

/datum/species/werewolf/prepare_werewolf_for_preview(mob/living/carbon/werewolf/werewolf)
	human.set_haircolor("#bb9966", update = FALSE) // brown
	human.set_hairstyle("Business Hair", update = TRUE)

/datum/species/werewolf/get_species_description()
	return "N/A"

/datum/species/human/get_species_lore()
	return list(
		"N/A",
	)

/datum/species/werewolf/create_pref_unique_perks()
	var/list/to_add = list()

		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "paw",
			SPECIES_PERK_NAME = "Primal Primate",
			SPECIES_PERK_DESC = "Werewolves are monstrous humans, and can't do most things a human can do. Computers are impossible, \
				complex machines are right out, and most clothes don't fit your smaller form.",
		))

		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Sensitive Hearing",
			SPECIES_PERK_DESC = "Werewolves are more sensitive to loud sounds, such as flashbangs.",
		))

	return to_add
