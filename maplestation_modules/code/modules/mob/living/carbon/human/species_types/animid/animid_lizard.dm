/datum/animid_type/lizard
	id = "Lizard"
	components = list(
		MUTANT_ORGANS = list(
			/obj/item/organ/horns = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/frills = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/spines = SPRITE_ACCESSORY_NONE,
			/obj/item/organ/tail/lizard = /datum/sprite_accessory/tails/lizard/smooth::name,
		),
	)

	animid_flags = HAS_SCALES
	name = "Reptilid"
	icon = FA_ICON_DRAGON

/datum/animid_type/lizard/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	// ensures we get mutant color rather than a random forced color
	new_animid.dna?.features["forced_mut_color"] = new_animid.dna?.features["mcolor"]
	species.mutanttongue = new_animid.dna?.features["hissing"] ? /obj/item/organ/tongue/lizard : /obj/item/organ/tongue/lizard/no_hiss
	if(new_animid.dna?.features["limb_scales"])
		species.bodypart_overrides = SCALED_LIMBS_LIST

/datum/animid_type/lizard/extra_feature_keys()
	return list(/datum/preference/color/mutant_color::savefile_key)

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
				However, good luck disguising your scaled skin, if you have it that is.",
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
	// behavior is only applied on animids by default
	target.dna.features["hissing"] = value

/datum/preference/toggle/liz_tongue_hissing/is_accessible(datum/preferences/preferences)
	return ..() && ((ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)) && (preferences.read_preference(/datum/preference/choiced/animid_type) == /datum/animid_type/lizard::id))

/obj/item/organ/tongue/lizard/no_hiss // because modifies_speech only affects things on init
	name = "mutated forked tongue"
	desc = "A thin and long muscle typically found in reptilian races, apparently moonlights as a nose. The ends on this one appear more rigid than normal, reducing the amount of hissing."
	modifies_speech = FALSE // no hiss for you
	draw_length = 0
