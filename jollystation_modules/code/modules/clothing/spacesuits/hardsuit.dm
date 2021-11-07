//Clown Op ""fake"" hard suit
/obj/item/clothing/suit/space/hardsuit/clownop
	name = "a silly blood-red hardsuit"
	desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_hardsuit"
	hardsuit_type = "syndi"
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 10, BULLET = 10, LASER = 0, ENERGY = 0, BOMB = 5, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)
	allowed = list(/obj/item/grown/bananapeel, /obj/item/food/grown/banana)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/clownop
	cell = /obj/item/stock_parts/cell/high

//Helmet for the ""hard suit""
/obj/item/clothing/head/helmet/space/hardsuit/clownop
	name = "a silly blood-red hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced helmet designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	inhand_icon_state = "syndie_helm"
	hardsuit_type = "syndi"
	armor = list(MELEE = 5, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)
	on = TRUE
	var/obj/item/clothing/suit/space/hardsuit/clownop/linkedsuit = null
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	visor_flags_inv = HIDEMASK|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	visor_flags = STOPSPRESSUREDAMAGE
