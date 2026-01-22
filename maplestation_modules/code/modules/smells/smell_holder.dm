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

/obj/effect/abstract/smell/Initialize(mapload)
	. = ..()
	if(duration)
		QDEL_IN(src, duration)
	AddElement(/datum/element/smell, smell, intensity, radius, category)

// /obj/effect/abstract/smell/gunpowder
// 	smell = "gunpowder"
// 	intensity = SMELL_INTENSITY_FAINT
// 	duration = 10 MINUTES

/obj/effect/abstract/smell/ozone
	smell = "ozone"
	category = "fragrance"
	intensity = SMELL_INTENSITY_FAINT
	duration = 10 MINUTES

/obj/effect/abstract/smell/reagent
	/// Intensity scales based on volume used and this factor
	var/volume_scale_factor = 5

/obj/effect/abstract/smell/reagent/Initialize(mapload, volume = 1)
	. = ..()
	intensity *= clamp(round(volume / volume_scale_factor, 0.1), 0.1, 1)

/obj/effect/abstract/smell/reagent/cleaning_chemicals
	smell = "cleaning chemicals"
	category = "fragrance"
	intensity = SMELL_INTENSITY_WEAK
	duration = 2 MINUTES

/obj/effect/abstract/smell/reagent/disinfectant
	smell = "disinfectant"
	category = "scent"
	intensity = SMELL_INTENSITY_MODERATE
	duration = 2 MINUTES

/obj/effect/abstract/smell/oven
	intensity = SMELL_INTENSITY_MODERATE
	duration = 5 MINUTES
	radius = 3

/obj/effect/abstract/smell/oven/good
	smell = /datum/smell/good_food

/obj/effect/abstract/smell/oven/bad
	smell = /datum/smell/burnt_food

/obj/effect/abstract/smell/cigarette_smoke
	smell = /datum/smell/cigarette_smoke
	intensity = SMELL_INTENSITY_MODERATE
	duration = 20 SECONDS
