/datum/action/cooldown/spell/smoke/tevetia
	name = "Hunter's Smoke"
	desc = "This spell spawns a cloud of black smoke at your location. \
		It will also give thermal vision, allowing you to see who is inside."

	cooldown_time = 25 SECONDS

	smoke_type = /datum/effect_system/fluid_spread/smoke/tevetia
	smoke_amt = 5

/datum/effect_system/fluid_spread/smoke/tevetia
	effect_type = /obj/effect/particle_effect/fluid/smoke/tevetia

/obj/effect/particle_effect/fluid/smoke/tevetia
	name = "black smoke"
	color = "#1b1b1b"
	lifetime = 16 SECONDS

/datum/action/cooldown/spell/smoke/tevetia/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_THERMAL_VISION, MAGIC_TRAIT)
	remove_from.update_sight()
	return ..()

/datum/action/cooldown/spell/smoke/tevetia/cast(mob/cast_on)
	. = ..()
	ADD_TRAIT(cast_on, TRAIT_THERMAL_VISION, MAGIC_TRAIT)
	cast_on.update_sight()
	addtimer(CALLBACK(src, PROC_REF(deactivate), cast_on), 17 SECONDS) //+1 second in order to account for smoke easing out

/datum/action/cooldown/spell/smoke/tevetia/proc/deactivate(mob/cast_on)
	REMOVE_TRAIT(cast_on, TRAIT_THERMAL_VISION, MAGIC_TRAIT)
	cast_on.update_sight()
