// -- Extra human level procc etensions. --
/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["flavor_text"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s flavor text", "[name]'s Flavor Text (expanded)", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s flavor text (expanded)", replacetext(linked_flavor.flavor_text, "\n", "<BR>")))
			popup.open()
			return

	if(href_list["exploitable_info"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s exp info", "[name]'s Exploitable Info", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s exploitable information", replacetext(linked_flavor.expl_info, "\n", "<BR>")))
			popup.open()
			return

/mob/living/carbon/human/update_ID_card()
	. = ..()
	var/image/holder = hud_list[ID_HUD]
	var/obj/item/card/id/id = wear_id?.GetID()
	if(!id?.trim)
		holder.icon = 'icons/mob/huds/hud.dmi'
		return

	holder.icon = id.trim.sechud_icon
