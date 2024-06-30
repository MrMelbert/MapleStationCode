//Just some admin stuff for view variables
/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_LOAD_LOADOUT, "Load Loadout")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_LOAD_LOADOUT])
		if(!check_rights(R_SPAWN))
			return
		if(!client)
			to_chat(usr, span_warning("That mob has no client and thus no loadout, dingus."))
			return
		var/used_outfit
		if(tgui_alert(usr, "Override worn items?.", "Loadout override", list("Yes", "No")) == "Yes")
			used_outfit = new /datum/outfit/varedit
			copy_to_outfit(used_outfit) //Use a copy of the original outfit, to then override
		else
			used_outfit = new /datum/outfit/player_loadout
		equip_outfit_and_loadout(used_outfit, client?.prefs, FALSE)
		to_chat(usr, span_boldnotice("Equipped [src] with [p_their()] loadout."))
