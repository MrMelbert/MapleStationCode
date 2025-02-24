/// -- LOOC verb --

/// For admin disabling LOOC
GLOBAL_VAR_INIT(looc_allowed, TRUE)

/// The LOOC verb
/client/verb/looc(msg as text)
	set name = "LOOC"
	set category = "OOC"

	if(!mob)
		return

	//Are guest accounts even real? I don't think guests exist in our usecase and it just makes testing harder
	//if(IsGuestKey(key))
	//	to_chat(src, "<span class='danger'>Guests may not use LOOC.</span>")
	//	return

	// Run through some checks for non-admins
	if(!holder)
		if(!GLOB.ooc_allowed) // If OOC is disabled LOOC probably should be, too
			to_chat(src, span_danger("All OOC is globally muted."))
			return
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted."))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD))
			to_chat(src, span_danger("LOOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("You cannot use LOOC (muted)."))
			return
	else
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted, but you are bypassing it as an admin."))

	// Really?
	if(!SSticker.HasRoundStarted())
		to_chat(src, span_danger("The round hasn't started yet!"))
		return
	if(isnewplayer(mob))
		to_chat(src, span_danger("You're not in game to broadcast LOOC anywhere!"))
		return

	// Check for people with OOC muted
	if(!(prefs.toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC / LOOC muted."))
		return

	// Check for people banned from OOC
	if(is_banned_from(ckey, "OOC"))
		to_chat(src, span_danger("You have been banned from LOOC."))
		return

	if(QDELETED(src))
		return

	msg = trim(sanitize(msg), MAX_MESSAGE_LEN)
	if(!msg)
		return

	mob.log_talk(msg, LOG_OOC)
	msg = emoji_parse(msg)

	// Spam checks for non-admins
	if(!holder)
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_bold("Advertising other servers is not allowed."))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(mob.stat == DEAD)
			to_chat(src, span_warning("Reminder: Living players cannot see the LOOC messages of ghosts."))

	/// Source mob of the message.
	var/mob/source = mob.get_looc_source()
	/// Everyone that can hear the message.
	var/list/heard = get_hearers_in_view(7, source)

	/// The ckey of the source mob
	var/display_name = key
	// If we're an admin and are deadminned/stealminned, use that key
	if(holder?.fakekey)
		display_name = holder.fakekey
	// Unless we're dead, use the source mob's shown name
	if(mob.stat != DEAD)
		display_name = mob.name

	// Now let's find all the people we send the LOOC to
	for(var/client/target in GLOB.clients)
		// Only bother checking for people with OOC enabled
		if(!(target.prefs.toggles & CHAT_OOC))
			continue

		/// What to prefix their display name
		var/prefix = ""
		/// Whether or not to send this target a message at the end
		var/send = FALSE
		/// Whether we're in close range or not
		var/close = FALSE
		/// Admin-logging
		var/display_admin = ""

		// If our target is in hearing range, then send them the message
		if(target.mob in heard)
			send = TRUE
			close = TRUE
			if(isAI(target.mob))
				prefix = " (Core)"
		// ...Or if they're an AI eye in range
		else if(isAI(target.mob))
			var/mob/living/silicon/ai/A = target.mob
			if(A.eyeobj in hearers(7, source))
				send = TRUE
				close = TRUE
				prefix = " (Eye)"

		// Only other ghosts can hear non-admin ghost LOOC, but everyone can hear adminghost LOOC
		if(mob.stat == DEAD)
			prefix = " (Dead)"
			if(check_rights_for(src, R_ADMIN))
				prefix = " (Admin)"
			else if(target.mob.stat != DEAD)
				send = FALSE

		// Of course, admins can hear all LOOC globally
		if(check_rights_for(target, R_ADMIN))
			if(!send)
				prefix += " (Relayed)"
			if(target != src)
				display_admin = "([ADMIN_LOOKUPFLW(mob)])"
			send = TRUE

		if(!send)
			continue

		var/message_contents = span_message(msg)
		to_chat(target, span_looc(span_bold("<span class='prefix'><font color='[LOOC_PREFIX_COLOR]'>LOOC[prefix]: </font></span><font color='[LOOC_SPAN_COLOR]'><EM>[display_admin ? "[display_admin]" : "[display_name]"]:</EM> [message_contents]</span></font>")))
		// Give a runechat message if
		// A. it's not something weird like an AI eye
		// B. it's nearby (not relayed)
		// C. target has runechat enabled
		if(target.mob && source == mob && close && source.runechat_prefs_check(target.mob))
			// EMOTE is close enough. We don't want it to treat the raw message with languages.
			// I wish it didn't include the asterisk but it's modular this way.
			target.mob.create_chat_message(source, raw_message = "(LOOC: [msg])", runechat_flags = EMOTE_MESSAGE)

/// Getter so some mobs can redirect their "message source" to other mobs, see AI for example
/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src

/// Admin verb for toggling LOOC
/datum/admins/proc/togglelooc()
	set category = "Server"
	set name = "Toggle LOOC"

	toggle_looc()
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle_local", 1, list("Toggle LOOC", "[GLOB.looc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! //I did

/// Global proc to toggle LOOC
/proc/toggle_looc()
	GLOB.looc_allowed = !GLOB.looc_allowed
	to_chat(world, span_bold("LOOC has been globally [GLOB.looc_allowed ? "enabled" : "disabled"]."))
