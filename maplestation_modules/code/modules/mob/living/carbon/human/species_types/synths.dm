// -- Synth additions (though barely functional) --
/// Whenver an ion storm rolls through, synthetic species may have issues
/datum/round_event/ion_storm/start()
	. = ..()
	for(var/mob/living/carbon/human/ioned_mob in GLOB.alive_mob_list)
		ioned_mob.dna?.species?.on_ion_storm(ioned_mob)

/// Called on the mob whenever an ion storm occurs.
/datum/species/proc/on_ion_storm(mob/living/carbon/human/target)
	return


// MELBERT TODO: working pref for synth's species
/datum/species/synth
	species_pain_mod = 0.5

/datum/species/synth/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.transfer_identity(human) // Makes the synth look like... a synth.

/datum/species/synth/on_ion_storm(mob/living/carbon/human/target)
	to_chat(target, span_userdanger("[ion_num()]. I0N1C D1STRBANCE D3TCTED!"))
	target.slurring = max(0, target.slurring + 20)
	var/datum/dna/original_dna = new
	target.dna.copy_dna(original_dna)
	for(var/i in 1 to rand(2, 4))
		addtimer(CALLBACK(src, .proc/mutate_after_time, target), i * 3 SECONDS)
	addtimer(CALLBACK(src, .proc/return_to_normal, target, original_dna), 30 SECONDS)

/// For use in a callback in [on_ion_storm].
/datum/species/synth/proc/mutate_after_time(mob/living/carbon/human/target)
	to_chat(target, span_warning("Your disguise glitches!"))
	target.random_mutate_unique_features()
	target.random_mutate_unique_identity()

/// For use in a callback in [on_ion_storm].
/datum/species/synth/proc/return_to_normal(mob/living/carbon/human/target, datum/dna/original)
	to_chat(target, span_notice("Your disguise returns to normal."))
	target.dna.features = original.features.Copy()
	target.dna.unique_features = original.unique_features
	target.dna.unique_enzymes = original.unique_enzymes
	target.dna.unique_identity = original.unique_identity
	target.updateappearance()
	qdel(original)

/datum/species/synth/military
	species_pain_mod = 0

/datum/species/synth/military/on_ion_storm(mob/living/carbon/human/target)
	to_chat(target, span_userdanger("[ion_num()]. I0N1C DISTURBANCE DETECTED. MILITARY SHIELDING ENGAGED."))

/datum/species/android/on_ion_storm(mob/living/carbon/human/target)
	to_chat(target, span_userdanger("[ion_num()]. I0N1C DISTURBANCE DETECTED."))
