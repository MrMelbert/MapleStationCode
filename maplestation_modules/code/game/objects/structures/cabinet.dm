/obj/item/wallframe/fireaxecabinet/jaws_of_life
	name = "hydraulic rescue tool cabinet"
	desc = "Holds the jaws of life, ready to snatch life from the jaws of death."
	result_path = /obj/structure/fireaxecabinet/jaws_of_life/empty
	icon = 'maplestation_modules/icons/obj/cabinet.dmi'

/obj/structure/fireaxecabinet/jaws_of_life
	name = "hydraulic rescue tool cabinet"
	desc = "There is a small label that reads \"For Emergency use only\" along with details for safe use of the tool. As if."
	item_path = /obj/item/crowbar/power
	item_overlay = "jaws"
	icon = 'maplestation_modules/icons/obj/cabinet.dmi'
	/// tracks if the lock was forced open intead of opening via security level
	var/lock_was_forced = FALSE

/obj/structure/fireaxecabinet/jaws_of_life/examine(mob/user)
	. = ..()
	if(SSsecurity_level.get_current_level_as_number() <= SEC_LEVEL_GREEN)
		. += span_notice("It has a locking mechanism preventing the handle from opening outside of emergencies. \
			<i>Of course, this won't stop the determined.</i>")
	else
		. += span_notice("Due to a security situation, its locking mechanism has been disabled.")

/obj/structure/fireaxecabinet/jaws_of_life/Initialize(mapload)
	. = ..()
	RegisterSignal(SSsecurity_level, COMSIG_SECURITY_LEVEL_CHANGED, PROC_REF(check_security_level))

/obj/structure/fireaxecabinet/jaws_of_life/toggle_lock(mob/user)
	. = ..()
	lock_was_forced = !locked

/obj/structure/fireaxecabinet/jaws_of_life/proc/check_security_level(datum/source, new_level)
	SIGNAL_HANDLER

	// level is being lowered
	if(new_level <= SEC_LEVEL_GREEN)
		// only re-lock if the lock was not forced open in the first place
		if(!locked && !lock_was_forced)
			locked = TRUE
			update_appearance()
		return

	// level is being raised
	if(!locked)
		return

	playsound(src, 'sound/machines/locktoggle.ogg', 50, TRUE)
	locked = FALSE
	update_appearance()

/obj/structure/fireaxecabinet/jaws_of_life/atom_deconstruct(disassembled = TRUE)
	if(held_item && loc)
		held_item.forceMove(loc)
	new /obj/item/wallframe/fireaxecabinet/jaws_of_life(loc)

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/fireaxecabinet/jaws_of_life, 32)

/obj/structure/fireaxecabinet/jaws_of_life/empty
	populate_contents = FALSE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/fireaxecabinet/jaws_of_life/empty, 32)
