// Elements

// Core

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
#define GET_RAW_CORRESPONDING_ATTUNEMENT(attunements, intensity, attunement) (attunements[attunement] * intensity)
#define GET_RAW_ATTUNEMENT_MULT(attunements, intensity, attunement) get_raw_attunement_mult_proc(attunements, intensity, attunement)

/// Returns the "mult" value using the correspondance between attunements and intensity. This value should be multiplied against
/// the mana cost of an action to determine how much "effective" mana a certain mana source can provide to it.
/proc/get_raw_attunement_mult_proc(list/datum/attunement/attunements, intensity, attunement)
	. = GET_RAW_CORRESPONDING_ATTUNEMENT(attunements, intensity, attunement)
	if (. < 0)
		return abs(.) // otherwise, we get (-5*2) = -10 = 1/-10 = -0.1. But with this, we just get (-5*2), -10, abs(-10), 10. A better result!
	else
		return SAFE_DIVIDE(1, .)

/// Attunements start at 0. A raw attunement correspondnace between 0 and 0 is 0, so we need to adjust by adding 1 if we want to actually use the mult.
#define GET_ADJUSTED_ATTUNEMENT_MULT(attunements, intensity, attunement) (GET_RAW_ATTUNEMENT_MULT(attunements, intensity, attunement)+1)

/// Compares the two lists of attunements and combines the raw mults of each's correspondance.
/proc/get_total_attunement_mult(list/attunements, list/other_attunements)
	. = 1

	for (var/datum/attunement/iterated_attunement as anything in attunements)
		. += GET_RAW_ATTUNEMENT_MULT(attunements, other_attunements[iterated_attunement], iterated_attunement) // use raw to avoid the +1
