// -- Extra human level procc etensions. --
/mob/living/carbon/human/Topic(href, href_list)
	. = ..()
	if(href_list["flavor_text"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s flavor text", "[name]'s Flavor Text (expanded)", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s flavor text (expanded)", replacetext(linked_flavor.flavor_text, "\n", "<BR>")))
			popup.open()
			return

	if(href_list["general_records"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s gen rec", "[name]'s General Record", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s general records", replacetext(linked_flavor.gen_records, "\n", "<BR>")))
			popup.open()
			return

	if(href_list["security_records"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s sec rec", "[name]'s Security Record", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s security records", replacetext(linked_flavor.sec_records, "\n", "<BR>")))
			popup.open()
			return

	if(href_list["medical_records"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s med rec", "[name]'s Medical Record", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s medical records", replacetext(linked_flavor.med_records, "\n", "<BR>")))
			popup.open()
			return

	if(href_list["exploitable_info"])
		if(linked_flavor)
			var/datum/browser/popup = new(usr, "[name]'s exp info", "[name]'s Exploitable Info", 500, 200)
			popup.set_content(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", "[name]'s exploitable information", replacetext(linked_flavor.expl_info, "\n", "<BR>")))
			popup.open()
			return
