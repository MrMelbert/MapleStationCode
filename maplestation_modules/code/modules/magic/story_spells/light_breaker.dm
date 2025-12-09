#define LIGHT_BREAKER_ATTUNEMENT_DARK 0.3
#define LIGHT_BREAKER_MANA_COST 25

/datum/action/cooldown/spell/pointed/projectile/light_breaker
	name = "Light Breaker"
	desc = "Propel forward a lance which shatters most lights it can hit."
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mad_touch"
	sound = 'sound/effects/parry.ogg'

	cooldown_time = 30 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	invocation = "Op'tc Br'k"
	invocation_type = INVOCATION_SHOUT
	school = SCHOOL_EVOCATION
	var/mana_cost = LIGHT_BREAKER_MANA_COST

	active_msg = "You prepare to throw a light shattering lance."
	deactive_msg = "You stop preparing to throw a light shattering lance."

	cast_range = 8
	projectile_type = /obj/projectile/energy/fisher

/datum/action/cooldown/spell/pointed/projectile/light_breaker/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_DARK] += LIGHT_BREAKER_ATTUNEMENT_DARK

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_required = mana_cost, \
		attunements = attunements, \
	)
