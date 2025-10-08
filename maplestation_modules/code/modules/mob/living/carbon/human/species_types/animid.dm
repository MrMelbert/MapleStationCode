#define MUTANT_ORGANS "mutant"

#define SKIN_TYPE_SKIN "Skin"
#define SKIN_TYPE_FUR "Fur"
#define SKIN_TYPE_SCALES "Scales"

/datum/species/human/animid
	name = "Animid"
	id = SPECIES_ANIMALID
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	digitigrade_legs = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/animal,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/animal,
	)
	/// A mapping of all animid ids to their singleton instances
	var/static/list/datum/animalid_type/animid_singletons

/datum/species/human/animid/New()
	. = ..()
	if(animid_singletons)
		return

	animid_singletons = list()
	for(var/datum/animalid_type/atype as anything in typesof(/datum/animalid_type))
		if(!atype::id)
			continue
		animid_singletons[atype::id] = new atype()

/datum/species/human/animid/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load)
	switch(human_who_gained_species.dna?.features["animid_skin_type"])
		if(SKIN_TYPE_FUR)
			inherent_traits |= TRAIT_MUTANT_COLORS
			inherent_traits -= TRAIT_USES_SKINTONES
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/furry
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/furry
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left/furry
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right/furry
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest/furry
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head/furry
			digitigrade_legs[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/digitigrade/animal
			digitigrade_legs[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/digitigrade/animal
		if(SKIN_TYPE_SCALES)
			inherent_traits |= TRAIT_MUTANT_COLORS
			inherent_traits -= TRAIT_USES_SKINTONES
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/lizard
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/lizard
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left/lizard
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right/lizard
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest/lizard
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head/furry // lizard heads are too much
			digitigrade_legs[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/digitigrade
			digitigrade_legs[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/digitigrade
		else
			inherent_traits |= TRAIT_USES_SKINTONES
			inherent_traits -= TRAIT_MUTANT_COLORS
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head
			digitigrade_legs.Cut()

	var/animid_id = human_who_gained_species.dna?.features["animid_type"] || pick(animid_singletons)
	for(var/organ_slot, organ_type_or_types in animid_singletons[animid_id].components)
		set_mutant_organ(organ_slot, organ_type_or_types)

	. = ..()
	// Call this anyways so we can update fur
	if(old_species.type == type)
		replace_body(human_who_gained_species, src)

/datum/species/human/animid/get_physical_attributes()
	return "Being a human hybrid, Animids are very similar to humans in almost all respects. \
		Depending on whichever animal DNA they were spliced with, they may have some \
		physical advantages or disadvantages, but nothing too extreme."

/datum/species/human/animid/get_species_description()
	return "Animids is a blanket term for a variety of genetic \
		modifications to come of humanity's mastery of genetic science. \
		These modifications involve splicing animal DNA into human DNA, \
		resulting in a humanoid with some animal traits."

/datum/species/human/animid/get_species_lore()
	return list(
		"For centuries, humans have been eager to splice their own DNA with animal DNA to create a more perfect lifeform: after all, \
			what could beat the fortitude of the human combined with the agility of a cat, the strength of a bear, or the sight of an eagle?",

		"Eventually, through decades upon decades of work, human bio-engineering progressed \
			to a point where such splices were not only possible, not only stable, but mass-applicable. \
			These new beings were dubbed \"Animids\", and were seen as a new step in human evolution - for a time.",

		"Following the honeymoon period, the general public soon grew wary of these new beings - \
			they were soon feared for a plethora of reasons, such as ethical grounds, over concerns of animal instincts taking over, \
			due to misuse by criminal elements, or simply an irrational prejudice against those who were different. \
			This growing distrust and agitation led many Animids to seek greener pastures out in the colonies, \
			where they could use their abilities to aid humanity's expansion into the stars without the threat of persecution.",

		"Many Animids grouped together into communities of their own kind, sometimes even forming their own settlements. \
			As a result, outer Human space has a high Animid population.",
	)

/datum/species/human/animid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_DOG,
			SPECIES_PERK_NAME = "Animal Instincts",
			SPECIES_PERK_DESC = "Being part animal, Animids inherit many traits from their animal side. \
				These traits vary wildly depending on the animal DNA they were spliced with, \
				and often come with both advantages and disadvantages.",
		),
	)

	return to_add

/datum/species/human/animid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#ffcccc", update = FALSE) // pink
	human_for_preview.set_hairstyle("Hime Cut", update = TRUE)

	var/obj/item/organ/internal/ears/cat/cat_ears = new()
	cat_ears.Insert(human_for_preview, special = TRUE, movement_flags = DELETE_IF_REPLACED)


/datum/species/human/animid/randomize_features()
	var/list/features = ..()
	features["animid_type"] = pick(animid_singletons)
	features["animid_skin_type"] = SKIN_TYPE_SKIN
	return features

// /datum/species/human/animid/get_organs()
// 	. = ..()
// 	for(var/animalid_id in animid_singletons)
// 		var/datum/animalid_type/atype = animid_singletons[animalid_id]
// 		. += flatten_list(atype.components)

/datum/species/human/animid/get_features()
	. = ..()
	. |= /datum/preference/color/mutant_color::savefile_key // mutant color for fur color, not always applied
	for(var/animalid_id in animid_singletons)
		var/datum/animalid_type/atype = animid_singletons[animalid_id]
		for(var/organ_slot, organ_type_or_types in atype.components)
			if(islist(organ_type_or_types))
				for(var/obj/item/organ/external/mutant_organ_type as anything in organ_type_or_types)
					. |= mutant_organ_type::preference

			else if(ispath(organ_type_or_types, /obj/item/organ/external))
				var/obj/item/organ/external/organ_type = organ_type_or_types
				. |= organ_type::preference

/datum/species/proc/set_mutant_organ(organ_slot, organ_type_or_types)
	switch(organ_slot)
		if(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			bodypart_overrides[organ_slot] = organ_type_or_types
		if(ORGAN_SLOT_BRAIN)
			mutantbrain = organ_type_or_types
		if(ORGAN_SLOT_TONGUE)
			mutanttongue = organ_type_or_types
		if(ORGAN_SLOT_EARS)
			mutantears = organ_type_or_types
		if(ORGAN_SLOT_EYES)
			mutanteyes = organ_type_or_types
		if(ORGAN_SLOT_LIVER)
			mutantliver = organ_type_or_types
		if(ORGAN_SLOT_HEART)
			mutantheart = organ_type_or_types
		if(ORGAN_SLOT_LUNGS)
			mutantlungs = organ_type_or_types
		if(ORGAN_SLOT_STOMACH)
			mutantstomach = organ_type_or_types
		if(ORGAN_SLOT_APPENDIX)
			mutantappendix = organ_type_or_types
		if(MUTANT_ORGANS)
			external_organs |= organ_type_or_types

/datum/animalid_type
	/// Bespoke ID for this animalid type. Must be unique.
	var/id

	/// Organs and limbs applied with this animalid type
	var/list/components

	/// Used in the UI - name of this animalid type
	var/name
	/// Fontawesome icon for this animalid type
	var/icon = FA_ICON_QUESTION
	/// Used in the UI - pros of this animalid type
	var/list/pros
	/// Used in the UI - cons of this animalid type
	var/list/cons
	/// Used in the UI - neutral traits of this animalid type
	var/list/neuts

/datum/animalid_type/cat
	id = "Cat"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/cat = "Cat"),
		ORGAN_SLOT_BRAIN = /obj/item/organ/internal/brain/felinid,
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/cat,
		ORGAN_SLOT_LIVER = /obj/item/organ/internal/liver/felinid,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/cat,
	)

	name = "Felinid"
	icon = FA_ICON_CAT
	pros = list(
		"Can lick wounds to stop bleeding",
	)
	cons = list(
		"Sensitive to loud noises and water",
	)
	neuts = list(
		"Always land on your feet",
	)

/datum/animalid_type/dog
	id = "Dog"
	// components = list(
	// 	MUTANT_ORGANS = list(/obj/item/organ/external/tail/dog = "Dog"),
	// 	ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/dog,
	// )

	name = "Canid"
	icon = FA_ICON_DOG

/datum/animalid_type/fox
	id = "Fox"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/fox = "Fox"),
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/fox,
	)

	name = "Vulpinid"

