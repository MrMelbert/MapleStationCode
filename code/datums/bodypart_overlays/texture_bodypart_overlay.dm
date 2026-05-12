/// Bodypart overlays focused on texturing limbs
/datum/bodypart_overlay/texture
	/// icon file for the texture
	var/texture_icon
	/// icon state for the texture
	var/texture_icon_state
	/// Cache the icon so we dont have to make a new one each time
	var/cached_texture_icon
	/// Priority of this texture - all textures with a lower priority will not be rendered
	var/overlay_priority = 0

/datum/bodypart_overlay/texture/New()
	. = ..()
	cached_texture_icon = icon(texture_icon, texture_icon_state)

/datum/bodypart_overlay/texture/modify_bodypart_appearance(image/appearance)
	appearance.add_filter("bodypart_texture_[texture_icon_state]", 1, layering_filter(icon = cached_texture_icon, blend_mode = BLEND_INSET_OVERLAY))

/datum/bodypart_overlay/texture/generate_icon_cache()
	return "[type]"

/datum/bodypart_overlay/texture/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	for (var/datum/bodypart_overlay/texture/other_texture in bodypart_owner.bodypart_overlays)
		if (other_texture.overlay_priority > overlay_priority)
			return FALSE
	return TRUE

/datum/bodypart_overlay/texture/spacey
	blocks_emissive = EMISSIVE_BLOCK_NONE
	texture_icon_state = "spacey"
	texture_icon = 'icons/mob/human/textures.dmi'
	overlay_priority = BODYPART_OVERLAY_VOIDWALKER_CURSE

/datum/bodypart_overlay/texture/carpskin
	texture_icon_state = "carpskin"
	texture_icon = 'icons/mob/human/textures.dmi'
	overlay_priority = BODYPART_OVERLAY_CARP_INFUSION

/datum/bodypart_overlay/texture/checkered
	texture_icon_state = "checkered"
	texture_icon = 'icons/mob/human/textures.dmi'
	overlay_priority = BODYPART_OVERLAY_CSS_SUICIDE

/datum/bodypart_overlay/texture/fishscale
	texture_icon_state = "fishscale"
	texture_icon = 'icons/mob/human/textures.dmi'
	overlay_priority = BODYPART_OVERLAY_FISH_INFUSION

/datum/bodypart_overlay/texture/mesh
	texture_icon_state = "mesh_mask"
	texture_icon = 'maplestation_modules/icons/mob/clothing/tail_suit_mask.dmi'
	overlay_priority = BODYPART_OVERLAY_MESH
	/// Icon state for displacement map that comes with the texture
	var/displacement_icon_state = "mesh_mask_displacement"
	/// Icon file for the displacement map that comes with the texture.
	var/displacement_icon = 'maplestation_modules/icons/mob/clothing/tail_suit_mask.dmi'
	/// Cache the displacement icon so we dont have to make a new one each time
	var/cached_displacement_icon

	/// Color used for the outline filter
	var/outline_color = "#080808"

/datum/bodypart_overlay/texture/mesh/New()
	. = ..()
	cached_displacement_icon = icon(displacement_icon, displacement_icon_state)

/datum/bodypart_overlay/texture/mesh/modify_bodypart_appearance(image/appearance)
	if(!should_modify(appearance))
		return

	. = ..()
	// adds a displacement map so the outline lines up with the bottom of the sprite
	appearance.add_filter("displacement", 2, displacement_map_filter(cached_displacement_icon, size = 1))
	// adds an outline so the texture doesn't end abruptly
	appearance.add_filter("outline", 3, outline_filter(1, outline_color, OUTLINE_SHARP))
	// forces white (blends better with the texture)
	appearance.color = COLOR_WHITE

/datum/bodypart_overlay/texture/mesh/proc/should_modify(image/appearance)
	// only apply to "real planes", ie not emissive or lighting or whatever
	var/appearance_plane = PLANE_TO_TRUE(appearance.plane)
	if(appearance_plane != FLOAT_PLANE && appearance_plane != GAME_PLANE)
		return FALSE
	// only apply to other mutant bodyparts. we filter by layer which is absolutely not ideal
	var/appearance_layer = abs(appearance.layer)
	if(appearance_layer != BODY_ADJ_LAYER && appearance_layer != BODY_FRONT_LAYER && appearance_layer != BODY_BEHIND_LAYER)
		return FALSE
	return TRUE

/datum/bodypart_overlay/texture/mesh/black
	texture_icon_state = "mesh_mask"
	outline_color = "#080808"

/datum/bodypart_overlay/texture/mesh/white
	texture_icon_state = "mesh_mask_white"
	outline_color = "#B2B2B2"

/datum/bodypart_overlay/texture/mesh/biosuit
	texture_icon_state = "mesh_mask_biosuit"
	outline_color = "#747182"

/datum/bodypart_overlay/texture/mesh/biosuit_dark
	texture_icon_state = "mesh_mask_biosuit_dark"
	outline_color = "#514F5B"
