/// -- Typing indicator wrappers, for the say hotkey and the emote hotkey. --
// Typing indicator ported from Russstation, adapted and updated for use.

/mob
	var/active_typing_indicator = null

/mob/verb/say_wrapper()
	set name = ".say"
	set hidden = TRUE

	var/image/typing_indicator = active_typing_indicator
	if(!typing_indicator)
		if(isliving(src)) //only living mobs have the bubble_icon var
			var/mob/living/living_src = src
			typing_indicator = image('icons/mob/talk.dmi', src, living_src.bubble_icon + "0", FLY_LAYER) //get unique speech bubble icons for different species
		else
			typing_indicator = image('icons/mob/talk.dmi', src, "default0", FLY_LAYER)

		typing_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

		if(ishuman(src))
			var/mob/living/carbon/human/human_src = src
			if(human_src.dna.check_mutation(/datum/mutation/human/mute) || human_src.silent) //Check for mute or silent, remove the overlay if true
				QDEL_NULL(typing_indicator)

		if(stat != CONSCIOUS || is_muzzled())
			QDEL_NULL(typing_indicator)

		if(typing_indicator)
			active_typing_indicator = typing_indicator
			overlays += typing_indicator

	var/message = input("", "Say \"text\"") as null|text

	if(typing_indicator)
		overlays -= typing_indicator
		active_typing_indicator = null
		qdel(typing_indicator)

	say_verb(message)

/mob/verb/me_wrapper()
	set name = ".me"
	set hidden = TRUE

	var/image/typing_indicator = active_typing_indicator
	if(!typing_indicator)
		typing_indicator = image('maplestation_modules/icons/mob/talk.dmi', src, "emoting", FLY_LAYER)
		typing_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

		if(stat != CONSCIOUS)
			QDEL_NULL(typing_indicator)

		if(typing_indicator)
			active_typing_indicator = typing_indicator
			overlays += typing_indicator

	var/message = input("", "Me \"text\"") as null|text

	if(typing_indicator)
		overlays -= typing_indicator
		active_typing_indicator = null
		qdel(typing_indicator)

	me_verb(message)
