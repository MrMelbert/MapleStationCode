// -- Synth additions (though barely functional) --

#define COMSIG_GLOB_ION_STORM "!ion_storm"

/// Whenver an ion storm rolls through, synthetic species may have issues
/datum/round_event/ion_storm/start()
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ION_STORM)

/datum/species/synth
	name = "Synth" //inherited from the real species, for health scanners and things
	id = SPECIES_SYNTH
	// say_mod = "beep boops" //inherited from a user's real species
	sexes = FALSE
	species_traits = list(NOTRANSSTING, NO_DNA_COPY) //all of these + whatever we inherit from the real species
	inherent_traits = list(
		TRAIT_VIRUSIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	wing_types = list(/obj/item/organ/external/wings/functional/robotic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	species_language_holder = /datum/language_holder/synthetic
	/// If your health becomes equal to or less than this value, your disguise is supposed to break.
	/// Unfortunately, that feature currently isn't implemented, so currently, all this threshold is
	/// used for is (I kid you not) determining whether or not your speech uses SPAN_CLOWN while you're
	/// disguised as a bananium golem. See the handle_speech() proc further down in this file for more information on that check.
	var/disguise_fail_health = 75
	///a species to do most of our work for us, unless we're damaged
	var/datum/species/fake_species
	///for getting these values back for assume_disguise()
	var/list/initial_species_traits
	var/list/initial_inherent_traits

	/// Hack ahead
	/// We need to react to [COMSIG_GLOB_ION_STORM], unfortunately we can't do that easily in a species, so we keep a weakref from Grant
	var/datum/weakref/silly_owner_weakref

/datum/species/synth/New()
	initial_species_traits = species_traits.Copy()
	initial_inherent_traits = inherent_traits.Copy()
	return ..()

/datum/species/synth/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	assume_disguise(old_species, H)
	RegisterSignal(H, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(SSdcs, COMSIG_GLOB_ION_STORM, PROC_REF(on_ion_storm))
	H.set_safe_hunger_level()
	silly_owner_weakref = WEAKREF(H)

/datum/species/synth/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	UnregisterSignal(H, COMSIG_MOB_SAY)
	UnregisterSignal(SSdcs, COMSIG_GLOB_ION_STORM)
	silly_owner_weakref = null

/datum/species/synth/get_species_description()
	return "Synths are disguised robots."

/datum/species/synth/get_species_lore()
	return list("Synth lore.")

/datum/species/synth/create_pref_unique_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "robot",
		SPECIES_PERK_NAME = "Robot Rock",
		SPECIES_PERK_DESC = "Synths are robotic instead of organic, and as such may be affected by or immune to some things \
			normal humanoids are or aren't.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "user-secret",
		SPECIES_PERK_NAME = "Incognito Mode",
		SPECIES_PERK_DESC = "Synths are secretly synthetic androids that disguise as another species.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "shield-alt",
		SPECIES_PERK_NAME = "Silicon Supremecy",
		SPECIES_PERK_DESC = "Being synthetic, Synths gain many resistances that come \
			with silicons. They're immune to viruses, dismemberment, having \
			limbs disabled, and they don't need to eat or breath.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "theater-masks",
		SPECIES_PERK_NAME = "Full Copy",
		SPECIES_PERK_DESC = "Synths take on all the traits of species they disguise as, \
			both positive and negative.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "users-cog",
		SPECIES_PERK_NAME = "Error: Disguise Failure",
		SPECIES_PERK_DESC = "Ion Storms can temporarily mess with your disguise, \
			causing some of your features to change sporatically.",
	))
	return perks

/datum/species/synth/create_pref_language_perk()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "language",
		SPECIES_PERK_NAME = "Language Processor",
		SPECIES_PERK_DESC = "Synths can understand and speak a wide variety of \
			additional languages, including Encoded Audio Language, the language \
			of silicon and synthetics.",
	))

	return perks

/datum/species/synth/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H, seconds_per_tick, times_fired)
	if(chem.type == /datum/reagent/medicine/c2/synthflesh)
		chem.expose_mob(H, TOUCH, 2 * REAGENTS_EFFECT_MULTIPLIER * seconds_per_tick, FALSE) //heal a little
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * seconds_per_tick)
		return TRUE
	return ..()

/datum/species/synth/proc/assume_disguise(datum/species/S, mob/living/carbon/human/H)
	if(S && !istype(S, type))
		name = S.name
		sexes = S.sexes
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		species_traits |= S.species_traits
		inherent_traits |= S.inherent_traits
		meat = S.meat
		mutant_bodyparts = S.mutant_bodyparts.Copy()
		mutant_organs = S.mutant_organs.Copy()
		no_equip_flags = S.no_equip_flags
		use_skintones = S.use_skintones
		fixed_mut_color = S.fixed_mut_color
		hair_color = S.hair_color
		fake_species = new S.type
	else
		name = initial(name)
		species_traits = initial_species_traits.Copy()
		inherent_traits = initial_inherent_traits.Copy()
		mutant_bodyparts = list()
		no_equip_flags = NONE
		qdel(fake_species)
		fake_species = null
		meat = initial(meat)
		use_skintones = 0
		sexes = 0
		fixed_mut_color = ""
		hair_color = ""

	for(var/X in H.bodyparts) //propagates the damage_overlay changes
		var/obj/item/bodypart/BP = X
		BP.update_limb()
	H.update_body_parts() //to update limb icon cache with the new damage overlays

	var/obj/item/organ/internal/tongue/disguise_tongue = initial(fake_species.mutanttongue) // handles the say_mod for species disguise.
	// this (below) is a major make or break for the code, this should set the synth tongue to be identical to the default species tongue the mob is disguised as.
	var/obj/item/organ/internal/tongue/my_tongue = H.getorgan(/obj/item/organ/internal/tongue)
	if(my_tongue && disguise_tongue)
		my_tongue.say_mod = initial(disguise_tongue.say_mod)

/datum/species/synth/handle_body(mob/living/carbon/human/H)
	if(fake_species)
		fake_species.handle_body(H)
	else
		return ..()

/datum/species/synth/handle_mutant_bodyparts(mob/living/carbon/human/H, forced_colour)
	if(fake_species)
		fake_species.handle_mutant_bodyparts(H,forced_colour)
	else
		return ..()

/datum/species/synth/proc/handle_speech(mob/living/source, list/speech_args)
	SIGNAL_HANDLER

	if(fake_species && source.health > disguise_fail_health)
		switch(fake_species.type)
			if (/datum/species/golem/bananium)
				speech_args[SPEECH_SPANS] |= SPAN_CLOWN

/datum/species/synth/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.transfer_identity(human) // Makes the synth look like... a synth.

/datum/species/synth/proc/on_ion_storm(datum/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/target = silly_owner_weakref?.resolve()
	if(QDELETED(target))
		return

	to_chat(target, span_userdanger("[ion_num()]. I0N1C D1STRBANCE D3TCTED!"))
	target.adjust_slurring(40 SECONDS)
	var/datum/dna/original_dna = new
	target.dna.copy_dna(original_dna)
	for(var/i in 1 to rand(2, 4))
		addtimer(CALLBACK(src,  PROC_REF(mutate_after_time), target), i * 3 SECONDS)
	addtimer(CALLBACK(src,  PROC_REF(return_to_normal), target, original_dna), 30 SECONDS)

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
