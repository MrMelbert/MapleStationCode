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
	attack_verb_simple = list("stab", "cut", "slash", "power attack") // fun fact: if the "power attack" verb rolls, there is a small chance of doing increased metaphorical damage!
	menu_description = "A blade which penetrates armor slightly. Can be worn only on the belt."

/obj/item/nullrod/clairen
	name = "clairen"
	desc = "A beautiful plasma sword that is not from this time. Perhaps its previous wielder found what it wanted to."
	/// hey there! head lorer here! note that this has 0 actual lore implications, and is just a nod to the sword's namesake.
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
	armour_penetration = 20 // this is 10 higher than the spear, but 15 less than the scythe series. unsure if this is a good or bad stat placement, given how this is a weapon that depends on this state for storage.
	// Also this has to be put here because there is no var for setting armor pen on transformed weapons, last i tried was with block chance, and that broke the entire fucking component
	hitsound = 'sound/weapons/genhit.ogg'
	attack_verb_continuous = list("stubs","whacks","pokes")
	attack_verb_simple = list("stub","whack","poke")
	menu_description = "A transforming plasma sword. Can be changed between an extremely low damaging unlit state that can be stored easily, or a lit state that cannot be stored anywhere. Has an armor pierce grade of 20."
	var/start_extended = FALSE
	// same as its origin code (switchblade), this decides if it starts extended or not. due to how nullrods work, there won't be a pre-ignited version.

/obj/item/nullrod/clairen/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		start_transformed = start_extended, \
		force_on = 18, \
		throwforce_on = 16, \
		throw_speed_on = throw_speed, \
		sharpness_on = SHARP_EDGED, \
		hitsound_on = 'sound/weapons/blade1.ogg', \
		w_class_on = WEIGHT_CLASS_BULKY, \
		attack_verb_continuous_on = list("incinerates", "slashes", "singes", "scorches", "tears", "stabs"), \
		attack_verb_simple_on = list("incinerate", "slash", "singe", "scorch", "tear", "stab"), \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/nullrod/clairen/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER
	balloon_alert(user, "[active ? "ignited":"extinguished"] [src]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 20, TRUE)
	update_appearance(UPDATE_ICON)
	tool_behaviour = (active ? TOOL_KNIFE : NONE) // Yolo. this will let it work as a knife can.
	slot_flags = active ? NONE : ITEM_SLOT_BELT // this is to prevent it from being storable in belt.
	return COMPONENT_NO_DEFAULT_MESSAGE
