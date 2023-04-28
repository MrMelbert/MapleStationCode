/datum/design/mech_ppc
	name = "PPC \"Awesome\""
	desc = "Allows for the construction of the \"Awesome\" PPC."
	id = "mech_ppc"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc
	materials = list(/datum/material/iron=10000)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX,
		RND_CATEGORY_MECHFAB_DURAND,
		RND_CATEGORY_MECHFAB_PHAZON,
		RND_CATEGORY_MECHFAB_HONK,
	)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_WEAPONS,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_HONK + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_ac5
	name = "Autocannon/5"
	desc = "A weapon for combat exosuits. Fires two rounds at high speed. Notably good at range."
	id = "mech_ac5"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_5
	materials = list(/datum/material/iron=10000)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX,
		RND_CATEGORY_MECHFAB_DURAND,
		RND_CATEGORY_MECHFAB_PHAZON,
	)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_ac5_ammo
	name = "Autocannon/5 Ammunition"
	desc = "Ammunition designed for Autocannon/5 exosuit weapons."
	id = "mech_ac5_ammo"
	build_type = MECHFAB
	build_path = /obj/item/mecha_ammo/autocannon_5
	materials = list(/datum/material/iron=4000)
	construction_time = 20
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX,
		RND_CATEGORY_MECHFAB_DURAND,
		RND_CATEGORY_MECHFAB_PHAZON,
	)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_ac5/mech_ac10 //A bit spaghetti, but this prevents lines upon lines of useless code
	name = "Autocannon/10"
	desc = "A weapon for combat exosuits. Fires a singular armor-piercing round."
	id = "mech_ac10"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_10
	materials = list(/datum/material/iron=10000)

/datum/design/mech_ac5_ammo/mech_ac10_ammo
	name = "Autocannon/10 Ammunition"
	desc = "Ammunition designed for Autocannon/10 exosuit weapons."
	id = "mech_ac10_ammo"
	build_path = /obj/item/mecha_ammo/autocannon_10
	materials = list(
		/datum/material/iron = 4000,
		/datum/material/uranium = 1000,
		)

/datum/design/mech_ac5/mech_ac20
	name = "Autocannon/20"
	desc = "A weapon for combat exosuits. Fires a singular slow gigantic slug."
	id = "mech_ac20"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_20
	materials = list(/datum/material/iron=10000)

/datum/design/mech_ac5_ammo/mech_ac20_ammo
	name = "Autocannon/20 Ammunition"
	desc = "Ammunition designed for Autocannon/20 exosuit weapons."
	id = "mech_ac20_ammo"
	build_path = /obj/item/mecha_ammo/autocannon_20
	materials = list(
		/datum/material/titanium = 2000,
		/datum/material/plasma = 500,
		/datum/material/diamond = 400,
		)
	construction_time = 50

/datum/design/mech_gauss
	name = "Gauss Rifle"
	desc = "A weapon for combat exosuits. Uses magnetic propulsion to fire a metallic slug at extremely high velocities."
	id = "mech_gauss"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gauss
	materials = list(
		/datum/material/iron=10000,
		/datum/material/gold=2000,
		)
	construction_time = 100
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX,
		RND_CATEGORY_MECHFAB_DURAND,
		RND_CATEGORY_MECHFAB_PHAZON,
	)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mech_gauss_ammo
	name = "Gauss Rifle Ammunition"
	desc = "Ammunition designed for exosuit-mounted gauss rifles."
	id = "mech_gauss_ammo"
	build_type = MECHFAB
	build_path = /obj/item/mecha_ammo/gauss
	materials = list(
		/datum/material/iron = 5000,
		/datum/material/titanium = 1000,
		)
	construction_time = 20
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT,
		RND_CATEGORY_MECHFAB_GYGAX,
		RND_CATEGORY_MECHFAB_DURAND,
		RND_CATEGORY_MECHFAB_PHAZON,
	)
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT + RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MINING,
		RND_CATEGORY_MECHFAB_GYGAX + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_DURAND + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT,
		RND_CATEGORY_MECHFAB_PHAZON + RND_SUBCATEGORY_MECHFAB_SUPPORTED_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
