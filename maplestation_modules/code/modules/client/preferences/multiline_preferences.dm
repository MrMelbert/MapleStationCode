#define MAX_FLAVOR_LEN 2048 // NON-MODULE CHANGES

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

/// Preferences that add onto flavor text datum
/datum/preference/multiline_text/flavor_datum
	abstract_type = /datum/preference/multiline_text/flavor_datum
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_NAMES

/datum/preference/multiline_text/flavor_datum/apply_to_human(mob/living/carbon/human/target, value)
	if(!value)
		return

	// Doesn't need to apply to the dummy
	if(istype(target, /mob/living/carbon/human/dummy))
		return

	var/datum/flavor_text/our_flavor = target.linked_flavor || add_or_get_mob_flavor_text(target)
	if(isnull(our_flavor))
		return

	add_to_flavor_datum(our_flavor, value)

/datum/preference/multiline_text/flavor_datum/proc/add_to_flavor_datum(datum/flavor_text/our_flavor, value)
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("add_to_flavor_datum not implemented for [type]")

/datum/preference/multiline_text/flavor_datum/flavor
	savefile_key = "flavor_text"

/datum/preference/multiline_text/flavor_datum/flavor/add_to_flavor_datum(datum/flavor_text/our_flavor, value)
	our_flavor.flavor_text = value

/datum/preference/multiline_text/flavor_datum/silicon
	savefile_key = "silicon_text"

/datum/preference/multiline_text/flavor_datum/silicon/apply_to_human(datum/flavor_text/our_flavor, value)
	our_flavor.silicon_text = value

/datum/preference/multiline_text/flavor_datum/exploitable
	savefile_key = "exploitable_info"

/datum/preference/multiline_text/flavor_datum/exploitable/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/flavor_text/our_flavor = ..()
	our_flavor?.expl_info = value

/// Preferences that add onto crew records
/datum/preference/multiline_text/record
	abstract_type = /datum/preference/multiline_text/record
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_NAMES

/datum/preference/multiline_text/record/after_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs, value)
	if(istype(target, /mob/living/carbon/human/dummy))
		return

	var/datum/record/crew/associated_record = find_record(target.real_name)
	if(isnull(associated_record))
		return

	add_to_record(associated_record, value)

/datum/preference/multiline_text/record/proc/add_to_record(datum/record/crew/associated_record, datum/preferences/prefs, value)
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("add_to_record not implemented for [type]")

/datum/preference/multiline_text/record/general
	savefile_key = "general_records"

/datum/preference/multiline_text/record/general/add_to_record(datum/record/crew/associated_record, datum/preferences/prefs, value)
	var/datum/medical_note/new_note = new("General Record", value)
	new_note.time = "Past record"
	associated_record.medical_notes += new_note

/datum/preference/multiline_text/record/medical
	savefile_key = "medical_records"

/datum/preference/multiline_text/record/medical/add_to_record(datum/record/crew/associated_record, datum/preferences/prefs, value)
	var/datum/medical_note/new_note = new("Medical Record", value)
	new_note.time = "Past record"
	associated_record.medical_notes += new_note

/datum/preference/multiline_text/record/security
	savefile_key = "security_records"

/datum/preference/multiline_text/record/security/add_to_record(datum/record/crew/associated_record, datum/preferences/prefs, value)
	var/datum/crime/new_crime = new("Past infractions / notes", value, "Security Record", "Indetermined")
	new_crime.time = "Past record"
	new_crime.valid = FALSE // makes it print as "REDACTED", which is neat?
	associated_record.crimes += new_crime

#undef MAX_FLAVOR_LEN
