/// Allows the bodypart to increase (or decrease) the sprint length of its owner
/datum/element/bodypart_sprint_buff
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Amount to increase sprint length by
	var/buff_amount

/datum/element/bodypart_sprint_buff/Attach(datum/target, buff_amount = 0)
	. = ..()
	if(!isbodypart(target))
		return ELEMENT_INCOMPATIBLE

	src.buff_amount = buff_amount

	RegisterSignal(target, COMSIG_BODYPART_ATTACHED, PROC_REF(add_buff))
	RegisterSignal(target, COMSIG_BODYPART_REMOVED, PROC_REF(remove_buff))

/datum/element/bodypart_sprint_buff/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_BODYPART_ATTACHED)
	UnregisterSignal(source, COMSIG_BODYPART_REMOVED)

/datum/element/bodypart_sprint_buff/proc/add_buff(obj/item/bodypart/limb, mob/living/carbon/human/new_owner, special)
	SIGNAL_HANDLER

	if(!ishuman(new_owner))
		return

	new_owner.sprint_length_max += buff_amount

/datum/element/bodypart_sprint_buff/proc/remove_buff(obj/item/bodypart/limb, mob/living/carbon/human/new_owner, special)
	SIGNAL_HANDLER

	if(!ishuman(new_owner))
		return

	new_owner.sprint_length_max -= buff_amount
