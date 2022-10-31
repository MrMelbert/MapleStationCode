GLOBAL_VAR(captain_weapon_picked)
//Weapons for the captain to use in melee.
/obj/item/melee/sabre/Initialize(mapload)
	. = ..()
	if(!GLOB.captain_weapon_picked)
		AddComponent(/datum/component/subtype_picker, GLOB.captain_weapons, CALLBACK(src, .proc/on_captain_weapon_picked))

///Probably doesn't need to be a proc, but this is used when the captain's weapon is chosen to make sure you can keep picking the sabre over and over. Has to be a global list so that its on the next weapon.
/obj/item/melee/sabre/proc/on_captain_weapon_picked(obj/item/melee/sabre/captain_weapon_picked)
	GLOB.captain_weapon_picked = captain_weapon_picked

/obj/item/melee/baseball_bat/golden
	name = "Il Batto Doro"
	desc = "A bat wrapped in hooked wires meant to dig into the flesh of the undead, although it works just as well on the living."
	icon_state = "baseball_bat_golden"
	inhand_icon_state = "baseball_bat_golden"
	force = 30 //OUCH
	wound_bonus = 40 //Bones? Never heard of em.
	bare_wound_bonus = 45
	belt_sprite = "-golden"

/obj/item/melee/energy/sword/captain_rapier
	name = "laser rapier"
	desc = "The captain's own laser rapier, designed to ruin any obnoxious security cameras. Marked with the logo of a company named TriOptimum."
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	icon_state = "laser_rapier"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 5 //The golden hilt is very blunt
	active_force = 25
	active_throwforce = 35 //Its a fucking spear of a sword
	armour_penetration = 50
	block_chance = 10 //Compared to the sabre's 50, yikes.

/obj/item/melee/energy/sword/captain_rapier/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(blade_active) //deals double damage to cameras
		if(istype(target, /obj/machinery/camera))
			var/obj/machinery/targetted_camera = target
			targetted_camera.take_damage(damage_amount = src.force, sound_effect = null, armour_penetration = src.armour_penetration)
