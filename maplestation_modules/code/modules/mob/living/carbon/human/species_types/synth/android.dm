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
	mutantears = /obj/item/organ/ears/android
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

	/// Whether or not to block organic bodyparts from being attached
	var/allow_fleshy_bits = FALSE

	/// Tracks if we have begun leaking due to excess blood volume
	VAR_FINAL/is_leaking = FALSE
	/// Tracks overheating state (0-3)
	VAR_FINAL/is_overheating = 0
	/// Tracks overcooling state (0-3)
	VAR_FINAL/is_overcooled = 0

	/// List of species an android can be designed as
	var/list/android_species = list(
		SPECIES_ANIMALID,
		SPECIES_HUMAN,
		SPECIES_LIZARD,
		SPECIES_MOTH,
		SPECIES_ORNITHID,
		SPECIES_SKRELL,
	)

/datum/species/android/on_species_gain(mob/living/carbon/human/gained_species, datum/species/old_species, pref_load)
	var/species_id = gained_species.dna?.features["android_species"] || old_species?.id
	if(!species_id || !(species_id in android_species))
		species_id = SPECIES_HUMAN

	var/datum/species/copy_datum = GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)]
	for(var/organtype in copy_datum.mutant_organs)
		set_mutant_organ(MUTANT_ORGANS, organtype, gained_species)
	for(var/markingtype in copy_datum.body_markings)
		set_mutant_organ(BODY_MARKINGS, markingtype, gained_species)
	// snowflakes
	switch(species_id)
		if(SPECIES_ANIMALID)
			apply_animid_features(gained_species, gained_species.dna?.features["animid_type"] || pick(GLOB.animid_singletons), list(ORGAN_SLOT_EARS, MUTANT_ORGANS, BODY_MARKINGS))
		if(SPECIES_MOTH)
			set_mutant_organ(ORGAN_SLOT_EYES, /obj/item/organ/eyes/robotic/basic/moth, gained_species)
		if(SPECIES_FELINE)
			set_mutant_organ(ORGAN_SLOT_EARS, /obj/item/organ/ears/cat/cybernetic, gained_species)

	RegisterSignal(gained_species, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(handle_blood))
	RegisterSignal(gained_species, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(gained_species, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE, PROC_REF(temperature_update))
	RegisterSignal(gained_species, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(brittle_modifier))
	RegisterSignal(gained_species, COMSIG_ATTEMPT_CARBON_ATTACH_LIMB, PROC_REF(block_fleshy_bits))
	RegisterSignal(gained_species, COMSIG_HUMAN_ON_HANDLE_BREATH_TEMPERATURE, PROC_REF(handle_breath_temperature))
	return ..()

/datum/species/android/on_species_loss(mob/living/carbon/human/lost_species, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(lost_species, COMSIG_HUMAN_ON_HANDLE_BLOOD)
	UnregisterSignal(lost_species, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(lost_species, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE)
	UnregisterSignal(lost_species, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
	UnregisterSignal(lost_species, COMSIG_ATTEMPT_CARBON_ATTACH_LIMB)
	UnregisterSignal(lost_species, COMSIG_HUMAN_ON_HANDLE_BREATH_TEMPERATURE)
	if(is_leaking)
		remove_leaking(lost_species)
	if(is_overheating)
		remove_heat_modifiers(lost_species)
	if(is_overcooled)
		remove_cold_modifiers(lost_species)

/datum/species/android/proc/remove_leaking(mob/living/carbon/human/removing)
	if(!is_leaking)
		return

	is_leaking = FALSE
	removing.physiology.bleed_mod /= 3
	removing.clear_alert("leak_warning")

/datum/species/android/proc/remove_heat_modifiers(mob/living/carbon/human/removing)
	if(!is_overheating)
		return

	is_overheating = 0
	removing.remove_actionspeed_modifier(/datum/actionspeed_modifier/hot_android)
	removing.remove_movespeed_modifier(/datum/movespeed_modifier/hot_android)
	removing.clear_alert(ALERT_TEMPERATURE)

/datum/species/android/proc/remove_cold_modifiers(mob/living/carbon/human/removing)
	if(!is_overcooled)
		return

	is_overcooled = 0
	removing.remove_actionspeed_modifier(/datum/actionspeed_modifier/cold_android)
	removing.remove_movespeed_modifier(/datum/movespeed_modifier/cold_android)
	removing.clear_alert(ALERT_TEMPERATURE)

/**
 * let's go over the mechanics
 *
 * 1. androids blood is oil / lubricant, and it serves as "hydraulic fluid".
 * their heart pumps the oil through the body, allowing limbs to move properly.
 *
 * 2. android lungs function as (currently) air cooling, taking in air to cool down
 *
 * 3. android livers function as a mechanical filter for toxic elements, which can clog up
 *
 * 4. android stomachs are "bioreactors" transforming food into power
 */
/datum/species/android/spec_life(mob/living/carbon/human/android, seconds_per_tick, times_fired)
	. = ..()
	// model pump behavior
	var/obj/item/organ/heart = android.get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(heart) || IS_ORGANIC_ORGAN(heart))
		// lacking a mechanical heart will eventually consume all of your oil/hydraulic fluid
		android.bleed(0.5 * seconds_per_tick, leave_pool = FALSE)
	else
		// otherwise the pump generates heat passively
		android.adjust_body_temperature(0.12 KELVIN * seconds_per_tick, max_temp = android.bodytemp_heat_damage_limit * 1.5)

	if(is_overheating)
		android.temperature_burns(1.25 * is_overheating * seconds_per_tick)
	if(is_overcooled)
		android.temperature_cold_damage(0.5 * is_overcooled * seconds_per_tick)

/datum/species/android/proc/block_fleshy_bits(mob/living/carbon/human/source, obj/item/bodypart/attaching, special)
	SIGNAL_HANDLER

	return (!allow_fleshy_bits && IS_ORGANIC_LIMB(attaching)) ? COMPONENT_NO_ATTACH : NONE

/datum/species/android/proc/brittle_modifier(mob/living/carbon/human/source, list/damage_mods, damage_type, damage, damage_amount, ...)
	SIGNAL_HANDLER

	if(damage_type != BRUTE)
		return

	switch(is_overcooled)
		if(2)
			damage_mods += 1.1
		if(3)
			damage_mods += 1.25

/datum/species/android/proc/temperature_update(mob/living/carbon/human/source, old_temp, new_temp)
	SIGNAL_HANDLER

	if(source.body_temperature > source.bodytemp_heat_damage_limit)
		update_heat_modifiers(source)
	else if(source.body_temperature < source.bodytemp_cold_damage_limit)
		update_cold_modifiers(source)
	else if(is_overheating)
		remove_heat_modifiers(source)
	else if(is_overcooled)
		remove_cold_modifiers(source)

/datum/species/android/proc/handle_blood(mob/living/carbon/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	switch(source.blood_volume)
		if(BLOOD_VOLUME_MAXIMUM to INFINITY)
			EMPTY_BLOCK_GUARD // handled in on_moved
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_MAXIMUM)
			EMPTY_BLOCK_GUARD // all good
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.9)
			source.add_consciousness_modifier(BLOOD_LOSS, -10)
			if(SPT_PROB(2.5, seconds_per_tick))
				source.set_eye_blur_if_lower(12 SECONDS)
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.6)
			source.add_consciousness_modifier(BLOOD_LOSS, -20)
			source.set_eye_blur_if_lower(6 SECONDS)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.2)
			source.add_consciousness_modifier(BLOOD_LOSS, -50)

	if(source.blood_volume > BLOOD_VOLUME_OKAY)
		source.remove_max_consciousness_value(BLOOD_LOSS)
		source.remove_consciousness_modifier(BLOOD_LOSS)

	return HANDLE_BLOOD_HANDLED

