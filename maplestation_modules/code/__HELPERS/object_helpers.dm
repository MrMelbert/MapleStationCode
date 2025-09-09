// code that checks for starlight on a movable atom. pillaged from starlight condensation, but not used there because we're a modular codebase, so lets pretend we did that
#define FULL_STARLIGHT 2
#define PARTIAL_STARLIGHT 1
#define NO_STARLIGHT 0

/atom/movable/proc/checktilestarlightdirectional(turf/turf_to_check, direction, starlight_max_range)
	if(direction == UP)
		turf_to_check = GET_TURF_ABOVE(turf_to_check)
		if(!turf_to_check)
			return NO_STARLIGHT
	var/area/area_to_check = get_area(turf_to_check)
	var/levels_of_glass = 0 // Since starlight condensation only works 2 tiles to the side anyways, it shouldn't work with like 100 z-levels of glass
	while(levels_of_glass <= starlight_max_range)
		// Outdoors covers lavaland and unroofed areas but with tiles under,
		// while space covers normal space and those caused by explosions,
		// if there is a floor tile when checking above, that means
		// a roof exists so the outdoors should only work downwards
		if(isspaceturf(turf_to_check) || (area_to_check.outdoors && direction == DOWN))
			if (levels_of_glass)
				return PARTIAL_STARLIGHT // Glass gives a penalty.
			return FULL_STARLIGHT // No glass = can activate fully.

		// Our turf is transparent, but it's NOT openspace - it's something like glass which reduces power
		if(istransparentturf(turf_to_check) && !(istype(turf_to_check, /turf/open/openspace)))
			levels_of_glass += 1

		// Our turf is transparent OR openspace - we can check higher or lower z-levels
		if(istransparentturf(turf_to_check) || istype(turf_to_check, /turf/open/openspace))
			// Check above or below us
			if(direction == UP)
				turf_to_check = GET_TURF_ABOVE(turf_to_check)
			else
				turf_to_check = GET_TURF_BELOW(turf_to_check)

			// If we found a turf above or below us,
			// then we can rerun the loop on the newly found turf / area
			// (Probably, with +1 to levels_of_glass)
			if(turf_to_check)
				area_to_check = get_area(turf_to_check)
				continue

			// If we didn't find a turf above or below us -
			// Checking below, we assume that space is below us (as we're standing on station)
			// Checking above, we check that the area is "outdoors" before assuming if it is space or not.
			else
				if(direction == DOWN || (direction == UP && area_to_check.outdoors))
					if (levels_of_glass)
						return PARTIAL_STARLIGHT
					return FULL_STARLIGHT

		return NO_STARLIGHT // Hit a non-space, Non-transparent turf - no starlight for you

/atom/movable/proc/checktilestarlight(turf/original_turf, satisfied_with_penalty, starlight_max_range)
	var/current_starlight_level = checktilestarlightdirectional(original_turf, DOWN, starlight_max_range)
	if(current_starlight_level == FULL_STARLIGHT)
		return current_starlight_level
	if(current_starlight_level && satisfied_with_penalty) // do not care if there is a +penalty or no
		return current_starlight_level
	var/starlight_level_from_above = checktilestarlightDirectional(original_turf, UP, starlight_max_range)
	if(starlight_level_from_above > current_starlight_level)
		return starlight_level_from_above
	else
		return current_starlight_level

/atom/movable/proc/checkstarlight(check_range)
	var/starlight_max_range = check_range
	var/turf/turf_of_target = get_turf(src)
	switch(checktilestarlight(turf_of_target, FALSE, starlight_max_range))
		if(PARTIAL_STARLIGHT)
			return PARTIAL_STARLIGHT
		if(FULL_STARLIGHT)
			return FULL_STARLIGHT
	for(var/turf/turf_to_check in view(src, starlight_max_range))
		if(checktilestarlight(turf_to_check, TRUE, starlight_max_range))
			return PARTIAL_STARLIGHT
	return NO_STARLIGHT
