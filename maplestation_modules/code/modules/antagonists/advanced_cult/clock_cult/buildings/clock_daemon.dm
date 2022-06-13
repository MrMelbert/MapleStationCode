#define JUDICIAL_VISOR "Judicial Visor"
#define RATVAR_SPEAR "Rat'varian Spear"
#define BRASS_ARMOR "Brass Armor"

// The daemon forge
// produces combat items
/obj/structure/destructible/cult/item_dispenser/daemon_forge
	name = "daemon forge"
	desc = "A forge used by followers of Rat'var to construct more advanced creations."
	icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi'
	icon_state = "tinkerers_daemon"
	cult_examine_tip = "A Rat'varian cultist can use it to create judicial visors, ratvarian spears, and brass armor."
	break_message = "<span class='warning'>The forge crumbles, spilling out alloys and brass.</span>"
	light_range = 1.5
	light_color = "#ffff99"
	debris = list(/obj/item/stack/sheet/brass = 1)
	/// A mutable / emissive appearance to make our forge glow.
	var/static/mutable_appearance/glow
	/// A list of mutable appearances of overlay runes for our forge. We shuffle through this every 2 seconds.
	var/static/list/mutable_appearance/rune_cache = list()
	/// A static list of possible rune icon_states we can create or pick from every 2 seconds.
	var/static/list/runes_to_show = list(
		"belligerent_eye",
		"vanguard_cogwheel",
		"geis_capacitor",
		"replicant_alloy",
		"hierophant_ansible",
		"random_component"
		)

/obj/structure/destructible/cult/item_dispenser/daemon_forge/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSmachines, src)
	if(!glow)
		glow = mutable_appearance(icon, "tinkerglow", alpha = src.alpha)
		glow.color = COLOR_YELLOW
		glow.overlays += emissive_appearance(icon, "tinkerglow", alpha = glow.alpha)
	add_overlay(glow)

/obj/structure/destructible/cult/item_dispenser/daemon_forge/Destroy()
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/structure/destructible/cult/item_dispenser/daemon_forge/update_overlays()
	. = ..()
	if(!anchored)
		return

	var/picked = pick(runes_to_show)
	if(!rune_cache[picked])
		var/mutable_appearance/rune = mutable_appearance(icon, "t_[picked]", layer = ABOVE_OBJ_LAYER)
		rune.color = pick("#F00", "#A02", "#FF0", "#F0F", "#80F", "#C0F", "#00F", "#0F0", "#070")
		rune_cache[picked] = rune

	if(!glow)
		glow = mutable_appearance(icon, "tinkerglow", alpha = 175)
		glow.color = COLOR_YELLOW
		glow.overlays += emissive_appearance(icon, "tinkerglow", alpha = glow.alpha)

	. += glow
	. += rune_cache[picked]

// Process is called every 2 seconds. Handles the changing of the rune overlay between the various types. Probably not very performant.
/obj/structure/destructible/cult/item_dispenser/daemon_forge/process(delta_time)
	if(!anchored)
		STOP_PROCESSING(SSmachines, src)

	update_icon(UPDATE_OVERLAYS)

/obj/structure/destructible/cult/item_dispenser/daemon_forge/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return

	if(anchored)
		STOP_PROCESSING(SSmachines, src)
	else
		START_PROCESSING(SSmachines, src)

/obj/structure/destructible/cult/item_dispenser/daemon_forge/setup_options()
	var/static/list/clock_forge_items = list(
		JUDICIAL_VISOR = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi', icon_state = "judicial_visor_1"),
			OUTPUT_ITEMS = list(/obj/item/clothing/glasses/judicial_visor),
			),
		RATVAR_SPEAR = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/obj/clockwork_objects.dmi', icon_state = "ratvarian_spear"),
			OUTPUT_ITEMS = list(/obj/item/melee/ratvar_spear),
			),
		BRASS_ARMOR = list(
			PREVIEW_IMAGE = image(icon = 'maplestation_modules/icons/mob/actions/actions_clockcult.dmi', icon_state = "clockwork_armor"),
			OUTPUT_ITEMS = list(/obj/item/clothing/suit/hooded/clock),
			),
	)

	options = clock_forge_items

/obj/structure/destructible/cult/item_dispenser/daemon_forge/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_brasstalics("You force [spawned_item] from [src]!"))

#undef JUDICIAL_VISOR
#undef RATVAR_SPEAR
#undef BRASS_ARMOR
