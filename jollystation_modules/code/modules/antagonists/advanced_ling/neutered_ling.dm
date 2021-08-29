/// Neutered changeling, basically changelings who can't do much of anything anymore.
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
	geneticpoints = 2
	total_geneticspoints = 2 // You get one or two abilities, max

	/// List of powers neutered lings are stuck with.
	var/static/list/allowed_powers = list(
		/datum/action/changeling/fakedeath,
		/datum/action/changeling/regenerate
		)

/datum/antagonist/changeling/neutered/on_gain()
	. = ..()
	finalize_antag()

/datum/antagonist/changeling/neutered/create_initial_profile()
	add_new_profile(owner.current, TRUE)

/datum/antagonist/changeling/neutered/reset_powers()
	if(purchasedpowers)
		remove_changeling_powers()
	for(var/path in allowed_powers)
		var/datum/action/changeling/sting = new path()
		purchasedpowers += sting
		sting.on_purchase(owner.current, TRUE)

/datum/antagonist/changeling/neutered/greet()
	to_chat(owner.current, span_boldannounce("You are a neutered changeling. Most of your powers are lost, and you are but a shell of your former self."))
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	/// MELBERT TODO; Make this playsound sound sad