/datum/animalid_type/rat
	id = "Rat"
	// components = list(
	// 	MUTANT_ORGANS = list(/obj/item/organ/external/tail/rat = "Rat"),
	// 	ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/rat,
	// )

	name = "Rodent"
	icon = FA_ICON_CHEESE

/datum/animalid_type/fish
	id = "Fish"
	components = list(
		MUTANT_ORGANS = list(
			/obj/item/organ/external/tail/fish = "Simple",
			/obj/item/organ/external/frills = "Aquatic",
		),
	)

	name = "Piscine"
	icon = FA_ICON_FISH

	pros = list(
		"Move and work faster in water",
	)
	cons = list(
		"Where the hell is water on a space station?",
	)

/datum/animalid_type/rabbit
	id = "Rabbit"
	// components = list(
	// 	MUTANT_ORGANS = list(/obj/item/organ/external/tail/rabbit = "Rabbit"),
	// 	ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/rabbit,
	// )

	name = "Leporid"
	icon = FA_ICON_CARROT

/datum/animalid_type/bat
	id = "Bat"
	// components = list(
	// 	MUTANT_ORGANS = list(/obj/item/organ/external/tail/bat = "Bat"),
	// 	ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/bat,
	// )

	name = "Chiropteran"
	pros = list(
		"Can hear whispers from far away",
	)
	cons = list(
		"Weak to bright lights",
	)

