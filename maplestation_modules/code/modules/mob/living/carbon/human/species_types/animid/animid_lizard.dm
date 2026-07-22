/datum/animid_type/lizard
	id = "Lizard"
	components = list(
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/scaled,
		BODY_ZONE_HEAD  = /obj/item/bodypart/head/scaled,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/scaled,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/scaled,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/scaled,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/scaled,
		MUTANT_ORGANS = list(
			/obj/item/organ/horns = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/frills = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/spines = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/tail/lizard = "Smooth",
		),
	)

	name = "Reptilid"
	icon = FA_ICON_HAND_LIZARD

/datum/animid_type/lizard/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	// ensures we get mutant color rather than a random forced color
	new_animid.dna?.features["forced_mut_color"] = new_animid.dna?.features["mcolor"]
	if (new_animid.dna?.features["Hissing"] == TRUE)
		components.Add(list(ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/lizard))
	else
		components.Add(list(ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/lizard/no_hiss))

/datum/animid_type/lizard/extra_feature_keys()
	return list(/datum/preference/color/mutant_color::savefile_key, /datum/preference/toggle/liz_tongue_hissing::savefile_key)

/datum/animid_type/lizard/get_readable_features()
	return ..() + "Scales"

/datum/animid_type/lizard/get_extra_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_HAND_FIST,
			SPECIES_PERK_NAME = "Scaled Defense",
			SPECIES_PERK_DESC = "[name] scales provide a minor amount of resistance to bruises and burns. \
				However, good luck disguising your scaled skin.",
		),
	)

	return to_add

/datum/preference/toggle/liz_tongue_hissing
	savefile_key = "liz_tongue_hissing"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	default_value = FALSE

/datum/preference/toggle/liz_tongue_hissing/apply_to_human(mob/living/carbon/human/target, value)
	if(!(is_species(target, /datum/species/human/animid) && (target.dna.features["animid_type"] == "Lizard")))
		return // sorry, but we're not blocking lizardpeople from hissing in this codebase
	target.dna.features["Hissing"] = value

/datum/preference/toggle/liz_tongue_hissing/is_accessible(datum/preferences/preferences)
	return ..() && ((ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)) && (preferences.read_preference(/datum/preference/choiced/animid_type) == "Lizard"))

/obj/item/organ/tongue/lizard/no_hiss // because modifies_speech only affects things on init
	name = "mutated forked tongue"
	desc = "A thin and long muscle typically found in reptilian races, apparently moonlights as a nose. The ends on this one appear more rigid than normal, reducing the amount of hissing."
	modifies_speech = FALSE // no hiss for you
	draw_length = 0
