/obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc
	equip_cooldown = 40 //4 seconds between shots, might be weak, certainly is dps-wise
	name = "\improper PPC \"Awesome\""
	desc = "A weapon for combat exosuits. Shoots a powerful stream of high-energy particles."
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_ppc"
	energy_drain = 150
	projectile = /obj/projectile/beam/ppc
	fire_sound = 'maplestation_modules/sound/weapons/mecha/ppc.ogg'
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ppc/hellstar //admin-only
	name = "\improper ER PPC \"Hellstar\""
	desc = "A weapon for combat exosuits. Shoots an extremely powerful stream of exotic particles capable of punching through any armoring."
	icon_state = "mecha_ppc_er"
	energy_drain = 200
	projectile = /obj/projectile/beam/ppc/hellstar
	fire_sound = 'maplestation_modules/sound/weapons/mecha/erppc.ogg'
