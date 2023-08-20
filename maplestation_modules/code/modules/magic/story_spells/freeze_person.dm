/datum/component/uses_mana/story_spell/pointed/freeze_person
	var/freeze_person_attunement = 0.5
	var/freeze_person_cost = 50

/datum/component/uses_mana/story_spell/pointed/freeze_person/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = freeze_person_attunement

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
		to_chat(owner, span_warning("You can only freeze living beings!"))
		return FALSE
	return TRUE

/datum/status_effect/magic_frozen
	id = "magic_frozen"
	duration = 100
	status_type = 3
	alert_type = /atom/movable/screen/alert/status_effect/magic_frozen
	var/icon/cube
	var/can_melt = TRUE
	var/trait_list = list(TRAIT_IMMOBILIZED, TRAIT_NOBLOOD, TRAIT_MUTE, TRAIT_EMOTEMUTE, TRAIT_RESISTHEAT)

/atom/movable/screen/alert/status_effect/magic_frozen
	name = "Magically Frozen"
	desc = "You're frozen inside an ice cube, and cannot move."
	icon_state = "frozen"

/datum/status_effect/magic_frozen/on_apply()
	. = ..()

	for(var/turf/open/nearby_turf in range(2, src)) //makes air around it cold
		var/datum/gas_mixture/air = nearby_turf.return_air()
		var/datum/gas_mixture/turf_air = nearby_turf?.return_air()
		if (air && air != turf_air)
			air.temperature = max(air.temperature + -15, 0)
			air.react(nearby_turf)

	if(!.)
		return
	owner.add_traits(trait_list, TRAIT_STATUS_EFFECT(id))
	owner.status_flags |= GODMODE
	owner.adjust_bodytemperature(-50)
	owner.move_resist = INFINITY
	owner.move_force = INFINITY
	owner.pull_force = INFINITY

	if(!owner.stat)
		to_chat(owner, span_userdanger("You become frozen in a cube!"))
	cube = icon('icons/effects/freeze.dmi', "ice_cube")
	owner.add_overlay(cube)

/datum/status_effect/magic_frozen/tick()
	if(can_melt && owner.bodytemperature >= owner.get_body_temp_normal())
		qdel(src)

/datum/status_effect/magic_frozen/on_remove()
	playsound(owner, 'sound/effects/glass_step.ogg', 70, TRUE, FALSE)
	if(!owner.stat)
		to_chat(owner, span_notice("The cube melts!"))
	owner.cut_overlay(cube)
	owner.adjust_bodytemperature(100)
	owner.remove_traits(trait_list, TRAIT_STATUS_EFFECT(id))
	owner.status_flags &= ~GODMODE
	owner.Knockdown(30)
	owner.move_resist = initial(owner.move_resist)
	owner.move_force = initial(owner.move_force)
	owner.pull_force = initial(owner.pull_force)
	return ..()

/datum/action/cooldown/spell/pointed/freeze_person/cast(var/mob/living/target)
	. = ..()
	var/mob/caster = usr || owner

	var/datum/effect_system/steam_spread/steam = new()
	steam.set_up(10, FALSE, target.loc)
	steam.start()

	caster?.Beam(target, icon_state="bsa_beam", time=5)
	target.apply_status_effect(/datum/status_effect/magic_frozen)
