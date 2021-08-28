// -- Resource drift event --
/// This event spawns multiple cargo pods containing a few resources.
/datum/round_event_control/resource_pods
	name = "Resource Pods"
	typepath = /datum/round_event/resource_pods
	// Relatively common, can start early
	weight = 25
	max_occurrences = 4
	earliest_start = 5 MINUTES

/datum/round_event/resource_pods
	/// The source of the resources (a short descriptive string)
	var/source
	/// The number of pods
	var/num_pods = 1
	/// The style the pod uses
	var/pod_style = STYLE_STANDARD
	/// The area the pods are landing in
	var/area/impact_area
	/// The list of possible crates to draw from
	var/static/list/possible_crates = list()
	/// The list of crates we're spawning
	var/list/obj/structure/closet/crate/picked_crates = list()
	/// Crates guaranteed to spawn with the pods
	var/list/obj/structure/closet/crate/priority_crates = list()

/datum/round_event/resource_pods/announce(fake)
	switch(pod_style)
		if(STYLE_SYNDICATE)
			priority_announce("A recent raid on a [source] in your sector resulted in a [get_num_pod_identifier()] of resources confiscated by Nanotrasen strike team personnel. \
							Given the occurance of the raid in your sector, we're sharing [num_pods] of the resource caches. They'll arrive shortly in: [impact_area.name].", "Nanotrasen News Network")
		if(STYLE_CENTCOM)
			priority_announce("Recent company activity [source] in your sector resulted in a [get_num_pod_identifier()] of resources obtained by Nanotrasen shareholders. \
							[num_pods] of the resource caches are being shared with your station as an investment. They'll arrive shortly in: [impact_area.name].", "Nanotrasen News Network")
		else
			priority_announce("A [source] has passed through your sector, dropping off a [get_num_pod_identifier()] of resources at central command. \
							[num_pods] of the resource caches are being shared with your station. They'll arrive shortly in: [impact_area.name].", "Nanotrasen News Network")

/datum/round_event/resource_pods/setup()
	startWhen = rand(10, 25)
	impact_area = find_event_area()
	if(!impact_area)
		stack_trace("Resource pods: No valid areas for cargo pod found.")
		return MAP_ERROR
	var/list/turf_test = get_valid_turfs(impact_area)
	if(!turf_test.len)
		stack_trace("Resource pods: No valid turfs found for [impact_area] - [impact_area.type]")
		return MAP_ERROR

	// Decide how many pods we're sending.
	num_pods = rand(2, 5)

	// Get a random style of the pod. Different styles have different potential crates and reports.
	switch(rand(1, 100))
		if(1 to 24)
			pod_style = STYLE_SYNDICATE
			source = get_syndicate_sources()
		if(25 to 69)
			pod_style = STYLE_CENTCOM
			source = get_nanotrasen_sources()
		if(70 to 95)
			pod_style = STYLE_STANDARD
			source = get_company_sources()
		if(96 to 100)
			pod_style = STYLE_CULT
			source = "Nanotrasen inquisitor mission, investigating traces of [pick("Nar'sian", "Wizard Federation")] influence,"

	//Clear and reset the list.
	possible_crates.Cut()

	// All subtypes of normal resource_caches
	possible_crates = subtypesof(/obj/structure/closet/crate/resource_cache/normal)
	// Add in extra subtypes based on the type of pod we have.
	switch(pod_style)
		if(STYLE_SYNDICATE)
			possible_crates += subtypesof(/obj/structure/closet/crate/resource_cache/syndicate)
		if(STYLE_CENTCOM)
			possible_crates += subtypesof(/obj/structure/closet/crate/resource_cache/centcom)
		if(STYLE_STANDARD)
			possible_crates += subtypesof(/obj/structure/closet/crate/resource_cache/special)
			if(source == "Lizard Empire trade route")
				priority_crates += /obj/structure/closet/crate/resource_cache/lizard_things
		if(STYLE_CULT)
			priority_crates += /obj/structure/closet/crate/resource_cache/magic_things

	if(!possible_crates.len)
		CRASH("Resource pods: No list of possible crates found.")

	for(var/i in 1 to num_pods)
		if(priority_crates.len)
			picked_crates.Add(pick_n_take(priority_crates))
		else
			picked_crates.Add(pick(possible_crates))

/datum/round_event/resource_pods/start()
	var/list/turf/valid_turfs = get_valid_turfs(impact_area)
	for(var/crate in picked_crates)
		var/turf/landing_turf
		// Try to use a different turf for each crate, but if we don't have enough turfs for all our crates, we double up
		if(valid_turfs.len >= picked_crates.len)
			landing_turf = pick_n_take(valid_turfs)
		else
			landing_turf = pick(valid_turfs)

		addtimer(CALLBACK(src, .proc/launch_pod, landing_turf, crate), (2 SECONDS * num_pods--))

