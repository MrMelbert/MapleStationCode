/obj/item/clothing/head/beret/frenchberet
	name = "french beret"
	desc = "A quality beret, infused with the aroma of chain-smoking, wine-swilling Parisians. You feel less inclined to engage in military conflict, for some reason."
	flags_1 = NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/head/beret/frenchberet/equipped(mob/M, slot, initial)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
		ADD_TRAIT(M, TRAIT_GARLIC_BREATH, type)
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)
		REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/beret/frenchberet/dropped(mob/M, silent)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)
	REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/beret/frenchberet/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/french_words = strings("french_replacement.json", "french")

		for(var/key in french_words)
			var/value = french_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")

		if(prob(3))
			message += pick(" Honh honh honh!"," Honh!"," Zut Alors!")
	speech_args[SPEECH_MESSAGE] = trim(message)
