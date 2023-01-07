GLOBAL_VAR_INIT(disposals_damage_markiplier, 1)
GLOBAL_VAR_INIT(disposals_pain_chance, 10)
GLOBAL_VAR_INIT(disposals_damage_chance, 10)

/obj/structure/disposalholder/try_expel(datum/move_loop/source, succeed, visual_delay)
	. = ..()
	if(current_pipe || !active)
		if(!(locate(/obj/structure/disposaloutlet) in get_turf(src))) /// Checks if there's an outlet so it doesn't keep trying to damage you there.
			for(var/mob/living/trashed_individual in src)
				if(prob(20))
					playsound(loc, 'sound/effects/clang.ogg', 30, TRUE, FALSE)
				else if(prob(GLOB.disposals_damage_chance))
					trashed_individual.apply_damage(1 * GLOB.disposals_damage_markiplier, BRUTE)
					playsound(loc, 'sound/effects/wounds/crack2.ogg', 50, TRUE, FALSE)
				else if(prob(GLOB.disposals_pain_chance) && iscarbon(trashed_individual))
					var/mob/living/carbon/carbon_trashed = trashed_individual
					playsound(loc, 'sound/effects/wounds/crack1.ogg', 50, TRUE, FALSE)
					carbon_trashed.sharp_pain(pick(BODY_ZONES_ALL), 1 * GLOB.disposals_damage_markiplier, BRUTE)
