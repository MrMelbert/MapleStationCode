// Prefernece for animid type
/datum/preference/choiced/animid_type
	savefile_key = "animid_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/animid_type/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["animid_type"] = value

/datum/preference/choiced/animid_type/init_possible_values()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter trips up on static accesses
	return assoc_to_keys(animid.animid_singletons)

/datum/preference/choiced/animid_type/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)

/datum/preference/choiced/animid_type/compile_constant_data()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	var/list/data = list()
	data["animid_customization"] = list()
	for(var/animalid_id in animid.animid_singletons)
		var/datum/animalid_type/atype = animid.animid_singletons[animalid_id]

		data["animid_customization"][animalid_id] = list(
			"id" = animalid_id,
			"name" = atype.name,
			"icon" = atype.icon,
			"components" = atype.get_readable_features(),
			"perks" = atype.get_perks(),
			"diet" = animid.get_diet_from_tongue(atype.components[ORGAN_SLOT_TONGUE] || animid.mutanttongue),
		)
	return data

/proc/generate_tail_icon(datum/sprite_accessory/tail_accessory, feature_key, tail_color = COLOR_BROWNER_BROWN)
	var/datum/universal_icon/body = generate_body_icon(
		bodyparts = list(
			/obj/item/bodypart/chest,
			/obj/item/bodypart/arm/left,
			/obj/item/bodypart/arm/right,
			/obj/item/bodypart/leg/left,
			/obj/item/bodypart/leg/right,
		),
	)

	var/datum/universal_icon/final_icon = body.copy()
	if (!isnull(tail_accessory) && tail_accessory.icon_state != SPRITE_ACCESSORY_NONE)
		ASSERT(istype(tail_accessory) && feature_key)

		var/datum/universal_icon/tail_icon = uni_icon(tail_accessory.icon, "m_[feature_key]_[tail_accessory.icon_state]_FRONT", NORTH)
		tail_icon.blend_color(tail_color, ICON_MULTIPLY)
		final_icon.blend_icon(tail_icon, ICON_OVERLAY)

	final_icon.scale(48, 48)
	final_icon.crop_32x32(8, 4)
	return final_icon

/proc/generate_body_icon(list/bodyparts = list(/obj/item/bodypart/chest), greyscale = TRUE, color = "caucasian1", dir = NORTH)
	var/static/list/datum/universal_icon/bodies
	if(color in GLOB.skin_tones)
		color = skintone2hex(color)
	var/key = jointext(list(greyscale, color, dir) + bodyparts, "-")
	if(!bodies?[key])
		var/datum/universal_icon/result
		for(var/obj/item/bodypart/bodypart as anything in bodyparts)
			var/base_icon = greyscale ? bodypart::icon_greyscale : bodypart::icon_static
			var/base_icon_state = "[bodypart::limb_id]_[bodypart::body_zone][bodypart::is_dimorphic ? "_m" : ""]"
			var/datum/universal_icon/part = uni_icon(base_icon, base_icon_state, dir)
			result = result?.blend_icon(part, ICON_OVERLAY) || part

		result.blend_color(color, ICON_MULTIPLY)
		LAZYSET(bodies, key, result)

	return bodies[key].copy()
