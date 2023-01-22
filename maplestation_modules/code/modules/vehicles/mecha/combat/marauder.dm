///The new variations of the marauder and seraph with the new weapons
/obj/vehicle/sealed/mecha/combat/marauder/upgraded
	name = "\improper Marauder II-N"
	desc = "An upgraded variant of the venerable Marauder, featuring the latest in military technologies. New composite armor technologies result in harder armor, but the inability to mount armor packages."
	armor = list(MELEE = 60, BULLET = 80, LASER = 70, ENERGY = 60, BOMB = 30, BIO = 0, FIRE = 100, ACID = 100)
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 2,
		MECHA_ARMOR = 0, //No armor packages otherwise the increased armor would be insane
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/ssrm2,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/obj/vehicle/sealed/mecha/combat/marauder/seraph/upgraded //Frankly overpowered, but let's be honest it's kind of intended to be.
	name = "\improper Seraph II-N"
	desc = "An upgraded variant of the Seraph. If you see this, just run. You'll probably get killed for even just gazing at it. New composite armor technologies result in harder armor, but the inability to mount armor packages."
	armor = list(MELEE = 80, BULLET = 85, LASER = 80, ENERGY = 60, BOMB = 30, BIO = 0, FIRE = 100, ACID = 100) //no more melee weakness
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 2,
		MECHA_ARMOR = 0,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/ssrm2,
		MECHA_UTILITY = list(
			/obj/item/mecha_parts/mecha_equipment/thrusters/ion,
			/obj/item/mecha_parts/mecha_equipment/repair_droid //it heals too
			),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)
