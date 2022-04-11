
/datum/action/innate/cult/clock_spell/slab
	name = "Replicant"
	desc = "Allows you to create a new Clockwork Slab."
	button_icon_state = "replicant"
	invocation = "Ubj Qvq V Ybfr Zl Fyno, Gurl'er Fb Oev-tug!"

/datum/action/innate/cult/clock_spell/slab/Activate()
	var/mob/living/user = owner

	var/turf/owner_turf = get_turf(user)
	var/obj/item/summoned_thing = new /obj/item/clockwork_slab(owner_turf)
	user.visible_message(
		span_warning("[user]'s hand glows yellow for a moment."),
		span_brass("You create a replication [summoned_thing.name] out of the air!"),
		)

	if(user.put_in_hands(summoned_thing))
		to_chat(user, span_warning("A [summoned_thing.name] appears in your hand!"))
	else
		user.visible_message(
			span_warning("A [summoned_thing.name] appears at [user]'s feet!"),
			span_cultitalic("A [summoned_thing.name] materializes at your feet.")
			)

	SEND_SOUND(user, sound('sound/effects/magic.ogg', FALSE, 0, 25))
	user.whisper(invocation, language = /datum/language/common, forced = "cult invocation")
	if(--charges <= 0)
		qdel(src)
