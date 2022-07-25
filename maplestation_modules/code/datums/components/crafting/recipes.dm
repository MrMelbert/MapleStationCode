/datum/crafting_recipe/barb_bat
	name = "Barbara"
	result = /obj/item/melee/baseball_bat/barbed
	reqs = list(/obj/item/melee/baseball_bat = 1,
				/obj/item/stack/rods = 10,
				)
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/home_bat
	name = "Homerun Bat"
	result = /obj/item/melee/baseball_bat/homerun
	reqs = list(/obj/item/melee/baseball_bat = 1,
				/obj/item/toy/crayon/red = 1,
				/obj/item/stock_parts/cell/hyper = 1,
				)
	tool_behaviors = list(TOOL_WIRECUTTER, TOOL_SCREWDRIVER)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/metal_bat
	name = "Metal Bat"
	result = /obj/item/melee/baseball_bat/ablative
	reqs = list(/obj/item/melee/baseball_bat = 1,
				/obj/item/stack/sheet/mineral/plastitanium = 20,
				)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 20
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
