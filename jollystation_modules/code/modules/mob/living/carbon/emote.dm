//Modular emote file.

/datum/emote/living/carbon/slow_clap
	key = "clap_slow"
	message = "slowly claps their hands."
	key_third_person "slowly claps"
	muzzle_ignore = TRUE
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE
	audio_cooldown = 7 SECONDS //Longer cooldown due to the "slightly longer" audio files
	vary = TRUE

/datum/emote/living/carbon/slow_clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return pick('jollystation_modules/sound/misc/slowclap1.ogg',
							'jollystation_modules/sound/misc/slowclap2.ogg',
							'jollystation_modules/sound/misc/slowclap4.ogg')