/datum/species/android/proc/on_moved(mob/living/carbon/human/source, atom/from_loc, movement_dir, ...)
	SIGNAL_HANDLER

	if(!ishuman(source))
		return // whatever man

	if(source.blood_volume <= BLOOD_VOLUME_EXCESS)
		if(is_leaking)
			remove_leaking()
		return

	if(!is_leaking)
		is_leaking = TRUE
		source.physiology.bleed_mod *= 3
		source.throw_alert("leak_warning", /atom/movable/screen/alert/blood_leak)

	var/shedded_blood = BLOOD_AMOUNT_PER_DECAL * (source.blood_volume >= BLOOD_VOLUME_MAXIMUM ? 0.33 : 0.1)
	source.make_blood_trail(
		target_turf = get_turf(source),
		start = from_loc,
		was_facing = source.dir,
		movement_direction = movement_dir,
		blood_to_add = shedded_blood,
		blood_dna = source.get_blood_dna_list(),
		static_viruses = source.get_static_viruses(),
	)
	source.blood_volume -= shedded_blood

// androids don't do homeostasis, instead they use their lungs to cool themselves
/datum/species/android/proc/handle_breath_temperature(mob/living/carbon/human/breather, datum/gas_mixture/breath, obj/item/organ/lungs)
	SIGNAL_HANDLER

	if(IS_ORGANIC_ORGAN(lungs))
		return HANDLE_BREATH_TEMPERATURE_HANDLED // nothing happened!

	// future todo: make better heat capacity gases work better here
	var/temp_delta = round((breath.temperature - breather.body_temperature), 0.01)
	if(temp_delta == 0)
		return HANDLE_BREATH_TEMPERATURE_HANDLED

	temp_delta = temp_delta < 0 ? max(temp_delta, BODYTEMP_HOMEOSTASIS_COOLING_MAX) : min(temp_delta, BODYTEMP_HOMEOSTASIS_HEATING_MAX)

	var/min = temp_delta < 0 ? breather.standard_body_temperature : 0
	var/max = temp_delta > 0 ? breather.standard_body_temperature : INFINITY

	breather.adjust_body_temperature(temp_delta, min, max)
	breath.temperature = breather.body_temperature
	return HANDLE_BREATH_TEMPERATURE_HANDLED

