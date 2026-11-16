/datum/mutation/human/wings
	name = "Wings"
	desc = "An ancient mutation that grants wings capable of flight."
	quality = POSITIVE
	difficulty = 12
	locked = TRUE
	instability = POSITIVE_INSTABILITY_MODERATE
	remove_on_aheal = FALSE

	var/datum/weakref/new_wings_ref
	var/datum/weakref/old_wings_ref

/datum/mutation/human/wings/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	if(.)
		return TRUE
	var/obj/item/bodypart/chest/chest = acquirer.get_bodypart(BODY_ZONE_CHEST)
	if(!LAZYLEN(chest.wing_types))
		return TRUE

	to_chat(acquirer, span_notice("You feel a strange sensation on your back..."))
	addtimer(CALLBACK(src, PROC_REF(give_wings), acquirer), rand(1, 3) SECONDS)
	return FALSE

/datum/mutation/human/wings/proc/give_wings(mob/living/carbon/human/acquirer)
	var/obj/item/organ/wings/functional/existing_wings = acquirer.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(isnull(existing_wings))
		to_chat(acquirer, span_userdanger("A terrible pain travels down your back as wings burst out!"))
	else
		to_chat(acquirer, span_userdanger("A terrible pain travels down your back as your wings change shape!"))

	insert_wing_organ(acquirer, get_wing_choice(acquirer))

	acquirer.apply_damage(20, def_zone = BODY_ZONE_CHEST, forced = TRUE, wound_bonus = CANT_WOUND)
	if(isnull(existing_wings))
		acquirer.cause_pain(BODY_ZONE_HEAD, 16)
		acquirer.cause_pain(BODY_ZONE_CHEST, 75)
		acquirer.cause_pain(list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), 30)
	else
		acquirer.cause_pain(BODY_ZONE_HEAD, 10)
		acquirer.cause_pain(BODY_ZONE_CHEST, 45)
		acquirer.cause_pain(list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), 18)
	acquirer.pain_emote("scream")

	RegisterSignal(acquirer, COMSIG_CARBON_POST_ATTACH_LIMB, PROC_REF(chest_changed))

/datum/mutation/human/wings/proc/insert_wing_organ(mob/living/carbon/human/acquirer, wings_type)
	QDEL_NULL(old_wings_ref)
	QDEL_NULL(new_wings_ref)

	var/obj/item/organ/wings/functional/existing_wings = acquirer.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(!isnull(existing_wings))
		old_wings_ref = WEAKREF(existing_wings)
		existing_wings.moveToNullspace()

	var/obj/item/organ/wings/functional/new_wings = new wings_type()
	new_wings.organ_flags |= ORGAN_UNREMOVABLE
	new_wings.Insert(acquirer)
	new_wings_ref = WEAKREF(new_wings)

/datum/mutation/human/wings/on_losing(mob/living/carbon/human/loser)
	. = ..()
	if(.)
		return TRUE

	var/obj/item/organ/new_wings = new_wings_ref?.resolve()
	if(!QDELETED(new_wings) && new_wings.owner == loser)
		to_chat(loser, span_warning("Your wings retract and disappear!"))
		QDEL_NULL(new_wings)

	var/obj/item/organ/old_wings = old_wings_ref?.resolve()
	if(!QDELETED(old_wings))
		old_wings.Insert(loser)

	UnregisterSignal(loser, COMSIG_CARBON_POST_ATTACH_LIMB)
	return FALSE

/// On species change let's make sure that the wings are updated accordingly
/datum/mutation/human/wings/proc/chest_changed(mob/living/carbon/human/source, obj/item/bodypart/chest/new_chest, special)
	SIGNAL_HANDLER

	if(!istype(new_chest))
		return
	if(!LAZYLEN(new_chest.wing_types))
		// don't need these anymore
		QDEL_NULL(old_wings_ref)
		QDEL_NULL(new_wings_ref)
		// removes the mutation too
		source.dna.remove_mutation(type)
		return

	insert_wing_organ(source, LAZYACCESS(new_chest.wing_types, 1))

/datum/mutation/human/wings/proc/get_wing_choice(mob/living/carbon/human/needs_wings)
	var/obj/item/bodypart/chest/chest = needs_wings.get_bodypart(BODY_ZONE_CHEST)
	if(LAZYLEN(chest.wing_types) == 1 || !needs_wings.client)
		return LAZYACCESS(chest.wing_types, 1)

	var/list/radial_wings = list()
	var/list/name2type = list()
	for(var/obj/item/organ/wings/functional/possible_type as anything in chest.wing_types)
		var/datum/sprite_accessory/accessory = SSaccessories.wings_list[possible_type::sprite_accessory_override::name] //get the singleton instance
		var/image/img = image(icon = accessory.icon, icon_state = "m_wingsopen_[accessory.icon_state]_BEHIND") //Process the HUD elements
		img.transform *= 0.5
		img.pixel_x = -32
		if(radial_wings[accessory.name])
			stack_trace("Different wing types with repeated names. Please fix as this may cause issues.")
		else
			radial_wings[accessory.name] = img
			name2type[accessory.name] = possible_type

	var/wing_name = show_radial_menu(needs_wings, needs_wings, radial_wings, tooltips = TRUE)
	return name2type[wing_name] || LAZYACCESS(chest.wing_types, 1)
