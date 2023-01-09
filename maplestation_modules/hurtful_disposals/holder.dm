// -- File to make disposals hurt when people tumble through them --
/// Multiplier to how much damage and pain is applied on proc
GLOBAL_VAR_INIT(disposals_damage_multiplier, 1)
/// Probability of taking brute damage every move (only rolls if the clang sound is not rolled)
GLOBAL_VAR_INIT(disposals_damage_chance, 10)
/// Probability of getting pain every move (only rolls if damage is not rolled)
GLOBAL_VAR_INIT(disposals_pain_chance, 10)


if(!current_pipe && active)
		return
	
	// Checks if there's an outlet so it doesn't keep trying to damage you there.
	if(locate(/obj/structure/disposaloutlet) in get_turf(src)) 
		return
		
	for(var/mob/living/trashed_individual in src)
		if(prob(20))
			playsound(loc, 'sound/effects/clang.ogg', 30, TRUE, FALSE)
		else if(prob(GLOB.disposals_damage_chance))
			trashed_individual.apply_damage(1 * GLOB.disposals_damage_multiplier, BRUTE)
			playsound(loc, 'sound/effects/wounds/crack2.ogg', 50, TRUE, FALSE)
		else if(prob(GLOB.disposals_pain_chance) && iscarbon(trashed_individual))
			var/mob/living/carbon/carbon_trashed = trashed_individual
			playsound(loc, 'sound/effects/wounds/crack1.ogg', 50, TRUE, FALSE)
			carbon_trashed.sharp_pain(pick(BODY_ZONES_ALL), 1 * GLOB.disposals_damage_multiplier, BRUTE)
