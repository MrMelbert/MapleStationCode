#define NO_DISGUISE "(No Disguise)"

/datum/preference/choiced/synth_species
	savefile_key = "feature_synth_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_GENDER

/datum/preference/choiced/synth_species/init_possible_values()
	var/datum/species/synth/synth = new()
	. = synth.valid_species.Copy()
	. += NO_DISGUISE
	qdel(synth)
	return .

/datum/preference/choiced/synth_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/synth_species/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(value == NO_DISGUISE)
		synth.drop_disguise(target)
		return
	if(value in synth.valid_species)
		synth.disguise_as(target, GLOB.species_list[value])
		return

/datum/preference/choiced/synth_species/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/synth)

#undef NO_DISGUISE

/datum/preference/numeric/synth_damage_threshold
	savefile_key = "feature_synth_damage_threshold"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	minimum = -100
	maximum = 75

/datum/preference/numeric/synth_damage_threshold/create_default_value()
	return 25

/datum/preference/numeric/synth_damage_threshold/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	synth.disuise_damage_threshold = value

/datum/preference/numeric/synth_damage_threshold/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/synth)

/datum/preference/choiced/synth_blood
	savefile_key = "feature_synth_blood"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_BODY_TYPE

/datum/preference/choiced/synth_blood/init_possible_values()
	return list("Always Oil", "As Disguise")

/datum/preference/choiced/synth_blood/create_default_value()
	return "As Disguise"

/datum/preference/choiced/synth_blood/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(value == "As Disguise" && synth.disguise_species)
		synth.exotic_bloodtype = synth.disguise_species.exotic_bloodtype
	else
		synth.exotic_bloodtype = /datum/blood_type/oil

/datum/preference/choiced/synth_blood/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/synth)



//synth head covers (aka head design options)
/datum/preference/choiced/synth_head_cover
	main_feature_name = "Head Cover"
	savefile_key = "feature_synth_head_cover"

	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = TRUE
	relevant_external_organ = /obj/item/organ/external/synth_head_cover
	should_generate_icons = TRUE

/datum/preference/choiced/synth_head_cover/init_possible_values()
	return assoc_to_keys(SSaccessories.synth_head_cover_list)

/datum/preference/choiced/synth_head_cover/icon_for(value)
	var/datum/sprite_accessory/sprite_accessory = SSaccessories.synth_head_cover_list[value]
	var/icon/head = icon('maplestation_modules/icons/mob/synth_heads.dmi', "synth_head", SOUTH)

	var/icon/final_icon = icon(head)

	if (!isnull(sprite_accessory))
		for(var/side in list("ADJ", "FRONT"))
			var/icon/accessory_icon = icon(
				icon = 'maplestation_modules/icons/mob/synth_heads.dmi',
				icon_state = "m_synth_head_cover_[sprite_accessory.icon_state]_ADJ",
				dir = SOUTH,
			)
			final_icon.Blend(accessory_icon, ICON_OVERLAY)

	final_icon.Crop(11, 20, 23, 32)
	final_icon.Scale(32, 32)
	final_icon.Blend(COLOR_GRAY, ICON_MULTIPLY)

	return final_icon

/datum/preference/choiced/synth_head_cover/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["synth_head_cover"] = value

/datum/preference/choiced/synth_head_cover/create_default_value()
	return /datum/sprite_accessory/synth_head_cover::name
