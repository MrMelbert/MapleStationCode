/datum/reagent/consumable/liquidelectricity/auric
	name = "Processed Auric Tesla"
	description = "A processed metallic gel that seems to spark and crackle with electricity. It is unlike anything you've seen before."
	color = "#fff870"
	taste_description = "absolute power"
	metabolization_rate = 2 * REAGENTS_METABOLISM
	var/shock_timer = 0
	
/datum/reagent/consumable/liquidelectricity/auric/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	shock_timer++
	if(shock_timer >= rand(5, 30))
		shock_timer = 0
		affected_mob.electrocute_act(rand(10, 30), "Auric Tesla in their body", 1, SHOCK_NOGLOVES)
		playsound(affected_mob, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/datum/chemical_reaction/auricelectrolysis
	results = list(/datum/reagent/oxygen = 2.5, /datum/reagent/hydrogen = 5)
	required_reagents = list(/datum/reagent/consumable/liquidelectricity/auric = 1, /datum/reagent/water = 10)
	reaction_tags = REACTION_TAG_UNIQUE | REACTION_TAG_CHEMICAL
	mix_message = "the reaction zaps suddenly!"
	mix_sound = 'sound/effects/supermatter.ogg'

/datum/reagent/gravitum/aerialite
	name = "Alloyed Aerialite"
	description = "A powdered alloy of a strange blue metal that seems to defy the laws of gravity. It is unlike anything you've seen before."
	color = "#00aaff"
	taste_description = "the boundless sky"
	chemical_flags = null
	taste_mult = 1
	reagent_state = SOLID

/datum/reagent/resmythril
	name = "Resonant Mythril"
	description = "A powdered turquoise metal that seems to resonate with electromagnetic waves. It is unlike anything you've seen before."
	color = "#14747c"
	taste_description = "resonance"
	reagent_state = SOLID

/datum/chemical_reaction/resmythril_emp
	required_reagents = list(/datum/reagent/uranium = 1, /datum/reagent/resmythril = 1)
	reaction_tags = REACTION_TAG_UNIQUE | REACTION_TAG_EXPLOSIVE | REACTION_TAG_DANGEROUS
	mix_message = "the reaction resonates!"
	mix_sound = 'sound/machines/defib_zap.ogg'

/datum/chemical_reaction/resmythril_emp/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	empulse(location, round(created_volume / 12), round(created_volume / 7), 1)
	holder.clear_reagents()

/datum/reagent/exodust
	name = "Prism Dust"
	description = "A pulverized crystalline dust that seems to be unusually stabilized. It is unlike anything you've seen before."
	color = "#d3d1ed"
	taste_description = "a forge of a bygone era"
	reagent_state = SOLID

/datum/chemical_reaction/exo_stabilizer
	results = list(/datum/reagent/exotic_stabilizer = 1)
	required_reagents = list(/datum/reagent/exodust = 1,/datum/reagent/stabilizing_agent = 1)
	reaction_tags = REACTION_TAG_UNIQUE | REACTION_TAG_CHEMICAL

/datum/reagent/darkplasma
	name = "Condensed Dark Plasma"
	description = "A swirling dark liquid that seems to dissipate any light around it. It is unlike anything you've seen before."
	color = "#0e0033"
	taste_description = "an endless void"

/datum/chemical_reaction/plasma_vortex
	required_reagents = list(/datum/reagent/darkplasma = 1)
	required_temp = 474
	reaction_tags = REACTION_TAG_UNIQUE | REACTION_TAG_EXPLOSIVE | REACTION_TAG_DANGEROUS
	mix_message = "the reaction destabilizes!"
	mix_sound = 'sound/machines/defib_zap.ogg'

/datum/chemical_reaction/plasma_vortex/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/turf/T = get_turf(holder.my_atom)
	var/range = clamp(sqrt(created_volume), 1, 6)
	do_sparks(2, TRUE, location)
	goonchem_vortex(T, 0, range)
