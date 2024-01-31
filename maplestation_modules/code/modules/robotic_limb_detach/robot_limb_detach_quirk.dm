/datum/quirk/robot_limb_detach
	name = "Cybernetic Limb Mounts"
	desc = "You are able to detach and reattach any installed robotic limbs with very little effort." // ", as long as they're in good condition."
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
	var/datum/action/cooldown/robot_self_amputation/limb_action = new /datum/action/cooldown/robot_self_amputation()
	limb_action.Grant(human_holder)
	added_action = limb_action

/datum/quirk/robot_limb_detach/remove()
	QDEL_NULL(added_action)

/datum/action/cooldown/robot_self_amputation
	name = "Detach a robotic limb"
	desc = "Disengage one of your robotic limbs from your cybernetic mounts. Requires you to not be restrained or otherwise under duress." // " Will not function on wounded limbs - tend to them first."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "autotomy"

	cooldown_time = 1 SECONDS
	check_flags = AB_CHECK_CONSCIOUS | AB_CHECK_HANDS_BLOCKED | AB_CHECK_INCAPACITATED

	var/list/exclusions = list()
	var/obj/item/bodypart/limb_to_detach

/datum/action/cooldown/robot_self_amputation/proc/detaching_check(mob/living/carbon/human/cast_on)
    return !QDELETED(limb_to_detach) && limb_to_detach.owner == cast_on

/datum/action/cooldown/robot_self_amputation/Activate(mob/living/carbon/human/cast_on)
	if(!ishuman(cast_on))
		return

	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_warning("ERROR: LIMB DISENGAGEMENT PROTOCOLS OFFLINE. Seek out a maintenance technician."))
		return

	exclusions += BODY_ZONE_CHEST
	exclusions += BODY_ZONE_HEAD // The code below is redundant in our codebase, but I'm keeping it commented in case someone in the future wants to make it useful
//	if (!issynthetic(cast_on))
//		exclusions += BODY_ZONE_HEAD // no decapitating yourself unless you're a synthetic, who keep their brains in their chest

	var/list/robot_parts = list()
	for (var/obj/item/bodypart/possible_part as anything in cast_on.bodyparts)
		if ((possible_part.bodytype & BODYTYPE_ROBOTIC) && !(possible_part.body_zone in exclusions)) //only robot limbs and only if they're not crucial to our like, ongoing life, you know?
			robot_parts += possible_part

	if (!length(robot_parts))
		to_chat(cast_on, "ERROR: Limb disengagement protocols report no compatible cybernetics currently installed. Seek out a maintenance technician.")
		return

	limb_to_detach = tgui_input_list(cast_on, "Limb to detach", "Cybernetic Limb Detachment", sort_names(robot_parts))
	if (QDELETED(src) || QDELETED(cast_on) || QDELETED(limb_to_detach) || limb_to_detach.owner != cast_on)
		return SPELL_CANCEL_CAST

	if (length(limb_to_detach.wounds) >= 1)
		cast_on.balloon_alert(cast_on, "can't detach wounded limbs!")
		playsound(cast_on, 'sound/machines/buzz-sigh.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		return
	var/leg_check = IGNORE_USER_LOC_CHANGE
	if (istype(limb_to_detach, /obj/item/bodypart/leg))
		leg_check = null

	cast_on.balloon_alert(cast_on, "detaching limb...")
	playsound(cast_on, 'sound/items/rped.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	cast_on.visible_message(span_notice("[cast_on] shuffles [cast_on.p_their()] [limb_to_detach.name] forward, actuators hissing and whirring as [cast_on.p_they()] disengage[cast_on.p_s()] the limb from its mount..."))

	if(do_after(cast_on, 1 SECONDS, timed_action_flags = leg_check, extra_checks = CALLBACK(src, PROC_REF(detaching_check), cast_on)))
		StartCooldown()
		cast_on.visible_message(span_notice("With a gentle twist, [cast_on] finally pries [cast_on.p_their()] [limb_to_detach.name] free from its socket."))
		limb_to_detach.drop_limb()
		cast_on.put_in_hands(limb_to_detach)
		cast_on.balloon_alert(cast_on, "limb detached!")
		if(prob(5))
			playsound(cast_on, 'sound/items/champagne_pop.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		else
			playsound(cast_on, 'sound/items/deconstruct.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	else
		cast_on.balloon_alert(cast_on, "interrupted!")
		playsound(cast_on, 'sound/machines/buzz-sigh.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
