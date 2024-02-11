/datum/unit_test/pain

/datum/unit_test/pain/Run()
	var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human/consistent)
	TEST_ASSERT_NOTNULL(dummy.pain_controller, "Dummy didn't have a pain controller on creation!")

	for(var/obj/item/bodypart/part as anything in dummy.bodyparts)
		TEST_ASSERT_EQUAL(part.bodypart_pain_modifier, 1, "Dummy's bodypart, [part], had an unexpected pain modifier.")
		TEST_ASSERT_EQUAL(part.pain, 0, "Dummy had pain on creation.")

	TEST_ASSERT_EQUAL(dummy.pain_controller.pain_modifier, 1, "Dummy had an unexpected pain modifier.")
	dummy.pain_controller.base_pain_decay = 0
	dummy.pain_controller.natural_pain_decay = 0

	dummy.cause_pain(BODY_ZONES_ALL, 25)
	for(var/obj/item/bodypart/part as anything in dummy.bodyparts)
		TEST_ASSERT_EQUAL(part.pain, 25, "Dummy had an unexpected amount of pain.")

/datum/unit_test/prosthetic_quirk_pain

/datum/unit_test/prosthetic_quirk_pain/Run()
	for(var/datum/quirk/prosthetic_type as anything in typesof(/datum/quirk/prosthetic_limb))
		if(initial(prosthetic_type.abstract_parent_type) == prosthetic_type)
			continue

		var/does_have_a_prosthetic = FALSE
		var/mob/living/carbon/human/dummy = allocate(/mob/living/carbon/human/consistent)
		dummy.add_quirk(prosthetic_type)
		for(var/obj/item/bodypart/part as anything in dummy.bodyparts)
			TEST_ASSERT_EQUAL(part.pain, 0, "Dummy had pain from the quirk [prosthetic_type].")
			if(part.bodytype & BODYTYPE_ROBOTIC)
				does_have_a_prosthetic = TRUE

		TEST_ASSERT(does_have_a_prosthetic, "Dummy didn't actually get a prosthetic replacement for any limbs.")
