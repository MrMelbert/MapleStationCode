/datum/design/item_dispenser_frame
	name = "Item Dispenser Frame"
	id = "item_d_frame"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/wallframe/item_dispenser
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)

/datum/design/shotgun_slug
	name = "Shotgun Slug"
	id = "shotgun_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/ammo_casing/shotgun
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/buckshot_shell
	name = "Buckshot Shell"
	id = "buckshot_shell"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/ammo_casing/shotgun/buckshot
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/ashtray
	name = "Ashtray"
	id = "ashtray"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.25)
	build_path = /obj/item/ashtray
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
