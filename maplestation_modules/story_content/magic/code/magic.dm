#define BASE_MAGIC_COST 1
#define NO_CATALYST_COST_MULT 5

/mob/proc/get_base_casting_cost()
	var/mult = BASE_MAGIC_COST
	return mult

/mob/living/carbon/get_base_casting_cost()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT

/datum/action/cooldown/spell/story_magic
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/story_magic/proc/get_possible_costs(mob/living/target)
	var/list/costs = list()
	for (var/datum/story_magic_cost/cost as anything in GLOB.story_magic_costs)
		if (want_to_use_cost(cost) && cost.can_be_applied_to(target)) costs += cost

	return costs

/// Use for blacklisting certain costs.
/datum/action/cooldown/spell/story_magic/proc/want_to_use_cost(datum/story_magic_cost/cost)
	return TRUE

/datum/action/cooldown/spell/story_magic/convect
	name = "Convect"
	desc = "Manipulate the temperature of matter around you."
	school = SCHOOL_TRANSMUTATION

/datum/action/cooldown/spell/story_magic/convect/before_cast(atom/cast_on)
	. = ..()
	if (!iscarbon(cast_on))
		return SPELL_CANCEL_CAST
	return

/datum/action/cooldown/spell/story_magic/convect/cast(atom/cast_on)
	. = ..()
	if (!iscarbon(cast_on))
		return SPELL_CANCEL_CAST
	var/mob/living/carbon/carbon_cast_on = cast_on
	var/list/things_to_convect = list()

	for (var/obj/item in carbon_cast_on.get_all_worn_items()) things_to_convect += item
	for (var/obj/item in carbon_cast_on.held_items) things_to_convect += item
	if (carbon_cast_on.pulling != null) things_to_convect += carbon_cast_on.pulling

	var/turf/carbon_turf = get_turf(carbon_cast_on)
	if (carbon_turf != null)
		things_to_convect += carbon_turf

	things_to_convect += carbon_cast_on
	if (things_to_convect.len == 0) return SPELL_CANCEL_CAST

	var/mob/living/carbon/carbon_cast_on = cast_on

	var/atom/target = tgui_input_list(carbon_cast_on, "Which one would you like to convect?", "Convect", things_to_convect)
	if (target == null) return

	var/temperature = tgui_input_number(carbon_cast_on, "How much would you like to convect by?", "Convect", null)
	if (temperature == null) return

	var/datum/story_magic_cost/cost = tgui_input_list(carbon_cast_on, "What will be transmuted into the thermal energy?", "Convect", get_possible_costs(carbon_cast_on))
	if (cost == null) return

	if (target == null || temperature == null || cost == null) return

	if (iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.adjust_bodytemperature(temperature, use_insulation = TRUE)
		carbon_target.reagents.expose_temperature(temperature)
	else if (is_reagent_container(target))
		var/obj/item/reagent_containers/container = target
		container.reagents.expose_temperature(temperature)
	else if (isturf(target))
		var/turf/turf_target = target
		var/datum/gas_mixture/turf_air = turf_target.return_air()
		if (turf_air != null)
			turf_target.temperature_expose(turf_air, temperature)

	cost.apply(owner, temperature)
