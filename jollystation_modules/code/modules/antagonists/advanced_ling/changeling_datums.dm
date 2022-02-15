/// -- Changeling datums and additions. --
/datum/antagonist/changeling
	/// Whether we give innates to this ling.
	var/give_innates = TRUE
	/// Our changeling ID.
	var/changeling_id
	/// Whether this changeling can talk in the hivemind.
	/// Fresh / neutered changelings need to have the hivemind awoken by another ling.
	var/hivemind_link_awoken = TRUE
	/// The number of changeling this changeling has uplifted using "Uplift Human".
	var/changeling_uplifts = 0

/datum/antagonist/changeling/on_gain()
	. = ..()
	if(!changeling_id)
		generate_name()

/datum/antagonist/changeling/finalize_antag()
	owner.current.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue. We are able to transform our body after all.
	create_emporium()
	if(give_innates)
		create_innate_actions()
	create_initial_profile()
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
/datum/antagonist/changeling/neutered
	name = "Neutered Changeling"
	ui_name = null
	hijack_speed = 0
	give_objectives = FALSE
	hivemind_link_awoken = FALSE
	antag_moodlet = /datum/mood_event/fallen_changeling
	dna_max = 1
	sting_range = 1
	chem_recharge_rate = 0.1
	chem_charges = 5
	total_chem_storage = 25
	genetic_points = 1
	total_genetic_points = 1 // You get one weak ability, make it count

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

/datum/antagonist/changeling/neutered/create_innate_actions()
	for(var/action in allowed_powers)
		var/datum/action/changeling/innate_ability = new action()
		innate_powers += innate_ability
		innate_ability.on_purchase(owner.current, TRUE)

/datum/antagonist/changeling/neutered/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was <b>[changeling_id]</b>, a changeling who had their powers neutered!"

	return result.Join("<br>")

/datum/antagonist/fallen_changeling
	show_in_antagpanel = FALSE
	soft_antag = TRUE
	/// Our changeling ID before we lost everything.
	var/previous_changeling_id = ""
	/// Weakref to the mind of the changeling that stole our powers.
	var/datum/weakref/changeling_who_robbed_us

/datum/antagonist/fallen_changeling/roundend_report()
	var/list/result = list()

	var/datum/mind/robber_mind = changeling_who_robbed_us?.resolve()
	var/datum/antagonist/changeling/robber_ling_datum = robber_mind?.has_antag_datum(/datum/antagonist/changeling)

	result += printplayer(owner)
	if(robber_ling_datum)
		result += "<b>[owner]</b> was <b>[previous_changeling_id]</b>, a changeling who had their powers stolen by <b>[robber_ling_datum.changeling_id]</b> ([robber_mind])!"
	else
		result += "<b>[owner]</b> was <b>[previous_changeling_id]</b>, a changeling who had their powers stolen!"

	return result.Join("<br>")

/// Fresh changeling, from the Uplift Human ability.
/datum/antagonist/changeling/fresh
	name = "Fresh Changeling"
	show_in_antagpanel = FALSE
	give_objectives = FALSE
	give_innates = FALSE
	soft_antag = TRUE
	hivemind_link_awoken = FALSE
	/// Weakref to a mob of whoever made us into a ling
	var/datum/weakref/granter

/datum/antagonist/changeling/fresh/play_changeling_sound()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, TRUE, 42000, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/changeling/fresh/create_innate_actions(datum/antagonist/changeling/learn_from)
	if(!istype(learn_from))
		return ..()

	for(var/datum/action/changeling/ling_action as anything in learn_from.innate_powers)
		var/datum/action/changeling/new_innate_ability = new ling_action.type()
		innate_powers += new_innate_ability
		new_innate_ability.on_purchase(owner.current, TRUE)

/datum/antagonist/changeling/fresh/roundend_report()
	var/list/result = list()

	var/datum/mind/parent_ling = granter?.resolve()
	var/datum/antagonist/changeling/parent_ling_datum = parent_ling?.has_antag_datum(/datum/antagonist/changeling)

	result += printplayer(owner)
	result += "<b>[owner]</b> was <b>[changeling_id]</b>, a freshly born changeling created by <b>[parent_ling_datum.changeling_id]</b> ([parent_ling])."

	return result.Join("<br>")

/// UI pinpointer that directs a fresh changeling to the hive leader.
/datum/status_effect/agent_pinpointer/changeling_spawn
	alert_type = /atom/movable/screen/alert/status_effect/agent_pinpointer/changeling_spawn
	tick_interval = CHANGELING_PHEROMONE_PING_TIME
	minimum_range = 0
	range_fuzz_factor = 0

/datum/status_effect/agent_pinpointer/changeling_spawn/scan_for_target()
	var/datum/antagonist/changeling/fresh/our_ling_datum = is_fresh_changeling(owner)
	var/datum/mind/our_parent_mind = our_ling_datum?.granter?.resolve()
	var/mob/living/our_living_parent = our_parent_mind.current
	scan_target = (istype(our_living_parent) ? our_living_parent : null)

/atom/movable/screen/alert/status_effect/agent_pinpointer/changeling_spawn
	name = "Hive Lead Scent"
	desc = "Points to the person who inducted us into the hive."
