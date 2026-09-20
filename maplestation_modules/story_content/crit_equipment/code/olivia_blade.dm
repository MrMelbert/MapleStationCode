/// Used for unlocking the second level of /obj/item/melee/olivia_blade 's psychic effects
#define TRAIT_SWORD_PSIONIC "sword_psionic"

/obj/item/melee/olivia_blade
	name = "ornate psi-blade"
	desc = "An incredibly ornate psionic blade. It's somewhat heavy."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/olivia_blade.dmi'
	icon_state = "olivia_blade"
	inhand_icon_state = "olivia_blade"
	lefthand_file = 'maplestation_modules/story_content/crit_equipment/icons/olivia_blade_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/crit_equipment/icons/olivia_blade_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY | UNIQUE_RENAME
	force = 18
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 25
	armour_penetration = 20
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	block_sound = 'sound/weapons/parry.ogg'
	hitsound = 'sound/weapons/bladeslice.ogg'
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	bare_wound_bonus = 20
	drop_sound = 'maplestation_modules/sound/items/drop/sword.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/sword2.ogg'
	equip_sound = 'maplestation_modules/sound/items/drop/sword.ogg'

/obj/item/melee/olivia_blade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jousting)
	AddComponent(/datum/component/butchering, \
		speed = 3 SECONDS, \
		effectiveness = 80, \
	)
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(check_psychic_effects))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(remove_psychic_effects))

/// Checks psychic traits of the user, either no psychic, psychic or the special super psychic kind
/obj/item/melee/olivia_blade/proc/check_psychic_effects(obj/item/source, mob/user, slot)
	if(HAS_TRAIT(user, TRAIT_FULL_PSIONIC))
		force = 25
		armour_penetration = 50
		wound_bonus = 20
		block_chance = 50
	if(HAS_TRAIT(user, TRAIT_SWORD_PSIONIC))
		// just overwrite everything from the previous one
		force = 35
		armour_penetration = 0
		wound_bonus = 40
		block_chance = 60
		sharpness = NONE
		attack_verb_continuous = list("beats", "smacks")
		attack_verb_simple = list("beat", "smack")
		hitsound = 'sound/weapons/resonator_blast.ogg'
	update_appearance()

/obj/item/melee/olivia_blade/proc/remove_psychic_effects(obj/item/source, mob/user)
	force = initial(force)
	armour_penetration = initial(armour_penetration)
	wound_bonus = initial(wound_bonus)
	sharpness = initial(sharpness)
	attack_verb_continuous = initial(attack_verb_continuous)
	attack_verb_simple = initial(attack_verb_simple)
	hitsound = initial(hitsound)
	update_appearance()

// THATS RIGHT ITS THE BASEBALL BAT KNOCKBACK
/obj/item/melee/olivia_blade/attack(mob/living/target, mob/living/user)
	// we obtain the relative direction from the ~~bat~~ SWORD itself to the target
	var/relative_direction = get_cardinal_dir(src, target)
	var/atom/throw_target = get_edge_target_turf(target, relative_direction)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM) || !HAS_TRAIT(user, TRAIT_SWORD_PSIONIC))
		return
	else if(!QDELETED(target) && !target.anchored)
		var/whack_speed = (prob(60) ? 1 : 3)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user, gentle = FALSE) // we are NOT gentle

/obj/item/melee/olivia_blade/on_exit_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/olivia_blade/on_enter_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/olivia_blade/update_overlays()
	. = ..()

	if(force >= 25)
		. += mutable_appearance(icon, "psi_effect", layer = layer + 0.1)

// Broken admin verb - gotta figure out how to make it not appear on *everything*
//ADMIN_VERB_ONLY_CONTEXT_MENU(toggle_olivia_blade_sheath_lock, R_FUN, "Toggle Sheath Lock", obj/item/storage/belt/olivia_blade_sheath/target_sheath in world)
//	target_sheath.toggle_sheath_lock()

