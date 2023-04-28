/obj/item/mecha_ammo/lmg //override on the ultra ac/2 box to fit the naming convention of other autocannon boxes
	name = "\improper AC/2 ammo box"
	desc = "A box of linked ammunition, designed for Autocannon/2 exosuit weapons."

/obj/item/mecha_ammo/autocannon_5
	name = "\improper AC/5 ammo box"
	desc = "A box of linked ammunition, designed for Autocannon/5 exosuit weapons."
	icon = 'maplestation_modules/icons/mecha/mecha_ammo.dmi'
	icon_state = "ac5"
	custom_materials = list(/datum/material/iron = 4000)
	rounds = 200
	ammo_type = MECHA_AMMO_AC5

/obj/item/mecha_ammo/autocannon_10
	name = "\improper AC/10 ammo box"
	desc = "A box of high-caliber AP ammunition, designed for Autocannon/10 exosuit weapons."
	icon = 'maplestation_modules/icons/mecha/mecha_ammo.dmi'
	icon_state = "ac10"
	custom_materials = list(
		/datum/material/iron = 4000,
		/datum/material/uranium = 1000, //DU penetrators inside of the rounds
		)
	rounds = 40
	ammo_type = MECHA_AMMO_AC10

/obj/item/mecha_ammo/autocannon_20
	name = "\improper AC/20 ammo box"
	desc = "A box of gigantic slugs, designed for Autocannon/20 exosuit weapons."
	icon = 'maplestation_modules/icons/mecha/mecha_ammo.dmi'
	icon_state = "ac20"
	custom_materials = list(
		/datum/material/titanium = 2000,
		/datum/material/plasma = 500,
		/datum/material/diamond = 400,
		)
	rounds = 20
	ammo_type = MECHA_AMMO_AC20

/obj/item/mecha_ammo/gauss
	name = "\improper Gauss ammo box"
	desc = "A box of heavy magnetic slugs, designed for exosuit-mounted Gauss Rifles."
	icon = 'maplestation_modules/icons/mecha/mecha_ammo.dmi'
	icon_state = "gauss"
	custom_materials = list(
		/datum/material/iron = 5000,
		/datum/material/titanium = 1000, //presumably to handle the high pressure and temperature loads
		)
	rounds = 8
	ammo_type = MECHA_AMMO_GAUSS
