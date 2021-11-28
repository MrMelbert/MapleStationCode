/obj/effect/rune/clock_trap
	cultist_name = "Sigil of Transgression"
	cultist_desc = "disorients and blinds any non-cultists who step over it. Can be manually invoked to trigger its effects on anyone nearby."
	invocation = "N Yv'ggyr Vz'cng-vrag, Trg Rz!"
	icon = 'jollystation_modules/icons/effects/clockwork_effects.dmi'
	icon_state = "nothing"
	color = LIGHT_COLOR_TUNGSTEN
	construct_invoke = FALSE
	/// The amount of charges on the rune. Deletes itself when out.
	var/charges = 3
	/// A list of everyone who this rune's afflicted, so we don't double-dip.
	var/list/people_we_dazed

/obj/effect/rune/clock_trap/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	var/image/hidden = image('jollystation_modules/icons/effects/clockwork_effects.dmi', loc, "sigiltransgression", SIGIL_LAYER)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/cult, "clock_trap_rune", hidden)

/obj/effect/rune/clock_trap/Destroy(force)
	LAZYCLEARLIST(people_we_dazed)
	return ..()

/obj/effect/rune/clock_trap/invoke(list/invokers)
	. = ..()
	for(var/mob/living/carbon/victim in orange(2, src))
		if(IS_CULTIST(victim))
			continue

		if(victim in people_we_dazed)
			continue

		if(anti_cult_magic_check(victim))
			continue

		daze_victim(victim)

/obj/effect/rune/clock_trap/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(!iscarbon(arrived))
		return

	var/mob/living/carbon/victim = arrived
	if(IS_CULTIST(victim))
		return

	if(victim in people_we_dazed)
		return

	if(anti_cult_magic_check(victim))
		return

	new /obj/effect/particle_effect/sparks(get_turf(victim))
	daze_victim(victim)

/obj/effect/rune/clock_trap/proc/daze_victim(mob/living/carbon/victim)
	// Keep track of the people we hit for later. But also don't hard-delete
	LAZYADD(people_we_dazed, victim)
	RegisterSignal(victim, COMSIG_PARENT_QDELETING, .proc/clear_references)

	to_chat(victim, span_userdanger("A bright yellow flash obscured your vision and dazes you!"))

	victim.flash_act(1, TRUE, visual = TRUE, length = 4 SECONDS)
	victim.apply_damage(50, STAMINA, BODY_ZONE_CHEST)
	victim.dizziness += 15
	victim.add_confusion(20)

	victim.mob_light(_range = 2, _color = LIGHT_COLOR_TUNGSTEN, _duration = 0.8 SECONDS)
	new /obj/effect/temp_visual/kindle(get_turf(victim))

	if(--charges <= 0)
		qdel(src)

/obj/effect/rune/clock_trap/proc/clear_references(datum/source, force)
	SIGNAL_HANDLER

	LAZYREMOVE(people_we_dazed, source)
