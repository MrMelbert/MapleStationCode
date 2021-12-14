// Clockwork hardsuit and helemet.
/obj/item/clothing/head/helmet/space/hardsuit/clock
	name = "\improper Rat'varian clockwork helmet"
	desc = "A heavily-armored helmet worn by warriors of the Rat'varian cult. It can withstand hard vacuum."
	icon_state = "clockwork_helmet"
	inhand_icon_state = "clockwork_helmet_inhand"
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 30, FIRE = 100, ACID = 100)
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	actions_types = list()

/obj/item/clothing/suit/space/hardsuit/clock
	name = "\improper Rat'varian clockwork hardsuit"
	desc = "A heavily-armored exosuit worn by warriors of the Rat'varian cult. It can withstand hard vacuum."
	icon_state = "clockwork_cuirass"
	inhand_icon_state = "clockwork_cuirass_inhand"
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/clockwork_slab, /obj/item/melee/ratvar_spear, /obj/item/tank/internals)
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 30, FIRE = 100, ACID = 100)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/clock
	slowdown = 0
