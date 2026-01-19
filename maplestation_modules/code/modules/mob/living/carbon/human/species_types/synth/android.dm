/datum/species/android
	name = "Android"
	plural_form = "Androids"
	id = SPECIES_ANDROID
	sexes = TRUE // i want to set this to false...
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	changesource_flags = MIRROR_BADMIN|MIRROR_PRIDE|MIRROR_MAGIC
	species_language_holder = /datum/language_holder/synthetic
	inherent_traits = list(
		TRAIT_GENELESS,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_RADIMMUNE, // rework this later - warping wires or something
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_UNHUSKABLE,
		// TRAIT_VIRUSIMMUNE, // shouldn't be necessary
	)

	bodytemp_heat_damage_limit = BODYTEMP_HEAT_LAVALAND_SAFE
	bodytemp_cold_damage_limit = BODYTEMP_COLD_ICEBOX_SAFE

	mutantbrain = /obj/item/organ/brain/cybernetic/android
	mutanttongue = /obj/item/organ/tongue/robot/android
	mutantstomach = /obj/item/organ/stomach/ethereal/android
	mutantappendix = null
	mutantheart = /obj/item/organ/heart/android
	mutantliver = /obj/item/organ/liver/android
	mutantlungs = /obj/item/organ/lungs/android
	mutanteyes = /obj/item/organ/eyes/robotic/synth
	mutantears = /obj/item/organ/ears/cybernetic
	species_pain_mod = 0.5 // the bodyparts themselves also reduce pain
	exotic_bloodtype = /datum/blood_type/oil

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/android,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/android,
	)
	digitigrade_legs = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/digi/android,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/digi/android,
	)

	temperature_homeostasis_speed = 0

	var/list/android_species = list(
		SPECIES_FELINE, // needs to be replaced with animids
		SPECIES_HUMAN,
		SPECIES_LIZARD,
		SPECIES_MOTH,
		SPECIES_ORNITHID,
		SPECIES_SKRELL,
	)

#define ID_TO_TYPEPATH(id) GLOB.species_list[id]

/datum/species/android/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load)
	var/species_id = human_who_gained_species.dna?.features["android_species"] || old_species?.id
	if(!species_id || !(species_id in android_species))
		species_id = SPECIES_HUMAN

	var/datum/species/spedies_datum = GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)]
	for(var/organtype in spedies_datum.mutant_organs)
		set_mutant_organ(MUTANT_ORGANS, organtype, human_who_gained_species)
	for(var/markingtype in spedies_datum.body_markings)
		set_mutant_organ(BODY_MARKINGS, markingtype, human_who_gained_species)

	// snowflake cyber replacements
	switch(species_id)
		if(SPECIES_MOTH)
			set_mutant_organ(ORGAN_SLOT_EYES, /obj/item/organ/eyes/robotic/basic/moth, human_who_gained_species)
		if(SPECIES_FELINE)
			set_mutant_organ(ORGAN_SLOT_EARS, /obj/item/organ/ears/cat/cybernetic, human_who_gained_species)

	return ..()

// Add features from all android species for prefs
/datum/species/android/get_features(only_innate = FALSE)
	var/list/features = ..()
	if(only_innate)
		return features

	features = features.Copy() // it's cached we gotta make a copy
	for(var/species_id in android_species)
		features |= GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)].get_features()
	return features

// Filter out features from unselected android species, keep active + innate features
/datum/species/android/get_filtered_features_per_prefs(datum/preferences/prefs)
	var/static/list/cached_features
	if(!cached_features)
		cached_features = list()
		for(var/species_id in android_species)
			cached_features |= GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)].get_features()

	var/list/filtered = cached_features.Copy()
	filtered -= GLOB.species_prototypes[ID_TO_TYPEPATH(prefs.read_preference(/datum/preference/choiced/android_species))].get_features()
	filtered -= get_features(TRUE)

	return filtered

#undef ID_TO_TYPEPATH

/datum/species/android/get_species_description()
	return "Androids are an entirely synthetic species."

/datum/species/android/get_species_lore()
	return list(
		"Androids are a synthetic species created by Nanotrasen as an intermediary between humans and cyborgs."
	)

/datum/species/android/create_pref_temperature_perks()
	var/list/to_add = list()

	// - you don't regulate temperature naturally
	// - heat damage can cause slowdown warping (direct damage)
	// - cold damage causes slowdown and brittleness (increased incoming damage, but no direct damage)
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_TEMPERATURE_HALF,
		SPECIES_PERK_NAME = "Temperature Sensitive",
		SPECIES_PERK_DESC = "Extreme heat or cold may still cause damage to \an [name], \
			though they are significantly more resistant to cold than heat.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_TEMPERATURE_HIGH,
		SPECIES_PERK_NAME = "Running Hot",
		SPECIES_PERK_DESC = "[plural_form] passively generate heat over time. \
			Failure to cool down may lead to overheating.",
	))

	return to_add

