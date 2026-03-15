/// Dummy atom to use for a smell that persists in an area
/obj/effect/abstract/smell
	invisibility = INVISIBILITY_MAXIMUM
	/// Smell text or typepath
	var/smell
	/// Smell category
	var/category
	/// How strong the smell is
	var/intensity = 1
	/// How big the smell radius is
	var/radius = 2
	/// Optional, duration of the smell effect
	var/duration
	/// If TRUE, the smell's intensity will fade over its duration, otherwise it will disappear after the duration ends
	var/fade_intensity_over_time = FALSE

	/// If TRUE, immediately has nearby mobs take a "smell"
	/// Primarily for scents that serve a gameplay purpose rather than just ambiance
	var/force_smell = FALSE

/obj/effect/abstract/smell/Initialize(mapload)
	. = ..()
	if(ismovable(loc))
		apply_to_loc(arglist(length(args) >= 2 ? args.Copy(2) : list()))
		. = INITIALIZE_HINT_QDEL
	else if(isnull(loc))
		. = INITIALIZE_HINT_QDEL
	else
		if(duration && duration != INFINITY)
			QDEL_IN(src, duration)

		if(fade_intensity_over_time)
			AddComponent(/datum/component/complex_smell, \
				duration = duration, \
				smell = smell, \
				intensity = intensity, \
				radius = radius, \
				category = category, \
				fade_intensity_over_time = TRUE, \
			)
		else
			AddElement(/datum/element/simple_smell, \
				smell = smell, \
				intensity = intensity, \
				radius = radius, \
				category = category, \
			)

	if(force_smell)
		for(var/mob/living/smeller in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, get_turf(src)))
			smeller.smell_something()


/obj/effect/abstract/smell/proc/apply_to_loc(...)
	loc.AddComponent( \
		/datum/component/complex_smell, \
		duration = src.duration, \
		smell = src.smell, \
		intensity = src.intensity, \
		radius = src.radius, \
		category = src.category, \
		fade_intensity_over_time = src.fade_intensity_over_time, \
	)

// /obj/effect/abstract/smell/gunpowder
// 	smell = "gunpowder"
// 	intensity = SMELL_INTENSITY_FAINT
// 	duration = 10 MINUTES

/obj/effect/abstract/smell/ozone
	smell = "ozone"
	category = "fragrance"
	intensity = SMELL_INTENSITY_FAINT
	duration = 20 SECONDS

/obj/effect/abstract/smell/ozone/lingering
	duration = 10 MINUTES
	fade_intensity_over_time = TRUE

/obj/effect/abstract/smell/reagent
	/// Intensity scales based on volume used and this factor. Cannot exceed base intensity
	/// Think of this in terms of "You need at least vol/x units to get the full effect"
	var/volume_intensity_scale = 0.2
	/// Duration scales based on volume used and this factor. Cannot exceed base duration
	/// Think of this in terms of "You need at least vol/x units to get the full duration"
	var/volume_duration_scale = 1

/obj/effect/abstract/smell/reagent/Initialize(mapload, volume)
	if(isnum(volume))
		intensity *= clamp(round(volume * volume_intensity_scale, 0.1), 0.1, 1)
		duration *= clamp(round(volume * volume_duration_scale, 0.1), 0.1, 1)
	return ..()

/obj/effect/abstract/smell/reagent/cleaning_chemicals
	smell = "cleaning chemicals"
	category = "fragrance"
	intensity = SMELL_INTENSITY_WEAK
	duration = 2 MINUTES

/obj/effect/abstract/smell/reagent/lube
	name = "cherry"
	category = "fragrance"
	intensity = SMELL_INTENSITY_WEAK
	duration = 2 MINUTES

/obj/effect/abstract/smell/reagent/disinfectant
	smell = "disinfectant"
	category = "scent"
	intensity = SMELL_INTENSITY_MODERATE
	duration = 2 MINUTES

/obj/effect/abstract/smell/reagent/perfume
	smell = "perfume"
	category = "fragrance"
	intensity = SMELL_INTENSITY_WEAK
	duration = 30 MINUTES
	volume_intensity_scale = 0.5
	volume_duration_scale = 0.5

/obj/effect/abstract/smell/reagent/perfume/Initialize(mapload, volume, smell = "perfume")
	src.smell = smell
	return ..()

// holder for a plant emitting a smell
/obj/effect/abstract/smell/plant
	duration = 20 SECONDS

/obj/effect/abstract/smell/plant/Initialize(mapload, smell, category, intensity, radius)
	src.smell = smell
	src.category = category
	src.intensity = intensity
	src.radius = radius
	return ..()

/obj/effect/abstract/smell/oven
	intensity = SMELL_INTENSITY_MODERATE
	duration = 5 MINUTES
	radius = 6
	force_smell = TRUE

/obj/effect/abstract/smell/oven/good
	smell = /datum/smell/good_food

/obj/effect/abstract/smell/oven/bad
	smell = /datum/smell/burnt_food

/obj/effect/abstract/smell/oven/bad/fryer
	smell = /datum/smell/burnt_food/fryer

/obj/effect/abstract/smell/cigarette_smoke
	smell = /datum/smell/cigarette_smoke
	intensity = SMELL_INTENSITY_MODERATE * 0.5
	duration = 20 SECONDS

/obj/effect/abstract/smell/cigarette_smoke/lingering
	intensity = SMELL_INTENSITY_WEAK
	duration = 2 MINUTES
	fade_intensity_over_time = TRUE

/obj/effect/abstract/smell/cigarette_smoke/lingering/longer
	intensity = SMELL_INTENSITY_WEAK
	duration = 8 MINUTES
	fade_intensity_over_time = TRUE
