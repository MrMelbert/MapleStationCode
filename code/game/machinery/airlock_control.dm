// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	opens_with_door_remote = TRUE

	/// The current state of the airlock, used to construct the airlock overlays
	var/airlock_state
	var/frequency

/// Forces the airlock to unbolt and open
/obj/machinery/door/airlock/proc/secure_open()
	set waitfor = FALSE
	locked = FALSE
	update_appearance()

	stoplag(0.2 SECONDS)
	open(FORCING_DOOR_CHECKS)

	locked = TRUE
	update_appearance()

/// Forces the airlock to close and bolt
/obj/machinery/door/airlock/proc/secure_close()
	set waitfor = FALSE

	locked = FALSE
	close(forced = TRUE)

	locked = TRUE
	stoplag(0.2 SECONDS)
	update_appearance()

/obj/machinery/door/airlock/on_magic_unlock(datum/source, datum/action/cooldown/spell/aoe/knock/spell, mob/living/caster)
	// Airlocks should unlock themselves when knock is casted, THEN open up.
	locked = FALSE
	return ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "airlock_sensor_off"
	base_icon_state = "airlock_sensor"
	name = "airlock sensor"
	desc = "A small sensor that monitors the atmosphere in the airlock."
	resistance_flags = FIRE_PROOF
	power_channel = AREA_USAGE_ENVIRON

	/// What controller are we linked to?
	var/master_tag
	/// Whether the detective atmosphere is currently dangerous
	var/alert = FALSE

/obj/machinery/airlock_sensor/incinerator_ordmix
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_SENSOR
	master_tag = INCINERATOR_ORDMIX_AIRLOCK_CONTROLLER

/obj/machinery/airlock_sensor/incinerator_atmos
	id_tag = INCINERATOR_ATMOS_AIRLOCK_SENSOR
	master_tag = INCINERATOR_ATMOS_AIRLOCK_CONTROLLER

/obj/machinery/airlock_sensor/incinerator_syndicatelava
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_SENSOR
	master_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_CONTROLLER

/obj/machinery/airlock_sensor/update_icon_state()
	if(!is_operational)
		icon_state = "[base_icon_state]_off"
	else
		if(alert)
			icon_state = "[base_icon_state]_alert"
		else
			icon_state = "[base_icon_state]_standby"
	return ..()

/obj/machinery/airlock_sensor/Initialize(mapload)
	. = ..()
	SSair.start_processing_machine(src)

/obj/machinery/airlock_sensor/Destroy()
	SSair.stop_processing_machine(src)
	return..()

/obj/machinery/airlock_sensor/interact(mob/user, special_state)
	. = ..()

	var/obj/machinery/airlock_controller/airlock_controller = GLOB.objects_by_id_tag[master_tag]
	airlock_controller?.try_cycle(user)
	flick("[base_icon_state]_cycle", src)

/obj/machinery/airlock_sensor/process_atmos()
	if(!is_operational)
		return

	monitor_atmos(return_air())

/obj/machinery/airlock_sensor/proc/monitor_atmos(datum/gas_mixture/air_sample)
	var/old_alert = alert
	alert = isnull(air_sample) || (air_sample.return_pressure() < WARNING_LOW_PRESSURE) || (air_sample.return_temperature() < BODYTEMP_COLD_WARNING_3)
	if(alert != old_alert)
		update_appearance()

/obj/machinery/airlock_sensor/heater
	name = "airlock sensor and regulator"
	desc = "A small sensor with an integrated heater/cooler that monitors and regulates the atmosphere in an airlock system."

	/// What temp do we trend to, does nothing if null
	var/target_temperature

/obj/machinery/airlock_sensor/heater/monitor_atmos(datum/gas_mixture/air_sample)
	. = ..()
	if(!isturf(loc) || isnull(target_temperature) || isnull(air_sample))
		return

	var/curr_temperature = air_sample.return_temperature()
	var/heat_capacity = air_sample.heat_capacity()
	var/required_energy = min(abs(curr_temperature - target_temperature) * heat_capacity, 40000)

	if(required_energy < 1)
		return

	var/delta_temperature = required_energy / heat_capacity
	if(curr_temperature > target_temperature + 1)
		delta_temperature *= -1
	if(delta_temperature == 0)
		return

	var/turf/local_turf = loc
	for (var/turf/open/turf in ((local_turf.atmos_adjacent_turfs || list()) + local_turf))
		var/datum/gas_mixture/turf_gasmix = turf.return_air()
		turf_gasmix.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)
	use_power(required_energy * 0.01) // melbert todo - keep an eye on this with the nergy rework
