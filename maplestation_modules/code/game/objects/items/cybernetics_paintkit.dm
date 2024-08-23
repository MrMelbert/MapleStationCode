/// List of icons that have emissives. Bodyparts with this icon will try to look for an [icon_state]_e icon_state
GLOBAL_LIST_INIT(emissive_augmentations, list(
	'maplestation_modules/icons/mob/augmentation/monokai.dmi',
	'maplestation_modules/icons/mob/augmentation/bs2ipc.dmi',
	'maplestation_modules/icons/mob/augmentation/bshipc.dmi',
))

/obj/item/cybernetics_paintkit
	name = "cybernetics paint kit"
	desc = "A kit for quickly stylizing your cybernetic prosthetics. Comes with a set of paint, brushes and LEDs."
	icon = 'maplestation_modules/icons/obj/devices.dmi'
	icon_state = "cybernetics_paintkit"
	var/static/list/full_recolor_options = list(
		"standard" = 'icons/mob/augmentation/augments.dmi',
		"engineer" = 'icons/mob/augmentation/augments_engineer.dmi',
		"security" = 'icons/mob/augmentation/augments_security.dmi',
		"mining" = 'icons/mob/augmentation/augments_mining.dmi',
		"bishop" = 'maplestation_modules/icons/mob/augmentation/bshipc.dmi',
		"bishop mk2" = 'maplestation_modules/icons/mob/augmentation/bs2ipc.dmi',
		"hephaestus" = 'maplestation_modules/icons/mob/augmentation/hsiipc.dmi',
		"hephaestus mk2" = 'maplestation_modules/icons/mob/augmentation/hi2ipc.dmi',
		"mariin" = 'maplestation_modules/icons/mob/augmentation/mariinskyipc.dmi',
		"MCG" = 'maplestation_modules/icons/mob/augmentation/mcgipc.dmi',
		"SGM" = 'maplestation_modules/icons/mob/augmentation/sgmipc.dmi',
		"WTM" = 'maplestation_modules/icons/mob/augmentation/wtmipc.dmi',
		"XMG" = 'maplestation_modules/icons/mob/augmentation/xmgipc.dmi',
		"zhenkov" = 'maplestation_modules/icons/mob/augmentation/zhenkovipc.dmi',
		"zhenkov dark" = 'maplestation_modules/icons/mob/augmentation/zhenkovipc_dark.dmi',
		"ZHP" = 'maplestation_modules/icons/mob/augmentation/zhpipc.dmi',
	)

	var/static/list/limb_recolor_options = list(
		"monokai" = 'maplestation_modules/icons/mob/augmentation/monokai.dmi',
	)

/obj/item/cybernetics_paintkit/attack_self(mob/living/carbon/user, modifiers)
	. = ..()
	if (!istype(user))
		return

	var/list/skins = list()
	for(var/skin_option in full_recolor_options)
		var/image/part_image = image(icon = full_recolor_options[skin_option], icon_state = "robotic_chest")
		skins[skin_option] = part_image

	for(var/skin_option in limb_recolor_options)
		var/image/part_image = image(icon = limb_recolor_options[skin_option], icon_state = "robotic_l_arm")
		part_image.overlays += image(icon = limb_recolor_options[skin_option], icon_state = "robotic_l_hand")
		skins[skin_option] = part_image
	
	var/choice = show_radial_menu(user, src, skins, require_near = TRUE)
	if (!choice)
		return
	
	var/list/parts_to_paint = list(BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG)
	if (choice in full_recolor_options)
		parts_to_paint |= list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	
	for (var/part_zone in parts_to_paint)
		var/obj/item/bodypart/limb = user.get_bodypart(part_zone)
		if (!IS_ORGANIC_LIMB(limb))
			limb.icon_state = replacetext("[limb.icon_state]", "borg_", "robotic_") // This is awful but /tg/code insists on duplicating all limb textures(???) and I'll go insane making emissives for those
			limb.base_icon_state = replacetext("[limb.base_icon_state]", "borg_", "robotic_")
			limb.update_appearance()
			limb.change_appearance((choice in full_recolor_options) ? full_recolor_options[choice] : limb_recolor_options[choice], greyscale = FALSE)

	playsound(user.loc, 'sound/effects/spray.ogg', 5, TRUE, 5)
	balloon_alert(user, "style applied")
	user.update_body()
	qdel(src)

/obj/item/cybernetics_paintkit/interact_with_atom(atom/interacting_with, mob/living/user)
	if (!isbodypart(interacting_with))
		return NONE
	var/obj/item/bodypart/limb = interacting_with
	if (IS_ORGANIC_LIMB(limb))
		return
	var/list/skins = list()
	for(var/skin_option in full_recolor_options)
		var/image/part_image = image(icon = full_recolor_options[skin_option], icon_state = "[limb.limb_id]_[limb.body_zone]")
		skins[skin_option] = part_image
	
	if (limb.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG))
		for(var/skin_option in limb_recolor_options)
			var/image/part_image = image(icon = limb_recolor_options[skin_option], icon_state = "[limb.limb_id]_[limb.body_zone]")
			skins[skin_option] = part_image

	var/choice = show_radial_menu(user, src, skins, require_near = TRUE)
	if (!choice)
		return ITEM_INTERACT_BLOCKING
	playsound(user.loc, 'sound/effects/spray.ogg', 5, TRUE, 5)
	limb.icon_state = replacetext("[limb.icon_state]", "borg_", "robotic_")
	limb.base_icon_state = replacetext("[limb.base_icon_state]", "borg_", "robotic_")
	limb.update_appearance()
	limb.change_appearance((choice in full_recolor_options) ? full_recolor_options[choice] : limb_recolor_options[choice], greyscale = FALSE)
	balloon_alert(user, "style applied")
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/datum/design/cybernetics_paintkit
	name = "Cybernetics Paintkit"
	id = "cybernetics_paintkit"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE |MECHFAB
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	construction_time = 5 SECONDS
	build_path = /obj/item/cybernetics_paintkit
	category = list(RND_CATEGORY_INITIAL)
