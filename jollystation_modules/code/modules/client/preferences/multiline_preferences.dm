/datum/preference/multiline_text
	abstract_type = /datum/preference/multiline_text
	can_randomize = FALSE

/datum/preference/multiline_text/deserialize(input, datum/preferences/preferences)
	return STRIP_HTML_SIMPLE("[input]", MAX_FLAVOR_LEN)

/datum/preference/multiline_text/serialize(input)
	return STRIP_HTML_SIMPLE(input, MAX_FLAVOR_LEN)

/datum/preference/multiline_text/is_valid(value)
	return istext(value) && !isnull(STRIP_HTML_SIMPLE(value, MAX_FLAVOR_LEN))

/datum/preference/multiline_text/create_default_value()
	return null

/datum/preference/multiline_text/flavor_datum
	abstract_type = /datum/preference/multiline_text/flavor_datum
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_NAMES

/datum/preference/multiline_text/flavor_datum/apply_to_human(mob/living/carbon/human/target, value)
	if(!value)
		return

	if(istype(target, /mob/living/carbon/human/dummy))
		return

	return target.linked_flavor || add_or_get_mob_flavor_text(target)

/datum/preference/multiline_text/flavor_datum/flavor
	savefile_key = "flavor_text"

/datum/preference/multiline_text/flavor_datum/flavor/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.flavor_text = value

/datum/preference/multiline_text/flavor_datum/exploitable
	savefile_key = "exploitable_info"

/datum/preference/multiline_text/flavor_datum/exploitable/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.expl_info = value

/datum/preference/multiline_text/flavor_datum/general
	savefile_key = "general_records"

/datum/preference/multiline_text/flavor_datum/general/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.gen_records = value

/datum/preference/multiline_text/flavor_datum/security
	savefile_key = "security_records"

/datum/preference/multiline_text/flavor_datum/security/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.sec_records = value

/datum/preference/multiline_text/flavor_datum/medical
	savefile_key = "medical_records"

/datum/preference/multiline_text/flavor_datum/medical/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.med_records = value
