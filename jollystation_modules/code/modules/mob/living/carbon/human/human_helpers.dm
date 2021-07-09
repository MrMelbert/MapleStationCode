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
/mob/living/proc/get_visible_flavor(mob/examiner)
	return null

/mob/living/carbon/human/get_visible_flavor(mob/examiner)
	//var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	var/shown_name = get_visible_name()

	// your identity is always known to you
	if(examiner == src)
		return linked_flavor

	if(shown_name == "Unknown")
		return null

	// the important check - if the visible name is our flavor text name, display our flavor text
	// if the visible name is not, however, we may be in disguise - so grab the corresponding flavor text from our global list
	if(shown_name == linked_flavor?.linked_name || findtext(shown_name, linked_flavor?.linked_name))
		. = linked_flavor
	else
		. = GLOB.flavor_texts[shown_name]

	var/datum/flavor_text/found_flavor = .

	// if you are not the species linked to the flavor text, you are not recognizable
	if(found_flavor?.linked_species != dna?.species.id)
		. = null

/mob/living/silicon/get_visible_flavor(mob/examiner)
	. = linked_flavor

	if(examiner == src)
		return

	var/datum/flavor_text/found_flavor = .
	if(found_flavor?.linked_species != "silicon")
		. = null

/mob/proc/check_med_hud_and_access()
	return FALSE

/mob/living/carbon/human/check_med_hud_and_access()
	var/list/access = wear_id?.GetAccess()
	return LAZYLEN(access) && HAS_TRAIT(src, TRAIT_MEDICAL_HUD) && (ACCESS_MEDICAL in access)

/mob/proc/check_sec_hud_and_access()
	return FALSE

/mob/living/carbon/human/check_sec_hud_and_access()
	var/list/access = wear_id?.GetAccess()
	return LAZYLEN(access) && HAS_TRAIT(src, TRAIT_SECURITY_HUD) && (ACCESS_SECURITY in access)

/// Mob proc for checking digitigrades. Non-humans are always FALSE
/mob/proc/is_digitigrade()
	return FALSE

/// Humans check for DIGITIGRADE in species_traits
/mob/living/carbon/human/is_digitigrade()
	return (DIGITIGRADE in dna?.species?.species_traits)
