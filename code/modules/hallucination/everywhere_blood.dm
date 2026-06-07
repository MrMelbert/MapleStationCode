/datum/hallucination/everywhere_blood
	hallucination_tier = HALLUCINATION_TIER_RARE
	/// List of images created
	VAR_PRIVATE/list/blood_images
	/// X coord of where the hallucination started
	VAR_PRIVATE/start_x = -1
	/// Y coord of where the hallucination started
	VAR_PRIVATE/start_y = -1
	/// Radius of the effect
	var/radius = 12

/datum/hallucination/everywhere_blood/Destroy()
	hallucinator.client.images -= blood_images
	return ..()

/datum/hallucination/everywhere_blood/start()
	if(!hallucinator.client)
		return FALSE

	var/list/splattered_atoms = list()
	for(var/atom/nearby in urange(radius, hallucinator))
		if(prob(5))
			continue
		var/dist = get_dist(nearby, hallucinator)
		if(prob((dist - 10) * 25))
			continue
		if(!splatterable_atom(nearby))
			continue
		splattered_atoms |= HAS_TRAIT(nearby, TRAIT_WALLMOUNTED) ? get_step(nearby, nearby.dir) : nearby

	if(!length(splattered_atoms))
		return FALSE

	start_x = hallucinator.x
	start_y = hallucinator.y
	var/obj/effect/decal/cleanable/blood/pre_dna/copy_from = new()

	blood_images = list()
	for(var/atom/to_splatter as anything in splattered_atoms)
		var/image/blood_image = image(
			icon = copy_from.icon,
			icon_state = pick(copy_from.random_icon_states),
			loc = to_splatter,
		)
		blood_image.color = copy_from.get_blood_dna_color()
		// blood_image.plane = SET_PLANE_EXPLICIT(blood_image, copy_from.plane, to_splatter)
		blood_image.plane = to_splatter.plane
		blood_image.layer = to_splatter.layer + 0.1
		blood_image.alpha = 0
		animate(blood_image, alpha = 50, time = (rand(5, 8) SECONDS))
		animate(alpha = 200, time = 0.5 SECONDS, easing = ELASTIC_EASING)
		animate(alpha = 50, time = 0.2 SECONDS)
		animate(alpha = 100, time = (rand(5, 8) SECONDS))
		animate(alpha = 200, time = 0.5 SECONDS, easing = ELASTIC_EASING)
		animate(alpha = 100, time = 0.2 SECONDS)
		animate(alpha = 150, time = (rand(5, 8) SECONDS))
		animate(alpha = 200, time = 0.5 SECONDS, easing = ELASTIC_EASING)
		animate(alpha = 150, time = 0.2 SECONDS)
		animate(alpha = 250, time = (rand(5, 8) SECONDS))
		blood_images += blood_image

	qdel(copy_from)
	hallucinator.client.images += blood_images
	addtimer(CALLBACK(src, PROC_REF(stop)), rand(60, 90) SECONDS, TIMER_DELETE_ME)
	RegisterSignal(hallucinator, COMSIG_MOVABLE_MOVED, PROC_REF(check_distance))
	return TRUE

/datum/hallucination/everywhere_blood/proc/stop()
	SIGNAL_HANDLER
	for(var/image/blood_image as anything in blood_images)
		animate(blood_image, alpha = 0, time = 7 SECONDS)
	QDEL_IN(src, 8 SECONDS)

/datum/hallucination/everywhere_blood/proc/check_distance(datum/source, atom/movable/moved_atom)
	SIGNAL_HANDLER
	if(hallucinator_too_far())
		qdel(src)

/// Checks if we leave range of the furthest point of the hallucination, cancels it if so.
/datum/hallucination/everywhere_blood/proc/hallucinator_too_far()
	if(hallucinator.x > start_x + (radius + 10))
		return TRUE
	if(hallucinator.x < start_x - (radius + 10))
		return TRUE
	if(hallucinator.y > start_y + (radius + 8))
		return TRUE
	if(hallucinator.y < start_y - (radius + 8))
		return TRUE
	return FALSE

/datum/hallucination/everywhere_blood/proc/splatterable_atom(atom/what)
	if(isfloorturf(what))
		return TRUE
	if(!isobj(what))
		return FALSE
	if(what.invisibility > hallucinator.see_invisible || HAS_TRAIT(what, TRAIT_UNDERFLOOR))
		return FALSE
	var/obj/objwhat = what
	if(istype(objwhat, /obj/structure/window))
		return TRUE
	if(!objwhat.anchored)
		return FALSE
	if(!objwhat.density)
		return TRUE
	if(objwhat.pass_flags_self & PASSMACHINE)
		return TRUE
	return FALSE
