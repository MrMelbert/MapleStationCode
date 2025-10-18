/// Gets the owner's current instability level
/datum/dna/proc/get_stability()
	stability = 100
	for(var/datum/mutation/human/mutation in mutations)
		if(mutation.class == MUT_EXTRA || mutation.instability < 0)
			stability -= mutation.instability * GET_MUTATION_STABILIZER(mutation)
	return stability
