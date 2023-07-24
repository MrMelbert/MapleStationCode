GLOBAL_VAR_INIT(pose_overlay, generate_pose_overlay())

/proc/generate_pose_overlay()
	var/mutable_appearance/temporary_flavor_text_indicator = mutable_appearance('maplestation_modules/icons/misc/temporary_flavor_text_indicator.dmi', "flavor", FLY_LAYER)
	temporary_flavor_text_indicator.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	return temporary_flavor_text_indicator

/// Called pose as it is inspired from "set pose" from other servers
/// Temporary examine text additions for mobs that is lost on death / incapacitation
/datum/component/pose
	/// Text shown on examine
	var/pose_text

/datum/component/pose/Initialize(pose_text)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.pose_text = pose_text

/datum/component/pose/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LATE_EXAMINE, PROC_REF(on_living_examine))
	RegisterSignals(parent, list(
		COMSIG_LIVING_DEATH,
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
		SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED),
	), PROC_REF(on_incapacitated))

	var/mob/living/living_parent = parent
	living_parent.add_overlay(list(GLOB.pose_overlay))
	living_parent.update_overlays()

/datum/component/pose/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_LIVING_LATE_EXAMINE,
		COMSIG_LIVING_DEATH,
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
		SIGNAL_REMOVETRAIT(TRAIT_INCAPACITATED),
	))

	var/mob/living/living_parent = parent
	living_parent.cut_overlay(list(GLOB.pose_overlay))
	living_parent.update_overlays()

/datum/component/pose/proc/on_living_examine(datum/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_italics(span_notice(pose_text))

/datum/component/pose/proc/on_incapacitated(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/// Verb that lets you set temporary pose / examine text.
/mob/living/verb/set_examine()
	set category = "IC"
	set name = "Set Examine Text"
	set desc = "Sets temporary text shown to people on examine. Can be used to pose your character, describe an injury, or anything you can think of."

	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED))
		to_chat(usr, span_warning("You can't do this right now!"))
		return

	var/default_text = "[p_they(TRUE)] [p_are()]..."
	var/pose_input = tgui_input_text(usr, "Set temporary examine text here. Can be used to pose your character, \
		describe an injury, or anything you can think of. Leave blank to clear.", "Set Examine Text", default = default_text, max_length = 85)
	if(QDELETED(src))
		return
	if(pose_input == default_text || !length(pose_input))
		qdel(GetComponent(/datum/component/pose)) // This is meh but I didn't want to make a signal just for "COMSIG_LIVING_POSE_SET"
		return
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED))
		to_chat(usr, span_warning("You can't do this right now!"))
		return

	AddComponent(/datum/component/pose, pose_input)
