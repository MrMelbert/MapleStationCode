/datum/wound/blunt
	name = "Blunt Wound"
	sound_effect = 'sound/effects/wounds/crack1.ogg'

/datum/wound/blunt/wound_injury(datum/wound/old_wound, attack_direction)
	if(!old_wound && limb.current_gauze && (wound_flags & ACCEPTS_GAUZE))
		// oops your bone injury knocked off your gauze, gotta re-apply it
		limb.remove_gauze(limb.drop_location())

	return ..()
