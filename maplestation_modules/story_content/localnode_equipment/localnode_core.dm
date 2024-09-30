/* #Localnode's core.
* This is a special core item for the strange alien AI localnode.
* A character can talk as localnode when held, as this is a dual char.
* Coded by Constellado, made for Blacklist 897
*/

/obj/item/localnode
	name = "LocalNode#4248"
	desc = "It looks like a basketball sized blue orb, however it looks like it had bits broken off with a hammer a few times before covering it with superglue and rolling it in a box of computer parts"
	icon = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode.dmi'
	icon_state = "localnode"
	lefthand_file = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode_inhand_lh.dmi'
	righthand_file = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode_inhand_rh.dmi'
	inhand_icon_state = "localnode"
	var/voice_name = "LocalNode#4248"

/obj/item/toy/dummy/localnode/attack_self(mob/user)
	say("HEY, STOP THAT!", language, sanitize = FALSE)
	playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, TRUE)
	return

/obj/item/toy/dummy/localnode/talk_into(atom/movable/A, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/M = A
	if (istype(M))
		M.log_talk(message, LOG_SAY, tag="LocalNode")

	say(message, language, sanitize = FALSE)
	return NOPASS

/obj/item/toy/dummy/localnode/GetVoice()
	return voice_name
