/datum/component/uses_mana/story_spell/pointed/ice_knife
	var/ice_knife_attunement = 0.5
	var/ice_knife_cost = 25

/datum/component/uses_mana/story_spell/pointed/ice_knife/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = ice_knife_attunement

/datum/action/cooldown/spell/pointed/projectile/ice_knife
	
	name = "Ice Knife"
	desc = "Materialize an explosive shard of ice and fling it at your target."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "iceknife"
	sound = 'sound/effects/parry.ogg'

	cooldown_time = 2 SECONDS // change to two minutes later ; this is for testing !!
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	invocation = "Ice knife! Replace this with something better later."
	invocation_type = INVOCATION_SHOUT
	school = SCHOOL_CONJURATION

	active_msg = "You prepare to throw an ice knife."
	deactive_msg = "You stop preparing to throw an ice knife."

	cast_range = 8
	projectile_type = /obj/projectile/magic/ice_knife

/obj/projectile/magic/ice_knife
	name = "ice knife"
	icon_state = "ice_2"
	damage_type = BURN
	damage = 30

/obj/projectile/magic/ice_knife/on_hit(atom/target)
	. = ..()

	var/turf/target_turf = get_turf(target)

	for(var/turf/open/nearby_turf in range(1, src))
		nearby_turf.MakeSlippery(TURF_WET_ICE, 300)
		var/datum/gas_mixture/air = nearby_turf.return_air()
		var/datum/gas_mixture/turf_air = nearby_turf?.return_air()
		if (air && air != turf_air) // if this has air and we arent a turf
			air.temperature = max(air.temperature + -50, 0) //this sucks.
			air.react(nearby_turf)
		if (isturf(nearby_turf) && turf_air)
			turf_air.temperature = max(turf_air.temperature + -50, 0)
			turf_air.react(nearby_turf)
			nearby_turf?.air_update_turf()
