/obj/item/reagent_containers/spray/perfume
	name = "perfume bottle"
	slot_flags = NONE
	w_class = WEIGHT_CLASS_TINY

	can_toggle_range = FALSE
	current_range = 1
	spray_range = 1
	volume = 10
	amount_per_transfer_from_this = 2
	possible_transfer_amounts = list(1, 2)
	can_fill_from_container = FALSE

/obj/item/reagent_containers/spray/perfume/Initialize(mapload, vol)
	. = ..()
	reagents.add_reagent(/datum/reagent/perfume, volume)
	transform = transform.Scale(0.5, 0.5)

/datum/reagent/perfume
	name = "Perfume"
	description = "A sweet-smelling liquid that is used to make things smell nicer."
	reagent_state = LIQUID
	color = "#bb8bbb"
	taste_description = "perfume"
	ph = 6.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// What type of smell to produce when exposed
	var/obj/effect/abstract/smell/smell_type = /obj/effect/abstract/smell/reagent/perfume

/datum/reagent/perfume/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	new smell_type(exposed_turf, reac_volume)

/datum/reagent/perfume/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || QDELETED(exposed_mob))
		return
	new smell_type(exposed_mob, reac_volume)
