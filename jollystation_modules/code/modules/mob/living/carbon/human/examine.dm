/// -- Extension of examine, examine_more, and flavortext code. --

/*
 *	Flavor text and Personal Records On Examine INS AND OUTS (implementation by mrmelbert)
 *	- Admin ghosts, when examining, are given a list of buttons for all the records of a player.
 *		(This can probably be moved to examine_more if it's too annoying)
 *	- When you examine yourself, you will always see your own records and flavor text, no matter what.
 *	- When another person examines you, the following happens:
 *		> If your face is covered (by helmet or mask), they will not see your favor text or records, unless you're wearing your ID.
 *		> If you are wearing another player's ID (In disguise as another active player), they will see the other player's records and flavor instead.
 *		> If you are not wearing another player's ID (if you are unknown, or wearing a non-player's ID), no records or flavor text will show up as if none were set.
 *		> If you do not have any flavor text or records set, nothing special happens. The examine is normal.
 *
 *	- Flavor text is displayed to other players without any pre-requisites. It displays [EXAMINE_FLAVOR_MAX_DISPLAYED] (65 by default) characters before being trimmed.
 *	- Exploitive information is displayed via link to antagonists with the proper flags.
 *	- Security records are displayed via link to people with sechuds that have security access.
 *	- Medical records are displayed via link to people with medhuds that have medical access.
 *
 *	- To actually access the additional records (if you have the allowance to)...
 *		You need to double examine (examine_more) the person, which will display the buttons for each record.
 *		Double-examining wil also print out the full flavor text of the person being examined in addition to links to records.
 *
 *	- Bonus: If you are not connected to the server and someone examines you...
 *		Instead of showing flavor text or records (as they are saved on the client)
 *		an AFK timer is shown to the examiner, which displays how long you have been disconnected for.
 */

// Mob is the person being examined. User is the one doing the examining.
// Extension of /mob/living/carbon/human/examine().
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	// The string we return, formatted.
	var/expanded_examine = ""
	// Who's identity are we dealing with? In most cases it's the same as [src], but it could be disguised people, or null.
	var/mob/living/carbon/human/known_identity = get_visible_identity(user)

	if(client)
		// Admins can view all records.
		if(user.client.holder && isAdminObserver(user))
			// Formatted output list of records.
			var/list/line = list()

			if(client.prefs.flavor_text)
				line += "<a href='?src=[REF(src)];flavor_text=1'>\[FLA\]</a>"
			if(client.prefs.general_records)
				line += "<a href='?src=[REF(src)];general_records=1'>\[GEN\]</a>"
			if(client.prefs.security_records)
				line += "<a href='?src=[REF(src)];security_records=1'>\[SEC\]</a>"
			if(client.prefs.medical_records)
				line += "<a href='?src=[REF(src)];medical_records=1'>\[MED\]</a>"
			if(client.prefs.exploitable_info)
				line += "<a href='?src=[REF(src)];exploitable_info=1'>\[EXP\]</a>"

			if(line.len)
				expanded_examine += "[ADMIN_LOOKUPFLW(src)] - "
				expanded_examine += line.Join()
				expanded_examine += "\n"

		if(!known_identity)
			expanded_examine += span_smallnoticeital("You can't make out any details of this individual.\n")

		else if(known_identity.client)
			expanded_examine += known_identity.get_basic_flavor_and_records(user)

	// if the mob doesn't have a client, show how long they've been disconnected for.
	else if(last_connection_time)
		var/formatted_afk_time = span_bold(round((world.time - last_connection_time) / (60*60), 0.1))
		expanded_examine += span_info(span_italics("[p_theyve(TRUE)] been unresponsive for [formatted_afk_time] minute(s).\n"))

	if(length(expanded_examine) > 0)
		expanded_examine = span_info(expanded_examine)
		expanded_examine += "*---------*\n"
		. += expanded_examine

// This isn't even an extension of examine_more this is the only definition for /human/examine_more, isn't that neat?
/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	// Who's identity are we dealing with? In most cases it's the same as [src], but it could be disguised people.
	var/mob/living/carbon/human/known_identity = get_visible_identity(user)
	if(client && known_identity?.client)
		. += span_info("[known_identity.get_flavor_text(FALSE)][known_identity.get_records_text(user)]")