/datum/animalid_type/deer
	id = "Deer"
	// components = list(
	// 	MUTANT_ORGANS = list(/obj/item/organ/external/tail/deer = "Deer"),
	// 	ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/deer,
	// )

	name = "Cervid"

// Prefernece for animid type
/datum/preference/choiced/animid_type
	savefile_key = "animid_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/animid_type/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["animid_type"] = value

/datum/preference/choiced/animid_type/init_possible_values()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter thinks it's unused
	return assoc_to_keys(animid.animid_singletons)

/datum/preference/choiced/animid_type/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)

/datum/preference/choiced/animid_type/compile_constant_data()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter thinks it's unused

	var/list/data = list()
	data["animid_customization"] = list()
	for(var/animalid_id in animid.animid_singletons)
		var/datum/animalid_type/atype = animid.animid_singletons[animalid_id]

		data["animid_customization"][animalid_id] = list(
			"id" = animalid_id,
			"name" = atype.name,
			"icon" = atype.icon,
			"components" = all_readable_organ_types(atype),
			"pros" = atype.pros || list("No notable advantages"),
			"cons" = atype.cons || list("No notable disadvantages"),
			"neuts" = atype.neuts || list(),
		)
	return data

/datum/preference/choiced/animid_type/proc/all_readable_organ_types(datum/animalid_type/atype)
	var/list/names = list()
	for(var/organ_slot, organ_type_or_types in atype.components)
		names += readable_organ_type(organ_type_or_types)
	list_clear_nulls(names)
	return names

/datum/preference/choiced/animid_type/proc/readable_organ_type(organ_type_or_types)
	if(islist(organ_type_or_types))
		var/list/names = list()
		for(var/organ_type in organ_type_or_types)
			names += readable_organ_type(organ_type)
		return names

	if(!ispath(organ_type_or_types, /obj/item/organ/external))
		return null // bodyparts that can't be customized
	var/obj/item/organ/external/organ_type = organ_type_or_types
	if(!organ_type::bodypart_overlay)
		return null // internal organs that don't alter appearance
	return organ_type::name

// Prefernece for fur/scales/skin type
/datum/preference/choiced/animid_fur
	savefile_key = "animalid_fur_skin"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/animid_fur/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["animid_skin_type"] = value

/datum/preference/choiced/animid_fur/create_default_value()
	return SKIN_TYPE_SKIN

