// --- baby mode book ---
/obj/item/storage/book/nonamebook
	name = "Fortuna Grimoire"
	desc = "A magical storybook! Countless stories are written here, though every page contains ineligible writing with unknown symbols.."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "grimoire"
	inhand_icon_state = "grimoire"
	worn_icon_state = "grimoire"
	lefthand_file = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_righthand.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	actions_types = list(/datum/action/item_action/toggle_light)
	light_color = LIGHT_COLOR_BLUE
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE
	/// Can we toggle this light on and off (used for contexual screentips only)
	var/toggle_context = TRUE
	/// The sound the light makes when it's turned on
	var/sound_on = 'sound/weapons/magin.ogg'
	/// The sound the light makes when it's turned off
	var/sound_off = 'sound/weapons/magout.ogg'
	/// Is the light turned on or off currently
	var/on = FALSE
	var/empty = FALSE

/obj/item/storage/book/nonamebook/Initialize(mapload) //book doubles as a casino set briefcase
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL //unsure how to calculate storage
	atom_storage.max_slots = 12
	atom_storage.max_total_storage = 24

/obj/item/storage/book/nonamebook/PopulateContents() //essentially a loadout thing for nono
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/toy/spadepokerchip = 1,
		/obj/item/toy/heartpokerchip = 1,
		/obj/item/toy/clubpokerchip = 1,
		/obj/item/toy/diamondpokerchip = 1,
		/obj/item/toy/jokerpokerchip = 1,
		/obj/item/dice/d6 = 2,
		/obj/item/toy/cards/deck = 1,
		/obj/item/toy/plush/nonamecat = 1,
		/obj/item/clothing/under/dress/nnseconddress = 1,
		/obj/item/clothing/shoes/nnredshoes = 1,
		/obj/item/clothing/head/costume/nnbluebonnet = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/book/nonamebook/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	// single use lights can be toggled on once
	if(isnull(held_item) && (toggle_context || !on))
		context[SCREENTIP_CONTEXT_RMB] = "Toggle light"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/flashlight) && (toggle_context || !on))
		context[SCREENTIP_CONTEXT_LMB] = "Toggle light"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/storage/book/nonamebook/proc/update_brightness(mob/user)
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)
	if(light_system == STATIC_LIGHT)
		update_light()

/obj/item/storage/book/nonamebook/attack_self(mob/user)
	balloon_alert(user, "the pages twist..")
	toggle_light(user)

/obj/item/storage/book/nonamebook/proc/toggle_light(mob/user)
	on = !on
	playsound(user, on ? sound_on : sound_off, 40, TRUE)
	update_brightness(user)
	update_action_buttons()

//i literally just slapped flashlight stuff on a book

// --- plushie ---

/obj/item/toy/plush/nonamecat
	name = "Cheshire"
	desc = "A small blue and white cat plush! It looks handstitched."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "cheshire"
	inhand_icon_state = "cheshire"
	lefthand_file = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_righthand.dmi'
	divine = TRUE //why would you hurt nono's plush you psycho

// -- poker chip props --

/obj/item/toy/spadepokerchip
	name = "Poker Chip of Spades"
	desc = "A poker chip representing spades. Underneath, it says '$25'. The spades suit lacks deals with good fortune, more suited to misfortune. This chip however, grants the holder a small amount of luck, as well as misfortune to balance. You feel at ease holding it."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "spadechip"
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/heartpokerchip
	name = "Poker Chip of Hearts"
	desc = "A poker chip representing hearts. Underneath, it says '$50'. The hearts suit gives fortune to those with love, yet can grant broken connections as well. This chip grants the holder a fair amount of luck, as well as misfortune to balance. You feel a bit uneasy holding it."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "heartchip"
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/clubpokerchip
	name = "Poker Chip of Clubs"
	desc = "A poker chip representing clubs. Underneath, it says '$100'. The clubs suit grants happiness to one's future, as well as warn one of troubling times. This chip grants the holder an abnormal amount of luck, as well as misfortune to balance. Holding it, you feel a small weight tied to you."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "clubchip"
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/diamondpokerchip
	name = "Poker Chip of Diamonds"
	desc = "A poker chip representing diamonds. Underneath, it says '$500'. The diamonds suit grants wealth and prosperity, along with the weight it brings it allures. This chip grants the holder a great amount of luck, as well as misfortune to balance. Holding it, you feel as if it's leeching off of you."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "diamondchip"
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/jokerpokerchip
	name = "Poker Chip of the Joker"
	desc = "A poker chip representing the Joker. Underneath, it says '$1000'. The Joker grants both freedom and captivity tied to one's life. This chip grants the holder an immeasurable amount of luck, as well as misfortune to balance. You feel as if you're holding your own existence within it. Your back burns."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nnitem_item.dmi'
	icon_state = "jokerchip"
	w_class = WEIGHT_CLASS_TINY
