/// --Unique examine element. --
// Original element from skyrat-tg (Gandalf2k15), completely refactored and adapted.
// Attach to an atom with some parameters to give it unique text when examined.

/**
 * Unique examine element parameters
 * Attach this element to an atom to give it unique examine text if it's double examined by certain people!
 *
 * Params:
 *
 * atom/thing - default element parameter, skip this
 * desc - The unique description displayed from this instance of this element
 * desc_requirement - What we check to see if the examiner gets the unique description - see [examine_defines.dm]
 * desc_special - If we chose a requirement that must be supplied a list, this param is the list it uses
 * desc_affiliation - An alternate affiliation to display to to the examiner
 * hint - Whether the atom hints it may have special examine_more text on normal examine or not
 */

/datum/element/unique_examine
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// The requirement setting for special descriptions. See examine_defines.dm for more info.
	var/desc_requirement = EXAMINE_CHECK_NONE
	/// The special description that is triggered when desc_requirements are met. Make sure you set the correct EXAMINE_CHECK!
	var/special_desc = ""
	/// The special affiliation type, basically overrides the "Syndicate Affiliation" for SYNDICATE check types. It will show whatever organisation you put here instead of "Syndicate Affiliation"
	var/special_desc_affiliation = ""
	/// Everything we may want to check based on an examine check.
	/// This can be a list of JOBS, FACTIONS, SKILL CHIPS, or TRAITS, or a bitflag
	var/special_desc_req
	/// If this is a toy / the real name of the object. Toys display a message if you fail the check.
	var/toy_name

/datum/element/unique_examine/Attach(atom/thing, desc, requirement = EXAMINE_CHECK_NONE, requirement_list, affiliation, hint = TRUE, real_name = "")
	. = ..()

	desc_requirement = requirement
	special_desc = desc
	special_desc_req = requirement_list
	special_desc_affiliation = affiliation
	toy_name = real_name

	// What are we doing if we don't even have a description?
	if(!special_desc)
		stack_trace("Unique examine element attempted to attach to something without an examine text set.")
		return ELEMENT_INCOMPATIBLE

	/// If we were passed a examine check that has a requirement, check to make sure we have that requirement / it's formatted correctly
	switch(desc_requirement)
		if(EXAMINE_CHECK_TRAIT, EXAMINE_CHECK_SKILLCHIP, EXAMINE_CHECK_FACTION, EXAMINE_CHECK_JOB, EXAMINE_CHECK_SPECIES)
			if(isnull(special_desc_req))
				return ELEMENT_INCOMPATIBLE
			else if(!islist(special_desc_req))
				special_desc_req = list(special_desc_req)
		if(EXAMINE_CHECK_DEPARTMENT)
			if(isnull(special_desc_req))
				return ELEMENT_INCOMPATIBLE

	if(hint)
		RegisterSignal(thing, COMSIG_ATOM_EXAMINE, PROC_REF(hint_at))
	RegisterSignal(thing, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(examine))

/datum/element/unique_examine/Detach(atom/thing)
	. = ..()
	UnregisterSignal(thing, list(COMSIG_ATOM_EXAMINE, COMSIG_ATOM_EXAMINE_MORE))

