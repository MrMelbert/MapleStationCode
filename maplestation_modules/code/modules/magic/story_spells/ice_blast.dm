#define ICE_BLAST_ATTUNEMENT_ICE 0.5
#define ICE_BLAST_MANA_COST 25

/datum/action/cooldown/spell/pointed/projectile/ice_blast
	name = "Ice blast"
	desc = "Throw an ice blast which'll cover nearby floor with a thin, slippery sheet of ice."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "ice_blast"
	sound = 'sound/effects/parry.ogg'

	cooldown_time = 1 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	invocation = "Frig'dus humer'm!" //this one sucks,  ireally wis hi had something better
	invocation_type = INVOCATION_SHOUT
	school = SCHOOL_CONJURATION
	var/mana_cost = ICE_BLAST_MANA_COST

	active_msg = "You prepare to throw an ice blast."
	deactive_msg = "You stop preparing to throw an ice blast."

	cast_range = 8
	projectile_type = /obj/projectile/magic/ice_blast

/datum/action/cooldown/spell/pointed/projectile/ice_blast/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_ICE] += ICE_BLAST_ATTUNEMENT_ICE

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
		attunements = attunements, \
	)

/// Special ice made so that I can replace it's Initialize's MakeSlippery call to have a different property.
/turf/open/misc/funny_ice
	name = "thin ice sheet"
	desc = "A thin sheet of solid ice. Looks slippery."
	icon = 'icons/turf/floors/ice_turf.dmi'
	icon_state = "ice_turf-0"
	base_icon_state = "ice_turf-0"
	slowdown = 1
	bullet_sizzle = TRUE
	underfloor_accessibility = UNDERFLOOR_HIDDEN
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/misc/funny_ice/Initialize(mapload)
	. = ..()
	MakeSlippery(TURF_WET_ICE, INFINITY, 0, INFINITY, TRUE)

/obj/projectile/magic/ice_blast
	name = "ice blast"
	icon_state = "ice_2"
	damage_type = BRUTE
	damage = 15
	wound_bonus = 10

/obj/projectile/magic/ice_blast/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	playsound(loc, 'sound/weapons/ionrifle.ogg', 70, TRUE, FALSE)

	var/datum/effect_system/steam_spread/steam = new()
	steam.set_up(10, FALSE, target.loc)
	steam.start()

	for(var/turf/open/nearby_turf in range(3, target))
		var/datum/gas_mixture/air = nearby_turf.return_air()
		var/datum/gas_mixture/turf_air = nearby_turf.return_air()
		if (air && air != turf_air)
			air.temperature = max(air.temperature + -15, TCMB)
			air.react(nearby_turf)

	for(var/turf/open/nearby_turf in range(1, src)) // this is fuck ugly, could make a new MakeSlippery flag instead.
		if(isgroundlessturf(nearby_turf))
			continue
		var/ice_turf = /turf/open/misc/funny_ice
		var/reset_turf = nearby_turf.type
		nearby_turf.TerraformTurf(ice_turf, flags = CHANGETURF_INHERIT_AIR) // this will also delete decals! consider the comment above. i'm tired.
		addtimer(CALLBACK(nearby_turf, TYPE_PROC_REF(/turf, TerraformTurf), reset_turf, null, CHANGETURF_INHERIT_AIR), 20 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)
