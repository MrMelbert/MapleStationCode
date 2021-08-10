/// -- Modular armor items. --
// BO Armor
/obj/item/clothing/suit/armor/vest/bridge_officer
	name = "bridge officer's armor vest"
	desc = "A rigid vest of armor worn by Bridge Officers in tandem with their padded suits. Style and protection!"
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 15, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)

//Unused, but we're keeping it
/obj/item/clothing/suit/armor/vest/bridge_officer/large
	name = "bridge officer's large armor vest"
	desc = "A larger, yet still comfortable suit of armor worn by Bridge Officers who prefer function over form."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"

//AP Armor
/obj/item/clothing/suit/armor/vest/asset_protection
	name = "asset protection's armor vest"
	desc = "A rigid vest of armor worn by Asset Protection. Rigid and stiff, just like your attitude."
	icon_state = "bulletproof"
	inhand_icon_state = "bulletproof"
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 30, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/armor/vest/asset_protection/large
	name = "asset protection's large armor vest"
	desc = "A bulkier, heavier armor that Asset Protection can use when the situation calls for it."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"
	armor = list(MELEE = 45, BULLET = 50, LASER = 45, ENERGY = 45, BOMB = 35, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 20)
	slowdown = 1
