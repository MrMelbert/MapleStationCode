/datum/action/cooldown/spell/conjure_item/dark_forging
	name = "Dark Forging"
	desc = "Form the darkness around you into one of multiple weapons. \
	Forming your signature blade requires extra concentration, therefore requiring you to manifest every other weapon before you can use it."
	button_icon = 'maplestation_modules/story_content/crit_equipment/icons/dark_forging_icon.dmi'
	button_icon_state = "dark_forging"

	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"

	cooldown_time = 20 SECONDS

	requires_hands = TRUE

	/// All the weapons we've previously casted, used to track if we can use Piercer
	var/list/casted_weapons = list()

/datum/action/cooldown/spell/conjure_item/dark_forging/can_cast_spell(feedback)
	. = ..()
	var/turf/cast_turf = get_turf(owner)
	if(cast_turf.get_lumcount() >= SHADOW_SPECIES_LIGHT_THRESHOLD)
		if(feedback)
			to_chat(owner, span_warning("It isn't dark enough here!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/conjure_item/dark_forging/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/list/summonable_weapons = list()
	var/list/summonable_weapon_types = list()
	for(var/atom/path as anything in subtypesof(/obj/item/melee/dark_forged))
		if(path == /obj/item/melee/dark_forged/piercer && (length(casted_weapons) != (length(subtypesof(/obj/item/melee/dark_forged)) - 1)))
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

/datum/action/cooldown/spell/conjure_item/dark_forging/post_created(atom/cast_on, atom/created)
	if(!casted_weapons.Find(created.name) && created != /obj/item/melee/dark_forged/piercer)
		casted_weapons += created.name
	if(created == /obj/item/melee/dark_forged/piercer)
		casted_weapons.Cut()

/obj/item/melee/dark_forged
	name = "dark forged weapon"
	desc = "A weapon shaped from darkness. This description is also a placeholder. god dammit"
	icon = 'maplestation_modules/story_content/crit_equipment/icons/dark_forging.dmi'
	icon_state = "axe"
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
	icon_state = "lance"
	sharpness = SHARP_POINTY
	force = 25
	throwforce = 50
	throw_speed = 4
	throw_range = 12
	tk_throw_range = 3 // thing's heavy

/obj/item/melee/dark_forged/lance/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_IMPACT, PROC_REF(on_throw_hit))

/obj/item/melee/dark_forged/lance/proc/on_throw_hit(obj/item/weapon, mob/living/carbon/victim, hit_zone, blocked, datum/thrownthing/throwingdatum, forced = FALSE)
	SIGNAL_HANDLER

	visible_message(
		span_warning("[src] breaks on impact!"),
		blind_message = span_danger("You hear a large chunk of glass shattering.")
		)
	playsound(victim, SFX_SHATTER, 60, TRUE)
	qdel(src)

/obj/item/melee/dark_forged/dagger
	name = "dark forged dagger"
	desc = "A knife made from the shadows by a masterful caster. It can be used to rapidly inflict wounds on a target."
	icon_state = "dagger"
	sharpness = SHARP_EDGED
	force = 18
	wound_bonus = 50
	bare_wound_bonus = 25
	attack_speed = CLICK_CD_MELEE / 2 // technically not twice as fast, there's a base 0.1s time on byond's click code. so 0.9s to 0.5s

/obj/item/melee/dark_forged/halberd
	name = "dark forged halberd"
	desc = "A halberd made from darkness. Using it well, you can easily counter any reckless attack."
	icon_state = "axe"
	sharpness = SHARP_EDGED
	force = 30
	block_chance = 50

/obj/item/melee/dark_forged/halberd/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	. = ..()
	if(.)
		on_halberd_block(owner, hitby, attack_text, damage, attack_type, damage_type)

/obj/item/melee/dark_forged/halberd/proc/on_halberd_block(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == THROWN_PROJECTILE_ATTACK)
		return

	var/mob/living/attacker = GET_ASSAILANT(hitby)
	if(istype(attacker) && owner.Adjacent(attacker))
		owner.visible_message(
			span_danger("[owner] counters the [attack_text] with an attack of [owner.p_their()] own!"),
			span_userdanger("You counter [attack_text]!"),
		)
		melee_attack_chain(owner, attacker) //ideally i'd have it do extra wounding but that's not really an attack modifier (yet)

/obj/item/melee/dark_forged/shield
	name = "dark forged shield"
	desc = "A shield of shadows. It seems to shape and morph to protect you from attacks you might not have seen coming. The sun, moon and the star are present in the shield's design."
	icon_state = "shield"
	force = 10
	block_chance = 75

// The jackpot, the furioso. doesnt make that much lore sense that it can't be formed instantly but gameplay balancing is more important
/obj/item/melee/dark_forged/piercer
	name = "dark forged blade"
	desc = "A masterfully shaped blade, yet made out of nothing but disposable shadow. Takes a greater effort to manifest, but is much more powerful."
	icon_state = "sword"
	sharpness = SHARP_EDGED
	force = 40
	armour_penetration = 75
	wound_bonus = 50
	bare_wound_bonus = 25
	block_chance = 50

/obj/item/melee/dark_forged/piercer/attack_secondary(mob/living/victim, mob/living/user, params)
	. = ..()

	if(!do_after(user,  3 SECONDS, target = victim))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	victim.apply_damage(damage = src.force * 2, def_zone = BODY_ZONE_CHEST, wound_bonus = src.wound_bonus, bare_wound_bonus = src.bare_wound_bonus, sharpness = src.sharpness, attacking_item = src)
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		carbon_victim.adjustOrganLoss(ORGAN_SLOT_HEART, 100) //yes, surviving this with a cyber heart is intentional because that's BADASS

	user.visible_message(
		span_danger("[user] stabs [victim] in the heart with the [src]!"),
		span_userdanger("You stab [victim] in the heart."),
	)

	user.do_attack_animation(victim, used_item = src)
	victim.do_splatter_effect(get_dir(user, victim))

	playsound(source = src, soundin = src.hitsound, vol = src.get_clamped_volume(), vary = TRUE)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
