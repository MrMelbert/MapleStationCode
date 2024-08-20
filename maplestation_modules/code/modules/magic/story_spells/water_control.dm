#define WET_ATTUNEMENT_WATER 0.5
#define WET_MANA_COST_PER_UNIT 0.4

/* /datum/component/uses_mana/story_spell/pointed/soft_and_wet/get_mana_required(atom/caster, atom/cast_on, ...)
	var/datum/action/cooldown/spell/pointed/soft_and_wet/spell = parent
	var/turf/open/cast_turf = get_turf(cast_on)
	if(SEND_SIGNAL(cast_turf, COMSIG_TURF_IS_WET) || spell.wetness_pool.total_volume >= spell.wetness_pool.maximum_volume)
		return ..() * spell.wetness_pool.maximum_volume * wet_cost_per_unit

	// Supplying water makes it cheaper, technically.
	return ..() * spell.wetness_pool.total_volume * wet_cost_per_unit */

/datum/action/cooldown/spell/pointed/soft_and_wet
	name = "Water Control"
	desc = "Wet a dry spot, or dry a wet spot. \n\
		Creating wetness requires water - you can draw upon condensation from your surroundings, \
		or supply your own by holding a container filled with water."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "water"
	sound =  'sound/effects/slosh.ogg'

	cooldown_time = 10 SECONDS
	spell_requirements = NONE
	var/wet_cost_per_unit = WET_MANA_COST_PER_UNIT

	school = SCHOOL_TRANSMUTATION

	cast_range = 5

	/// Reagent holder for the water that is used to wet the ground.
	VAR_FINAL/datum/reagents/wetness_pool

	/// The radius that is wetted or dried.
	var/aoe_range = 1
	/// The number of units of water that are applied to the ground.
	var/water_units_applied = 10
	/// The type of water that is used to wet the ground.
	var/datum/reagent/water_type = /datum/reagent/water
	/// How long in seconds it takes to regenerate nautral water.
	var/water_regen_time = 60 SECONDS

/datum/action/cooldown/spell/pointed/soft_and_wet/New(Target)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[/datum/attunement/water] += WET_ATTUNEMENT_WATER

	AddComponent(/datum/component/uses_mana/spell, \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		mana_consumed = CALLBACK(src, PROC_REF(get_mana_consumed)), \
		attunements = attunements, \
	)
	wetness_pool = new(water_units_applied * ((1 + 2 * aoe_range) ** 2))
	wetness_pool.add_reagent(water_type, INFINITY)

/datum/action/cooldown/spell/pointed/soft_and_wet/proc/get_mana_consumed(atom/caster, atom/cast_on, ...)
	var/turf/open/cast_turf = get_turf(cast_on)
	if(SEND_SIGNAL(cast_turf, COMSIG_TURF_IS_WET) || wetness_pool.total_volume >= wetness_pool.maximum_volume)
		return wetness_pool.maximum_volume * wet_cost_per_unit

	// Supplying water makes it cheaper, technically.
	return wetness_pool.total_volume * wet_cost_per_unit

/datum/action/cooldown/spell/pointed/soft_and_wet/Destroy()
	QDEL_NULL(wetness_pool)
	return ..()

/datum/action/cooldown/spell/pointed/soft_and_wet/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, aoe_range))
		if(!isnum(var_value))
			return FALSE
		set_new_range(var_value)

	if(var_name == NAMEOF(src, water_units_applied))
		if(!isnum(var_value))
			return FALSE
		set_new_water_units_applied(var_value)

	if(var_name == NAMEOF(src, water_type))
		if(!ispath(var_value, /datum/reagent))
			return FALSE
		set_new_water_type(var_value)

	return ..()

/datum/action/cooldown/spell/pointed/soft_and_wet/proc/set_new_range(new_range)
	if(aoe_range == new_range)
		return
	aoe_range = new_range
	wetness_pool.maximum_volume = water_units_applied * ((1 + 2 * aoe_range) ** 2)

