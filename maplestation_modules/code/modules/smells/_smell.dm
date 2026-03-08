/// Singleton datum representing a smell
/datum/smell
	/// Text of the smell
	var/text = "stinky"
	/// The "type" of smell it is
	var/category = "smell"

/datum/smell/New(set_text, set_category)
	if(set_text)
		text = set_text
	if(set_category)
		category = set_category

/// Can the passed mob smell this smell?
/datum/smell/proc/can_mob_smell(mob/living/whom)
	return TRUE

/// Any bonus effects when smelling this smell
/datum/smell/proc/on_smell(mob/living/whom, intensity)
	return

/// Returns what adjective to use for the smell for output
/datum/smell/proc/get_adjective(mob/living/for_whom, intensity)
	switch(intensity)
		if(SMELL_INTENSITY_FAINT to SMELL_INTENSITY_WEAK)
			return "faint"
		if(SMELL_INTENSITY_WEAK to SMELL_INTENSITY_MODERATE)
			return "weak"
		if(SMELL_INTENSITY_MODERATE to SMELL_INTENSITY_STRONG)
			return ""
		if(SMELL_INTENSITY_STRONG to SMELL_INTENSITY_OVERPOWERING)
			return "strong"
		if(SMELL_INTENSITY_OVERPOWERING to INFINITY)
			return "overpowering"

	return ""

/// Return what category of smell this is for output
/datum/smell/proc/get_category(mob/living/for_whom, intensity)
	return category

// Blood
/datum/smell/blood
	text = span_danger("blood") // melbert todo : needs special handing for special bloodtypes
	category = "stench"

/datum/smell/blood/on_smell(mob/living/whom, intensity)
	whom.add_mood_event("blood-smell", /datum/mood_event/blood_smell)

/datum/smell/blood/get_category(mob/living/for_whom, intensity)
	return (HAS_TRAIT(for_whom, TRAIT_MORBID) || isvampire(for_whom)) ? "scent" : "stench"

// Oil
/datum/smell/oil
	text = "oil"
	category = "odor"

/datum/smell/oil/on_smell(mob/living/whom, intensity)
	whom.add_mood_event("oil-smell", /datum/mood_event/oil_smell)

// Cigarette Smoke
/datum/smell/cigarette_smoke
	text = "cigarette smoke"
	category = "odor"

/datum/smell/cigarette_smoke/on_smell(mob/living/whom, intensity)
	whom.add_mood_event("cigarette-smoke", /datum/mood_event/cigarette_smoke)

// Plasma
/datum/smell/plasma
	text = span_purple("plasma")
	category = "odor"

// Miasma
/datum/smell/miasma
	text = span_green("miasma")
	category = "stench"

/datum/smell/miasma/on_smell(mob/living/whom, intensity)
	whom.adjust_disgust(10)
	switch(intensity)
		if(SMELL_INTENSITY_MODERATE to SMELL_INTENSITY_STRONG)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/bad_smell)

		if(SMELL_INTENSITY_STRONG to SMELL_INTENSITY_OVERPOWERING)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/really_bad_smell)
			if(prob(5) && iscarbon(whom))
				var/mob/living/carbon/carb_whom = whom
				carb_whom.vomit(VOMIT_CATEGORY_DEFAULT)

		if(SMELL_INTENSITY_OVERPOWERING to INFINITY)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/nauseating_stench)
			if(prob(15) && iscarbon(whom))
				var/mob/living/carbon/carb_whom = whom
				carb_whom.vomit(VOMIT_CATEGORY_DEFAULT)

// Decay (mimics miasma)
/datum/smell/decay
	text = span_warning("decay")
	category = "stench"

/datum/smell/decay/on_smell(mob/living/whom, intensity)
	whom.adjust_disgust(10)
	switch(intensity)
		if(0 to SMELL_INTENSITY_MODERATE)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/minor_bad_smell)

		if(SMELL_INTENSITY_MODERATE to SMELL_INTENSITY_OVERPOWERING)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/bad_smell)

		if(SMELL_INTENSITY_OVERPOWERING to INFINITY)
			whom.add_mood_event("decay-smell", /datum/mood_event/disgust/really_bad_smell)

/datum/smell/good_food
	text = "something good"
	category = "aroma"

/datum/smell/good_food/on_smell(mob/living/whom, intensity)
	whom.add_mood_event("good-food-aroma", /datum/mood_event/good_food_aroma)

/datum/smell/burnt_food
	text = "something bad"

/datum/smell/burnt_food/on_smell(mob/living/whom, intensity)
	whom.add_mood_event("burnt-food-aroma", /datum/mood_event/burnt_food_aroma)

/datum/smell/burnt_food/fryer
	text = "something acrid"
