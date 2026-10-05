// used for additional stuff on mutant bodypart overlays

// used by "ORGAN_COLOR_MUTANT_OVERRIDE" but can also be used by other organs' color overrides
/datum/bodypart_overlay/mutant/proc/mutant_override_color(obj/item/bodypart/bodypart_owner)
	// use body color if we should be mutant colored
	if(isnull(bodypart_owner.owner) || HAS_TRAIT(bodypart_owner.owner, TRAIT_MUTANT_COLORS) || HAS_TRAIT(bodypart_owner, TRAIT_MUTANT_COLORS))
		return bodypart_owner.draw_color
	// first try to use forced color - for non-mutant-colored species, like piscinids
	// then default to body color - though this will probably be skin color, some other forced color, or pure white
	return bodypart_owner.owner.dna.features["forced_mut_color"] || bodypart_owner.draw_color

// todo: figure out how on god's green earth functional wings even get their color, also refactor that part of the code and push it to TG
/datum/bodypart_overlay/mutant/wings/functional/mutant_color
	color_source = ORGAN_COLOR_MUTANT_OVERRIDE
