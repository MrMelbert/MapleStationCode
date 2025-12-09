/datum/story_rapid_status/lunar_judge
	name = "Lunar Judge"

/datum/story_rapid_status/lunar_judge/apply(mob/living/carbon/human/selected)
	var/list/datum/action/cooldown/spell/spells_to_grant = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/lunar,
		/datum/action/cooldown/spell/summonitem,
	)

	grant_spell_list(selected, spells_to_grant, TRUE)

	var/obj/item/toy/the_moon_itself/new_moon = new(selected)
	selected.equip_conspicuous_item(new_moon)

	return TRUE

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/lunar
	name = "Judge's Jaunt"

	background_icon_state = "bg_hive"
	overlay_icon_state = "bg_demon_border"
	cooldown_time = 12 SECONDS
	cooldown_reduction_per_rank = 0 SECONDS
	sound = 'sound/magic/cosmic_energy.ogg'
	exit_jaunt_sound = 'sound/magic/cosmic_energy.ogg'

/obj/item/toy/the_moon_itself
	name = "The Moon"
	desc = "Where did you even get this? I swear there's lunar colonies, are those people shrunk or dead?"
	icon = 'maplestation_modules/story_content/common_story/icons/literally_just_the_moon.dmi'
	icon_state = "moon"
	inhand_icon_state = "minimeteor"
	w_class = WEIGHT_CLASS_SMALL

	force = 20
	throwforce = 99
	max_integrity = 500000
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/the_moon_itself

/datum/armor/the_moon_itself
	melee = 65
	bullet = 70
	laser = 90 // highly reflective
	energy = 80
	consume = 100
	bomb = 95
	fire = 100
	acid = 90

/obj/item/toy/the_moon_itself/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	playsound(src, 'sound/effects/meteorimpact.ogg', 40, TRUE)
	for(var/mob/M in urange(10, src))
		if(!M.stat && !isAI(M))
			shake_camera(M, 3, 1)
