// name says enough! this is for chaplain weapons. If you want to add boring NORMAL weapons, make a new .dm (or use it if someone already made it)
/obj/item/nullrod/spear/amber_blade
	name = "amber blade"
	desc = "A rapier-like sword made from the amber of an alien root-tree."
	icon_state = "amber_blade"
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	worn_icon_state = "amber_blade"
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	inhand_icon_state = "amber_blade" // do you know the muffin man the muffin man the muffin man?
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("stabs", "cuts", "slashes", "power attacks") // felt like it needed a 4th like its parent spear, chose power attacks from TES.
	attack_verb_simple = list("stab", "cut", "slash", "power attack") // fun fact: if the "power attack" verb rolls, there is a small chance of doing increased metaphorical damage.
	menu_description = "A blade which penetrates armor slightly. Can be worn only on the belt."

/obj/item/nullrod/clairen
	name = "clairen"
	desc = "A beautiful plasma sword that is not from this time. Perhaps its previous wielder found what it wanted to."
	// hey there! head lorer here! note that this has 0 actual lore implications, and is just a nod to the sword's namesake.
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 6
	icon_state = "clairen"
	base_icon_state = "clairen"
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	inhand_icon_state = "clairen"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	worn_icon_state = "clairen"
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/weapons/genhit.ogg'
	attack_verb_continuous = list("stubs","whacks","pokes")
	attack_verb_simple = list("stub","whack","poke")
	menu_description = "A transforming plasma sword. Can be changed between an extremely low damaging unlit state that can be stored easily, or a lit state that cannot be stored anywhere. Has an armor pierce grade of 20."
	light_system = OVERLAY_LIGHT
	light_range = 2
	light_power = 1
	light_on = FALSE

/obj/item/nullrod/clairen/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = 18, \
		throwforce_on = 16, \
		throw_speed_on = throw_speed, \
		sharpness_on = SHARP_EDGED, \
		hitsound_on = 'maplestation_modules/sound/weapons/plasmaslice.ogg', \
		w_class_on = WEIGHT_CLASS_BULKY, \
		attack_verb_continuous_on = list("incinerates", "slashes", "singes", "scorches", "tears", "stabs"), \
		attack_verb_simple_on = list("incinerate", "slash", "singe", "scorch", "tear", "stab"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/nullrod/clairen/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER
	balloon_alert(user, "[active ? "ignited":"extinguished"] [src]")
	playsound(user ? user : src, active ? 'maplestation_modules/sound/weapons/plasmaon.ogg' : 'maplestation_modules/sound/weapons/plasmaoff.ogg', 20, TRUE)
	update_appearance(UPDATE_ICON)
	set_light_on(active)
	set_light_color(COLOR_CLAIREN_RED) // shoutouts to jade for the lighting code.
	tool_behaviour = (active ? TOOL_KNIFE : NONE) // Yolo. this will let it work as a knife can.
	slot_flags = active ? NONE : ITEM_SLOT_BELT // this is to prevent it from being storable in belt.
	armour_penetration = active ? 20 : 0  // this ternary grants (successfully) 20 armour piercing to the transformed weapon. active ? X : Y. X = effect while on, Y = effect while off.
	// this is 10 higher than the spear, but 15 less than the scythe series. unsure if this is a good or bad stat placement, given how this is a weapon that depends on this state for storage.
	return COMPONENT_NO_DEFAULT_MESSAGE
