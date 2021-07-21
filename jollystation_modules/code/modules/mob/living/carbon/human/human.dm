// -- Extra human level procc etensions. --
/mob/living/carbon/human
	var/temp_disease_counter = 0

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

//Extends body temp datum
/datum/species/handle_body_temperature(mob/living/carbon/human/humi, delta_time, times_fired)
	. = ..()
	if(humi.bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT && !HAS_TRAIT(humi, TRAIT_RESISTHEAT))
		switch(humi.bodytemperature)
			if(0 to 460)
				humi.temp_disease_counter += 1
			if(461 to 700)
				humi.temp_disease_counter += 2
			else
				humi.temp_disease_counter += 3
		if(humi.temp_disease_counter >= DISEASE_HYPERTHERMIA_MIN)
			var/datum/disease/new_hyperthermia = new /datum/disease/hyperthermia()
			humi.ForceContractDisease(new_hyperthermia, FALSE, TRUE)
	else if (humi.bodytemperature < BODYTEMP_COLD_DAMAGE_LIMIT && !HAS_TRAIT(humi, TRAIT_RESISTCOLD))
		if(humi.temp_disease_counter <= DISEASE_HYPOTHERMIA_MIN)
			switch(humi.bodytemperature)
				if(201 to bodytemp_cold_damage_limit)
					humi.temp_disease_counter -=1
				if(120 to 200)
					humi.temp_disease_counter -=2
				else
					humi.temp_disease_counter -=3
		if(humi.temp_disease_counter <= DISEASE_HYPOTHERMIA_MIN)
			var/datum/disease/new_hypothermia = new /datum/disease/hypothermia()
			humi.ForceContractDisease(new_hypothermia, FALSE, TRUE)
