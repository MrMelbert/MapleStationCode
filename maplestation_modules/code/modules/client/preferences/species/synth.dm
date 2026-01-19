#define NO_DISGUISE "(No Disguise)"

/datum/preference/choiced/synth_species
	savefile_key = "feature_synth_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_GENDER

/datum/preference/choiced/synth_species/init_possible_values()
	var/datum/species/android/synth/synth = GLOB.species_prototypes[/datum/species/android/synth]

	. = list()
	. += synth.valid_species
	. += NO_DISGUISE

/datum/preference/choiced/synth_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/synth_species/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/android/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(value == NO_DISGUISE)
		synth.drop_disguise(target)
		return
	if(value in synth.valid_species)
		synth.disguise_as(target, GLOB.species_list[value])
		return

/datum/preference/choiced/synth_species/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/android/synth)

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
	var/datum/species/android/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	synth.disuise_damage_threshold = value

/datum/preference/numeric/synth_damage_threshold/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/android/synth)

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
	var/datum/species/android/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(value == "As Disguise" && synth.disguise_species)
		synth.exotic_bloodtype = synth.disguise_species.exotic_bloodtype
	else
		synth.exotic_bloodtype = /datum/blood_type/oil

/datum/preference/choiced/synth_blood/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/android/synth)

//synth head covers (aka head design options)
/datum/preference/choiced/synth_head_cover
	main_feature_name = "Head Cover"
	savefile_key = "feature_synth_head_cover"

	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = TRUE
	relevant_external_organ = /obj/item/organ/synth_head_cover
	should_generate_icons = TRUE

/datum/preference/choiced/synth_head_cover/init_possible_values()
	return assoc_to_keys(SSaccessories.synth_head_cover_list)

/datum/preference/choiced/synth_head_cover/icon_for(value)
	var/datum/sprite_accessory/sprite_accessory = SSaccessories.synth_head_cover_list[value]
	var/datum/universal_icon/head = uni_icon('maplestation_modules/icons/mob/synth_heads.dmi', "synth_head", SOUTH)

	var/datum/universal_icon/final_icon = head.copy()

	if (!isnull(sprite_accessory))
		for(var/side in list("ADJ", "FRONT"))
			var/datum/universal_icon/accessory_icon = uni_icon('maplestation_modules/icons/mob/synth_heads.dmi', "m_synth_head_cover_[sprite_accessory.icon_state]_ADJ", dir = SOUTH)
			final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	final_icon.crop(11, 20, 23, 32)
	final_icon.scale(32, 32)
	final_icon.blend_color(COLOR_GRAY, ICON_MULTIPLY)

	return final_icon

/datum/preference/choiced/synth_head_cover/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["synth_head_cover"] = value

/datum/preference/choiced/synth_head_cover/create_default_value()
	return /datum/sprite_accessory/synth_head_cover::name

/datum/preference/choiced/android_species
	savefile_key = "feature_android_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE

/datum/preference/choiced/android_species/init_possible_values()
	var/datum/species/android/droid = GLOB.species_prototypes[/datum/species/android]

	. = list()
	. += droid.android_species

/datum/preference/choiced/android_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/android_species/apply_to_human(mob/living/carbon/human/target, value)
	target.dna?.features["android_species"] = value

/datum/preference/choiced/android_species/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	var/pref_species = preferences.read_preference(/datum/preference/choiced/species)
	if(!ispath(pref_species, /datum/species/android))
		return FALSE
	if(ispath(pref_species, /datum/species/android/synth))
		return FALSE

	return TRUE

/datum/preference/toggle/android_emotions
	savefile_key = "feature_android_emotionless"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	default_value = TRUE

/datum/preference/toggle/android_emotions/apply_to_human(mob/living/carbon/human/target, value)
	target.dna?.features["android_emotionless"] = !value // the pref is "i want emotions", the feature is "we don't have emotions"

/datum/preference/toggle/android_emotions/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/android)

/datum/preference/choiced/android_laws
	savefile_key = "feature_android_laws"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	/// Assoc list of readable law name to law ID, set in init
	VAR_FINAL/list/lawname_to_lawid

/datum/preference/choiced/android_laws/New()
	. = ..()
	lawname_to_lawid = list(
		"Unlawed" = "",
	)

	// assoc list of law typepath to law name override - no override, use default name
	var/list/lawsets = list(
		/datum/ai_laws/default/asimov = "Asimov",
		/datum/ai_laws/asimovpp = null,
		/datum/ai_laws/asimovmm = null,
		/datum/ai_laws/default/corporate = "Nanotrasen™ Corporate",
		/datum/ai_laws/maintain = null,
		/datum/ai_laws/hippocratic = "Hippocratic Oath",
		/datum/ai_laws/liveandletlive = null,
		/datum/ai_laws/default/paladin = "Paladin v3.5e",
		/datum/ai_laws/paladin5 = "Paladin v5e",
		/datum/ai_laws/tyrant = "Tyrant",
	)
	for(var/datum/ai_laws/lawset as anything in lawsets)
		lawname_to_lawid[lawsets[lawset] || lawset::name] = lawset::id

/datum/preference/choiced/android_laws/init_possible_values()
	return assoc_to_keys(lawname_to_lawid)

/datum/preference/choiced/android_laws/create_default_value()
	return lawname_to_lawid[1]

/datum/preference/choiced/android_laws/apply_to_human(mob/living/carbon/human/target, value)
	target.dna?.features["android_laws"] = lawname_to_lawid[value]

/datum/preference/choiced/android_laws/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/android)

/datum/preference_middleware/android_laws
	key = "laws"

/datum/preference_middleware/android_laws/get_constant_data()
	var/list/data = list()

	data["lawname_to_laws"] = list()

	var/datum/preference/choiced/android_laws/pref = GLOB.preference_entries[/datum/preference/choiced/android_laws]
	for(var/lawname, lawid in pref.lawname_to_lawid)
		if(lawid == "")
			continue
		var/lawset_type = lawid_to_type(lawid)
		var/datum/ai_laws/lawset = new lawset_type()
		var/list/laws = lawset.get_law_list(render_html = FALSE)
		for(var/i in 1 to length(laws))
			laws[i] = replacetext(laws[i], "human being", "crewmember")

		data["lawname_to_laws"][lawname] = laws

	return data
