/// -- Changeling datums and additions. --
/datum/antagonist/changeling
	/// Whether this changeling can talk in the hivemind.
	/// Fresh / neutered changelings need to have the hivemind awoken by another ling..
	var/hivemind_link_awoken = TRUE
	/// The number of changeling this changeling has uplifted using "Uplift Human".
	var/changeling_uplifts = 0
	/// Our changeling ID.
	var/changeling_id

/datum/antagonist/changeling/on_gain()
	. = ..()
	if(!changeling_id)
		generate_name()

/datum/antagonist/changeling/finalize_antag()
	create_actions()
	reset_powers()
	create_initial_profile()
	owner.current.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue. We are able to transform our body after all.
	play_changeling_sound()
	if(hivemind_link_awoken)
		to_chat(owner.current, span_bold(span_changeling("You can communicate in the changeling hivemind using \"[MODE_TOKEN_CHANGELING]\".")))

/// The sound that plays when our changeling is finalized.
/datum/antagonist/changeling/proc/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/// Generate a changeling name for our ling, if they don't have their own.
/datum/antagonist/changeling/proc/generate_name()
	var/honorific
	if(owner.current.gender == FEMALE)
		honorific = "Ms."
	else if(owner.current.gender == MALE)
		honorific = "Mr."
	else
		honorific = "Mx."

	if(GLOB.possible_abductor_names.len)
		changeling_id = "[honorific] [pick_n_take(GLOB.possible_abductor_names)]"
	else
		changeling_id = "[honorific] [rand(1, 999)]"

/datum/antagonist/changeling/headslug
	hivemind_link_awoken = FALSE

/// Neutered changelings, for the neuter changeling surgery.
/datum/antagonist/changeling/neutered // MELBERT TODO; roundend report
	name = "Neutered Changeling"
	ui_name = null
	hijack_speed = 0
	give_objectives = FALSE
	you_are_greet = FALSE
	hivemind_link_awoken = FALSE
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
/datum/antagonist/changeling/fresh // MELBERT TODO; roundend report
	name = "Fresh Changeling"
	you_are_greet = FALSE
	show_in_antagpanel = FALSE
	give_objectives = FALSE
	soft_antag = TRUE
	hivemind_link_awoken = FALSE
	/// Weakref to whoever made us into a ling
	var/datum/weakref/granter

/datum/antagonist/changeling/fresh/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, TRUE, 42000, pressure_affected = FALSE, use_reverb = FALSE)

/// UI pinpointer that directs a fresh changeling to the hive leader.
/datum/status_effect/agent_pinpointer/changeling_spawn
	alert_type = /atom/movable/screen/alert/status_effect/agent_pinpointer/changeling_spawn
	tick_interval = CHANGELING_PHEROMONE_PING_TIME
	minimum_range = 0
	range_fuzz_factor = 0

/datum/status_effect/agent_pinpointer/changeling_spawn/scan_for_target()
	var/datum/antagonist/changeling/fresh/our_ling_datum = owner.mind?.has_antag_datum(/datum/antagonist/changeling/fresh)
	scan_target = our_ling_datum?.granter?.resolve()

/atom/movable/screen/alert/status_effect/agent_pinpointer/changeling_spawn
	name = "Hive Lead Scent"
	desc = "Points to the person who inducted us into the hive."
