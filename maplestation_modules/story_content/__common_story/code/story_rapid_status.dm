//Rapid status, a way to make a lot of changes to a mob quickly, albeit preset. Hopefully eventually replaced with JSON. Pretty much taken from the "make me tanky" menu
#define VV_STORY_RAPID_STATUS "story_rapid_status"

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_STORY_RAPID_STATUS, "Story Rapid Status")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()

	if(href_list[VV_STORY_RAPID_STATUS])
		if(!check_rights(R_SPAWN))
			return

		var/list/options = new()

		for(var/datum/story_rapid_status/status as anything in subtypesof(/datum/story_rapid_status))
			if(status.selectable)
				options += status.name
				options[status.name] += status

		var/result = tgui_input_list(usr, "Pick something. You can also cancel with \"Cancel\".", "Rapid Status", options + "Cancel")
		if(QDELETED(src) || !result || result == "Cancel")
			return
		var/datum/story_rapid_status/picked = options[result]
		picked = new picked()

		if(!picked)
			return
		message_admins("[key_name(usr)] has rapidly given [key_name(src)] the following preset: [result]")
		log_admin("[key_name(usr)] has rapidly given [key_name(src)] the following preset: [result]")

		picked.apply(selected = src)
