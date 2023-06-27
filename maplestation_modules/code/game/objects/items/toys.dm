// Let users talk through all toys instead of only ventriloquist dummy and decapitated heads.

/obj/item/toy/talk_into(atom/movable/A, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/M = A
	if (istype(M))
		M.log_talk(message, LOG_SAY, tag="toy")

	say(message, language, sanitize = FALSE)
	return NOPASS

/obj/item/toy/GetVoice()
	return name
