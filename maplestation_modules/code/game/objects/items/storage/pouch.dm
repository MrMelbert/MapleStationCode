/datum/storage/pouch
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_slots = 5
	max_total_storage = 10
	storage_sound = 'maplestation_modules/sound/items/storage/briefcase.ogg'

/datum/storage/pouch/survival
	max_specific_storage = WEIGHT_CLASS_TINY
	max_slots = 5
	max_total_storage = 8

/datum/storage/pouch/survival/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	var/static/list/survival_typecache = typecacheof(list(
		/obj/item/analyzer,
		/obj/item/assembly/flash,
		/obj/item/chameleon,
		/obj/item/climbing_hook/emergency,
		/obj/item/clipboard,
		/obj/item/clockwork_slab,
		/obj/item/clothing/accessory/medal,
		/obj/item/clothing/glasses,
		/obj/item/clothing/gloves,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/mask/gas/sechailer,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/mask/muzzle,
		/obj/item/clothing/neck/eldritch_amulet,
		/obj/item/clothing/neck/fake_heretic_amulet,
		/obj/item/clothing/neck/heretic_focus,
		/obj/item/codex_cicatrix,
		/obj/item/crowbar, // ehhhhhh
		/obj/item/desynchronizer,
		/obj/item/extinguisher/mini,
		/obj/item/flashlight,
		/obj/item/folder,
		/obj/item/food/donkpocket,
		/obj/item/geiger_counter,
		/obj/item/gps,
		/obj/item/grenade,
		/obj/item/hand_tele,
		/obj/item/implanter,
		/obj/item/instrument/harmonica,
		/obj/item/instrument/piano_synth/headphones,
		/obj/item/knife,
		/obj/item/laser_pointer,
		/obj/item/melee/baton/telescopic,
		/obj/item/melee/cultblade/advanced_dagger,
		/obj/item/melee/cultblade/dagger,
		/obj/item/melee/energy,
		/obj/item/melee/rune_carver,
		/obj/item/mining_scanner,
		/obj/item/multitool,
		/obj/item/pinpointer,
		/obj/item/radio,
		/obj/item/restraints/handcuffs,
		/obj/item/stock_parts/power_store/cell,
		/obj/item/storage/pill_bottle,
		/obj/item/storage/wallet,
		/obj/item/swapper,
		/obj/item/syndicate_teleporter,
		/obj/item/t_scanner,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman/belt,
		/obj/item/teleportation_scroll,
		/obj/item/tome,
		/obj/item/toy/clockwork_watch,
	))

	exception_hold = survival_typecache

/datum/storage/pouch/survival/can_insert(obj/item/to_insert, mob/user, messages = TRUE, force = STORAGE_NOT_LOCKED)
	. = ..()
	if(!.)
		return FALSE
	// items in the exception list are still limited to max storage + 2
	if(to_insert.w_class >= max_specific_storage + 2)
		if(messages)
			to_insert.balloon_alert(user, "too big!")
		return FALSE
	return TRUE

/datum/storage/pouch/open_storage(mob/to_show)
	if(parent.loc?.atom_storage)
		if(!silent)
			parent.balloon_alert(to_show, "[LOWER_TEXT(parent.loc)] is in the way!")
		return FALSE

	return ..()

/obj/item/storage/pouch
	name = "pouch"
	desc = "A pocket sized pouch."
	icon = 'maplestation_modules/icons/obj/storage/pouch.dmi'
	icon_state = "pouch"
	base_icon_state = "pouch"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	resistance_flags = FLAMMABLE
	drop_sound = 'maplestation_modules/sound/items/drop/generic2.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/generic3.ogg'
	w_class = POCKET_WEIGHT_CLASS
	storage_type = /datum/storage/pouch
	slot_flags = ITEM_SLOT_BELT
	/// Overlay to apply to the pouch
	var/overlay_state = ""
	/// Changes the icon state if an item was recently added or removed to storage
	VAR_PRIVATE/recently_opened = FALSE

/obj/item/storage/pouch/Initialize(mapload)
	. = ..()
	update_appearance()
	RegisterSignals(src, list(COMSIG_ATOM_STORED_ITEM, COMSIG_ATOM_REMOVED_ITEM), PROC_REF(animate_icon))

/obj/item/storage/pouch/update_overlays()
	. = ..()
	if(overlay_state)
		. += overlay_state

/obj/item/storage/pouch/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][recently_opened ? "_open" : ""]"

/obj/item/storage/pouch/proc/animate_icon(...)
	SIGNAL_HANDLER
	recently_opened = TRUE
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(reset_recently_opened)), 2 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/storage/pouch/proc/reset_recently_opened()
	recently_opened = FALSE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/storage/pouch/tools
	name = "tool pouch"
	desc = "A pocket sized pouch, perfectly capable of holding a few tools."
	overlay_state = "wrench"

/obj/item/storage/pouch/survival
	name = "surival pouch"
	desc = "A pocket sized pouch, assigned to members of the crew to use in emergencies."
	icon_state = "pouch_em"
	base_icon_state = "pouch_em"
	overlay_state = "emergencytank"
	storage_type = /datum/storage/pouch/survival
	/// What type of mask are we going to use for this box?
	var/mask_type = /obj/item/clothing/mask/breath
	/// Which internals tank are we going to use for this box?
	var/internal_type = /obj/item/tank/internals/emergency_oxygen
	/// What medipen should be present in this box?
	var/medipen_type = /obj/item/reagent_containers/hypospray/medipen

/obj/item/storage/pouch/survival/Initialize(mapload)
	. = ..()
	if(!HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		return
	atom_storage.max_slots += 2
	atom_storage.max_total_storage += 4
	name = "large [name]"
	transform = transform.Scale(1.25, 1)

/obj/item/storage/pouch/survival/PopulateContents()
	if(!isnull(mask_type))
		new mask_type(src)

	if(!isplasmaman(loc))
		new internal_type(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)

	if(!isnull(medipen_type))
		new medipen_type(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/flashlight/flare(src)
		new /obj/item/radio/off(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_RADIOACTIVE_NEBULA))
		new /obj/item/storage/pill_bottle/potassiodide(src)

	if(SSmapping.is_planetary() && LAZYLEN(SSmapping.multiz_levels))
		new /obj/item/climbing_hook/emergency(src)
