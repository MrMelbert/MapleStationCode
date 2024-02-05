/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard Nanotrasen Space Stations."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "newspaper"
	inhand_icon_state = "newspaper"
	lefthand_file = 'icons/mob/inhands/items/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/books_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("baps")
	attack_verb_simple = list("bap")
	resistance_flags = FLAMMABLE
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/scribble=""
	var/scribble_page = null
	var/wantedAuthor
	var/wantedCriminal
	var/wantedBody
	var/wantedPhoto
	var/creation_time
	///The page in the newspaper currently being read. 0 is the title screen while the last is the security screen.
	var/current_page = 0
	///The currently scribbled text written in scribble_page
	var/scribble_text
	///The page with something scribbled on it, can only have one at a time.
	var/scribble_page

	///Stored information of the wanted criminal's name, if one existed at the time of creation.
	var/saved_wanted_criminal
	///Stored information of the wanted criminal's description, if one existed at the time of creation.
	var/saved_wanted_body
	///Stored icon of the wanted criminal, if one existed at the time of creation.
	var/icon/saved_wanted_icon

/obj/item/newspaper/Initialize(mapload)
	. = ..()
	register_context()
	AddComponent(\
		/datum/component/two_handed,\
		wield_callback = CALLBACK(src, PROC_REF(on_wielded)),\
		unwield_callback = CALLBACK(src, PROC_REF(on_unwielded)),\
	)
	creation_time = GLOB.news_network.last_action
	for(var/datum/feed_channel/iterated_feed_channel in GLOB.news_network.network_channels)
		news_content += iterated_feed_channel

	if(!GLOB.news_network.wanted_issue.active)
		return
	saved_wanted_criminal = GLOB.news_network.wanted_issue.criminal
	saved_wanted_body = GLOB.news_network.wanted_issue.body
	if(GLOB.news_network.wanted_issue.img)
		saved_wanted_icon = GLOB.news_network.wanted_issue.img

/obj/item/newspaper/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(held_item)
		if(IS_WRITING_UTENSIL(held_item))
			context[SCREENTIP_CONTEXT_LMB] = "Scribble"
			return CONTEXTUAL_SCREENTIP_SET
		if(held_item.get_temperature())
			context[SCREENTIP_CONTEXT_LMB] = "Burn"
			return CONTEXTUAL_SCREENTIP_SET

/obj/item/newspaper/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is focusing intently on [src]! It looks like [user.p_theyre()] trying to commit sudoku... until [user.p_their()] eyes light up with realization!"))
	user.say(";JOURNALISM IS MY CALLING! EVERYBODY APPRECIATES UNBIASED REPORTI-GLORF", forced="newspaper suicide")
	var/mob/living/carbon/human/H = user
	var/obj/W = new /obj/item/reagent_containers/cup/glass/bottle/whiskey(H.loc)
	playsound(H.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)
	W.reagents.trans_to(H, W.reagents.total_volume, transferred_by = user)
	user.visible_message(span_suicide("[user] downs the contents of [W.name] in one gulp! Shoulda stuck to sudoku!"))
	return TOXLOSS

