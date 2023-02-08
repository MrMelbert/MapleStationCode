/datum/component/story_spell/convect

/datum/component/story_spell/convect/handle_precast(atom/cast_on)
	. = ..()
	if (!istype(spell_parent, /datum/action/cooldown/spell/pointed/convect))
		return . | SPELL_CANCEL_CAST
	var/datum/action/cooldown/spell/pointed/convect/convect_spell = spell_parent

	if (!can_cast())
		to_chat(convect_spell.owner, span_warning("The thrum of the leylines die out. Perhaps you demanded too much mana?"))
		spell_parent.unset_click_ability(spell_parent.owner)
		return . | SPELL_CANCEL_CAST

/datum/component/story_spell/convect/handle_aftercast(atom/cast_on)
	. = ..()

	confirm_cast(get_mana_needed_for_cast())
	if (!can_cast())
		to_chat(spell_parent.owner, span_warning("The thrum of the leylines die out. Perhaps you demanded too much mana?"))
		spell_parent.unset_click_ability(spell_parent.owner)

/datum/component/story_spell/convect/proc/can_cast()
	var/mana_needed = get_mana_needed_for_cast()
	var/available_mana = get_available_mana()
	if (available_mana < mana_needed)
		return FALSE
	return TRUE

/datum/component/story_spell/convect/proc/get_mana_needed_for_cast()
	if (!istype(spell_parent, /datum/action/cooldown/spell/pointed/convect))
		return INFINITY //placeholder shit until i improve this

	var/datum/action/cooldown/spell/pointed/convect/convect_spell = spell_parent
	return ((abs(convect_spell.temperature_for_cast)*0.25) * convect_spell.owner.get_base_casting_cost())

/datum/component/story_spell/convect/proc/get_available_mana()
	return SSmagic.get_available_mana()

/datum/component/story_spell/convect/proc/confirm_cast(mana_spent)
	SSmagic.adjust_stored_mana(-mana_spent)

/datum/action/cooldown/spell/pointed/convect
	name = "Convect"
	desc = "Manipulate the temperature of matter around you."
	school = SCHOOL_TRANSMUTATION

	active_msg = "Nearby matter seems to still eversoslightly."
	deactive_msg = "Your surroundings normalize."

	aim_assist = FALSE
	cast_range = 1 //physical touching

	unset_after_click = FALSE

	var/temperature_for_cast = 0 // I FUCKING HATE THIS GAH MELBERT PLEASE HOW DO I KEEP INFO BETWEEN PROCS BETTER

/datum/action/cooldown/spell/pointed/convect/New(Target, original)
	. = ..()

	AddComponent(/datum/component/story_spell/convect, src)

/datum/action/cooldown/spell/pointed/convect/is_valid_target(atom/cast_on)
	return TRUE //cant call suepr cause i want to be able to use this on myself

/datum/action/cooldown/spell/pointed/convect/on_activation(mob/on_who)
	. = ..()
	var/temperature = tgui_input_number(owner, "How many degrees (kelvin) do you wish to shift temperature by?", "Convect", null, max_value = INFINITY, min_value = -INFINITY, timeout = 5 SECONDS)
	if (temperature == null)
		unset_click_ability(on_who)
		return FALSE
	temperature_for_cast = temperature

/datum/action/cooldown/spell/pointed/convect/on_deactivation(mob/on_who, refund_cooldown)
	. = ..()
	temperature_for_cast = 0

/// I hate doing the bulk of the work here but I hate having to have extra vars for cross-proc shit.
/datum/action/cooldown/spell/pointed/convect/cast(atom/cast_on)
	. = ..()

	if (iscarbon(cast_on))
		var/mob/living/carbon/carbon_target = cast_on
		carbon_target.adjust_bodytemperature(temperature_for_cast, use_insulation = TRUE)
		var/hot_or_cold
		if (temperature_for_cast > 0)
			hot_or_cold = "heat"
		else
			hot_or_cold = "cold"
		to_chat(carbon_target, span_warning("You feel a wave of [hot_or_cold] eminate from [owner]..."))
	else if (is_reagent_container(cast_on))
		var/obj/item/reagent_containers/container = cast_on
		container.reagents.expose_temperature(temperature_for_cast)
	else if (isturf(cast_on))
		var/turf/turf_target = cast_on
		var/datum/gas_mixture/turf_air = turf_target.return_air()
		if (turf_air)
			turf_air.temperature += temperature_for_cast //this sucks.
			turf_target.air_update_turf()

/datum/action/cooldown/spell/pointed/convect/after_cast(atom/cast_on)
	. = ..()

	//unset_click_ability()
