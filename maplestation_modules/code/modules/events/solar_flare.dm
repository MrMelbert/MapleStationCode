/// -- Solar flare event. spawns fire in a department. --
/datum/round_event_control/solar_flare
	name = "Solar Flare"
	category = EVENT_CATEGORY_SPACE
	typepath = /datum/round_event/solar_flare

	weight = 10
	max_occurrences = 1
	earliest_start = 20 MINUTES

/datum/round_event/solar_flare
	announce_when = 5

	/// Whether the event was announced or hidden
	var/was_announced = TRUE
	/// Time (in seconds) between flares.
	var/time_between_flares = 5
	/// Department string picked.
	var/picked_dept
	/// List of areas valid.
	var/list/area/impacted_areas

/datum/round_event/solar_flare/setup()
	start_when = rand(45, 90) // 1 == 1 second.
	end_when = start_when + rand(90, 150)
	time_between_flares += rand(-1, 1)

	var/static/list/possible_choices = list(
		DEPARTMENT_SECURITY = /area/station/security,
		DEPARTMENT_COMMAND = /area/station/command,
		DEPARTMENT_SERVICE = /area/station/service,
		DEPARTMENT_SCIENCE = /area/station/science,
		DEPARTMENT_ENGINEERING = /area/station/engineering,
		DEPARTMENT_MEDICAL = /area/station/medical,
		DEPARTMENT_CARGO = /area/station/cargo,
	)

	picked_dept = pick(possible_choices)
	impacted_areas = get_areas(picked_dept, possible_choices[picked_dept])
	message_admins("A solar flare event has triggered, targeting the [picked_dept] department.")

/datum/round_event/solar_flare/announce(fake)
	was_announced = (!fake && TRUE)
	priority_announce("[command_name()] has issued an emergency solar weather warning for your station. The afflicted area has not yet been detected. Stay alert, report any sightings of activity, and evacuate affected departments.", "Solar Weather Alert")

/datum/round_event/solar_flare/start()
	if(was_announced)
		var/detected_location = prob(30) // 30% chance that the event will reveal the location when it starts
		priority_announce("A solar weather event is ocurring over [detected_location ? "the [picked_dept]" : "an undetected"] department. [detected_location ? "" : "All crew are to locate and report the afflicted area. "]Evacuate all personnel and personal belongings from affected rooms until the weather has cleared.", "Solar Weather Alert")
	deadchat_broadcast("A <b>Solar Flare</b> event has triggered, targeting the [picked_dept] department.", message_type = DEADCHAT_ANNOUNCEMENT)

/datum/round_event/solar_flare/end()
	if(was_announced)
		priority_announce("[command_name()] has issued an all clear signal for your station. The solar weather event over the [picked_dept] department has cleared. Please return to your workplaces and resume duty.", "All Clear Alert")

/datum/round_event/solar_flare/tick()
	if(activeFor % time_between_flares != 0)
		return

	var/list/our_areas = LAZYCOPY(impacted_areas)
	for(var/i in 0 to rand(2, 4))
		if(!LAZYLEN(our_areas))
			return
		addtimer(CALLBACK(src,  PROC_REF(trigger_flare), pick_n_take(our_areas)), i SECONDS)

/**
 * Trigger a solar flare effect at a random non-dense turf in [chosen_area].
 */
/datum/round_event/solar_flare/proc/trigger_flare(area/chosen_area)
	var/turf/destination = get_valid_turf_from_area(chosen_area)
	if(!isturf(destination))
		return

	// Weight of picking each type of flare. Adds up to 100 for easy math.
	var/static/list/flare_types_to_weight = list(
		/obj/effect/solar_flare = 88,
		/obj/effect/solar_flare/large = 8,
		/obj/effect/solar_flare/emp = 4,
	)

	var/obj/effect/solar_flare/spawned_flare = pick_weight(flare_types_to_weight)
	new spawned_flare(destination, TRUE)

/**
 * Get a random non-dense turf of all the turfs in [chosen_area].
 */
/datum/round_event/solar_flare/proc/get_valid_turf_from_area(area/chosen_area)
	RETURN_TYPE(/turf)
	var/list/turf/turfs = get_area_turfs(chosen_area)

	if(!LAZYLEN(turfs))
		return null

	for(var/turf/a_turf as anything in turfs)
		if(a_turf.density)
			turfs -= a_turf

	return pick(turfs)

/**
 * Get all areas associated with a department.
 */
/datum/round_event/solar_flare/proc/get_areas(department, area/station/area_path)
	RETURN_TYPE(/list)
	var/list/area_pool = list()
	for(var/area/station/area_type as anything in subtypesof(area_path))
		if(initial(area_type.associated_department) != department)
			continue
		area_pool += area_type
	return area_pool

// Solar flare. Causes a diamond of fire centered on the initial turf.
/obj/effect/solar_flare
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	/// Max radius of the flare
	var/radius = 2
	/// Current radius we're at
	var/curr_radius = 0
	/// List of turfs we've yet to expose with the flare (via process)
	var/list/turf/turfs_to_heat
	/// List of turfs/mobs/whatever we already hit with the flare
	var/list/already_heated_things

/obj/effect/solar_flare/Initialize(mapload, admin_spawned = FALSE)
	. = ..()
	if(!isturf(loc))
		stack_trace("Solar flare initialized in a non-turf loc, what?")
		return INITIALIZE_HINT_QDEL

	turfs_to_heat = list(loc)
	START_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/magic/fireball.ogg', 60, TRUE)
	if(!admin_spawned)
		message_admins("Solar flare triggered at [ADMIN_VERBOSEJMP(loc)].")

/obj/effect/solar_flare/Destroy(force)
	LAZYCLEARLIST(turfs_to_heat)
	LAZYCLEARLIST(already_heated_things)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/solar_flare/process(seconds_per_tick)
	for(var/select_turf in turfs_to_heat)
		do_flare(select_turf)

		for(var/side_turf in get_adjacent_open_turfs(select_turf))
			if(side_turf in already_heated_things)
				continue
			turfs_to_heat |= side_turf

		turfs_to_heat -= select_turf

	if(++curr_radius > radius)
		qdel(src)

/obj/effect/solar_flare/proc/do_flare(turf/location)
	new /obj/effect/hotspot(location)

	location.hotspot_expose(clamp((1000 - curr_radius * 100), 500, 1000), clamp((250 - curr_radius * 25), 100, 250), 1)
	LAZYADD(already_heated_things, location)
	for(var/mob/living/hit_mob in location.contents)
		if(hit_mob in already_heated_things)
			continue
		LAZYADD(already_heated_things, hit_mob)
		hit_mob.apply_damage((clamp((radius - curr_radius), 0.5, 3) * 30), BURN, spread_damage = TRUE)
		hit_mob.adjust_fire_stacks(clamp(radius - curr_radius, 1, 5))
		hit_mob.ignite_mob()

// Larger flare. Double radius.
/obj/effect/solar_flare/large
	radius = 4

// Slightly larger flare, comes with added EMP action, but much rarer
// Heaviest area of the EMP are in the very center of the flare
/obj/effect/solar_flare/emp
	radius = 3

/obj/effect/solar_flare/emp/do_flare(turf/location)
	. = ..()
	empulse(location, round(radius / 3), radius)
