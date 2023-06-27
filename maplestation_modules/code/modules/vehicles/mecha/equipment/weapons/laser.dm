/obj/item/mecha_parts/mecha_equipment/weapon/energy/er_laser
	equip_cooldown = 30
	name = "\improper ER Large Laser \"Mauler\""
	desc = "A weapon for combat exosuits. Fires a cohesive laser beam. Utilizes Extended-Range technology to aid in long-range combat."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_erlaser"
	energy_drain = 250 //Huge energy drain!
	projectile = /obj/projectile/beam/er_laser
	fire_sound = 'maplestation_modules/sound/weapons/mecha/erlaser.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/er_laser/heavy
	name = "\improper ER Large Laser (N) \"Stormcrow\"" //(N) notation for stuff reserved to the Nanotrasen Military with the same name as something else.
	desc = "A weapon for combat exosuits. Fires a cohesive laser beam. Utilizes Extended-Range technology to aid in long-range combat. Utilizes high-grade crystals to fire a larger pulse beam."
	projectile = /obj/projectile/beam/er_laser/pulse
	icon_state = "mecha_erlaser_p"
	fire_sound = 'maplestation_modules/sound/weapons/mecha/erlasern.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulsed_laser
	equip_cooldown = 20
	name = "\improper Pulsed Laser \"Gunslinger\""
	desc = "A weapon for combat exosuits. Fires 3 small lasers in quick succession."
	icon_state = "mecha_laser"
	energy_drain = 80 //Fun fact, did you know there's a check to find out if a burst weapon still has energy when it fires in case it runs out? It's buggy.
	projectile = /obj/projectile/beam/weak/pulsed
	projectiles_per_shot = 3
	projectile_delay = 1.5
	fire_sound = 'sound/weapons/blaster.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulsed_laser/large
	name = "\improper Heavy Pulsed Laser \"Huntsman\""
	desc = "A weapon for combat exosuits. Fires 3 hellfire lasers in quick succession."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_erlaser"
	projectile = /obj/projectile/beam/laser/hellfire/pulsed
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
