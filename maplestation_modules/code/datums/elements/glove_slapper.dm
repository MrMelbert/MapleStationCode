/// Lets an item be used to slap people in the face.
/datum/element/glove_slapper

/datum/element/glove_slapper/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(try_slap))

/datum/element/glove_slapper/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_ITEM_ATTACK)

/datum/element/glove_slapper/proc/try_slap(obj/item/source, mob/living/slapped, mob/living/slapper)
	SIGNAL_HANDLER

	if(deprecise_zone(slapper.zone_selected) != BODY_ZONE_HEAD)
		return NONE
	if(slapper == source)
		return NONE

	slapper.visible_message(
		span_warning("[slapper] slaps [slapped] with [source]!"),
		span_warning("You slap [slapped] with [source]!"),
		span_hear("You hear a slap."),
		COMBAT_MESSAGE_RANGE,
	)
	playsound(slapped, 'sound/weapons/slap.ogg', source.get_clamped_volume(), vary = TRUE)
	slapped.Knockdown(1 SECONDS)
	slapped.AdjustSleeping(-5 SECONDS)
	slapped.AdjustUnconscious(-5 SECONDS)
	slapped.adjust_drowsiness(-5 SECONDS)
	slapper.do_attack_animation(slapped, used_item = source)
	slapper.changeNext_move(CLICK_CD_MELEE)
	return COMPONENT_CANCEL_ATTACK_CHAIN
