// the many spells that are used to turn into versions of a werewolf

/datum/action/cooldown/spell/shapeshift/werewolf // use this for the simplemob forms, like standard wolves
	name = "Lycanthropic Shift"
	desc = "Channel the wolf within yourself and turn into one of your possible forms. \
		Be careful, for you can still die within this form."
	invocation = "RAAAAAAAAWR!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	possible_shapes = list(
		/mob/living/simple_animal/hostile/asteroid/wolf, // room to add other forms
	)
