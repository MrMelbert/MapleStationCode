#define REPLICA_FAB "Replica Fabricator"
#define WRAITH_SPEC "Wraith Specs"
#define TRUESIGHT_LENS "Truesight Lens"

// The tinker's cache
// produces utility items
/obj/structure/destructible/cult/item_dispenser/tinkers_cache
	name = "tinkerer's cache"
	desc = "A cache of gizmos and gears constructed by a follower of Rat-Var."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "tinkerers_cache"
	cult_examine_tip = "Can be used to create replica fabricators, wraith specs, and truesight lenses."
	break_message = "<span class='warning'>The cache crumbles, its incessant ticking ceasing.</span>"
	light_range = 2
	light_color = "#ff9900"
	debris = list(/obj/item/stack/sheet/brass = 1)

/obj/structure/destructible/cult/item_dispenser/tinkers_cache/setup_options()
	var/static/list/cache_items = list(
		REPLICA_FAB = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi', icon_state = "replica_fabricator"),
			OUTPUT_ITEMS = list(/obj/item/construction/rcd/clock),
			),
		WRAITH_SPEC = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi', icon_state = "wraith_specs"),
			OUTPUT_ITEMS = list(/obj/item/clothing/glasses/wraith_specs),
			),
		TRUESIGHT_LENS = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi', icon_state = "truesight_lens"),
			OUTPUT_ITEMS = list(/obj/item/binoculars/truesight_lens),
			),
	)

	options = cache_items

/obj/structure/destructible/cult/item_dispenser/tinkers_cache/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_brasstalics("You assemble [spawned_item] from [src]!"))

#undef REPLICA_FAB
#undef WRAITH_SPEC
#undef TRUESIGHT_LENS
