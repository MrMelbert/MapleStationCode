/// -- Loadout undersuits (jumpsuit kind) --
/obj/item/clothing/under/suit/teal
	name = "teal suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon = 'icons/obj/clothing/under/civilian.dmi'
	worn_icon = 'icons/mob/clothing/under/civilian.dmi'
	icon_state = "teal_suit"
	inhand_icon_state = "g_suit"
	can_adjust = FALSE

/obj/item/clothing/under/suit/teal/skirt
	name = "teal suitskirt"
	desc = "A teal suitskirt and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit_skirt"
	inhand_icon_state = "g_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/costume/gladiator/loadout
	desc = "An almost pristine light-weight gladitorial armor set inspired by those the Ash Walkers wear. It's unarmored and looks very dated."

/obj/item/clothing/under/color/greyscale
	name = "tailored jumpsuit"
	desc = "A tailor made custom jumpsuit."
	greyscale_colors = "#eeeeee"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/color/jumpskirt/greyscale
	name = "tailored jumpskirt"
	desc = "A tailor made custom jumpskirt."
	greyscale_colors = "#eeeeee"
	flags_1 = IS_PLAYER_COLORABLE_1
