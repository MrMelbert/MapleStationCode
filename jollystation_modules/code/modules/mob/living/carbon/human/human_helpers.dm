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
	// your identity is always known to you
	if(examiner == src)
		return src

	// whether their face is covered
	var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(!face_obscured)
		return src

	// What name they show up as
	var/shown_name = get_visible_name()
	if(shown_name == "Unknown")
		return null
	else if(shown_name == real_name)
		return src

	// if we're disguised as someone, return them instead
	for(var/client/clients in GLOB.clients)
		if(clients.mob.real_name == shown_name)
			return clients.mob

	return null

// Returns the mob's flavor text if it has any. Includes a newline
/mob/living/carbon/human/proc/get_flavor_text(shorten = TRUE)
	if(!client)
		CRASH("get_flavor_text() called on something without a client")

	if(!client.prefs)
		CRASH("get_flavor_text() called on something without a saved data prefs")

	if(!client.prefs.flavor_text)
		return null

	/// The text we display, formatted
	var/displayed_flavor_text = ""
	/// The raw flavor text.
	var/found_flavor_text = client.prefs.flavor_text
	// Shorten the flavor text if it exceeds our limit and we are told to.
	if(shorten && length(found_flavor_text) > EXAMINE_FLAVOR_MAX_DISPLAYED)
		displayed_flavor_text += TextPreview(found_flavor_text, EXAMINE_FLAVOR_MAX_DISPLAYED)
		displayed_flavor_text += " </i><a href='?src=[REF(src)];flavor_text=1'>\[More\]</a>"
	else
		displayed_flavor_text += found_flavor_text
		displayed_flavor_text += "</i>"

	displayed_flavor_text += "\n"
	return displayed_flavor_text

// Returns href buttons to the mob's records text - exploitable stuff, security, and medical. Includes a newline
/mob/living/carbon/human/proc/get_records_text(mob/living/carbon/human/examiner)
	if(!client)
		CRASH("get_records_text() called on something without a client")

	if(!client.prefs)
		CRASH("get_records_text() called on something without a saved data prefs")

	if(!examiner)
		CRASH("get_records_text() called without a user argument - proc is not implemented for a null examiner")

	// Record links, formatted, to return.
	var/returned_links = ""
	// A list of our user's acccess.
	var/list/access = istype(examiner) ? examiner.wear_id?.GetAccess() : null

	// Antagonists can see exploitable info.
	if(examiner.mind?.antag_datums && client.prefs.exploitable_info)
		for(var/antag_datum in examiner.mind.antag_datums)
			var/datum/antagonist/curious_antag = antag_datum
			if(!(curious_antag.antag_flags & CAN_SEE_EXPOITABLE_INFO))
				continue
			returned_links += "<a href='?src=[REF(src)];exploitable_info=1'>\[Exploitable Info\]</a>"
			break
	// Medhuds can see medical records.
	if(client.prefs.medical_records && HAS_TRAIT(examiner, TRAIT_MEDICAL_HUD) && access && (ACCESS_MEDICAL in access))
		returned_links += "<a href='?src=[REF(src)];medical_records=1'>\[Past Medical Records\]</a>"
	// Sechuds can see security records.
	if(client.prefs.security_records && HAS_TRAIT(examiner, TRAIT_SECURITY_HUD) && access && (ACCESS_SECURITY in access))
		returned_links += "<a href='?src=[REF(src)];security_records=1'>\[Past Security Records\]</a>"

	returned_links += "\n"
	return returned_links

/// Mob proc for checking digitigrades. Non-humans are always FALSE
/mob/proc/is_digitigrade()
	return FALSE

/// Humans check for DIGITIGRADE in species_traits
/mob/living/carbon/human/is_digitigrade()
	return (DIGITIGRADE in dna?.species?.species_traits)
