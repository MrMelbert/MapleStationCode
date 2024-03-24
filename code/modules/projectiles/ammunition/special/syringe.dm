// NON-MODULE CHANGE : this whole file
/obj/item/ammo_casing/syringegun
	name = "syringe gun spring"
	desc = "A high-power spring that throws syringes."
	slot_flags = null
	projectile_type = /obj/projectile/bullet/dart/syringe
	firing_effect_type = null

/obj/item/ammo_casing/syringegun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if(!istype(loaded_projectile, /obj/projectile/bullet/dart))
		return ..()

	var/obj/projectile/bullet/dart/loaded_dart = loaded_projectile
	if(istype(loc, /obj/item/gun/syringe))
		var/obj/item/gun/syringe/syringe_gun = loc
		if(!length(syringe_gun.syringes))
			return ..()

		loaded_dart.add_syringe(popleft(syringe_gun.syringes))

	else if(istype(loc, /obj/item/mecha_parts/mecha_equipment/medical/syringe_gun))
		var/obj/item/mecha_parts/mecha_equipment/medical/syringe_gun/syringe_gun = loc
		if(!LAZYLEN(syringe_gun.syringes))
			return ..()

		loaded_dart.add_syringe(popleft(syringe_gun.syringes))
		loaded_dart.range *= 4

	return ..()

/obj/item/ammo_casing/chemgun
	name = "dart synthesiser"
	desc = "A high-power spring, linked to an energy-based piercing dart synthesiser."
	projectile_type = /obj/projectile/bullet/dart
	firing_effect_type = null

/obj/item/ammo_casing/chemgun/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if(!istype(loaded_projectile, /obj/projectile/bullet/dart))
		return ..()
	if(istype(loc, /obj/item/gun/chem))
		var/obj/item/gun/chem/chem_gun = loc
		if(chem_gun.syringes_left <= 0)
			return ..()

		var/obj/item/reagent_containers/syringe/synthed_dart = new()
		synthed_dart.name = "piercing chemical dart"
		synthed_dart.inject_flags |= INJECT_CHECK_PENETRATE_THICK
		synthed_dart.item_flags |= DROPDEL

		chem_gun.reagents.trans_to(synthed_dart, synthed_dart.reagents.maximum_volume, transferred_by = user)
		chem_gun.syringes_left--

		var/obj/projectile/bullet/dart/loaded_dart = loaded_projectile
		loaded_dart.add_syringe(synthed_dart)

	return ..()

/obj/item/ammo_casing/dnainjector
	name = "rigged syringe gun spring"
	desc = "A high-power spring that throws DNA injectors."
	projectile_type = /obj/projectile/bullet/dart/syringe
	firing_effect_type = null

/obj/item/ammo_casing/dnainjector/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	if(!istype(loaded_projectile, /obj/projectile/bullet/dart))
		return ..()

	var/obj/projectile/bullet/dart/loaded_dart = loaded_projectile
	if(istype(loc, /obj/item/gun/syringe/dna))
		var/obj/item/gun/syringe/dna/dna_syringe_gun = loc
		if(!length(dna_syringe_gun.syringes))
			return ..()

		loaded_dart.add_syringe(popleft(dna_syringe_gun.syringes))
		loaded_dart.name = "\improper DNA injector"

	return ..()