/*
 * Launch the supplied crate path [crate] via pod to the target turf [landing_turf].
 *
 * landing_turf - reference to a turf that we're targeting with our pod
 * crate - a path of something, normally a crate, that gets instantiated and launched via pod
 */
/datum/round_event/resource_pods/proc/launch_pod(turf/landing_turf, obj/structure/closet/crate/crate)
	var/obj/structure/closet/crate/spawned_crate = new crate()
	var/obj/structure/closet/supplypod/pod = new
	pod.setStyle(pod_style)
	pod.explosionSize = list(0, 0, 1, 2)
	var/new_desc = "A standard-style drop pod dropped by the company directly to your station."
	switch(pod_style)
		if(STYLE_SYNDICATE)
			new_desc = "A syndicate-style drop pod reposessed by a Nanotrasen strike force and redirected directly to your station."
		if(STYLE_CENTCOM)
			new_desc = "A nanotrasen-style drop pod dropped by the company directly to your station."

	pod.desc = new_desc
	log_game("EVENT: A pod containing a [spawned_crate.type] was launched at [loc_name(landing_turf)].")

	new /obj/effect/pod_landingzone(landing_turf, pod, spawned_crate)

/*
 * Finds a valid area for our event to fire.
 * We avoid places that pod explosions can cause critical infrastructre damage.
 *
 * returns the area our event will fire in.
 */
/datum/round_event/resource_pods/proc/find_event_area()
	var/static/list/allowed_areas
	if(!allowed_areas)
		///Places that we shouldn't send crates.
		var/list/safe_area_types = typecacheof(list(
			/area/maintenance,
			/area/tcommsat,
			/area/ai_monitored,
			/area/engineering/supermatter,
			/area/shuttle,
			/area/solars,
		))

		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types

	var/list/possible_areas = typecache_filter_list(GLOB.sortedAreas,allowed_areas)
	if (length(possible_areas))
		var/chosen_area = pick(possible_areas)
		while(possible_areas)
			chosen_area = pick_n_take(possible_areas)
			if(length(get_valid_turfs(chosen_area)) >= num_pods)
				break
		return chosen_area

/*
 * Returns a list of all turfs in the area [found_area] that have no dense objects within the tile.
 */
/datum/round_event/resource_pods/proc/get_valid_turfs(area/found_area)
	var/list/turf/valid_turfs = get_area_turfs(found_area)
	for(var/turf/chosen_turf as anything in valid_turfs)
		if(chosen_turf.density)
			valid_turfs -= chosen_turf
			continue
		for(var/atom/blocker as anything in chosen_turf)
			if(blocker.density)
				valid_turfs -= chosen_turf
				break

	return valid_turfs

/*
 * Picks a Syndicate-related "source" of the pods based on the number of pods that are being sent and returns it.
 */
/datum/round_event/resource_pods/proc/get_syndicate_sources()
	if(num_pods >= 4)
		return pick(
			"Syndicate base",
			"Syndicate trade route",
			"Cybersun industries research facility",
			"Gorlex fortification",
			"Donk Co. Factory",
			"Waffle Co. Factory",
			)
	else
		return pick(
			"Syndicate outpost",
			"Syndicate trade route",
			"Gorlex staging post",
			"Cybersun research expedition",
			"Syndicate distribution post",
			)

/*
 * Picks a Nanotrasen-related "source" of the pods based on the number of pods that are being sent and returns it.
 */
/datum/round_event/resource_pods/proc/get_nanotrasen_sources()
	if(num_pods >= 4)
		return pick(
			"establishing trade routes",
			"crypto-currency mining",
			"conducting plasma research",
			"gas-giant siphoning",
			"solar-energy farming",
			"pulsar ray gathering",
			)
	else
		return pick(
			"asteroid mining",
			"moon drilling",
			"crypto-currency mining",
			"rare-mineral smelting",
			"solar-energy farming",
			)

/*
 * Picks a random, neutral "source" of the pods and returns it.
 */
/datum/round_event/resource_pods/proc/get_company_sources()
	return pick(
		"TerraGov trade route",
		"Space Station [rand(1, 12)] supply shuttle",
		"Space Station [rand(14, 99)] supply shuttle",
		"Waffle Co. goods shuttle", "Donk Co. goods shuttle",
		"Spinward Stellar Coalition relief ship",
		"Lizard Empire trade route",
		"Ethereal trade caravan",
		"Mothperson trade caravan",
		"Civilian trade caravan",
		)

/*
 * Picks a adjective describing the number of pods being sent and returns it.
 */
/datum/round_event/resource_pods/proc/get_num_pod_identifier()
	switch(num_pods)
		if(1)
			return "small amount"
		if(2)
			return "middling amount"
		if(3)
			return "moderate amount"
		if(4)
			return "large amount"
		if(5)
			return "wealthy amount"
		else
			return "number"
