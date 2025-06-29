/// Updates the limb id of a bodypart if the mob is wearing digitigrade squishing clothing
/datum/element/digitigrade_limb
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	/// Id when wearing digitigrade squishing clothing
	var/squashed_id
	/// Id when not wearing digitigrade squishing clothing
	var/free_id

/datum/element/digitigrade_limb/Attach(datum/target, squashed_id, free_id)
	. = ..()
	if(!isbodypart(target))
		return ELEMENT_INCOMPATIBLE

	src.squashed_id = squashed_id
	src.free_id = free_id

	RegisterSignal(target, COMSIG_BODYPART_UPDATED, PROC_REF(update_id))

	var/obj/item/bodypart/limb = target
	if(update_id(limb)) // just in case the default is the "squished" state
		if(isnull(limb.owner))
			limb.update_icon_dropped()
		else
			limb.owner.update_body_parts()

/datum/element/digitigrade_limb/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_BODYPART_UPDATED)
	if(QDELING(source))
		return

	var/obj/item/bodypart/limb = source
	if(update_id(limb)) // this should "free" the limb
		if(isnull(limb.owner))
			limb.update_icon_dropped()
		else
			limb.owner.update_body_parts()

/datum/element/digitigrade_limb/proc/limb_updated(obj/item/bodypart/limb, dropping_limb = FALSE, is_creating = FALSE)
	SIGNAL_HANDLER

	update_id(limb)

/**
 * Updates the limb depending on the current state of the mob.
 *
 * Also updates any clothing that might be affected by the change.
 *
 * Does not actually update the sprite. Updating the sprite should be avoided,
 * as this proc is called as a part of (right before) the sprite update process.
 * While this does not (theoretically) infinitely loop, it's just wasteful.
 */
/datum/element/digitigrade_limb/proc/update_id(obj/item/bodypart/limb)

	var/old_id = limb.limb_id
	if(limb.owner?.is_digitigrade_squished())
		now_squashed(limb)
	else
		now_free(limb)
	if(old_id == limb.limb_id)
		return FALSE
	for(var/obj/item/thing as anything in limb.owner?.get_equipped_items())
		if(thing.supports_variations_flags & DIGITIGRADE_VARIATIONS)
			thing.update_slot_icon()
	return TRUE

/// The limb is now squashed
/datum/element/digitigrade_limb/proc/now_squashed(obj/item/bodypart/limb)
	limb.limb_id = src.squashed_id

/// The limb is now free
/datum/element/digitigrade_limb/proc/now_free(obj/item/bodypart/limb)
	limb.limb_id = src.free_id

/// Element subtype - I know it sucks - that also updates the static icon of the limb
/datum/element/digitigrade_limb/change_static_icon
	/// Static Icon to use when the limb is squashed
	var/squashed_icon
	/// Static Icon to use when the limb is free
	var/free_icon

/datum/element/digitigrade_limb/change_static_icon/Attach(datum/target, squashed_id, free_id, squashed_icon, free_icon)
	src.squashed_icon = squashed_icon
	src.free_icon = free_icon
	return ..()

/datum/element/digitigrade_limb/change_static_icon/now_squashed(obj/item/bodypart/limb)
	// skip the bodypart helper as this is being done IN update_limb
	UNLINT(limb.icon_static = src.squashed_icon)
	return ..()

/datum/element/digitigrade_limb/change_static_icon/now_free(obj/item/bodypart/limb)
	// skip the bodypart helper as this is being done IN update_limb
	UNLINT(limb.icon_static = src.free_icon)
	return ..()