/obj/item/storage/belt/olivia_blade_sheath
	name = "ornate psiblade sheath"
	desc = "An ornate sheath designed to hold a psionic blade. It looks heavy enough to bludgeon with."
	force = 18
	block_chance = 30
	icon = 'maplestation_modules/story_content/crit_equipment/icons/olivia_blade.dmi'
	worn_icon = 'maplestation_modules/story_content/crit_equipment/icons/olivia_blade_sheath.dmi'
	icon_state = "sheath"
	worn_icon_state = "sheath"
	w_class = WEIGHT_CLASS_BULKY
	interaction_flags_click = parent_type::interaction_flags_click | NEED_DEXTERITY | NEED_HANDS

/obj/item/storage/belt/olivia_blade_sheath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

	atom_storage.max_slots = 1
	atom_storage.rustle_sound = FALSE
	atom_storage.max_specific_storage = WEIGHT_CLASS_BULKY
	atom_storage.set_holdable(/obj/item/melee/olivia_blade)
	atom_storage.click_alt_open = FALSE
	atom_storage.locked = STORAGE_FULLY_LOCKED
	update_appearance()

/obj/item/storage/belt/olivia_blade_sheath/examine(mob/user)
	. = ..()
	if(length(contents) && (atom_storage.locked == STORAGE_NOT_LOCKED))
		. += span_notice("Alt-click it to quickly draw the blade.")

/obj/item/storage/belt/olivia_blade_sheath/click_alt(mob/user)
	if(length(contents) && (atom_storage.locked == STORAGE_NOT_LOCKED))
		var/obj/item/I = contents[1]
		user.visible_message(span_notice("[user] takes [I] out of [src]."), span_notice("You take [I] out of [src]."))
		user.put_in_hands(I)
		update_appearance()
	else if(length(contents) && atom_storage.locked != STORAGE_NOT_LOCKED)
		balloon_alert(user, "it's not budging!")
	else
		balloon_alert(user, "it's empty!")
	return CLICK_ACTION_SUCCESS

/obj/item/storage/belt/olivia_blade_sheath/proc/toggle_sheath_lock()
	if(atom_storage.locked != STORAGE_NOT_LOCKED)
		atom_storage.locked = STORAGE_NOT_LOCKED
		atom_storage.display_contents = TRUE
		update_appearance()
		return TRUE
	else
		atom_storage.locked = STORAGE_FULLY_LOCKED
		atom_storage.display_contents = FALSE
		atom_storage.close_all()
		update_appearance()
		return FALSE

/obj/item/storage/belt/olivia_blade_sheath/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)

	if(!length(contents) && istype(tool, /obj/item/melee/olivia_blade) && atom_storage.locked == STORAGE_FULLY_LOCKED)
		if(do_after(user, 4 SECONDS, src))
			atom_storage.attempt_insert(tool, user, force = STORAGE_FULLY_LOCKED)
			return ITEM_INTERACT_SUCCESS
		else
			return ..()

	if(length(contents) && istype(tool, /obj/item/melee/olivia_blade) && atom_storage.locked == STORAGE_FULLY_LOCKED) // what
		balloon_alert(user, "it's full.")
		return ..()

	return ..()

/obj/item/storage/belt/olivia_blade_sheath/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()

	if(contents.len)
		. += mutable_appearance(worn_icon, "sheath_blade", layer = standing.layer + 0.1)

/obj/item/storage/belt/olivia_blade_sheath/update_overlays()
	. = ..()

	if(contents.len)
		. += mutable_appearance(icon, "sheath_sword", layer = layer + 0.1)

	if(atom_storage.locked == STORAGE_FULLY_LOCKED)
		. += mutable_appearance(icon, "lock", layer = layer + 0.11)
	else
		. += mutable_appearance(icon, "lock_inactive", layer = layer + 0.11)

/obj/item/storage/belt/olivia_blade_sheath/PopulateContents()
	new /obj/item/melee/olivia_blade(src)
	update_appearance()
