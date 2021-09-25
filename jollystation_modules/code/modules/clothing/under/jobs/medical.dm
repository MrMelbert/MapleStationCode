/// -- Modular medical clothing. --
// CMO turtleneck sprites ported from skyrat-tg.
/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck
	name = "chief medical officer's turtleneck"
	desc = "A light blue turtleneck and tan khakis, for a chief medical with a sense of style."
	icon_state = "cmoturtle"
	inhand_icon_state = "b_suit"
	icon = 'jollystation_modules/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'jollystation_modules/icons/mob/clothing/under/medical.dmi'
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt
	name = "chief medical officer's turtleneck skirt"
	desc = "A light blue turtleneck and tan khaki skirt, for a chief medical with a sense of style."
	icon_state = "cmoturtle_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	fitted = FEMALE_UNIFORM_TOP

/obj/structure/closet/secure_closet/chief_medical/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck(src)
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt(src)
