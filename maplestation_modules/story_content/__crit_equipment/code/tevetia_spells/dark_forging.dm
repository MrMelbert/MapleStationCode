/datum/action/cooldown/spell/conjure_item/dark_forging
	button_icon_state = "shapeshift"
	cooldown_time = 20 SECONDS

	requires_hands = TRUE

	/// All the weapons we've previously casted, used to track if we can use Piercer
	var/list/casted_weapons = list()

/datum/action/cooldown/spell/dark_forging/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/list/summonable_weapons = list()
	for(var/atom/path as anything in subtypesof(/obj/item/melee/dark_forged))
		if(path == /obj/item/melee/dark_forged/piercer)
			continue
		var/path_name = initial(path.name)
		summonable_weapon_types[path_name] = path
		summonable_weapons[path_name] = image(icon = initial(path.icon), icon_state = initial(path.icon_state))

	var/picked_item = show_radial_menu(
		cast_on,
		cast_on,
		summonable_weapons,
		custom_check = FALSE,
		radius = 38,
	)

	item_type = summonable_weapon_types[picked_item]

/datum/action/cooldown/spell/dark_forging/post_created(atom/cast_on, atom/created)
	if(!casted_weapons.Find(created.name) && created != /obj/item/melee/dark_forged/piercer)
		casted_weapons += created.name
	if(created == /obj/item/melee/dark_forged/piercer)
		casted_weapons.Cut()

/obj/item/melee/dark_forged
	name = "dark forged weapon"
	desc = "A weapon shaped from darkness. This description is also a placeholder. god dammit"
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "sabre"
	inhand_icon_state = "sabre"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	block_sound = 'sound/weapons/parry.ogg'
	hitsound = 'sound/weapons/rapierhit.ogg'
	drop_sound = 'maplestation_modules/sound/items/drop/sword.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/sword2.ogg'
	equip_sound = 'maplestation_modules/sound/items/drop/sword.ogg'

/obj/item/melee/dark_forged/lance
	name = "dark forged lance"
	desc = "A lance formed by darkness. It can be used to lunge at enemies or be thrown for massive damage."
	sharpness = SHARP_POINTY
	force = 25
	throwforce = 50

/obj/item/melee/dark_forged/dagger
	name = "dark forged dagger"
	desc = "A knife made from the shadows by a masterful caster. It can be used to rapidly inflict wounds on a target."
	sharpness = SHARP_EDGED
	force = 20
	wound_bonus = 50
	bare_wound_bonus = 25

/obj/item/melee/dark_forged/halberd
	name = "dark forged halberd"
	desc = "A halberd made from darkness."
	force = 25

/obj/item/melee/dark_forged/hammer
	name = "dark forged hammer"
	desc = "A sledgehammer made out of the dark, with a surprising amount of weight to it. It can easily destroy objects or break people's guard."
	force = 20
	demolition_mod = 2

/obj/item/melee/dark_forged/shield
	name = "dark forged shield"
	desc = "A shield of shadows. It seems to shape and morph to protect you from attacks you might not have seen coming."
	force = 10
	block_chance = 60

/obj/item/melee/dark_forged/piercer
	name = "dark forged blade"
	desc = "A masterfully shaped blade, yet made out of nothing but disposable shadow. Takes a greater effort to manifest, but is much more powerful."
	sharpness = SHARP_EDGED
	force = 40
	armour_penetration = 75
	wound_bonus = 50
	bare_wound_bonus = 25

/obj/item/melee/dark_forged/piercer/attack_secondary(mob/living/victim, mob/living/user, params)
	. = ..()

	if(!do_after(user,  3 SECONDS, target = victim))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	victim.apply_damage(damage = src.force * 2, def_zone = BODY_ZONE_CHEST, wound_bonus = src.wound_bonus, bare_wound_bonus = src.bare_wound_bonus, sharpness = src.sharpness, attacking_item = src)
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		carbon_victim.adjustOrganLoss(ORGAN_SLOT_HEART, 100) //yes, surviving this with a cyber heart is intentional

	user.do_attack_animation(victim, used_item = src)
	victim.do_splatter_effect(get_dir(user, victim))

	playsound(source = src, soundin = src.hitsound, vol = src.get_clamped_volume(), vary = TRUE)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
