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

/datum/reagent/perfume/on_new(list/new_data)
	if(!length(new_data) || !islist(new_data["perfume_smell"]))
		new_data ||= list()
		new_data["perfume_smell"] = list("perfume" = volume)

	return ..()

/datum/reagent/perfume/on_merge(list/new_data, amount)
	if(!length(new_data) || !islist(new_data["perfume_smell"]))
		return

	for(var/new_smell in new_data["perfume_smell"])
		data["perfume_smell"][new_smell] += amount

/datum/reagent/perfume/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	for(var/smell, smell_volume in data["perfume_smell"])
		new /obj/effect/abstract/smell/reagent/perfume(exposed_turf, smell_volume, smell)

/datum/reagent/perfume/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(!(methods & (TOUCH|VAPOR)) || QDELETED(exposed_mob))
		return
	for(var/smell, smell_volume in data["perfume_smell"])
		new /obj/effect/abstract/smell/reagent/perfume(exposed_mob, smell_volume, smell)