/datum/preference/choiced/animid_fur/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)

/datum/preference/choiced/animid_fur/init_possible_values()
	return list(
		SKIN_TYPE_SKIN,
		SKIN_TYPE_FUR,
		SKIN_TYPE_SCALES,
	)

// Override for mutatn color so it's not always visible to animids
/datum/preference/color/mutant_color/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return
	if(!ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid))
		return

	return preferences.read_preference(/datum/preference/choiced/animid_fur) != SKIN_TYPE_SKIN

// Override for skin tone so it's not always visible to animids
/datum/preference/choiced/skin_tone/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return
	if(!ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid))
		return

	return preferences.read_preference(/datum/preference/choiced/animid_fur) == SKIN_TYPE_SKIN

// Override for lizard legs so it's not always visible to animids
/datum/preference/choiced/lizard_legs/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return
	if(!ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid))
		return

	return preferences.read_preference(/datum/preference/choiced/animid_fur) != SKIN_TYPE_SKIN

/datum/preference/choiced/fish_tail
	savefile_key = "fish_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/fish

/datum/preference/choiced/fish_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fish_tail"] = value

/datum/preference/choiced/fish_tail/create_default_value()
	return /datum/sprite_accessory/tails/fish/simple::name

/datum/preference/choiced/fish_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.tails_list_fish)

#undef MUTANT_ORGANS

#undef SKIN_TYPE_SKIN
#undef SKIN_TYPE_FUR
#undef SKIN_TYPE_SCALES

/obj/item/bodypart/leg/left/furry
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/leg/right/furry
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/arm/left/furry
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/arm/right/furry
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/chest/furry
	limb_id = SPECIES_PODPERSON

/obj/item/bodypart/head/furry
	limb_id = SPECIES_PODPERSON

///Tail for fish DNA-infused spacemen. It provides a speed buff while in water. It's also needed for the crawl speed bonus once the threshold is reached.
/obj/item/organ/external/tail/fish
	name = "fish tail"
	desc = "A severed tail from some sort of marine creature... or a fish-infused spaceman. It's smooth, faintly wet and definitely not flopping."
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/external/tail/fish"
	post_init_icon_state = "fish_tail"
	greyscale_config = /datum/greyscale_config/fish_tail
	greyscale_colors = "#875652"

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/fish
	// dna_block = /datum/dna_block/feature/tail_fish
	wag_flags = NONE
	//  organ_traits = list(TRAIT_FLOPPING, TRAIT_SWIMMER)
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	// // Fishlike reagents, you could serve it raw like fish
	// food_reagents = list(
	// 	/datum/reagent/consumable/nutriment/protein = 10,
	// 	/datum/reagent/consumable/nutriment/vitamin = 5,
	// 	/datum/reagent/consumable/nutriment/fat = 10,
	// )
	// // Seafood instead of meat, because it's a fish organ
	// foodtype_flags = RAW | SEAFOOD | GORE
	// // Also just tastes like fish
	// food_tastes = list("fatty fish" = 1)
	/// The fillet type this fish tail is processable into
	var/fillet_type = /obj/item/food/fishmeat/fish_tail
	/// The amount of fillets this gets processed into
	var/fillet_amount = 5

/obj/item/organ/external/tail/fish/Initialize(mapload)
	. = ..()
	// AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fish)
	var/time_to_fillet = fillet_amount * 0.5 SECONDS
	AddElement(/datum/element/processable, TOOL_KNIFE, fillet_type, fillet_amount, time_to_fillet, screentip_verb = "Cut")

/obj/item/organ/external/tail/fish/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	owner.AddElementTrait(TRAIT_WADDLING, type, /datum/element/waddling)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_location))
	// RegisterSignal(owner, COMSIG_LIVING_GIBBER_ACT, PROC_REF(on_gibber_processed))
	check_location(owner, null)

/obj/item/organ/external/tail/fish/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	owner.remove_traits(list(TRAIT_WADDLING, TRAIT_NO_STAGGER), type)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/fish_on_water)
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/fish_on_water)
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED/*, COMSIG_LIVING_GIBBER_ACT*/))

