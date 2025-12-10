/// Whenver an ion storm rolls through, synthetic species may have issues
/datum/round_event/ion_storm/start()
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ION_STORM)

/datum/component/ion_storm_randomization
	var/datum/dna/original_dna

/datum/component/ion_storm_randomization/Initialize(...)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterGlobalSignal(COMSIG_GLOB_ION_STORM, PROC_REF(on_ion_storm))

/datum/component/ion_storm_randomization/Destroy()
	UnregisterGlobalSignal(COMSIG_GLOB_ION_STORM)
	if(!QDELING(parent) && !isnull(original_dna))
		return_to_normal()
	QDEL_NULL(original_dna)
	return ..()

/datum/component/ion_storm_randomization/proc/on_ion_storm(datum/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/target = parent
	var/datum/species/prefs_android/synth/synth = target.dna.species
	if(isnull(synth.disguise_species))
		to_chat(target, span_danger("[ion_num()]. I0n1c D1strbance d3tcted!"))
		return

	to_chat(target, span_userdanger("[ion_num()]. I0N1C D1STRBANCE D3TCTED!"))
	original_dna = new()
	target.dna.copy_dna(original_dna)
	target.adjust_slurring(40 SECONDS)
	for(var/i in 1 to rand(2, 4))
		addtimer(CALLBACK(src,  PROC_REF(mutate_after_time), target), i * 6 SECONDS, TIMER_DELETE_ME)

	addtimer(CALLBACK(src,  PROC_REF(return_to_normal), target), 30 SECONDS, TIMER_DELETE_ME)

/// For use in a callback in [on_ion_storm].
/datum/component/ion_storm_randomization/proc/mutate_after_time()
	var/mob/living/carbon/human/target = parent
	var/datum/species/prefs_android/synth/synth = target.dna.species
	if(isnull(synth.disguise_species))
		return

	to_chat(target, span_warning("Your disguise glitches!"))
	target.random_mutate_unique_features()
	target.random_mutate_unique_identity()

/// For use in a callback in [on_ion_storm].
/datum/component/ion_storm_randomization/proc/return_to_normal()
	var/mob/living/carbon/human/target = parent
	var/datum/species/prefs_android/synth/synth = target.dna.species
	if(!isnull(synth.disguise_species))
		to_chat(target, span_notice("Your disguise returns to normal."))
	target.dna.features = original_dna.features.Copy()
	target.dna.unique_features = original_dna.unique_features
	target.dna.unique_enzymes = original_dna.unique_enzymes
	target.dna.unique_identity = original_dna.unique_identity
	target.updateappearance()
	QDEL_NULL(original_dna)
