/datum/component/uses_mana/story_spell/pointed/freeze_person
	var/freeze_person_attunement = 0.5
	var/freeze_person_cost = 50

/datum/component/uses_mana/story_spell/pointed/freeze_person/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = freeze_person_attunement

/datum/component/uses_mana/story_spell/pointed/freeze_person/get_mana_required(atom/caster, atom/cast_on, ...)
	return ..() * freeze_person_cost

/datum/action/cooldown/spell/pointed/freeze_person
	name = "Freeze Person"
	desc = "Encase your target in a block of enchanted ice, rendering them immobile and immune to damage."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "benfrozen"
	sound = 'sound/effects/ice_shovel.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	invocation = "Als Eisz'it!" 
	invocation_type = INVOCATION_SHOUT
	school = SCHOOL_CONJURATION

	active_msg = "You prepare to freeze someone."
	deactive_msg = "You stop preparing to freeze someone."
	aim_assist = FALSE
	cast_range = 8

/datum/action/cooldown/spell/pointed/freeze_person/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		var/mob/caster = usr || owner
		if(caster)
			cast_on.balloon_alert(caster, "can't freeze that!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/freeze_person/cast(var/mob/living/target)
	. = ..()
	var/mob/caster = usr || owner

	var/datum/effect_system/steam_spread/steam = new()
	steam.set_up(10, FALSE, target.loc)
	steam.start()

	caster?.Beam(target, icon_state="bsa_beam", time=5)
	target.apply_status_effect(/datum/status_effect/freon/magic)

/datum/status_effect/freon/magic
	id = "magic_frozen"
	duration = 100
	status_type = 3
	alert_type = /atom/movable/screen/alert/status_effect/magic_frozen
	var/trait_list = list(TRAIT_IMMOBILIZED, TRAIT_NOBLOOD, TRAIT_MUTE, TRAIT_EMOTEMUTE, TRAIT_RESISTHEAT)

/atom/movable/screen/alert/status_effect/magic_frozen
	name = "Magically Frozen"
	desc = "You're frozen inside an ice cube, and cannot move."
	icon_state = "frozen"

/datum/status_effect/freon/magic/on_apply()
	. = ..()
	if(!.)
		return
	for(var/turf/open/nearby_turf in range(2, owner)) //makes air around it cold
		var/datum/gas_mixture/air = nearby_turf.return_air()
		var/datum/gas_mixture/turf_air = nearby_turf?.return_air()
		if (air && air != turf_air)
			air.temperature = max(air.temperature + -15, 0)
			air.react(nearby_turf)

	owner.add_traits(trait_list, TRAIT_STATUS_EFFECT(id))
	owner.status_flags |= GODMODE
	owner.adjust_bodytemperature(-50)
	owner.move_resist = INFINITY
	owner.move_force = INFINITY
	owner.pull_force = INFINITY

/datum/status_effect/freon/magic/do_resist()
	return 

/datum/status_effect/freon/magic/on_remove()
	playsound(owner, 'sound/effects/glass_step.ogg', 70, TRUE, FALSE)
	owner.adjust_bodytemperature(-100)
	owner.remove_traits(trait_list, TRAIT_STATUS_EFFECT(id))
	owner.status_flags &= ~GODMODE
	owner.Knockdown(3 SECONDS)
	owner.move_resist = initial(owner.move_resist)
	owner.move_force = initial(owner.move_force)
	owner.pull_force = initial(owner.pull_force)
	return ..()
