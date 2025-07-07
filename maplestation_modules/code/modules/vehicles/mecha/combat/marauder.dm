/obj/vehicle/sealed/mecha/marauder
	mecha_flags = ID_LOCK_ON | CAN_STRAFE | IS_ENCLOSED | HAS_LIGHTS | MMI_COMPATIBLE //Upstream fix for the marauder not having an ID lock by default despite being intended to. You love to see it.

///The new variations of the marauder and seraph with the new weapons
/obj/vehicle/sealed/mecha/marauder/upgraded
	name = "\improper Marauder II-N"
	desc = "An upgraded variant of the venerable Marauder, featuring the latest in military technologies. New titan-carbide armor technologies result in harder armor, but the inability to mount armor packages."
	armor_type = /datum/armor/mecha_marauder_two
	bumpsmash = FALSE //bumpsmash is annoying on mechs that are often piloted by all-access pilots
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 5,
		MECHA_POWER = 1,
		MECHA_ARMOR = 0, //No armor packages otherwise the increased armor would be insane
	)
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/datum/armor/mecha_marauder_two
	melee = 60
	bullet = 80
	laser = 70
	energy = 60
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/marauder/upgraded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

/obj/vehicle/sealed/mecha/marauder/upgraded/loaded
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulsed_laser/large,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/er_laser/heavy,
		MECHA_UTILITY = list(
			/obj/item/mecha_parts/mecha_equipment/radio,
			/obj/item/mecha_parts/mecha_equipment/air_tank/full,
			/obj/item/mecha_parts/mecha_equipment/thrusters/ion,
		),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/obj/vehicle/sealed/mecha/marauder/seraph/upgraded //Frankly overpowered, but let's be honest it's kind of intended to be.
	name = "\improper Seraph II-N"
	desc = "An upgraded variant of the Seraph. If you see this, just run. You'll probably get killed for even just gazing at it. New composite armor technologies result in harder armor, but the inability to mount armor packages."
	armor_type = /datum/armor/mecha_seraph_two
	bumpsmash = FALSE
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 5,
		MECHA_POWER = 1,
		MECHA_ARMOR = 0, //No armor packages otherwise the increased armor would be insane
	)
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/datum/armor/mecha_seraph_two
	melee = 80
	bullet = 85
	laser = 80
	energy = 60
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/marauder/seraph/upgraded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

/obj/vehicle/sealed/mecha/marauder/seraph/upgraded/loaded
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/ssrm2,
		MECHA_UTILITY = list(
			/obj/item/mecha_parts/mecha_equipment/repair_droid,
			/obj/item/mecha_parts/mecha_equipment/radio,
			/obj/item/mecha_parts/mecha_equipment/air_tank/full,
			/obj/item/mecha_parts/mecha_equipment/thrusters/ion,
		),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)
