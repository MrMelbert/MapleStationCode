// Elements

// Core
#define MAGIC_ELEMENT_FIRE_LIZARD_MULT_INCREMENT 0.5

#define MAGIC_ELEMENT_FIRE /datum/attunement/fire
#define MAGIC_ELEMENT_ICE /datum/attunement/ice
// When other elements are used, add them here

// Alignments
#define MAGIC_ALIGNMENT_NONE "None"
#define MAGIC_ALIGNMENT_LAW "Law"
#define MAGIC_ALIGNMENT_CHAOS "Chaos"
#define MAGIC_ALIGNMENT_GOOD "Good"
#define MAGIC_ALIGNMENT_EVIL "Evil"

/// Returns the raw attunement correspondance between args 1 and 3. Its fine if both are negative, since thats a positive correspondance.
/// The direction and intensity of the correspondance should correspond to altered casting cost - intense positive correspondance should lower
/// casting cost by a large amount-but a weak negative correspondance should increase casting cost by a small amount.
#define GET_RAW_ATTUNEMENT_CORRESPONDANCE(attunements, intensity, attunement) (attunements[attunement] * intensity)

/// Compares the two lists of attunements and combines the raw correspondance.
/proc/get_total_correspondance(list/attunements, list/other_attunements)
	. = 0

	for (var/datum/attunement/iterated_attunement as anything in attunements)
		. += GET_RAW_ATTUNEMENT_CORRESPONDANCE(attunements, other_attunements[iterated_attunement], iterated_attunement)

/// Returns the "mult" value using the correspondance between attunements and intensity. This value should be multiplied against
/// the mana cost of an action to determine how much "effective" mana a certain mana source can provide to it.
/// Should NEVER return anything negative, ever. The minimum is 0.
/proc/get_total_attunement_mult(list/attunements, list/other_attunements)
	. = 1
	var/total_correspondance = get_total_correspondance(attunements, other_attunements)

	if (total_correspondance == 0) return
	if (total_correspondance > 0)
		. = (1/(1+total_correspondance)) // 1 over correspondance to convert to decimal, 1+total_correspondance so sub-1 correspondances dont INCREASE casting cost
		if (. > 1)
			stack_trace("[.] > 1 in get_total_attachment_mult with [total_correspondance]")
	else
		. = -total_correspondance
		if (. < 1)
			stack_trace("[.] < 1 in get_total_attachment_mult with [total_correspondance]")
	if (. < 0)
		stack_trace("[.] < 0 in get_total_attachment_mult with [total_correspondance]")

/*
/proc/get_total_attunement_inherent_mult(atom/caster, list/attunements = GLOB.magic_attunements)
	. = 1
	for (var/datum/attunement/iterated_attunement as anything in attunements)
		. += iterated_attunement.get_intrinsic_mult_increment(caster)
*/
