/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC/2" //this entire time it was mispelled, and the proper version looks way cooler
	desc = "A weapon for combat exosuits. Shoots a rapid, three shot burst. Utilizes magnetic loading for faster firing." //override for lore purposes, explains what "Ultra" even means

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/slow //weaker version of the AC2 for lore purposes, used by non-NT factions
	name = "\improper Autocannon/2"
	desc = "A weapon for combat exosuits. Shoots a three shot burst."
	equip_cooldown = 15
	projectile_delay = 3

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_5
	name = "\improper Autocannon/5"
	desc = "A weapon for combat exosuits. Fires two rounds at high speed. Notably good at range."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_ac5"
	equip_cooldown = 25
	projectile_delay = 1 //hyper-burst
	projectile = /obj/projectile/bullet/autocannon_5
	projectiles = 100 //Diminishing returns on ammo as caliber increases
	projectiles_cache = 200
	projectiles_cache_max = 400
	projectiles_per_shot = 2
	fire_sound = 'maplestation_modules/sound/weapons/starbloom_45.ogg'
	harmful = TRUE
	ammo_type = MECHA_AMMO_AC5

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_5/ultra //ultra ACs from this point on aren't printable and thus are rarer to get
	name = "\improper Ultra AC/5"
	desc = "A weapon for combat exosuits. Fires two rounds at high speed. Notably good at range. Utilizes magnetic loading for faster firing."
	equip_cooldown = 15

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_10
	name = "\improper Autocannon/10"
	desc = "A weapon for combat exosuits. Fires a singular armor-piercing round."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_ac10"
	equip_cooldown = 15
	projectile = /obj/projectile/bullet/autocannon_10
	projectiles = 20
	projectiles_cache = 40
	projectiles_cache_max = 80
	fire_sound = 'maplestation_modules/sound/weapons/starbloom_revolver.ogg'
	harmful = TRUE
	ammo_type = MECHA_AMMO_AC10

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_10/ultra
	name = "\improper Ultra AC/10"
	desc = "A weapon for combat exosuits. Fires a singular armor-piercing round. Utilizes magnetic loading for faster firing."
	equip_cooldown = 10

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_20
	name = "\improper Autocannon/20"
	desc = "A weapon for combat exosuits. Fires a singular slow gigantic slug."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_ac20"
	equip_cooldown = 40
	projectile = /obj/projectile/bullet/autocannon_20
	projectiles = 5 //make it count
	projectiles_cache = 20
	projectiles_cache_max = 40
	fire_sound = 'maplestation_modules/sound/weapons/mecha/ac20.ogg'
	harmful = TRUE
	ammo_type = MECHA_AMMO_AC20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/autocannon_20/ultra
	name = "\improper Ultra AC/20"
	desc = "A weapon for combat exosuits. Fires a singular slow gigantic slug. Utilizes magnetic loading for faster firing."
