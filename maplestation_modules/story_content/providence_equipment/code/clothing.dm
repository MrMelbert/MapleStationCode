// meck galter

/obj/item/clothing/mask/neck_gaiter
	name = "neck gaiter"
	desc = "A cloth for covering your neck, and usually part of your face too, but that part's optional. Has a small respirator to be used with internals."
	actions_types = list(/datum/action/item_action/adjust)
	icon = 'maplestation_modules/story_content/providence_equipment/icons/obj/mask.dmi'
	worn_icon = 'maplestation_modules/story_content/providence_equipment/icons/mob/mask.dmi'
	alternate_worn_layer = LOW_FACEMASK_LAYER
	icon_state = "neck_gaiter"
	post_init_icon_state = "gaiter"
	inhand_icon_state = "balaclava"
	greyscale_config = /datum/greyscale_config/neck_gaiter
	greyscale_config_worn = /datum/greyscale_config/neck_gaiter/worn
	greyscale_colors = "#666666"
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT|MASKINTERNALS
	w_class = WEIGHT_CLASS_SMALL
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	visor_flags_cover = MASKCOVERSMOUTH
	flags_1 = IS_PLAYER_COLORABLE_1
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING

/obj/item/clothing/mask/neck_gaiter/attack_self(mob/user)
	adjust_visor(user)

/obj/item/clothing/mask/neck_gaiter/click_alt(mob/user)
	adjust_visor(user)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/mask/neck_gaiter/click_alt_secondary(mob/user)
	alternate_worn_layer = (alternate_worn_layer == initial(alternate_worn_layer) ? NONE : initial(alternate_worn_layer))
	user.update_clothing(ITEM_SLOT_MASK)
	balloon_alert(user, "wearing [alternate_worn_layer == initial(alternate_worn_layer) ? "below" : "above"] suits")

/obj/item/clothing/mask/neck_gaiter/examine(mob/user)
	. = ..()
	. += span_notice("[src] can be worn above or below your suit. Alt-Right-click to toggle.")
	. += span_notice("Alt-click [src] to adjust it.")

/datum/loadout_item/mask/neck_gaiter
	name = "Neck Gaiter"
	item_path = /obj/item/clothing/mask/neck_gaiter

// croptop jacket

/obj/item/clothing/suit/jacket/crop_top_jacket
	name = "crop-top jacket"
	desc = "A remarkably fancy-looking two-tone cropped jacket with a nice gold trim."
	icon = 'maplestation_modules/story_content/providence_equipment/icons/mob/crop_jacket.dmi'
	worn_icon = 'maplestation_modules/story_content/providence_equipment/icons/mob/crop_jacket.dmi'
	icon_state = "crop_jacket"
	worn_icon_state = "crop_jacket"

/datum/loadout_item/suit/crop_top_jacket
	name = "Crop-top Jacket"
	item_path = /obj/item/clothing/suit/jacket/crop_top_jacket

// both leg wraps

/obj/item/clothing/shoes/wraps
	name = "cloth foot wraps"
	desc = "Simple cloth footwraps, suitable for padding the heels."
	icon = 'maplestation_modules/story_content/providence_equipment/icons/obj/wraps.dmi'
	worn_icon = 'maplestation_modules/story_content/providence_equipment/icons/mob/wrap.dmi'
	digitigrade_file = 'maplestation_modules/story_content/providence_equipment/icons/mob/wrap_digi.dmi'
	icon_state = "wraps"
	post_init_icon_state = "wraps"
	greyscale_config = /datum/greyscale_config/legwraps
	greyscale_config_worn = /datum/greyscale_config/legwraps/worn
	greyscale_colors = "#FFFFFF"
	body_parts_covered = FALSE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/wraps/leg
	name = "cloth leg wraps"
	desc = "Simple cloth legwraps, for when socks aren't good enough."
	icon_state = "legwraps"
	post_init_icon_state = "legwraps"

/datum/loadout_item/shoes/wraps
	name = "Cloth Foot Wraps"
	item_path = /obj/item/clothing/shoes/wraps

/datum/loadout_item/shoes/legwraps
	name = "Cloth Leg Wraps"
	item_path = /obj/item/clothing/shoes/wraps/leg
