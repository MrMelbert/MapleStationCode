// -- Resource drift event --
// Spawns a bunch of crates and space dust and yeets them towards the station (sometimes)

/// Defines for how much debris we're throwing at them
#define NO_DEBRIS 0
#define MINOR_DEBRIS 1
#define MAJOR_DEBRIS 2

/datum/round_event_control/resource_drift
	name = "Resource Drift"
	typepath = /datum/round_event/resource_drift
	weight = 18
	max_occurrences = 3
	earliest_start = 5 MINUTES

/datum/round_event/resource_drift
	/// The number of caches that spawn
	var/num_caches = 1
	/// Amount of debris that spawns.
	var/amt_debris = NO_DEBRIS
	/// All subtypes of normal resource_caches
	var/static/list/possible_crates = list()
	/// Crates we're throwing
	var/list/obj/structure/closet/crate/picked_crates = list()

/datum/round_event/resource_drift/announce(fake)
	priority_announce("[get_source()] Expect [get_debris()][num_caches - rand(1, 2)] to [num_caches + rand(1, 3)] caches of resources to drift near your station soon.", "Nanotrasen News Network")

/datum/round_event/resource_drift/setup()
	startWhen = rand(40, 60)
	possible_crates = subtypesof(/obj/structure/closet/crate/resource_cache/normal)

	num_caches = rand(3, 8)

	// More crates = more debris
	switch(num_caches)
		if(5 to 10)
			amt_debris = MAJOR_DEBRIS
		if(3 to 5)
			amt_debris = MINOR_DEBRIS
		else
			amt_debris = NO_DEBRIS

	if(!possible_crates.len)
		CRASH("Resource drift: No list of possible crates found.")

	// Get our list of crates
	for(var/i in 1 to num_caches)
		picked_crates += pick(possible_crates)

/datum/round_event/resource_drift/start()
	/// The possible spawn locs for our crates
	var/list/spawn_locations = list()
	for(var/obj/effect/landmark/carpspawn/spawns in GLOB.landmarks_list)
		if(isturf(spawns.loc))
			spawn_locations += spawns.loc
	if(!spawn_locations.len)
		return MAP_ERROR
	if(!picked_crates.len)
		CRASH("Resource drift: No list of picked crates found.")

	// Spawn some debris (space dust) in based on the number of caches we're throwing.
	// In the future this can be buffed up a bit but space dust is laggy.
	spawn_meteors(num_caches * amt_debris, GLOB.meteorsC)

	// Now, spawn the caches and yeet them towards the station
	for(var/crate in picked_crates)
		addtimer(CALLBACK(src, .proc/spawn_and_throw_crate, crate, pick_n_take(spawn_locations)), (4 SECONDS * num_caches--))

/*
 * Spawns the supplied crate path [selected_cache_path] at [spawn_loc].
 * After being spawned, the crate is thrown towards a random human, or a communications console if there are no humans.
 */
/datum/round_event/resource_drift/proc/spawn_and_throw_crate(obj/structure/closet/crate/resource_cache/selected_cache_path, spawn_loc)
	var/obj/structure/closet/crate/resource_cache/selected_cache = new selected_cache_path(spawn_loc)
	log_game("EVENT: Resource crate spawned at [ADMIN_VERBOSEJMP(selected_cache.loc)].")

	// If we just spawned the crates in space they'd be impossible to find, let's throw em!
	/// The target we're throwing at
	var/atom/target
	// Pick a random human and chuck it towards them
	//won't reach them in 99% of circumstances but gives a little variance to where they end up (even throwing some off the z level)
	for(var/mob/living/carbon/human/H in shuffle(GLOB.alive_mob_list))
		if(H.z == selected_cache.z)
			target = H
			break
	// If there's no mobs somehow then let's just chuck it towards the comms consoles (center mass, usually)
	if(!target)
		for(var/obj/machinery/computer/communications/console in GLOB.machines)
			if(console.z == selected_cache.z)
				target = console
				break
	// If, SOMEHOW, there are no humans and no comms consoles on the station, send it towards observer spawn (middle of the station)
	if(!target)
		target = (locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list)
	// Toss it with big range and okay speed at the target
	selected_cache.throw_at(target, 200, 2)

/*
 * Generate a "source event" / reason as to why the crates and debris are spawning.
 */
/datum/round_event/resource_drift/proc/get_source()
	var/list/parties = strings(COMPANY_FILE, "companies")
	parties += list("Space Station [rand(1, 12)]", "Space Station [rand(14, 99)]", "raider", "pirate")

	. = pick_list(RESOURCE_EVENT_FILE, "drift_reasons")
	. = replacetext(., "$party_one", pick_n_take(parties))
	. = replacetext(., "$party_two", pick_n_take(parties))

/*
 * Picks a adjective describing the amount of debris being thrown and returns it.
 */
/datum/round_event/resource_drift/proc/get_debris()
	switch(amt_debris)
		if(NO_DEBRIS)
			return ""
		if(MINOR_DEBRIS)
			return "minor space dust, potential debris, and "
		if(MAJOR_DEBRIS)
			return "space dust, debris, and "

#undef NO_DEBRIS
#undef MINOR_DEBRIS
#undef MAJOR_DEBRIS