/datum/element/unique_examine/proc/hint_at(datum/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	if(!toy_name && !get_all_fulfilled_requirements(examiner)[desc_requirement])
		return

	// What IS this thing anyways?
	var/thing = "thing"
	if(ismob(source))
		thing = "creature"
	if(isanimal(source))
		thing = "animal"
	if(ishuman(source))
		thing = "person"
	if(isobj(source))
		thing = "object"
	if(isgun(source))
		thing = "weapon"
	if(isclothing(source))
		thing = "clothing"
	if(ismachinery(source))
		thing = "machine"
	if(isstructure(source))
		thing = "structure"

	examine_list += span_smallnoticeital("This [thing] may have additional information if you [EXAMINE_CLOSER_BOLD].")

/datum/element/unique_examine/proc/examine(datum/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	var/list/fulfilled_requirements = get_all_fulfilled_requirements(examiner)
	if(!toy_name && !fulfilled_requirements[desc_requirement])
		return

	var/datum/mind/examiner_mind = examiner.mind
	if(!examiner_mind)
		return

	var/composed_message = ""
	switch(desc_requirement)
		//Will always show if set
		if(EXAMINE_CHECK_NONE)
			composed_message = "You note the following: <br>"
		//Mindshield checks
		if(EXAMINE_CHECK_MINDSHIELD)
			composed_message = "You note the following because of your [span_blue(span_bold("mindshield"))]: <br>"
		//Syndicate checks
		if(EXAMINE_CHECK_SYNDICATE)
			composed_message = "You note the following because of your [span_red(span_bold("Syndicate Affiliation"))]: <br>"
		//Aantag checks
		if(EXAMINE_CHECK_ANTAG)
			var/datum/antagonist/antag_datum = fulfilled_requirements[EXAMINE_CHECK_ANTAG]
			composed_message = "You note the following because of your [span_red(span_bold(special_desc_affiliation ? special_desc_affiliation : "[antag_datum.name] Role"))]: <br>"

		//Job (title) checks
		if(EXAMINE_CHECK_JOB)
			var/checked_job = fulfilled_requirements[EXAMINE_CHECK_JOB]
			composed_message = "You note the following because of your job as a [span_bold(checked_job)]: <br>"

		//Department checks
		if(EXAMINE_CHECK_DEPARTMENT)
			composed_message = "You note the following because of your place [get_department(special_desc_req)]: <br>"

		//Standard faction checks
		if(EXAMINE_CHECK_FACTION)
			var/checked_faction = fulfilled_requirements[EXAMINE_CHECK_FACTION]
			composed_message = "You note the following because of your loyalty to [get_formatted_faction(checked_faction)]: <br>"

		// Skillchip checks
		if(EXAMINE_CHECK_SKILLCHIP)
			var/obj/item/skillchip/checked_skillchip = fulfilled_requirements[EXAMINE_CHECK_SKILLCHIP]
			composed_message = "You note the following because of your implanted [span_readable_yellow(span_bold(checked_skillchip.name))]: <br>"

		// Trait checks
		if(EXAMINE_CHECK_TRAIT)
			composed_message = "You note the following because of a [span_readable_yellow(span_bold("trait"))] you have: <br>"

		// Species checks
		if(EXAMINE_CHECK_SPECIES)
			var/mob/living/carbon/human/human_examiner = examiner
			composed_message = "You note the following because you are a [span_green(span_bold(human_examiner.dna.species.name))]: <br>"

	if(composed_message)
		composed_message += special_desc
	else if(toy_name) //If we don't have a message and we're a toy, add on the toy message.
		composed_message = "The popular toy resembling \a [toy_name] from your local arcade, suitable for children and adults alike."
	examine_list += span_info(composed_message)

/// Check if we're any spice or variety of syndicate (antagonists, ghost roles, or special)
/datum/element/unique_examine/proc/check_if_syndicate(datum/mind/our_mind)
	if(our_mind.has_antag_datum(/datum/antagonist/traitor))
		return TRUE
	if(our_mind.has_antag_datum(/datum/antagonist/nukeop))
		return TRUE
	if(our_mind.assigned_role.faction_alignment & JOB_SYNDICATE)
		return TRUE
	if(ROLE_SYNDICATE in our_mind.current.faction)
		return TRUE

	return FALSE

// Formats some of the more common faction names into a more accurate string.
/datum/element/unique_examine/proc/get_formatted_faction(faction)
	. = faction

	switch(faction)
		if(ROLE_WIZARD)
			. = span_hypnophrase("the Wizard Federation")
		if(ROLE_SYNDICATE)
			. = span_red("the Syndicate")
		if(ROLE_ALIEN)
			. = span_alien("the alien hivemind")
		if(ROLE_NINJA)
			. = span_hypnophrase("the spider clan")
		if(FACTION_STATION)
			. = span_blue("[station_name()]")
		// I love that some factions use role defines while others use magic strings
		if("Nanotrasen")
			. = span_blue("Nanotrasen") // not necessary but keeping it here
		if("heretics")
			. = span_hypnophrase("the Mansus")
		if("cult")
			. = span_cult("Nar'sie")
		if("pirate")
			. = span_red("the Jolly Roger")
		if("plants")
			. = span_green("nature")
		if("ashwalker")
			. = span_red("the tendril")
		if("carp")
			. = span_green("space carp")

	return span_bold(.)

/// Format our department bitflag into a string.
/datum/element/unique_examine/proc/get_department(department_bitflag)
	. = "on the station"

	if(department_bitflag & DEPARTMENT_BITFLAG_COMMAND)
		. = "as a member of command staff"
	else if(department_bitflag & DEPARTMENT_BITFLAG_SECURITY)
		. = "as a member of security force"
	else if(department_bitflag & DEPARTMENT_BITFLAG_SERVICE)
		. = "in the service department"
	else if(department_bitflag & DEPARTMENT_BITFLAG_CARGO)
		. = "in the cargo bay"
	else if(department_bitflag & DEPARTMENT_BITFLAG_ENGINEERING)
		. = "as one of the engineers"
	else if(department_bitflag & DEPARTMENT_BITFLAG_SCIENCE)
		. = "in the science team"
	else if(department_bitflag & DEPARTMENT_BITFLAG_MEDICAL)
		. = "in the medical field"
	else if(department_bitflag & DEPARTMENT_BITFLAG_SILICON)
		. = "as a silicon unit"

	return span_bold(.)

/datum/element/unique_examine/proc/get_all_fulfilled_requirements(mob/examiner) as /list
	var/list/fulfilled_requirements = list(EXAMINE_CHECK_NONE = TRUE)

	var/datum/mind/examiner_mind = examiner.mind
	if(!examiner_mind)
		return fulfilled_requirements

	//Mindshield checks
	if(HAS_TRAIT(examiner, TRAIT_MINDSHIELD))
		fulfilled_requirements[EXAMINE_CHECK_MINDSHIELD] = TRUE

	//Syndicate checks
	if(check_if_syndicate(examiner_mind))
		fulfilled_requirements[EXAMINE_CHECK_SYNDICATE] = TRUE

	//Aantag checks
	for(var/antag_type in special_desc_req)
		var/datum/antagonist/antag_datum = examiner_mind.has_antag_datum(antag_type)
		if(antag_datum)
			fulfilled_requirements[EXAMINE_CHECK_ANTAG] = antag_datum
			break

	//Job (title) checks
	for(var/checked_job in special_desc_req)
		if(examiner_mind.assigned_role.title == checked_job)
			fulfilled_requirements[EXAMINE_CHECK_JOB] = checked_job
			break

	//Department checks
	if(examiner_mind.assigned_role.departments_bitflags & special_desc_req)
		fulfilled_requirements[EXAMINE_CHECK_DEPARTMENT] = TRUE

	//Standard faction checks
	for(var/checked_faction in special_desc_req)
		if(checked_faction in examiner.faction)
			fulfilled_requirements[EXAMINE_CHECK_FACTION] = checked_faction
			break

	// Skillchip checks
	var/obj/item/organ/internal/brain/examiner_brain = examiner.get_organ_slot(ORGAN_SLOT_BRAIN)
	for(var/obj/item/skillchip/checked_skillchip as anything in examiner_brain?.skillchips)
		if(checked_skillchip.active && is_type_in_list(checked_skillchip, special_desc_req))
			fulfilled_requirements[EXAMINE_CHECK_SKILLCHIP] = checked_skillchip
			break

	// Trait checks
	for(var/checked_trait in special_desc_req)
		if(HAS_TRAIT(examiner, checked_trait))
			fulfilled_requirements[EXAMINE_CHECK_TRAIT] = checked_trait
			break

	// Species checks
	for(var/checked_species in special_desc_req)
		if(is_species(examiner, checked_species))
			fulfilled_requirements[EXAMINE_CHECK_SPECIES] = checked_species
			break

	return fulfilled_requirements