/datum/action/cooldown/spell/pointed/soft_and_wet/proc/set_new_water_units_applied(new_water_units_applied)
	if(water_units_applied == new_water_units_applied)
		return
	water_units_applied = new_water_units_applied
	wetness_pool.maximum_volume = water_units_applied * (aoe_range ** 2)

/datum/action/cooldown/spell/pointed/soft_and_wet/proc/set_new_water_type(new_water_type)
	if(water_type == new_water_type)
		return
	water_type = new_water_type
	var/amount_to_add = wetness_pool.total_volume
	wetness_pool.clear_reagents()
	wetness_pool.add_reagent(water_type, amount_to_add)

/datum/action/cooldown/spell/pointed/soft_and_wet/is_valid_target(atom/cast_on)
	var/turf/castturf = get_turf(cast_on)
	return isopenturf(castturf) && !isgroundlessturf(castturf)

/datum/action/cooldown/spell/pointed/soft_and_wet/before_cast(atom/cast_on)
	. = ..()
	var/turf/open/cast_turf = get_turf(cast_on)
	if(SEND_SIGNAL(cast_turf, COMSIG_TURF_IS_WET))
		return
	if(wetness_pool.total_volume >= wetness_pool.maximum_volume)
		// technically this is "drawing from the air" which means it... shouldn't work in space. but i'm too lazy to check that
		return

	var/did_alert = FALSE
	for(var/obj/item/reagent_containers/container in owner)
		if(container.reagents?.trans_to(wetness_pool, INFINITY, 1, water_type) > 0 && !did_alert)
			container.balloon_alert(owner, "drawing from [container.name]...")
			did_alert = TRUE

	if(wetness_pool.total_volume <= 0)
		owner?.balloon_alert(owner, "not enough [lowertext(initial(water_type.name))]!")
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/pointed/soft_and_wet/cast(atom/cast_on)
	. = ..()
	var/turf/open/cast_turf = get_turf(cast_on)
	var/make_dry = SEND_SIGNAL(cast_turf, COMSIG_TURF_IS_WET)
	var/datum/reagents/temp_holder
	if(!make_dry)
		temp_holder = new(water_units_applied)

	for(var/turf/open/nearby_turf in range(aoe_range, cast_turf)) // i'd use RANGE_TURFS but i want to go inside -> outside
		if(!is_valid_target(nearby_turf))
			continue
		if(make_dry)
			nearby_turf.MakeDry(TURF_WET_WATER, TRUE)
			continue

		wetness_pool.trans_to(temp_holder, water_units_applied)
		if(temp_holder.total_volume <= 0)
			break
		new /obj/effect/temp_visual/splashie(nearby_turf, temp_holder)
		temp_holder.expose(nearby_turf)
		temp_holder.remove_reagent(water_type, temp_holder.total_volume)

	qdel(temp_holder)

	if(owner)
		if(make_dry)
			cast_turf.balloon_alert(owner, "dried")
		else
			cast_turf.balloon_alert(owner, "dampened")

/datum/action/cooldown/spell/pointed/soft_and_wet/after_cast(atom/cast_on)
	. = ..()
	if(wetness_pool.total_volume <= wetness_pool.maximum_volume)
		addtimer(CALLBACK(src, PROC_REF(regenerate_water)), water_regen_time, TIMER_UNIQUE)

	owner?.face_atom(cast_on)

/datum/action/cooldown/spell/pointed/soft_and_wet/proc/regenerate_water()
	if(QDELETED(src) || QDELETED(wetness_pool))
		return
	wetness_pool.add_reagent(water_type, INFINITY)
	owner?.balloon_alert(owner, "[lowertext(initial(water_type.name))] regenerated")

/obj/effect/temp_visual/splashie
	name = "splash"
	icon = 'icons/effects/effects.dmi'
	icon_state = "splash_floor"
	duration = 1 SECONDS

/obj/effect/temp_visual/splashie/Initialize(mapload, datum/reagents/used)
	. = ..()
	if(istype(used))
		color = mix_color_from_reagents(used.reagent_list)

#undef WET_ATTUNEMENT_WATER
#undef WET_MANA_COST_PER_UNIT
