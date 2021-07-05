/datum/element/temperature_pack
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	var/pain_heal_rate = 0
	var/pain_modifier_on_limb = 1

/datum/element/temperature_pack/Attach(obj/item/target, pain_heal_rate = 0, pain_modifier_on_limb = 1)
	. = ..()

	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	src.pain_heal_rate = pain_heal_rate
	src.pain_modifier_on_limb = pain_modifier_on_limb

	RegisterSignal(target, COMSIG_ITEM_ATTACK_SECONDARY, .proc/try_freeze_limb)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/get_examine_text)

/datum/element/temperature_pack/Detach(obj/target)
	. = ..()
	UnregisterSignal(target, list(
		COMSIG_ITEM_ATTACK_SECONDARY,
		COMSIG_PARENT_EXAMINE,
	))

/datum/element/temperature_pack/proc/get_examine_text(obj/item/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	if(pain_heal_rate > 0)
		examine_list += span_notice("Right-clicking on a hurt limb with this item can help soothe pain.")

/datum/element/temperature_pack/proc/try_freeze_limb(obj/item/source, atom/target, mob/user, params)
	SIGNAL_HANDLER

	. = SECONDARY_ATTACK_CALL_NORMAL
	if(!ishuman(target))
		return

	var/mob/living/carbon/human/target_mob = target
	var/targeted_zone = target_mob.zone_selected

	if(target.stat == DEAD)
		return
	if(!target_mob.pain_controller)
		return
	if(!target_mob.get_bodypart_pain(targeted_zone, TRUE))
		return

	. = SECONDARY_ATTACK_CONTINUE_CHAIN

	for(var/datum/status_effect/temperature_pack/pre_existing_effect in target_mob.status_effects)
		if(pre_existing_effect.targeted_zone == targeted_zone)
			to_chat(user, span_warning("There is already a something pressed against that limb."))
			return
		if(pre_existing_effect.pressed_item == source)
			to_chat(user, span_warning("You are already pressing [source] onto another limb."))
			return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	INVOKE_ASYNC(src, .proc/begin_freezing_limb, source, target, user, targeted_zone)

/datum/element/temperature_pack/proc/begin_freezing_limb(obj/item/parent, mob/living/carbon/target, mob/user, targeted_zone)
	if(!do_after(user, 0.5 SECONDS, target))
		return

	var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(targeted_zone)
	user.visible_message(
		span_notice("[user] press [parent] against [target == user ? "their" : "[target]'s" ] [targeted_bodypart.name]."),
		span_notice("You press [parent] against [target == user ? "your" : "[target]'s" ] [targeted_bodypart.name].")
	)
	target.apply_status_effect(/datum/status_effect/temperature_pack/cold, user, parent, targeted_zone, pain_heal_rate, pain_modifier_on_limb)
