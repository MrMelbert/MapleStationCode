/datum/action/item_action/cult/clock_spell/disable
	name = "Slab: Disable"
	desc = "Empowers a slab to disable and mute targets when hit."
	examine_hint = "deal heavy stamina damage and knock down targets hit. Non-mindshielded targets will also be silenced."
	button_icon_state = "Kindle"
	charges = 4

/datum/action/item_action/cult/clock_spell/disable/activate()
	. = ..()
	to_chat(owner, span_brass("You empower [target] to shine a bright light at your next target, disabling them."))

/datum/action/item_action/cult/clock_spell/disable/deactivate()
	to_chat(owner, span_brass("You withdraw the power into [target]."))
	. = ..()

/datum/action/item_action/cult/clock_spell/disable/do_hit_spell_effects(mob/living/victim, mob/living/user)
	if(HAS_TRAIT_FROM(victim, TRAIT_I_WAS_FUNNY_HANDED, REF(user)))
		return FALSE

	var/mob/living/living_target = victim
	user.visible_message(
		span_warning("[user] holds up [target], which glows in a harsh white light!"),
		span_brasstalics("You attempt to disable [living_target] with [target]!")
		)

	user.mob_light(_range = 3, _color = LIGHT_COLOR_HALOGEN, _duration = 0.8 SECONDS)

	if(anti_cult_magic_check(victim, user))
		return TRUE

	if(living_target.getStaminaLoss() >= 70)
		living_target.flash_act(1, TRUE, visual = TRUE, length = 6 SECONDS)
	else
		living_target.Knockdown(1 SECONDS)
	living_target.apply_damage(75, STAMINA, BODY_ZONE_CHEST)

	var/final_hit = living_target.getStaminaLoss() >= 100

	if(issilicon(victim))
		var/mob/living/silicon/silicon_target = victim
		silicon_target.emp_act(EMP_HEAVY)
		if(iscyborg(target))
			var/mob/living/silicon/robot/cyborg_target = victim
			cyborg_target.cell.charge = clamp(cyborg_target.cell.charge - 5000, 0, cyborg_target.cell.maxcharge)

		to_chat(user, span_brasstalics("[victim] is enveloped in a bright white flash, overloading their sensors[iscyborg(victim)?" and draining their power":""]!"))
		to_chat(target, span_userdanger("A bright white light washes over you, overloading your system[iscyborg(victim)?" and draining your cell":""]!"))
		victim.visible_message(
			span_warning("[victim] overloads and shuts down!"),
			ignored_mobs = list(user, victim)
			)

	else if(iscarbon(victim))
		var/mob/living/carbon/carbon_target = victim
		if(HAS_TRAIT(victim, TRAIT_MINDSHIELD))
			if(!final_hit)
				to_chat(user, span_brass("[victim] is enveloped in a white flash, <b>but their mind is too strong to be silenced!</b>"))
				to_chat(victim, span_userdanger("A bright white light washes over you, sapping you of energy!"))
		else
			if(!final_hit)
				to_chat(user, span_brass("[victim] is enveloped in a white flash, preventing them from speaking!"))
				to_chat(victim, span_userdanger("A bright white light washes over you, sapping you of energy and voice!"))
			carbon_target.silent += 4

		carbon_target.stuttering += 8
		carbon_target.Jitter(4 SECONDS)

	ADD_TRAIT(victim, TRAIT_I_WAS_FUNNY_HANDED, REF(user))
	addtimer(TRAIT_CALLBACK_REMOVE(victim, TRAIT_I_WAS_FUNNY_HANDED, REF(user)), 3 SECONDS)
	playsound(get_turf(user), 'sound/magic/blind.ogg', 10, FALSE, SILENCED_SOUND_EXTRARANGE, pressure_affected = FALSE, ignore_walls = FALSE)

	return TRUE
