#define REPLICA_FAB "Replica Fabricator"
#define WRAITH_SPEC "Wraith Specs"
#define TRUESIGHT_LENS "Truesight Lens"

/obj/structure/destructible/brass/tinkers_cache
	name = "Tinkerer's Cache"
	desc = "A cache of gizmos and gears constructed by a follower of Ratvar."
	icon_state = "tinkerers_cache"
	success_message = "The chache"
	cult_examine_tip = "A Rat'varian cultist can use it to create replica fabricators, wraith specs, and truesight lenses."
	break_message = "<span class = 'warning'>The cache crumbles, its incessant ticking ceasing.</span>"

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
			. += /obj/item
		if(TRUESIGHT_LENS)
			. += /obj/item

#undef REPLICA_FAB
#undef WRAITH_SPEC
#undef TRUESIGHT_LENS
