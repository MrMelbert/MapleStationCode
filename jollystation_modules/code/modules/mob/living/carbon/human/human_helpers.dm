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
/mob/living/carbon/human/proc/get_visible_flavor(mob/examiner)
	var/face_obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	var/shown_name = get_visible_name()
	var/is_our_name_visible = (shown_name == linked_flavor.linked_name || findtext(shown_name, linked_flavor.linked_name))

	. = linked_flavor

	// your identity is always known to you
	if(examiner == src)
		return

	if(shown_name == "Unknown")
		return null

	// whether their face is covered
	if(face_obscured)
		. = null

	// the important check - if the name visible is not the name saved in our flavor text
	if(is_our_name_visible)
		. = linked_flavor

	// if you are not your original species, you are not recognizable
	if(dna?.species.id != linked_flavor.linked_species)
		. = null

	// If we don't have a visible identity by now, we may be in disguise - return that (can be null, too)
	if(!. && !is_our_name_visible)
		. = GLOB.flavor_texts[shown_name]

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
