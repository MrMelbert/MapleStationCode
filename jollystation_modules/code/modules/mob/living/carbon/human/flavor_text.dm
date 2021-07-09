// -- Flavor text datum stuff. --
/// Global list of all flavor texts we have generated. Associated list of [mob name] to [datum ref]
GLOBAL_LIST_EMPTY(flavor_texts)

/*
 * Go through all clients with living mobs and generate flavor text datums for them.
 */
/proc/populate_flavor_texts()
	for(var/client/found_client as anything in GLOB.clients)
		if(isliving(found_client.mob))
			add_client_flavor_text(found_client)

/*
 * Create a flavor text datum for [added_client].
 */
/proc/add_client_flavor_text(client/added_client)
	if(!added_client.prefs)
		return FALSE
	if(!added_client.prefs.flavor_text)
		return FALSE
	if(!iscarbon(added_client.mob))
		return FALSE

	var/mob/living/carbon/added_mob = added_client.mob
	if(!GLOB.flavor_texts[added_mob.real_name])
		var/datum/flavor_text/found_text = new /datum/flavor_text(added_client)
		GLOB.flavor_texts[added_mob.real_name] = found_text
		added_mob.linked_flavor = found_text

	return TRUE

/// We generate all our flavor texts at the end of setup.
/datum/controller/subsystem/ticker/setup()
	. = ..()
	if(!.)
		return FALSE

	populate_flavor_texts()

/// Flavor text define for carbons.
/mob/living/carbon
	/// The flavor text linked to our carbon.
	var/datum/flavor_text/linked_flavor

/mob/living/carbon/Destroy()
	linked_flavor = null // We should never QDEL flavor text datums.
	return ..()

/// The actual flavor text datum. This should never be qdeleted - just leave it floating in the global list.
/datum/flavor_text
	/// The client that owns this flavor text.
	var/client/owner
	/// The name associated with this flavor text.
	var/linked_name
	/// The species associated with this flavor text.
	var/linked_species
	/// The actual flavor text.
	var/flavor_text
	/// General records associated
	var/gen_records
	/// Medical records associated
	var/med_records
	/// Security records associated
	var/sec_records
	/// Exploitable info associated
	var/expl_info

/datum/flavor_text/New(client/linked_client)
	owner = linked_client
	linked_name = linked_client.prefs.real_name
	linked_species = linked_client.prefs.pref_species.id

	flavor_text = linked_client.prefs.flavor_text
	gen_records = linked_client.prefs.general_records
	med_records = linked_client.prefs.medical_records
	sec_records = linked_client.prefs.security_records
	expl_info = linked_client.prefs.exploitable_info

/*
 * Get the flavor text formatted.
 *
 * examiner - who's POV we're gettting this flavor text from
 * shorten - whether to cut it off at [EXAMINE_FLAVOR_MAX_DISPLAYED]
 *
 * returns a string
 */
/datum/flavor_text/proc/get_flavor_text(mob/living/carbon/human/examiner, shorten = TRUE)
	. = flavor_text

	if(shorten && length(.) > EXAMINE_FLAVOR_MAX_DISPLAYED)
		. = TextPreview(., EXAMINE_FLAVOR_MAX_DISPLAYED)
		. += " <a href='?src=[REF(src)];flavor_text=1'>\[More\]</a>"

	if(.)
		. += "\n"
		. = span_italics(.)

/*
 * Get the href buttons for all the mob's records, formatted.
 *
 * examiner - who's POV we're gettting the records from
 *
 * returns a string
 */
/datum/flavor_text/proc/get_records_text(mob/living/carbon/human/examiner)
	if(!examiner)
		return

	. = ""

	// Antagonists can see exploitable info.
	if(examiner.mind?.antag_datums && expl_info)
		for(var/datum/antagonist/antag_datum as anything in examiner.mind.antag_datums)
			if(antag_datum.antag_flags & CAN_SEE_EXPOITABLE_INFO)
				. += "<a href='?src=[REF(src)];exploitable_info=1'>\[Exploitable Info\]</a>"
				break

	// Medhuds can see medical records.
	if(med_records && examiner.check_med_hud_and_access())
		. += "<a href='?src=[REF(src)];medical_records=1'>\[Past Medical Records\]</a>"
	// Sechuds can see security records.
	if(sec_records && examiner.check_sec_hud_and_access())
		. += "<a href='?src=[REF(src)];security_records=1'>\[Past Security Records\]</a>"
	// General records aren't seen normally, but i'm leaving this here for if it is implemented.
	//if(gen_records)
	//	. += "<a href='?src=[REF(src)];general_records=1'>\[General Records\]</a>"

	if(.)
		. += "\n"

/*
 * All-In-One proc that gets the flavor text and record hrefs and formats it into one message.
 *
 * examiner - who's POV we're gettting this flavor text from
 * shorten - whether to cut it off at [EXAMINE_FLAVOR_MAX_DISPLAYED]
 *
 * returns a string
 */
/datum/flavor_text/proc/get_flavor_and_records_links(mob/living/carbon/human/examiner, shorten = TRUE)
	if(!examiner)
		CRASH("get_records_text() called without a user argument - proc is not implemented for a null examiner")

	. = ""

	// Whether or not we would have additional info on `examine_more()`.
	var/has_additional_info

	// If the client has flavor text set.
	if(flavor_text)
		var/found_flavor_text = get_flavor_text(shorten)
		. += found_flavor_text
		if(length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
			has_additional_info |= ADDITIONAL_INFO_FLAVOR

	// Antagonists can see expoitable information.
	if(expl_info && examiner.mind?.antag_datums)
		for(var/datum/antagonist/antag_datum as anything in examiner.mind.antag_datums)
			if(antag_datum.antag_flags & CAN_SEE_EXPOITABLE_INFO)
				has_additional_info |= ADDITIONAL_INFO_EXPLOITABLE
				break
	// Medhuds can see medical records, with adequate access.
	if(med_records && examiner.check_med_hud_and_access())
		has_additional_info |= ADDITIONAL_INFO_RECORDS
	// Sechuds can see security records, with adequate access.
	if(sec_records && examiner.check_sec_hud_and_access())
		has_additional_info |= ADDITIONAL_INFO_RECORDS
	// General records are unseen normally but leaving this here incase it is implemented.
	//if(gen_records)
	//	has_additional_info |= ADDITIONAL_INFO_RECORDS

	// Format a little message to append to let the player know they can access longer flavor text/records/info on double examine.
	var/added_info = ""
	if(has_additional_info & ADDITIONAL_INFO_FLAVOR)
		added_info = "longer flavor text"
	if(has_additional_info & ADDITIONAL_INFO_EXPLOITABLE)
		added_info = "[added_info ? "[added_info], exploitable information" : "exploitable information"]"
	if(has_additional_info & ADDITIONAL_INFO_RECORDS)
		added_info = "[added_info ? "[added_info] and past records" : "past records"]"

	if(added_info)
		added_info = span_italics(added_info)
		. += span_smallnoticeital("This individual may have [added_info] available if you [EXAMINE_CLOSER_BOLD].\n")
