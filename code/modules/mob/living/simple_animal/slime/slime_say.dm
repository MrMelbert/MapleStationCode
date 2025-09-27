/mob/living/simple_animal/slime/Hear(atom/movable/speaker, message_langs, raw_message, radio_freq, spans, list/message_mods = list(), message_range)
	. = ..()
	if(speaker == src || radio_freq || stat || !(speaker in Friends))
		return

	speech_buffer = list()
	speech_buffer += speaker
	speech_buffer += LOWER_TEXT(raw_message)
