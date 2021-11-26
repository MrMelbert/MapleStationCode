
/datum/action/innate/cult/clock_spell/slab
	name = "Replicant"
	desc = "Allows you to create a new Clockwork Slab."
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_clockcult.dmi'
	button_icon_state = "Replicant"
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire"

/datum/action/innate/cult/clock_spell/slab/Activate()
	var/turf/owner_turf = get_turf(owner)
	var/obj/item/summoned_thing = new /obj/item/clockwork_slab(owner_turf)
	owner.visible_message(
		span_warning("[owner]'s hand glows yellow for a moment."),
		span_brass("You create a replication [summoned_thing.name] out of the air!"),
		)

	if(owner.put_in_hands(summoned_thing))
		to_chat(owner, span_warning("A [summoned_thing.name] appears in your hand!"))
	else
		owner.visible_message(
			span_warning("A [summoned_thing.name] appears at [owner]'s feet!"),
			span_cultitalic("A [summoned_thing.name] materializes at your feet.")
			)

	SEND_SOUND(owner, sound('sound/effects/magic.ogg', FALSE, 0, 25))
	owner.whisper(invocation, language = /datum/language/common)
	if(--charges <= 0)
		qdel(src)
