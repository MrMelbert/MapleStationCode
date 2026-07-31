/datum/supply_pack/goody/peepy
	name = "Peepy"
	desc = "Each Peepy may differ slightly in appearance, the pattern will be slightly different and your Peepy's face may be aligned slightly more or less off center. \
	It's ok because it's very cute. Peepy is about 6 inches from beak to butt."
	cost = PAYCHECK_CREW * 4
	crate_type = /obj/structure/closet/crate/critter
	contains = list(/obj/item/toy/plush/peepy)

/datum/supply_pack/goody/cut_volite
	name = "Cut Volite Gemstone"
	desc = "An expertly cut volite gemstone, ready to be socketed into an amulet."
	cost = PAYCHECK_CREW * 5
	contains = list(
		/obj/item/mana_battery/mana_crystal/cut,
	)

/datum/supply_pack/goody/mana_star
	name = "Pre-Assembled Volite Amulet"
	desc = "A volite gemstone pre-cut and placed within an amulet, saving you the hassle."
	cost = PAYCHECK_CREW * 8
	contains = list(
		/obj/item/clothing/neck/mana_star,
	)

/datum/supply_pack/goody/volite_single_pack
	name = "Volite Crystal Single Pack"
	desc = "A singular volite crystal, ready for use."
	cost = PAYCHECK_CREW * 4
	contains = list(
		/obj/item/mana_battery/mana_crystal/standard,
	)

/datum/supply_pack/goody/small_volite_pack
	name = "Small Volite Crystal Single Pack"
	desc = "A miniaturized volite crystal."
	cost = PAYCHECK_CREW * 2
	contains = list(
		/obj/item/mana_battery/mana_crystal/small,
	)

/datum/supply_pack/goody/volitious_lignite_single_pack
	name = "Volitious Lignite Pack"
	desc = "A single pack of a natural source of volite, volitious lignite."
	cost = PAYCHECK_CREW * 2
	contains = list(
		/obj/item/mana_battery/mana_crystal/lignite,
	)

/datum/supply_pack/goody/meditation_guide_single
	name = "Meditation Guide Single Pack"
	desc = "Provides a single copy of the Nanotrasen Approved Meditation Guidebook"
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/book/granter/action/spell/meditation,
	)

/datum/supply_pack/service/lesser_splattercasting_guide
	name = "Lesser Splattercasting Guide Multi-Pack"
	desc = "Provides a single copy of the Nanotrasen Unapproved Meditation Guidebook"
	cost = PAYCHECK_CREW
	contraband = TRUE
	contains = list(
		/obj/item/book/granter/action/spell/lesser_splattercasting,
	)
