GLOBAL_LIST_INIT(brass_recipes, list ( \
	new /datum/stack_recipe("tinker's cache (can make replica fabricators, wraith specs, and truesight lenses)", /obj/structure/destructible/cult/item_dispenser/tinkers_cache, 3, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("daemon forge (can make judicial visors, ratvarian spears, and brass hardened armor)", /obj/structure/destructible/cult/item_dispenser/daemon_forge, 3, time = 4 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("brass door (stuns non-cultists who attempt entry)", /obj/machinery/door/airlock/cult/brass, 1, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	new /datum/stack_recipe("brass girder (can be destroyed by slabs in one hit)", /obj/structure/girder/brass, 1, time = 5 SECONDS, one_per_turf = TRUE, on_floor = TRUE), \
	))

/datum/material/brass
	name = "brass"
	desc = "Pybpx phyg? Lrf Engine, Lrf!"
	color = "#92661A"
	greyscale_colors = "#92661A"
	categories = list(MAT_CATEGORY_ITEM_MATERIAL = TRUE)
	sheet_type = /obj/item/stack/sheet/bronze
	value_per_unit = 0.75
	armor_modifiers = list(MELEE = 1.2, BULLET = 1.2, LASER = 1, ENERGY = 1, BOMB = 1.2, BIO = 1.2, FIRE = 1.5, ACID = 1.5)
	beauty_modifier = -0.15

/datum/material/brass/on_accidental_mat_consumption(mob/living/carbon/victim, obj/item/source_item)
	victim.reagents.add_reagent(/datum/reagent/fuel/unholywater, rand(8, 12))
	victim.apply_damage(10, BRUTE, BODY_ZONE_HEAD, wound_bonus = 5)
	return TRUE

/datum/material/brass/on_applied(atom/source, amount, material_flags)
	. = ..()
	if(material_flags & MATERIAL_COLOR)
		ADD_CLOCKCULT_FILTER(source)

/datum/material/brass/on_removed(atom/source, amount, material_flags)
	if(material_flags & MATERIAL_COLOR)
		REMOVE_CLOCKCULT_FILTER(source)
	return ..()

/obj/item/stack/sheet/brass
	name = "brass"
	desc = "It's not bronze, but actually sheets of brass metal that seem to glint purple and yellow when glanced at from certain angles."
	singular_name = "brass sheet"
	icon_state = "sheet-brass"
	inhand_icon_state = "sheet-brass"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/brass = MINERAL_MATERIAL_AMOUNT)
	sheettype = "brass"
	merge_type = /obj/item/stack/sheet/brass
	grind_results = list(/datum/reagent/iron = 5, /datum/reagent/copper = 15)
	material_type = /datum/material/brass
	has_unique_girder = TRUE
	tableVariant = /obj/structure/table/reinforced/brass

/obj/item/stack/sheet/brass/attack_self(mob/living/user)
	if(!IS_CULTIST(user))
		to_chat(user, span_warning("Only one with forbidden knowledge could hope to work this metal..."))
		return TRUE
	var/turf/our_turf = get_turf(user)
	var/area/our_area = get_area(user)
	if((!is_station_level(our_turf.z) && !is_mining_level(our_turf.z)) || (our_area && !(our_area.area_flags & CULT_PERMITTED)))
		to_chat(user, span_warning("The veil is not weak enough here."))
		return TRUE
	return ..()

/obj/item/stack/sheet/brass/get_main_recipes()
	. = ..()
	. += GLOB.brass_recipes

/obj/item/stack/sheet/brass/fifty
	amount = 50

/obj/item/stack/sheet/brass/ten
	amount = 10

/obj/item/stack/sheet/brass/five
	amount = 5

/obj/effect/temp_visual/brass
	icon = 'maplestation_modules/icons/effects/clockwork_effects.dmi'
	randomdir = FALSE
	duration = 20
