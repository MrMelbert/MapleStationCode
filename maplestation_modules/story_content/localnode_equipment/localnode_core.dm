/* #Localnode's core.
* This is a special core item for the strange alien AI localnode.
* A character can talk as localnode when held, as this is a dual char.
* Coded by Constellado, made for Blacklist 897
*/

/obj/item/localnode
	name = "LocalNode#4248"
	desc = "A strange blue orb, humming with alien power and smelling strongly of ozone"
	icon = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode.dmi'
	icon_state = "localnode"
	lefthand_file = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode_inhand_lh.dmi'
	righthand_file = 'maplestation_modules/story_content/localnode_equipment/sprites/localnode_inhand_rh.dmi'
	inhand_icon_state = "localnode"
	var/item_chat_color = "#0e5807"
	var/voice_name = "LocalNode#4248"

/obj/item/localnode/attack_self(mob/user)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 35, TRUE)

/obj/item/localnode/talk_into(atom/movable/A, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/M = A
	if (istype(M))
		M.log_talk(message, LOG_SAY, tag="LocalNode")

	chat_color = item_chat_color// this feels cursed to call this very time but i cant get it to work
	say(message, language, sanitize = FALSE)
	return NOPASS

/obj/item/localnode/GetVoice()
	return voice_name