/obj/item/newspaper/attack_self(mob/user)
	if(!istype(user) || !user.can_read(src))
		return
	var/dat
	pages = 0
	switch(screen)
		if(0) //Cover
			dat+="<DIV ALIGN='center'><B><FONT SIZE=6>The Griffon</FONT></B></div>"
			dat+="<DIV ALIGN='center'><FONT SIZE=2>Nanotrasen-standard newspaper, for use on Nanotrasen? Space Facilities</FONT></div><HR>"
			if(!length(news_content))
				if(wantedAuthor)
					dat+="Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR></ul>"
				else
					dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
			else
				dat+="Contents:<BR><ul>"
				for(var/datum/feed_channel/NP in news_content)
					pages++
				if(wantedAuthor)
					dat+="<B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\[page [pages+2]\]</FONT><BR>"
				var/temp_page=0
				for(var/datum/feed_channel/NP in news_content)
					temp_page++
					dat+="<B>[NP.channel_name]</B> <FONT SIZE=2>\[page [temp_page+1]\]</FONT><BR>"
				dat+="</ul>"
			if(scribble_page == curr_page)
				dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
			dat+= "<HR><DIV STYLE='float:right;'><A href='?src=[REF(src)];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='?src=[REF(user)];mach_close=newspaper_main'>Done reading</A></DIV>"
		if(1) // X channel pages inbetween.
			for(var/datum/feed_channel/NP in news_content)
				pages++
			var/datum/feed_channel/C = news_content[curr_page]
			dat += "<FONT SIZE=4><B>[C.channel_name]</B></FONT><FONT SIZE=1> \[created by: <FONT COLOR='maroon'>[C.return_author(notContent(C.author_censor_time))]</FONT>\]</FONT><BR><BR>"
			if(notContent(C.D_class_censor_time))
				dat+="This channel was deemed dangerous to the general welfare of the station and therefore marked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printing."
			else
				if(!length(C.messages))
					dat+="No Feed stories stem from this channel..."
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in C.messages)
						if(MESSAGE.creation_time > creation_time)
							if(i == 0)
								dat+="No Feed stories stem from this channel..."
							break
						if(i == 0)
							dat+="<ul>"
						i++
						dat+="-[MESSAGE.return_body(notContent(MESSAGE.body_censor_time))] <BR>"
						if(MESSAGE.img)
							user << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.return_author(notContent(MESSAGE.author_censor_time))]</FONT>\]</FONT><BR><BR>"
					dat+="</ul>"
			if(scribble_page == curr_page)
				dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
			dat+= "<BR><HR><DIV STYLE='float:left;'><A href='?src=[REF(src)];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='?src=[REF(src)];next_page=1'>Next Page</A></DIV>"
		if(2) //Last page
			for(var/datum/feed_channel/NP in news_content)
				pages++
			if(wantedAuthor != null)
				dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT SIZE></DIV><BR><BR>"
				dat+="<B>Criminal name</B>: <FONT COLOR='maroon'>[wantedCriminal]</FONT><BR>"
				dat+="<B>Description</B>: [wantedBody]<BR>"
				dat+="<B>Photo:</B>: "
				if(wantedPhoto)
					user << browse_rsc(wantedPhoto, "tmp_photow.png")
					dat+="<BR><img src='tmp_photow.png' width = '180'>"
				else
					dat+="None"
			else
				dat+="<I>Apart from some uninteresting classified ads, there's nothing on this page...</I>"
			if(scribble_page == curr_page)
				dat+="<BR><I>There is a small scribble near the end of this page... It reads: \"[scribble]\"</I>"
			dat+= "<HR><DIV STYLE='float:left;'><A href='?src=[REF(src)];prev_page=1'>Previous Page</A></DIV>"
	dat+="<BR><HR><div align='center'>[curr_page+1]</div>"
	user << browse(dat, "window=newspaper_main;size=300x400")
	onclose(user, "newspaper_main")

/obj/item/newspaper/proc/notContent(list/L)
	if(!L.len)
		return FALSE
	for(var/i=L.len;i>0;i--)
		var/num = abs(L[i])
		if(creation_time <= num)
			continue
		else
			if(L[i] > 0)
				return TRUE
			else
				return FALSE
	return FALSE

/// Called when you start reading the paper with both hands
/obj/item/newspaper/proc/on_wielded(obj/item/source, mob/user)
	RegisterSignal(user, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(holder_updated_overlays))
	RegisterSignal(user, COMSIG_HUMAN_GET_VISIBLE_NAME, PROC_REF(holder_checked_name))
	user.update_appearance(UPDATE_OVERLAYS)
	user.name = user.get_visible_name()

/// Called when you stop doing that
/obj/item/newspaper/proc/on_unwielded(obj/item/source, mob/user)
	UnregisterSignal(user, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_HUMAN_GET_VISIBLE_NAME))
	user.update_appearance(UPDATE_OVERLAYS)
	user.name = user.get_visible_name()

/// Called when we're being read and overlays are updated, we should show a big newspaper over the reader
/obj/item/newspaper/proc/holder_updated_overlays(atom/reader, list/overlays)
	SIGNAL_HANDLER
	overlays += mutable_appearance(icon, "newspaper_held_over", ABOVE_MOB_LAYER)
	overlays += mutable_appearance(icon, "newspaper_held_under", BELOW_MOB_LAYER)

/// Called when someone tries to figure out what our identity is, but they can't see it because of the newspaper
/obj/item/newspaper/proc/holder_checked_name(mob/living/carbon/human/source, list/identity)
	SIGNAL_HANDLER
	identity[VISIBLE_NAME_FACE] = ""
	identity[VISIBLE_NAME_ID] = ""

/obj/item/newspaper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(ui)
		return
	ui = new(user, src, "Newspaper", name)
	ui.open()

/obj/item/newspaper/attackby(obj/item/W, mob/living/user, params)
	if(burn_paper_product_attackby_check(W, user))
		return

	if(istype(W, /obj/item/pen))
		if(!user.can_write(W))
			return
		if(scribble_page == curr_page)
			to_chat(user, span_warning("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
		else
			var/s = tgui_input_text(user, "Write something", "Newspaper")
			if (!s)
				return
			if(!user.can_perform_action(src))
				return
			scribble_page = curr_page
			scribble = s
			attack_self(user)
			add_fingerprint(user)
	else
		return ..()
