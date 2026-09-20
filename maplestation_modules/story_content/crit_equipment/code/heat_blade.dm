/obj/item/melee/heat_blade_unit
	name = "heat blade"
	desc = "A blade unit able to take in heating blade elements in order to augment it's strikes with high temperatures. \
		Rapidly chews through blades."
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "sabre"
	inhand_icon_state = "sabre"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 10
	throwforce = 10
	demolition_mod = 0.75
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	block_sound = 'sound/weapons/parry.ogg'
	hitsound = 'sound/weapons/rapierhit.ogg'
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	drop_sound = 'maplestation_modules/sound/items/drop/sword.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/sword2.ogg'
	equip_sound = 'maplestation_modules/sound/items/drop/sword.ogg'

/obj/item/heat_blade
	name = "heat blade"
	desc = "A plastitanium blade for a heat blade unit to take in. Might be somewhat usable by itself in a pinch."