/// Has trait but not from lungs if present
#define HAS_TRAIT_NOT_FROM_LUNGS(mob, trait, lungs) (isnull(lungs) ? HAS_TRAIT(mob, trait) : HAS_TRAIT_NOT_FROM(mob, trait, REF(lungs)))

/datum/species/android/proc/update_heat_modifiers(mob/living/carbon/human/source)
	var/obj/item/organ/lungs = source.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(HAS_TRAIT_NOT_FROM_LUNGS(source, TRAIT_RESISTHEAT, lungs))
		remove_heat_modifiers()
		return

	if(source.body_temperature > source.bodytemp_heat_damage_limit * 2)
		if(is_overheating != 3)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t3)
			source.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t3)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 3)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_critical_overheat)
			is_overheating = 3

	else if(source.body_temperature > source.bodytemp_heat_damage_limit * 1.75)
		if(is_overheating != 2)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t2)
			source.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t2)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 2)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_major_overheat)
			is_overheating = 2

	else if(source.body_temperature > source.bodytemp_heat_damage_limit * 1.2)
		if(is_overheating != 1)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t1)
			source.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t1)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 1)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_minor_overheat)
			is_overheating = 1

/datum/species/android/proc/update_cold_modifiers(mob/living/carbon/human/source)
	var/obj/item/organ/lungs = source.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(HAS_TRAIT_NOT_FROM_LUNGS(source, TRAIT_RESISTCOLD, lungs))
		remove_cold_modifiers()
		return

	if(source.body_temperature < source.bodytemp_cold_damage_limit * 2)
		if(is_overcooled != 3)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t3)
			source.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t3)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 3)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_critical_overcool)
			is_overcooled = 3

	else if(source.body_temperature < source.bodytemp_cold_damage_limit * 1.75)
		if(is_overcooled != 2)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t2)
			source.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t2)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 2)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_major_overcool)
			is_overcooled = 2

	else if(source.body_temperature < source.bodytemp_cold_damage_limit * 1.2)
		if(is_overcooled != 1)
			source.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t1)
			source.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t1)
			source.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 1)
			source.add_mood_event(ALERT_TEMPERATURE, /datum/mood_event/android_minor_overcool)
			is_overcooled = 1

#undef HAS_TRAIT_NOT_FROM_LUNGS

// Add features from all android species for prefs
/datum/species/android/get_features()
	. = ..()
	for(var/species_id in android_species)
		. |= GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)].get_features()

// Filter out features from unselected android species, keep active + innate features
/datum/species/android/filter_features_per_prefs(list/to_filter, datum/preferences/prefs)
	. = ..()
	var/selected_species_id = prefs.read_preference(/datum/preference/choiced/android_species)
	// filter out all unselected species features
	for(var/species_id in android_species - selected_species_id)
		to_filter -= GLOB.species_prototypes[ID_TO_TYPEPATH(species_id)].get_features()

	// re-add features that we may have filtered from our selected species
	var/datum/species/selected_species = GLOB.species_prototypes[ID_TO_TYPEPATH(selected_species_id)]
	to_filter |= selected_species.get_features()
	// allow our select species to filter its own features per its prefs
	selected_species.filter_features_per_prefs(to_filter, prefs)

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
