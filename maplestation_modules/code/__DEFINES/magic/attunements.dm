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

/// Returns the raw attunement correspondance between args 1 and 3.
#define GET_RAW_CORRESPONDING_ATTUNEMENT(attunements, intensity, attunement) (attunements[attunement] * intensity)
/// Divides 1 by GET_RAW_CORRESPONDING_ATTUNEMENT(args). Returns 0 if divisor = 0.
#define GET_RAW_ATTUNEMENT_MULT(attunements, intensity, attunement) SAFE_DIVIDE(1, GET_RAW_CORRESPONDING_ATTUNEMENT(attunements, intensity, attunement))

/// Attunements start at 0. A raw attunement correspondnace between 0 and 0 is 0, so we need to adjust by adding 1 if we want to actually use the mult.
#define GET_ADJUSTED_ATTUNEMENT_MULT(attunements, intensity, attunement) (GET_RAW_ATTUNEMENT_MULT(attunements, intensity, attunement)+1)

/// Compares the two lists of attunements and combines the raw mults of each's correspondance.
/proc/get_total_attunement_mult(list/attunements, list/other_attunements)
	. = 1

	for (var/datum/attunement/iterated_attunement as anything in attunements)
		. += GET_RAW_ATTUNEMENT_MULT(attunements, other_attunements[iterated_attunement], iterated_attunement) // use raw to avoid the +1
