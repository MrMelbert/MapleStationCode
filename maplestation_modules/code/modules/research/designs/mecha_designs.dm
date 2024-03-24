/datum/design/mech_ppc
	name = "PPC \"Awesome\""
	desc = "Allows for the construction of the \"Awesome\" PPC."
	id = "mech_ppc"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
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

///new name and desc override
/datum/design/mech_scattershot
	name = "LB 10-X AC \"Scattershot\""
	desc = "A weapon for combat exosuits. Shoots a spread of pellets. Nobody knows what the LB stands for."

///new name and desc override
/datum/design/mech_lmg
	name = "Ultra AC/2 \"Koshi\""
	desc = "A weapon for combat exosuits. Shoots a rapid, three shot burst. Utilizes magnetic loading for faster firing."

/datum/design/mech_ac5
	name = "Autocannon/5 \"Hermes\""
	desc = "A weapon for combat exosuits. Fires two rounds at high speed. Notably good at range."
	id = "mech_ac5"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_5
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)
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
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
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
	name = "Autocannon/10 \"Urbie\""
	desc = "A weapon for combat exosuits. Fires a singular armor-piercing round."
	id = "mech_ac10"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_10
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/datum/design/mech_ac5_ammo/mech_ac10_ammo
	name = "Autocannon/10 Ammunition"
	desc = "Ammunition designed for Autocannon/10 exosuit weapons."
	id = "mech_ac10_ammo"
	build_path = /obj/item/mecha_ammo/autocannon_10
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
		)

/datum/design/mech_ac5/mech_ac20
	name = "Autocannon/20 \"Atlas\""
	desc = "A weapon for combat exosuits. Fires a singular slow gigantic slug."
	id = "mech_ac20"
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_20
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5)

/datum/design/mech_ac5_ammo/mech_ac20_ammo
	name = "Autocannon/20 Ammunition"
	desc = "Ammunition designed for Autocannon/20 exosuit weapons."
	id = "mech_ac20_ammo"
	build_path = /obj/item/mecha_ammo/autocannon_20
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SMALL_MATERIAL_AMOUNT * 4,
		)
	construction_time = 50

/datum/design/mech_gauss
	name = "\"Highlander\" Mech Gauss Rifle"
	desc = "A weapon for combat exosuits. Uses magnetic propulsion to fire a metallic slug at extremely high velocities."
	id = "mech_gauss"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gauss
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
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
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
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

/datum/design/mech_erlargelaser
	name = "ER Large Laser \"Mauler\""
	desc = "A weapon for combat exosuits. Fires a cohesive laser beam. Utilizes Extended-Range technology to aid in long-range combat."
	id = "mech_erlargelaser"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/er_laser
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
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

/datum/design/mech_pulsedlaser
	name = "Pulsed Laser \"Gunslinger\""
	desc = "A weapon for combat exosuits. Fires 3 small lasers in quick succession."
	id = "mech_pulsedlaser"
	build_type = MECHFAB
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulsed_laser
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
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
