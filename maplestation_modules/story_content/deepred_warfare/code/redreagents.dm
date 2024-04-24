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
		affected_mob.electrocute_act(rand(10, 30), "Auric Tesla in their body", 1, SHOCK_NOGLOVES) //SHOCK_NOGLOVES because it's caused from INSIDE of you
		playsound(affected_mob, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
