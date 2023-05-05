// -- Module emotes. --
/datum/emote/living/wince
	key = "wince"
	key_third_person = "winces"
	message = "winces."
	stat_allowed = SOFT_CRIT

/datum/emote/living/inhale_s
	key = "inhale_s"
	message = "inhales sharply."
	stat_allowed = SOFT_CRIT

/datum/emote/living/exhale_s
	key = "exhale_s"
	message = "exhales sharply."
	stat_allowed = SOFT_CRIT

/datum/emote/living/blush/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && ishuman(user)) // Give them a visual blush effect if they're human
		var/mob/living/carbon/human/human_user = user
		ADD_TRAIT(human_user, TRAIT_BLUSHING, "[type]")
		playsound(user,'maplestation_modules/sound/emote/blush.ogg',80)
		human_user.update_body_parts()
