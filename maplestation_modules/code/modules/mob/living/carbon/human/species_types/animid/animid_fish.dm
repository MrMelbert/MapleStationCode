/datum/animalid_type/fish
	id = "Fish"
	components = list(
		MUTANT_ORGANS = list(
			/obj/item/organ/external/tail/fish = "Simple",
			/obj/item/organ/external/frills = "Aquatic",
		),
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/scaled,
		BODY_ZONE_HEAD  = /obj/item/bodypart/head/scaled,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/scaled,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/scaled,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/scaled,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/scaled,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/fish,
	)

	name = "Piscinid"
	icon = FA_ICON_FISH

	pros = list(
		"Scales provide some protection",
		"Move and work faster in water",
	)
	cons = list(
		"Bad at kicking and punching",
		"Where the hell is water on a space station?",
	)

/datum/animalid_type/fish/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	// ensures we get mutant color rather than a random forced color
	new_animid.dna?.features["forced_fish_color"] = new_animid.dna?.features["mcolor"]

/datum/animalid_type/fish/extra_feature_keys()
	return list(/datum/preference/color/mutant_color::savefile_key)

/datum/animalid_type/fish/get_readable_features()
	return ..() + "Scales"

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
	AddElement(/datum/element/processable, TOOL_KNIFE, fillet_type, fillet_amount, fillet_amount * 0.5 SECONDS, screentip_verb = "Cut")

/obj/item/organ/external/tail/fish/on_mob_insert(mob/living/carbon/owner)
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_location))
	check_location(owner, null)
	owner.dna.features["forced_fish_color"] ||= pick("#B4B8DD", "#85C7D0", "#67BBEE", "#2F4450", "#55CCBB", "#999FD0", "#345066", "#585B69", "#7381A0", "#B6DDE5", "#4E4E50")

/obj/item/organ/external/tail/fish/on_mob_remove(mob/living/carbon/owner)
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/fish_on_water)
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/fish_on_water)
	owner.remove_traits(list(/*TRAIT_OFF_BALANCE_TACKLER, */TRAIT_NO_STAGGER, TRAIT_NO_THROW_HITPUSH), type)
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED))

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

/datum/bodypart_overlay/mutant/tail/fish/override_color(obj/item/bodypart/bodypart_owner)
	//If the owner uses mutant colors, inherit the color of the bodypart
	if(!bodypart_owner.owner || HAS_TRAIT(bodypart_owner.owner, TRAIT_MUTANT_COLORS))
		return bodypart_owner.draw_color

	return bodypart_owner.owner.dna?.features["forced_fish_color"] || bodypart_owner.draw_color

/datum/bodypart_overlay/mutant/tail/fish/get_global_feature_list()
	return SSaccessories.tails_list_fish

/datum/bodypart_overlay/mutant/tail/fish/get_image(image_layer, obj/item/bodypart/limb)
	var/mutable_appearance/appearance = ..()
	// We add all appearances the parent bodypart has to the tail to inherit scales and fancy effects
	// but most other organs don't want to inherit those so we do it here and not on parent
	for (var/datum/bodypart_overlay/texture/texture in limb.bodypart_overlays)
		if(texture.can_draw_on_bodypart(limb))
			texture.modify_bodypart_appearance(appearance)
	return appearance

/datum/preference/choiced/fish_tail
	savefile_key = "feature_fish_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/fish

/datum/preference/choiced/fish_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fish_tail"] = value

/datum/preference/choiced/fish_tail/create_default_value()
	return /datum/sprite_accessory/tails/fish/simple::name

/datum/preference/choiced/fish_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.tails_list_fish)

// Fish tongue
/obj/item/organ/internal/tongue/fish
	name = "fish tongue"
	desc = "A tongue from some sort of marine creature."

	liked_foodtypes = SEAFOOD | BUGS // likes eating fish, does not mind raw or gore
	disliked_foodtypes = GROSS | CLOTH | JUNKFOOD | DAIRY | SUGAR // does not like junky food
	toxic_foodtypes = TOXIC | FRIED // dies to processed stuff
	organ_traits = list(TRAIT_FISH_EATER)

// Scaled bodyparts
/obj/item/bodypart/leg/left/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9
	unarmed_damage_low = 4
	unarmed_damage_high = 8

/obj/item/bodypart/leg/right/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9
	unarmed_damage_low = 4
	unarmed_damage_high = 8

/obj/item/bodypart/arm/left/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9
	unarmed_damage_low = 3
	unarmed_damage_high = 6

/obj/item/bodypart/arm/right/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9
	unarmed_damage_low = 3
	unarmed_damage_high = 6

/obj/item/bodypart/chest/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9

/obj/item/bodypart/head/scaled
	texture_bodypart_overlay = /datum/bodypart_overlay/texture/fishscale
	brute_modifier = 0.9
	burn_modifier = 0.9
