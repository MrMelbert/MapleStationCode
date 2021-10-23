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
 *	Bonus: If you are not connected to the server and someone examines you...
 *	an AFK timer is shown to the examiner, which displays how long you have been disconnected for.
 */

// Mob is the person being examined. User is the one doing the examining.
// Extension of /mob/living/carbon/human/examine().
/mob/living/carbon/human/examine(mob/user)
	. = ..()
	// Who's identity are we dealing with? In most cases it's the same as [src], but it could be disguised people, or null.
	var/datum/flavor_text/known_identity = get_visible_flavor(user)
	var/expanded_examine = ""

	if(known_identity)
		expanded_examine += known_identity.get_flavor_and_records_links(user)

	if(linked_flavor && user.client.holder && isAdminObserver(user))
		// Formatted output list of records.
		var/admin_line = ""

		if(linked_flavor.flavor_text)
			admin_line += "<a href='?src=[REF(linked_flavor)];flavor_text=1'>\[FLA\]</a>"
		if(linked_flavor.gen_records)
			admin_line += "<a href='?src=[REF(linked_flavor)];general_records=1'>\[GEN\]</a>"
		if(linked_flavor.sec_records)
			admin_line += "<a href='?src=[REF(linked_flavor)];security_records=1'>\[SEC\]</a>"
		if(linked_flavor.med_records)
			admin_line += "<a href='?src=[REF(linked_flavor)];medical_records=1'>\[MED\]</a>"
		if(linked_flavor.expl_info)
			admin_line += "<a href='?src=[REF(linked_flavor)];exploitable_info=1'>\[EXP\]</a>"

		if(admin_line)
			expanded_examine += "ADMIN EXAMINE: [ADMIN_LOOKUPFLW(src)] - [admin_line]\n"

	// if the mob doesn't have a client, show how long they've been disconnected for.
	if(!client && last_connection_time)
		var/formatted_afk_time = span_bold("[round((world.time - last_connection_time) / (60*60), 0.1)]")
		expanded_examine += span_italics("\n[p_theyve(TRUE)] been unresponsive for [formatted_afk_time] minute(s).\n")

	if(length(expanded_examine))
		expanded_examine = span_info(expanded_examine)
		expanded_examine += "*---------*\n"
		. += expanded_examine

// This isn't even an extension of examine_more this is the only definition for /human/examine_more, isn't that neat?
/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	var/datum/flavor_text/known_identity = get_visible_flavor(user)

	if(known_identity)
		. += span_info(known_identity.get_flavor_and_records_links(user, FALSE))
	else
		. += span_smallnoticeital("You can't make out any details of this individual.\n")