/datum/species/android/create_pref_liver_perks()
	var/list/to_add = list()

	// - immune to most chems in general
	// - toxins build up as 'toxicity' that causes negative effects
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SYRINGE,
		SPECIES_PERK_NAME = "In-Filtration",
		SPECIES_PERK_DESC = "[plural_form] are unaffected by most chemicals. \
			Fortunately, this includes most toxic chemicals which would otherwise be harmful. \
			Unfortunately, this also includes most medicines. \
			Additionally, too many toxins at once may clog their filters, leading to adverse effects.",
	))

	return to_add

/datum/species/android/create_pref_lung_perks()
	var/list/to_add = list()

	// - lungs are how you do homeostasis
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_WIND,
		SPECIES_PERK_NAME = "Air Cooled",
		SPECIES_PERK_DESC = "[plural_form] breathe like organic beings, but for an entirely different purpose - \
			Their breaths are used to regulate chassis temperature. Failing to breathe properly may result in overheating.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_LUNGS,
		SPECIES_PERK_NAME = "Any Gas Will Do",
		SPECIES_PERK_DESC = "Unlike most organic beings, [plural_form] can \"breathe\" in any gas without adverse effects. \
			Their lungs are designed to extract heat from their surroundings, not oxygen.",
	))
	return to_add

/datum/species/android/create_pref_blood_perks()
	var/list/to_add = list()

	// - oil instead of blood
	// - oil has less negative effects
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_TINT_SLASH,
		SPECIES_PERK_NAME = "Fuel Efficient",
		SPECIES_PERK_DESC = "Rather than blood, [plural_form] circulate fuel throughout their systems. \
			Fuel will never replenish naturally, but lacking fuel is less punishing than blood loss is for organic beings - \
			though you will still experience degraded performance and eventually shutdown if fuel levels get too low.",
	))

	return to_add

/datum/species/android/create_pref_unique_perks()
	var/list/to_add = list()

	// - you don't need to eat
	// - you DO need to recharge
	// - you can eat to recharge unlike ethereals
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_PLUG_CIRCLE_BOLT,
		SPECIES_PERK_NAME = "Batteries not Included",
		SPECIES_PERK_DESC = "[plural_form] require a steady supply of power to function optimally. \
			Without it, their performance starts to degrade until they eventually shutdown. \
			Charge can be gained directly from batteries or light fixtures, or at APCs or recharging stations.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BURGER,
		SPECIES_PERK_NAME = "Bio-Reactor",
		SPECIES_PERK_DESC = "[plural_form] don't need to eat, but they can convert food or drink into energy using their internal bio-reactor.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BIOHAZARD,
		SPECIES_PERK_NAME = "Self Isolated",
		SPECIES_PERK_DESC = "An overwhelming majority of viral biohazards cannot infect [plural_form].",
	))
	// - you can taste
	// - you don't like or dislike anything
	// - you practically don't get disgusted
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_FACE_GRIN_TONGUE_SQUINT,
		SPECIES_PERK_NAME = "Fuel for the Body",
		SPECIES_PERK_DESC = "[plural_form] can taste food and drink, but derive no pleasure or displeasure from them. \
			They are also incapable of accruing disgust.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_EXPLOSION,
		SPECIES_PERK_NAME = "Ion Vulnerability",
		SPECIES_PERK_DESC = "Being entirely synthetic, [plural_form] are vulnerable to electromagnetic and ion pulses. \
			These will drain their internal power, cause temporary malfunctions, and may even damage their systems if potent enough.",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_COGS,
		SPECIES_PERK_NAME = "Irreplacable Parts",
		SPECIES_PERK_DESC = "The core components of \an [name] are highly specialized. \
			Most of their organs cannot be removed or replaced - they must be surgically repaired if damaged.",
	))

	return to_add

/datum/species/android/create_pref_damage_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_ALT,
		SPECIES_PERK_NAME = "Metallic Chassis",
		SPECIES_PERK_DESC = "Being made of metal, [plural_form] take reduced damage from attacks and sustain practically no pain from injuries. \
			Additionally, low pressure environments don't threaten them - though high pressure can still cause damage.",
	))

	return to_add

/mob/living/carbon/human/get_cell(atom/movable/interface, mob/user)
	var/obj/item/organ/stomach/ethereal/charge_stomach = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(charge_stomach))
		return charge_stomach.cell

	return null

// future todos:
// - radiation effects
// - more emp effects
// - make sure bleeding causes oil to leak
// - look at pain
// - block defibbing, require special revival method
