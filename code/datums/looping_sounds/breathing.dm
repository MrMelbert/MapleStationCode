/datum/looping_sound/breathing
	mid_sounds = 'sound/voice/breathing.ogg'
	//Calculated this by using the average breathing time of an adult (12 to 20 per minute, which on average is 16 per minute)
	mid_length = 3.75 SECONDS
	mid_length_vary = 0.2 SECONDS
	//spess station-
	volume = 13
	pressure_affected = FALSE

/datum/looping_sound/breathing/start(on_behalf_of)
	var/mob/living/carbon/breather = on_behalf_of || parent
	if(!breather.client?.prefs?.read_preference(/datum/preference/toggle/sound_breathing))
		return
	return ..()
