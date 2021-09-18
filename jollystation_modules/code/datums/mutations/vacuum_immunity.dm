//Vacuum immunity
/datum/mutation/human/vacuum_adaptation
	name = "Vacuum Adaptation"
	desc = "A mysterious mutation that allows the host to be completely resistant the impervious vacuum of space."
	quality = POSITIVE
	difficulty = 24
	text_gain_indication = "<span class='notice'>Your body feels cool!</span>"
	time_coeff = 5
	instability = 30


/datum/mutation/human/vacuum_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)

/datum/mutation/human/vacuum_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)

