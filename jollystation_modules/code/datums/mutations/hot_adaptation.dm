//Heat immunity
/datum/mutation/human/heat_adaptation
	name = "Swealtering Adaptation"
	desc = "A pecuilar mutation that allows the host to be completely resistant to the hottest tempeatures known to man."
	quality = POSITIVE
	difficulty = 12
	text_gain_indication = "<span class='notice'>Your body feels cool!</span>"
	time_coeff = 5
	instability = 10


/datum/mutation/human/heat_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTHEAT, GENETIC_MUTATION)

/datum/mutation/human/heat_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTHEAT, GENETIC_MUTATION)

