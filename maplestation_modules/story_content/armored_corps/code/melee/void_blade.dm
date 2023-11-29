/// Void Blade, an upgraded version of the plasma blade
/obj/item/melee/maple_plasma_blade/void_blade
	name = "void blade"
	desc = "An upgraded version of the plasma blade. The interior plasma absorbs energy, causing a darkened apperance and a shearing effect to anything caught in the blade. The guard seems to be stylized in the shape of some winged entity."
	force = 8
	throwforce = 10
	throw_speed = 4
	throw_range = 7
	icon_state = "dark_blade"
	base_icon_state = "dark_blade"
	icon = 'maplestation_modules/story_content/armored_corps/icons/dark_blade.dmi'
	inhand_icon_state = "dark_blade"
	lefthand_file = 'maplestation_modules/story_content/armored_corps/icons/inhands/dark_blade_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/armored_corps/icons/inhands/dark_blade_righthand.dmi'
	hitsound = 'sound/weapons/genhit1.ogg'
	attack_verb_continuous = list("stubs","whacks","bludgeons")
	attack_verb_simple = list("stub","whack","bludgeon")
	armour_penetration = 25
	active_force = 25
	active_throwforce = 20
	active_light_color = COLOR_STRONG_VIOLET
