// Don't ask my why I tested these
/obj/item/clothing/under
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK

/obj/item/clothing/under/rank/civilian/janitor/maid
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/costume/maid
	supports_variations_flags = CLOTHING_DIGITIGRADE_FILTER

/obj/item/clothing/under/rank/engineering/engineer/get_general_color(icon/base_icon)
	return "#DEB63E"

/obj/item/clothing/under/spacer_turtleneck/get_general_color(icon/base_icon)
	return "#5e483c"
