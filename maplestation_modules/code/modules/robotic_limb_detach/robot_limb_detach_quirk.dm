/datum/quirk/robot_limb_detach
	name = "Cybernetic Limb Mounts"
	desc = "You are able to detach and reattach any installed robotic limbs with very little effort."
	gain_text = span_notice("Internal sensors report limb disengagement protocols are ready and waiting.")
	lose_text = span_notice("ERROR: LIMB DISENGAGEMENT PROTOCOLS OFFLINE.")
	medical_record_text = "Patient bears quick-attach and release limb joint cybernetics."
	value = 0
	mob_trait = TRAIT_ROBOTIC_LIMBATTACHMENT
	icon = FA_ICON_HANDSHAKE_SIMPLE_SLASH
	quirk_flags = QUIRK_HUMAN_ONLY
	/// The action we add with this quirk in add(), used for easy deletion later
	var/datum/action/cooldown/added_action

/datum/quirk/robot_limb_detach/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/datum/action/cooldown/robot_self_amputation/limb_action = new()
	limb_action.Grant(human_holder)
	added_action = limb_action

/datum/quirk/robot_limb_detach/remove()
	QDEL_NULL(added_action)

/datum/action/cooldown/robot_self_amputation
	name = "Detach a robotic limb"
	desc = "Disengage one of your robotic limbs from your cybernetic mounts. Requires you to not be restrained or otherwise under duress."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "autotomy"

	cooldown_time = 1 SECONDS
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED | AB_CHECK_INCAPACITATED

	var/list/exclusions = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)

/datum/action/cooldown/robot_self_amputation/proc/detaching_check(mob/living/carbon/human/target, obj/item/bodypart/limb_to_detach)
	return !QDELETED(limb_to_detach) && limb_to_detach.owner == target

/datum/action/cooldown/robot_self_amputation/Activate(mob/living/carbon/human/target)
	if(!ishuman(target))
		return

	if(HAS_TRAIT(target, TRAIT_NODISMEMBER))
		to_chat(target, span_warning("ERROR: LIMB DISENGAGEMENT PROTOCOLS OFFLINE. Seek out a maintenance technician."))
		return


	var/list/robot_parts = list()
	for (var/obj/item/bodypart/possible_part as anything in target.bodyparts)
		if ((possible_part.bodytype & BODYTYPE_ROBOTIC) && !(possible_part.body_zone in exclusions)) //only robot limbs and only if they're not crucial to our like, ongoing life, you know?
			robot_parts += possible_part

	if (!length(robot_parts))
		to_chat(target, "ERROR: Limb disengagement protocols report no compatible cybernetics currently installed. Seek out a maintenance technician.")
		return

	var/obj/item/bodypart/limb_to_detach = tgui_input_list(target, "Limb to detach", "Cybernetic Limb Detachment", sort_names(robot_parts))
	if (QDELETED(src) || QDELETED(target) || QDELETED(limb_to_detach) || limb_to_detach.owner != target)
		return 

	if (length(limb_to_detach.wounds) >= 1)
		target.balloon_alert(target, "can't detach wounded limbs!")
		playsound(target, 'sound/machines/buzz-sigh.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		return
	var/leg_check = IGNORE_USER_LOC_CHANGE
	if (istype(limb_to_detach, /obj/item/bodypart/leg))
		leg_check = NONE

	target.balloon_alert(target, "detaching limb...")
	playsound(target, 'sound/items/rped.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	target.visible_message(span_notice("[target] shuffles [target.p_their()] [limb_to_detach.name] forward, actuators hissing and whirring as [target.p_they()] disengage[target.p_s()] the limb from its mount..."))

	if(do_after(target, 1 SECONDS, timed_action_flags = leg_check, extra_checks = CALLBACK(src, PROC_REF(detaching_check), target, limb_to_detach)))
		StartCooldown()
		target.visible_message(span_notice("With a gentle twist, [target] finally pries [target.p_their()] [limb_to_detach.name] free from its socket."))
		limb_to_detach.drop_limb()
		target.put_in_hands(limb_to_detach)
		target.balloon_alert(target, "limb detached!")
		if(prob(5))
			playsound(target, 'sound/items/champagne_pop.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		else
			playsound(target, 'sound/items/deconstruct.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	else
		target.balloon_alert(target, "interrupted!")
		playsound(target, 'sound/machines/buzz-sigh.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE
