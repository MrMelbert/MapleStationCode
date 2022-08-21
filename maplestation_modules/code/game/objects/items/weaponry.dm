/*
	Baseball bats
	Adds a variable for the storage, and some basic variants.
*/

// Basic Bat
/obj/item/melee/baseball_bat
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/bats_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/bats_righthand.dmi'
	obj_flags = UNIQUE_RENAME
	unique_reskin = list(
		"Default" = "baseball_bat",
		"Pretty Pink Bat" = "baseball_bat_kitty",
		"Magical Bat" = "baseball_bat_magic"
		)
	/// The overlay this will add to the bat sheathe
	var/belt_sprite = "-basic"

// Home Run Bat
/obj/item/melee/baseball_bat/homerun
	icon_state = "baseball_bat_home"
	inhand_icon_state = "baseball_bat_home"
	belt_sprite = "-home"

// Metal Bat
/obj/item/melee/baseball_bat/ablative
	belt_sprite = "-metal"

// Barbed Bat
/obj/item/melee/baseball_bat/barbed
	name = "Barbara"
	desc = "A bat wrapped in hooked wires meant to dig into the flesh of the undead, although it works just as well on the living."
	icon_state = "baseball_bat_barbed"
	inhand_icon_state = "baseball_bat_barbed"
	attack_verb_simple = list("beat", "bashed", "tore into")
	attack_verb_continuous = list("beats", "bashes", "tears into")
	force = 10
	wound_bonus = 20
	bare_wound_bonus = 15
	belt_sprite = "-barbed"
