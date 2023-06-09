///The new variations of the marauder and seraph with the new weapons
/obj/vehicle/sealed/mecha/combat/marauder/upgraded
	name = "\improper Marauder II-N"
	desc = "An upgraded variant of the venerable Marauder, featuring the latest in military technologies. New titan-carbide armor technologies result in harder armor, but the inability to mount armor packages."
	armor_type =/datum/armor/marauder_two_armor
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 2,
		MECHA_ARMOR = 0, //No armor packages otherwise the increased armor would be insane
	)
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/datum/armor/marauder_two_armor
	melee = 60
	bullet = 80
	laser = 70
	energy = 60
	bomb = 30
	bio = 0
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/combat/marauder/seraph/upgraded //Frankly overpowered, but let's be honest it's kind of intended to be.
	name = "\improper Seraph II-N"
	desc = "An upgraded variant of the Seraph. If you see this, just run. You'll probably get killed for even just gazing at it. New composite armor technologies result in harder armor, but the inability to mount armor packages."
	armor_type = /datum/armor/seraph_two_armor
	max_equip_by_category = list(
		MECHA_UTILITY = 3,
		MECHA_POWER = 2,
		MECHA_ARMOR = 0,
	)
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/datum/armor/seraph_two_armor
	melee = 80
	bullet = 85
	laser = 80
	energy = 60
	bomb = 30
	bio = 0
	fire = 100
	acid = 100
