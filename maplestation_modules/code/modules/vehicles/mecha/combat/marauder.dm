///The new variations of the marauder and seraph with the new weapons
/obj/vehicle/sealed/mecha/combat/marauder/upgraded
	name = "\improper Marauder II-N"
	desc = "An upgraded variant of the venerable Marauder, featuring the latest in military technologies."
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/ssrm2,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster,
			/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
	)

/obj/vehicle/sealed/mecha/combat/marauder/seraph/upgraded //Frankly overpowered, but let's be honest it's kind of intended to be.
	name = "\improper Seraph II-N"
	desc = "An upgraded variant of the Seraph. If you see this, just run. You'll probably get killed for even just gazing at it."
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/ssrm2,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/thrusters/ion, /obj/item/mecha_parts/mecha_equipment/repair_droid), //it heals too
		MECHA_POWER = list(),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster,
			/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster,
			/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster),
	)
