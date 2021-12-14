#define REPLICA_FAB "Replica Fabricator"
#define WRAITH_SPEC "Wraith Specs"
#define TRUESIGHT_LENS "Truesight Lens"

// The tinker's cache
// produces utility items
/obj/structure/destructible/brass/tinkers_cache
	name = "tinkerer's cache"
	desc = "A cache of gizmos and gears constructed by a follower of Ratvar."
	icon_state = "tinkerers_cache"
	cult_examine_tip = "Can be used to create replica fabricators, wraith specs, and truesight lenses."
	break_message = "<span class='warning'>The cache crumbles, its incessant ticking ceasing.</span>"
	light_range = 2
	light_color = "#ff9900"

/obj/structure/destructible/brass/tinkers_cache/open_radial_and_get_item(mob/living/user)
	var/list/items = list(
		REPLICA_FAB = image(icon = 'icons/obj/clockwork_objects.dmi', icon_state = "replica_fabricator"),
		WRAITH_SPEC = image(icon = 'icons/obj/clockwork_objects.dmi', icon_state = "wraith_specs"),
		TRUESIGHT_LENS = image(icon = 'icons/obj/clockwork_objects.dmi', icon_state = "truesight_lens")
		)
	var/choice = show_radial_menu(user, src, items, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	. = list()
	switch(choice)
		if(REPLICA_FAB)
			. += /obj/item/construction/rcd/clock
		if(WRAITH_SPEC)
			. += /obj/item/clothing/glasses/wraith_specs
		if(TRUESIGHT_LENS)
			. += /obj/item/binoculars/truesight_lens

#undef REPLICA_FAB
#undef WRAITH_SPEC
#undef TRUESIGHT_LENS
