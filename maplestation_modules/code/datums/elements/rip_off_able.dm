/// Attach to an item to allow other mobs to (accidentally?) rip it off when trying to hug/help the wearer.
/datum/component/wearertargeting/rip_off_able
	signals = list(COMSIG_CARBON_PRE_MISC_HELP)
	mobtype = /mob/living/carbon
	proctype = PROC_REF(on_help_act)
	/// What's being ripped off, for messages.
	var/what_ripped
	/// The body zone that needs to be selected to rip this off.
	var/target_zone

/datum/component/wearertargeting/rip_off_able/Initialize(required_slots, target_zone, what_ripped)
	. = ..()
	src.what_ripped = what_ripped
	src.target_zone = target_zone
	src.valid_slots = list(required_slots) // melbert todo : change this later when this is refactored

/datum/component/wearertargeting/rip_off_able/proc/on_help_act(mob/living/is_helped, mob/living/helper)
	SIGNAL_HANDLER

	if(is_helped.body_position != STANDING_UP || is_helped.combat_mode)
		return NONE

	if(check_zone(helper.zone_selected) != target_zone || !is_helped.get_bodypart(deprecise_zone(target_zone)))
		return NONE

	var/obj/item/ripped = parent
	if(!is_helped.dropItemToGround(ripped))
		return NONE

	helper.visible_message(
		span_danger("[helper] pulls on [is_helped]'s [what_ripped]... and it rips off!"), \
		null,
		span_hear("You hear a ripping sound."),
		DEFAULT_MESSAGE_RANGE,
		list(helper, is_helped),
	)
	to_chat(helper, span_danger("You pull on [is_helped]'s [what_ripped]... and it rips off!"))
	to_chat(is_helped, span_userdanger("[helper] pulls on your [what_ripped]... and it rips off!"))
	playsound(ripped, 'sound/effects/cloth_rip.ogg', 75, TRUE)
	helper.put_in_hands(ripped)
	return COMPONENT_BLOCK_MISC_HELP
