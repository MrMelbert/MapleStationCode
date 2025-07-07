/mob/living/simple_animal/slime
	icon = 'maplestation_modules/icons/mob/simple/slimes.dmi'
	icon_state = "grey-baby"
	icon_dead = "grey-baby-dead"
	icon_living = "grey-baby"

/obj/effect/mob_spawn/corpse/slime
	icon_state = "grey-baby-dead"
	icon = 'maplestation_modules/icons/mob/simple/slimes.dmi'

/mob/living/simple_animal/slime/get_speech_sounds(sound_type)
	. = ..()
	switch(sound_type)
		if(SOUND_NORMAL)
			return string_assoc_list(list(
		'maplestation_modules/sound/voice/slime_1.ogg' = 80,
		'maplestation_modules/sound/voice/slime_2.ogg' = 80,
		'maplestation_modules/sound/voice/slime_3.ogg' = 80,
	))
		if(SOUND_QUESTION)
			return string_assoc_list(list(
		'maplestation_modules/sound/voice/slime_ask.ogg' = 80,
	))
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list(
		'maplestation_modules/sound/voice/slime_exclaim.ogg' = 80,
	))
