/datum/status_effect/block_headset_use
	id = "block_headset_use"
	alert_type = null

	var/static/image/earslot_overlay

/datum/status_effect/block_headset_use/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/block_headset_use/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(clear_silence))
	ADD_TRAIT(owner, TRAIT_BLOCK_HEADSET_USE, id)

	if(!earslot_overlay)
		earslot_overlay = image(icon = 'icons/hud/screen_gen.dmi', icon_state = "x")
		SET_PLANE_IMPLICIT(earslot_overlay, ABOVE_HUD_PLANE)
		earslot_overlay.layer = HIGH_OBJ_LAYER
		earslot_overlay.alpha = 200
	var/atom/movable/screen/inventory/ear_slot = owner.hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_EARS) + 1]
	ear_slot?.add_overlay(earslot_overlay)
	return TRUE

/datum/status_effect/block_headset_use/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	REMOVE_TRAIT(owner, TRAIT_BLOCK_HEADSET_USE, id)
	var/atom/movable/screen/inventory/ear_slot = owner.hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_EARS) + 1]
	ear_slot?.cut_overlay(earslot_overlay)

/datum/status_effect/block_headset_use/proc/clear_silence(mob/living/source)
	SIGNAL_HANDLER
	qdel(src)
