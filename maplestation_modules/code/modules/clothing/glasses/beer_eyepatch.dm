/obj/item/clothing/glasses/eyepatch/reagent
	name = "beer eyepatch"
	desc = "Me bottle o' scrumpy!"
	icon = 'maplestation_modules/icons/obj/clothing/glasses.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/eyes.dmi'
	icon_state = "beerpatch"
	base_icon_state = "beerpatch"
	inhand_icon_state = null
	actions_types = list(/datum/action/item_action/flip)
	clothing_traits = list(TRAIT_BOOZE_SLIDER, TRAIT_REAGENT_SCANNER, FLASH_PROTECTION_FLASH) //flash protection so it's not a direct downgrade with no extra upsides than style

/obj/item/clothing/glasses/eyepatch/reagent/attack_self(mob/user, modifiers)
	. = ..()
	icon_state = (icon_state == base_icon_state) ? "[base_icon_state]_flipped" : base_icon_state
	user.update_worn_glasses()
