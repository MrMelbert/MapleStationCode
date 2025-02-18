/datum/keybinding/human/open_close_storage
	hotkey_keys = list("ShiftR")
	name = "open_close_storage"
	full_name = "Open/Close storage"
	description = "Close the current storage interface, or open equipped storage if available"
	keybind_signal = COMSIG_KB_HUMAN_OPENCLOSESTORAGE_DOWN

/datum/keybinding/human/open_close_storage/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	human.open_close_storage()
	return TRUE

/mob/living/carbon/human/proc/open_best_storage(mob/user)

	var/list/obj/item/possible = list(
	user.get_active_held_item(),
	user.get_inactive_held_item(),
	user.get_item_by_slot(ITEM_SLOT_BACK),
	user.get_item_by_slot(ITEM_SLOT_BELT),
	user.get_item_by_slot(ITEM_SLOT_SUITSTORE),
	)
	for(var/thing in possible)
		if(isnull(thing))
			continue
		var/obj/item/gear = thing
		if(gear.atom_storage?.open_storage(user))
			return TRUE

/mob/living/carbon/human/verb/open_close_storage()
	set name = "open-close-storage"
	set hidden = TRUE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(execute_open_close_storage)))

/mob/living/carbon/human/proc/execute_open_close_storage()
	var/datum/storage/storage = src.active_storage
	if(storage)
		storage.hide_contents(src)
		return
	open_best_storage(src)
	return
