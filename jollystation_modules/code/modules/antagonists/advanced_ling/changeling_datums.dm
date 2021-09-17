/// -- Changeling datums and additions. --
/datum/antagonist/changeling
	/// The number of changeling this changeling has uplifted using "Uplift Human".
	var/changeling_uplifts = 0

/datum/antagonist/changeling/finalize_antag()
	create_actions()
	reset_powers()
	create_initial_profile()
	owner.current.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue. We are able to transform our body after all.
	play_changeling_sound()

/// The sound that plays when our changeling is finalized.
/datum/antagonist/changeling/proc/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/// Neutered changelings, for the neuter changeling surgery.
/datum/antagonist/changeling/neutered
	name = "Neutered Changeling"
	ui_name = null
	hijack_speed = 0
	give_objectives = FALSE
	you_are_greet = FALSE
	dna_max = 1
	sting_range = 1
	chem_recharge_rate = 0.1
	chem_charges = 5
	chem_storage = 25
	total_chem_storage = 25
	geneticpoints = 1
	total_geneticspoints = 1 // You get one weak ability, make it count

	/// List of powers neutered lings are allowed to keep.
	var/list/allowed_powers = list(
		/datum/action/changeling/regenerate,
		)

/datum/antagonist/changeling/neutered/on_gain()
	. = ..()
	if(!give_objectives)
		finalize_antag()

/datum/antagonist/changeling/neutered/finalize_antag()
	. = ..()
	to_chat(owner.current, span_boldannounce("You are a neutered changeling. Most of your powers are lost, and you are but a shell of your former self."))

/datum/antagonist/changeling/neutered/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, TRUE, 36000, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/changeling/neutered/create_initial_profile()
	add_new_profile(owner.current, TRUE)

/datum/antagonist/changeling/neutered/reset_powers()
	var/list/powers = purchasedpowers
	if(powers.len)
		remove_changeling_powers()
	for(var/path in allowed_powers)
		var/datum/action/changeling/sting = new path()
		purchasedpowers += sting
		sting.on_purchase(owner.current, TRUE)


/// Fresh changeling, from the Uplift Human ability.
/datum/antagonist/changeling/fresh
	name = "Fresh Changeling"
	you_are_greet = FALSE
	show_in_antagpanel = FALSE
	give_objectives = FALSE
	soft_antag = TRUE
	/// Weakref to whoever made us into a ling
	var/datum/weakref/granter

/datum/antagonist/changeling/fresh/on_gain()
	. = ..()
	if(!give_objectives)
		finalize_antag()

/datum/antagonist/changeling/fresh/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, TRUE, 42000, pressure_affected = FALSE, use_reverb = FALSE)
