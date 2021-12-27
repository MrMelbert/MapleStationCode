// Brass tables. Strong bronze tables?
/obj/structure/table/reinforced/brass
	name = "brass table"
	desc = "A reinforced brass table."
	icon = 'icons/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table-0"
	base_icon_state = "brass_table"
	buildstack = /obj/item/stack/sheet/brass
	max_integrity = 200
	damage_deflection = 6
	smoothing_groups = list(SMOOTH_GROUP_BRONZE_TABLES)
	canSmoothWith = list(SMOOTH_GROUP_BRONZE_TABLES)

/obj/structure/table/reinforced/brass/Initialize(mapload, _buildstack)
	. = ..()
	ADD_CLOCKCULT_FILTER(src)
	new /obj/effect/temp_visual/brass/girder(loc)

/obj/structure/table/reinforced/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()
