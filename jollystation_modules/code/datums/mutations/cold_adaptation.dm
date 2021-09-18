//Cold immunity
/datum/mutation/human/cold_adaptation
	name = "Frigid Adaptation"
	desc = "A pecuilar mutation that allows the host to be completely resistant to absolute zero."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>Your body feels warm!</span>"
	time_coeff = 5
	instability = 5


/datum/mutation/human/cold_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, GENETIC_MUTATION)

/datum/mutation/human/cold_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, GENETIC_MUTATION)