// /obj/item/organ/external/tail/fish/proc/on_gibber_processed(mob/living/carbon/owner, mob/living/user, obj/machinery/gibber, list/results)
// 	SIGNAL_HANDLER
// 	for(var/iteration in 1 to fillet_amount * 0.5)
// 		results += new fillet_type

/obj/item/organ/external/tail/fish/save_color()
	set_greyscale(bodypart_overlay.draw_color)

/obj/item/organ/external/tail/fish/proc/check_location(mob/living/carbon/source, atom/movable/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/was_water = istype(old_loc, /turf/open/water)
	var/is_water = istype(source.loc, /turf/open/water) && !HAS_TRAIT(source.loc, TRAIT_TURF_IGNORE_SLOWDOWN)
	if(was_water && !is_water)
		source.remove_movespeed_modifier(/datum/movespeed_modifier/fish_on_water)
		source.remove_actionspeed_modifier(/datum/actionspeed_modifier/fish_on_water)
		source.remove_traits(list(/*TRAIT_OFF_BALANCE_TACKLER, */TRAIT_NO_STAGGER, TRAIT_NO_THROW_HITPUSH), type)
	else if(!was_water && is_water)
		source.add_movespeed_modifier(/datum/movespeed_modifier/fish_on_water)
		source.add_actionspeed_modifier(/datum/actionspeed_modifier/fish_on_water)
		source.add_traits(list(/*TRAIT_OFF_BALANCE_TACKLER, */TRAIT_NO_STAGGER, TRAIT_NO_THROW_HITPUSH), type)

/datum/actionspeed_modifier/fish_on_water
	multiplicative_slowdown = -0.15

/datum/movespeed_modifier/fish_on_water
	blacklisted_movetypes = MOVETYPES_NOT_TOUCHING_GROUND
	multiplicative_slowdown = -/turf/open/water::slowdown

/datum/bodypart_overlay/mutant/tail/fish
	feature_key = "fish_tail"
	color_source = ORGAN_COLOR_OVERRIDE

// /datum/bodypart_overlay/mutant/tail/fish/on_mob_insert(obj/item/organ/parent, mob/living/carbon/receiver)
// 	//Initialize the related dna feature block if we don't have any so it doesn't error out.
// 	//This isn't tied to any species, but I kinda want it to be mutable instead of having a fixed sprite accessory.
// 	if(imprint_on_next_insertion && !receiver.dna.features[FEATURE_TAIL_FISH])
// 		receiver.dna.features[FEATURE_TAIL_FISH] = pick(SSaccessories.tails_list_fish)
// 		receiver.dna.update_uf_block(/datum/dna_block/feature/tail_fish)

// 	return ..()

/datum/bodypart_overlay/mutant/tail/fish/override_color(obj/item/bodypart/bodypart_owner)
	//If the owner uses mutant colors, inherit the color of the bodypart
	if(!bodypart_owner.owner || HAS_TRAIT(bodypart_owner.owner, TRAIT_MUTANT_COLORS))
		return bodypart_owner.draw_color
	else //otherwise get one from a set of faded out blue and some greys colors.
		return pick("#B4B8DD", "#85C7D0", "#67BBEE", "#2F4450", "#55CCBB", "#999FD0", "#345066", "#585B69", "#7381A0", "#B6DDE5", "#4E4E50")

/datum/bodypart_overlay/mutant/tail/fish/get_global_feature_list()
	return SSaccessories.tails_list_fish

// /datum/bodypart_overlay/mutant/tail/fish/get_image(image_layer, obj/item/bodypart/limb)
// 	var/mutable_appearance/appearance = ..()
// 	// We add all appearances the parent bodypart has to the tail to inherit scales and fancy effects
// 	// but most other organs don't want to inherit those so we do it here and not on parent
// 	for (var/datum/bodypart_overlay/texture/texture in limb.bodypart_overlays)
// 		if(texture.can_draw_on_bodypart(limb, limb.owner))
// 			texture.modify_bodypart_appearance(appearance)
// 	return appearance
