// -- Extra helper procs for humans. --

/* Determine if the current mob's real identity is visible.
 * This probably has a lot of edge cases that will get missed but we can find those later.
 * (There's gotta be a helper proc for this that already exists in the code, right?)
 *
 * returns a reference to a mob -
 *	- returns SRC if [src] isn't disguised, or is wearing their id / their name is visible
 *	- returns another mob if [src] is disguised as someone that exists in the world
 * returns null otherwise.
 */
/mob/living/carbon/human/proc/get_visible_identity(mob/examiner)
	. = null
	// your identity is always known to you
	if(examiner == src)
		return src

	// whether their face is covered
	var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(!face_obscured)
		. = src

	// What name they show up as
	var/shown_name = get_visible_name()
	var/realer_name = client?.prefs ? client.prefs.real_name : (mind ? mind.name : real_name)
	if(shown_name == "Unknown")
		. = null
	else if(. || shown_name == realer_name || findtext(realer_name, shown_name, 1, length(realer_name)+1))
		return src

	// if we're disguised as someone, return them instead
	for(var/mob/living/checked_mob as anything in GLOB.player_list)
		if(checked_mob.client?.prefs?.real_name == shown_name)
			. = checked_mob
		else if(checked_mob.mind?.name == shown_name)
			. = checked_mob
		else if(checked_mob.real_name == shown_name)
			. = checked_mob

// Returns the mob's flavor text if it has any. Includes a newline
/mob/living/carbon/human/proc/get_flavor_text(shorten = TRUE)
	if(!client)
		CRASH("get_flavor_text() called on something without a client")
	if(!client.prefs)
		CRASH("get_flavor_text() called on something without a saved data prefs")
	if(!client.prefs.flavor_text)
		return null

	. = ""

	if(client.prefs.real_name != real_name || !findtext(client.prefs.real_name, name, 1, length(name)+1))
		return

	/// The raw flavor text.
	var/found_flavor_text = client.prefs.flavor_text
	// Shorten the flavor text if it exceeds our limit and we are told to.
	if(shorten && length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
		. += TextPreview(found_flavor_text, EXAMINE_FLAVOR_MAX_DISPLAYED)
		. += " <a href='?src=[REF(src)];flavor_text=1'>\[More\]</a>"
	else
		. += found_flavor_text

	if(.)
		. += "\n"
		. = span_italics(.)

// Returns href buttons to the mob's records text - exploitable stuff, security, and medical. Includes a newline
/mob/living/carbon/human/proc/get_records_text(mob/living/carbon/human/examiner)
	if(!client)
		CRASH("get_records_text() called on something without a client")
	if(!client.prefs)
		CRASH("get_records_text() called on something without a saved data prefs")
	if(!examiner)
		CRASH("get_records_text() called without a user argument - proc is not implemented for a null examiner")

	. = ""

	if(client.prefs.real_name != real_name || !findtext(client.prefs.real_name, name, 1, length(name)+1))
		return

	// A list of our user's acccess.
	var/list/access = istype(examiner) ? examiner.wear_id?.GetAccess() : null

	// Antagonists can see exploitable info.
	if(examiner.mind?.antag_datums && client.prefs.exploitable_info)
		for(var/antag_datum in examiner.mind.antag_datums)
			var/datum/antagonist/curious_antag = antag_datum
			if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
				continue
			. += "<a href='?src=[REF(src)];exploitable_info=1'>\[Exploitable Info\]</a>"
			break
	// Medhuds can see medical records.
	if(client.prefs.medical_records && HAS_TRAIT(examiner, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
		. += "<a href='?src=[REF(src)];medical_records=1'>\[Past Medical Records\]</a>"
	// Sechuds can see security records.
	if(client.prefs.security_records && HAS_TRAIT(examiner, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
		. += "<a href='?src=[REF(src)];security_records=1'>\[Past Security Records\]</a>"

	if(.)
		. += "\n"
/*
 * Get the actual flavor text and hint at records of [src] to [examiner].
 */
/mob/living/carbon/human/proc/get_basic_flavor_and_records(mob/living/carbon/human/examiner)
	if(!client)
		CRASH("get_basic_flavor_and_records() called on something without a client")
	if(!client.prefs)
		CRASH("get_basic_flavor_and_records() called on something without a saved data prefs")
	if(!examiner)
		CRASH("get_records_text() called without a user argument - proc is not implemented for a null examiner")

	. = ""

	// Whether or not we would have additional info on `examine_more()`.
	var/has_additional_info

	if(client.prefs.real_name != real_name || !findtext(client.prefs.real_name, name, 1, length(name)+1))
		return

	// If the client has flavor text set.
	if(client.prefs.flavor_text)
		var/found_flavor_text = get_flavor_text(TRUE)
		. += found_flavor_text
		if(length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
			has_additional_info |= ADDITIONAL_INFO_FLAVOR

	// A list of our examiner's acccess.
	var/list/access = istype(examiner) ? examiner.wear_id?.GetAccess() : null

	// Antagonists can see expoitable information.
	if(examiner.mind?.antag_datums && client.prefs.exploitable_info)
		for(var/datum/antagonist/antag_datum as anything in examiner.mind.antag_datums)
			if(antag_datum.antag_flags & CAN_SEE_EXPOITABLE_INFO)
				has_additional_info |= ADDITIONAL_INFO_EXPLOITABLE
				break
	// Medhuds can see medical records, with adequate access.
	if(client.prefs.medical_records && HAS_TRAIT(examiner, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
		has_additional_info |= ADDITIONAL_INFO_RECORDS
	// Sechuds can see security records, with adequate access.
	if(client.prefs.security_records && HAS_TRAIT(examiner, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
		has_additional_info |= ADDITIONAL_INFO_RECORDS

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


/// Mob proc for checking digitigrades. Non-humans are always FALSE
/mob/proc/is_digitigrade()
	return FALSE

/// Humans check for DIGITIGRADE in species_traits
/mob/living/carbon/human/is_digitigrade()
	return (DIGITIGRADE in dna.species.species_traits)
