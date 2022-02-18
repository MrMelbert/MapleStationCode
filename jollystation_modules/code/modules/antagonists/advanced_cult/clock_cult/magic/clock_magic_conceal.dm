
/datum/action/item_action/cult/clock_spell/conceal
	name = "Slab: Conceal"
	desc = "Alternates between hiding and revealing nearby cult structures and runes."
	invocation = "Erg'hea Gb Error!"
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "gone"
	charges = 10
	/// The sound that will play on next invocation.
	var/curr_sound = 'sound/magic/smoke.ogg'
	/// Whether our next use will reveal or conceal.
	var/revealing = FALSE

/datum/action/item_action/cult/clock_spell/conceal/Trigger(trigger_flags)
	if(revealing)
		reveal_nearby()
	else
		conceal_nearby()

	SEND_SOUND(owner, sound(curr_sound, 0, 1, 25))
	after_successful_spell(owner)
	UpdateButtonIcon()

/datum/action/item_action/cult/clock_spell/conceal/proc/reveal_nearby()
	owner.visible_message(
		span_warning("A flash of light shines from [owner]'s [target]!"),
		span_brasstalics("You invoke the revealing spell, revealing nearby sigils.")
		)

	var/list/nearby = range(6, owner)
	for(var/obj/effect/rune/sigil in nearby)
		sigil.reveal()
	for(var/obj/structure/destructible/cult/struct in nearby)
		struct.reveal()
	for(var/turf/open/floor/engine/cult/brass/tile in nearby)
		if(!tile.realappearance)
			continue
		tile.realappearance.alpha = initial(tile.realappearance.alpha)
	for(var/obj/machinery/door/airlock/cult/brass/airlock in nearby)
		airlock.reveal()

	revealing = FALSE
	curr_sound = 'sound/magic/enter_blood.ogg'
	name = "Slab: Conceal"
	button_icon_state = "gone"

/datum/action/item_action/cult/clock_spell/conceal/proc/conceal_nearby()
	owner.visible_message(
		span_warning("Thin grey dust falls from [owner]'s [target]!"),
		span_brasstalics("You invoke the concealment spell, hiding nearby sigils.")
		)

	var/list/nearby = range(5, owner)
	for(var/obj/effect/rune/sigil in nearby)
		sigil.conceal()
	for(var/obj/structure/destructible/cult/struct in nearby)
		struct.conceal()
	for(var/turf/open/floor/engine/cult/tile in nearby)
		if(!tile.realappearance)
			continue
		tile.realappearance.alpha = 0
	for(var/obj/machinery/door/airlock/cult/airlock in nearby)
		airlock.conceal()

	curr_sound = 'sound/magic/smoke.ogg'
	revealing = TRUE
	name = "Slab: Reveal"
	button_icon_state = "back"
