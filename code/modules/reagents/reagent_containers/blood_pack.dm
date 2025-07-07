// NON-MODULE CHANGE : This whole file
/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Must be attached to an IV drip."
	icon = 'icons/obj/medical/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200
	var/blood_type = null
	var/labelled = FALSE
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

/obj/item/reagent_containers/blood/Initialize(mapload, vol)
	. = ..()
	if(!isnull(blood_type))
		var/datum/blood_type/blood = find_blood_type(blood_type)
		reagents.add_reagent(blood.reagent_type, 200, list("blood_type" = blood_type))
		update_appearance()

/// Handles updating the container when the reagents change.
/obj/item/reagent_containers/blood/on_reagent_change(datum/reagents/holder, ...)
	blood_type = null

	var/datum/reagent/master_reagent = holder.get_master_reagent()
	if(isnull(master_reagent))
		return ..()

	if(istype(master_reagent, /datum/reagent/blood))
		blood_type = master_reagent.data?["blood_type"]

	if(isnull(blood_type))
		blood_type = find_blood_type(master_reagent.type).type_key()

	return ..()

/obj/item/reagent_containers/blood/update_name(updates)
	. = ..()
	if(labelled)
		return
	var/datum/blood_type/blood = find_blood_type(blood_type)
	name = "blood pack[blood ? " - [blood.name]" : null]"

/obj/item/reagent_containers/blood/random
	icon_state = "random_bloodpack"

/obj/item/reagent_containers/blood/random/Initialize(mapload, vol)
	icon_state = "bloodpack"
	blood_type = pick(subtypesof(/datum/blood_type/crew) - /datum/blood_type/crew/human)
	return ..()

/obj/item/reagent_containers/blood/a_plus
	blood_type = /datum/blood_type/crew/human/a_plus

/obj/item/reagent_containers/blood/a_minus
	blood_type = /datum/blood_type/crew/human/a_minus

/obj/item/reagent_containers/blood/b_plus
	blood_type = /datum/blood_type/crew/human/b_plus

/obj/item/reagent_containers/blood/b_minus
	blood_type = /datum/blood_type/crew/human/b_minus

/obj/item/reagent_containers/blood/o_plus
	blood_type = /datum/blood_type/crew/human/o_plus

/obj/item/reagent_containers/blood/o_minus
	blood_type = /datum/blood_type/crew/human/o_minus

/obj/item/reagent_containers/blood/lizard
	blood_type = /datum/blood_type/crew/lizard

/obj/item/reagent_containers/blood/ethereal
	blood_type = /datum/blood_type/crew/ethereal

/obj/item/reagent_containers/blood/skrell
	blood_type = /datum/blood_type/crew/skrell

/obj/item/reagent_containers/blood/snail
	blood_type = /datum/blood_type/snail

/obj/item/reagent_containers/blood/snail/examine()
	. = ..()
	. += span_notice("It's a bit slimy... The label indicates that this is meant for snails.")

/obj/item/reagent_containers/blood/podperson
	blood_type = /datum/blood_type/water

/obj/item/reagent_containers/blood/podperson/examine()
	. = ..()
	. += span_notice("This appears to be some very overpriced water.")

// for slimepeople
/obj/item/reagent_containers/blood/toxin
	blood_type = /datum/blood_type/slime

/obj/item/reagent_containers/blood/toxin/examine()
	. = ..()
	. += span_notice("There is a toxin warning on the label. This is for slimepeople.")

/obj/item/reagent_containers/blood/universal
	blood_type = /datum/blood_type/universal

/obj/item/reagent_containers/blood/attackby(obj/item/tool, mob/user, params)
	if (IS_WRITING_UTENSIL(tool))
		if(!user.can_write(tool))
			return
		var/custom_label = tgui_input_text(user, "What would you like to label the blood pack?", "Blood Pack", name, MAX_NAME_LEN)
		if(!user.can_perform_action(src))
			return
		if(user.get_active_held_item() != tool)
			return
		if(custom_label)
			labelled = TRUE
			name = "blood pack - [custom_label]"
			playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
			balloon_alert(user, "new label set")
		else
			labelled = FALSE
			update_name()
	else
		return ..()
