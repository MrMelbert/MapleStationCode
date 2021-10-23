//Vacuum immunity
/datum/mutation/human/vacuum_adaptation
	name = "Vacuum Adaptation"
	desc = "A mysterious mutation that allows the host to be completely resistant the impervious vacuum of space."
	quality = POSITIVE
	difficulty = 24
	text_gain_indication = "<span class='notice'>Your body feels hollow!</span>"
	time_coeff = 5
	instability = 30


/datum/mutation/human/vacuum_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)
	owner.physiology.oxy_mod *= 2.5
	owner.set_pain_mod(PAIN_MOD_GENETICS, 1.75)

/datum/mutation/human/vacuum_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)
	owner.physiology.oxy_mod /= 2.5
	owner.unset_pain_mod(PAIN_MOD_GENETICS)
