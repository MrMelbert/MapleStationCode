//States for airlock_control

/// Interior is open
#define AIRLOCK_STATE_INTERIOR_OPEN "inopen"
/// Interior is opening actively
#define AIRLOCK_STATE_INTERIOR_OPENING "inopening"
/// Interior and exterior are closed
#define AIRLOCK_STATE_CLOSED "closed"
/// Exterior is opening actively
#define AIRLOCK_STATE_EXTERIOR_OPENING "exopening"
/// Exterior is open
#define AIRLOCK_STATE_EXTERIOR_OPEN "exopen"

/obj/machinery/airlock_controller
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "airlock_control_standby"
	base_icon_state = "airlock_control"

	name = "airlock console"
	density = FALSE

	power_channel = AREA_USAGE_ENVIRON

	// Setup parameters only
	var/exterior_door_tag
	var/interior_door_tag
	var/airpump_tag
	var/sensor_tag
	// Refs to the components
	VAR_FINAL/datum/weakref/interior_door_ref
	VAR_FINAL/datum/weakref/exterior_door_ref
	VAR_FINAL/list/datum/weakref/pump_refs
	VAR_FINAL/list/datum/weakref/sensor_refs

	// Generally don't set both of these at the same time they will fight

	// Set these values to `null` to only check temperature
	/// Desired pressure for cycling to the interior
	var/interior_target_pressure = 0 // default: vacuum
	/// Desired pressure for cycling to the exterior
	var/exterior_target_pressure = ONE_ATMOSPHERE
	/// Pressure leeway for cycling, because getting exact is tedious
	var/pressure_leeway = ONE_ATMOSPHERE * 0.03

	// Set these values to `null` to only check pressure
	/// Desired temperature for cycling to the interior
	var/interior_temperature_target = T20C
	/// Desired temperature for cycling to the exterior
	var/exterior_temperature_target = null
	/// Temperature leeway for cycling
	var/temperature_leeway = T20C * 0.01

	/// Current state of the airlock setup
	VAR_PRIVATE/state = AIRLOCK_STATE_CLOSED
	/// Desired state of the airlock setup
	VAR_PRIVATE/target_state = AIRLOCK_STATE_CLOSED
	/// Whether we are currently processing a state change, used for icon
	VAR_PRIVATE/processing = FALSE

/obj/machinery/airlock_controller/post_machine_initialize()
	. = ..()

	var/obj/machinery/door/interior_door = GLOB.objects_by_id_tag[interior_door_tag]
	if (!isnull(interior_door_tag) && !istype(interior_door))
		stack_trace("interior_door_tag is set to [interior_door_tag], which is not a door ([interior_door || "null"])")
	interior_door_ref = WEAKREF(interior_door)

	var/obj/machinery/door/exterior_door = GLOB.objects_by_id_tag[exterior_door_tag]
	if (!isnull(exterior_door_tag) && !istype(exterior_door))
		stack_trace("exterior_door_tag is set to [exterior_door_tag], which is not a door ([exterior_door || "null"])")
	exterior_door_ref = WEAKREF(exterior_door)

	var/obj/machinery/atmospherics/components/binary/dp_vent_pump/pump = GLOB.objects_by_id_tag[airpump_tag]
	if (!isnull(airpump_tag) && !istype(pump))
		stack_trace("airpump_tag is set to [airpump_tag], which is not a pump ([pump || "null"])")
	LAZYADD(pump_refs, WEAKREF(pump))

	var/obj/machinery/airlock_sensor/sensor = GLOB.objects_by_id_tag[sensor_tag]
	if (!isnull(sensor_tag) && !istype(sensor))
		stack_trace("sensor_tag is set to [sensor_tag], which is not a sensor ([sensor || "null"])")
	LAZYADD(sensor_refs, WEAKREF(sensor))

/obj/machinery/airlock_controller/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockController", src)
		ui.open()

/// Attempt to shut off the pump if it is on and exists
/obj/machinery/airlock_controller/proc/pump_shutoff()
	for(var/datum/weakref/pump_ref in pump_refs)
		var/obj/machinery/atmospherics/components/binary/dp_vent_pump/pump = pump_ref.resolve()
		if(isnull(pump))
			continue

		if(pump.on)
			pump.on = FALSE
			pump.update_appearance(UPDATE_ICON)

/// Attempts to swap the pump from depressurizing to pressurizing
/// Also turns it on if it is off
/obj/machinery/airlock_controller/proc/pump_pressurize()
	for(var/datum/weakref/pump_ref in pump_refs)
		var/obj/machinery/atmospherics/components/binary/dp_vent_pump/pump = pump_ref.resolve()
		if(isnull(pump))
			return

		if(pump.pump_direction == ATMOS_DIRECTION_SIPHONING)
			pump.pressure_checks |= ATMOS_EXTERNAL_BOUND
			pump.pump_direction = ATMOS_DIRECTION_RELEASING

		if(!pump.on)
			pump.on = TRUE
			pump.update_appearance(UPDATE_ICON)

/// Attempts to swap the pump from pressurizing to depressurizing
/// Also turns it on if it is off
/obj/machinery/airlock_controller/proc/pump_depressurize()
	for(var/datum/weakref/pump_ref in pump_refs)
		var/obj/machinery/atmospherics/components/binary/dp_vent_pump/pump = pump_ref.resolve()
		if(isnull(pump))
			return

		if(pump.pump_direction == ATMOS_DIRECTION_RELEASING)
			pump.pressure_checks &= ~ATMOS_EXTERNAL_BOUND
			pump.pump_direction = ATMOS_DIRECTION_SIPHONING

		if(!pump.on)
			pump.on = TRUE
			pump.update_appearance(UPDATE_ICON)

/// Attempts to set the temperature regulators to a target temperature, which turns them on
/obj/machinery/airlock_controller/proc/temp_regulator_activate(to_what_temp = 0)
	for(var/datum/weakref/sensor_ref in sensor_refs)
		var/obj/machinery/airlock_sensor/heater/temp_regulator = sensor_ref.resolve()
		if(!istype(temp_regulator))
			continue

		temp_regulator.target_temperature = to_what_temp

/// Attempts to shut off the temperature regulators by setting the target temperature to null
/obj/machinery/airlock_controller/proc/temp_regulator_shutoff()
	for(var/datum/weakref/sensor_ref in sensor_refs)
		var/obj/machinery/airlock_sensor/heater/temp_regulator = sensor_ref.resolve()
		if(!istype(temp_regulator))
			continue

		temp_regulator.target_temperature = null

/**
 * Handls a door actively cycling, checking if it's in a valid state to finish / abort / continue
 *
 * Return TRUE to update state
 * Return FALSE to keep waiting on the current state
 */
/obj/machinery/airlock_controller/proc/cycle_door(datum/weakref/door_ref, target_pressure, temperature_target)
	PRIVATE_PROC(TRUE)
	var/obj/machinery/door/airlock/to_cycle = door_ref.resolve()
	if(isnull(to_cycle))
		state = AIRLOCK_STATE_CLOSED // failsafe
		return FALSE
	var/list/reading = sensor_reading()
	if(isnull(reading))
		state = AIRLOCK_STATE_CLOSED // failsafe
		return FALSE

	. = TRUE
	if(!isnull(target_pressure))
		// pressurizing
		if(reading["pressure"] < target_pressure - pressure_leeway)
			pump_pressurize() // always ensure the pump is pressurizing (may noop)
			. = FALSE
		// depressurizing
		else if(reading["pressure"] > target_pressure + pressure_leeway)
			pump_depressurize() // always ensure the pump is depressurizing (may noop)
			. = FALSE
	if(!isnull(temperature_target))
		// heating
		if(reading["temperature"] < temperature_target - temperature_leeway)
			temp_regulator_activate(temperature_target)
			. = FALSE
		// cooling
		else if(reading["temperature"] > temperature_target + temperature_leeway)
			temp_regulator_activate(temperature_target)
			. = FALSE
	return .

/obj/machinery/airlock_controller/proc/handle_state()
	var/old_state = state
	switch(state)
		if(AIRLOCK_STATE_INTERIOR_OPEN)
			// Int Open -> Close -> Ext Open
			if(target_state == AIRLOCK_STATE_EXTERIOR_OPEN || target_state == AIRLOCK_STATE_CLOSED)
				state = AIRLOCK_STATE_CLOSED
			// Int opening -> Int open
			else
				var/obj/machinery/door/airlock/interior_airlock = interior_door_ref.resolve()
				pump_shutoff()
				temp_regulator_shutoff()
				if(interior_airlock?.density)
					interior_airlock.secure_open()

		if(AIRLOCK_STATE_INTERIOR_OPENING)
			// Abort cycling
			if(target_state == AIRLOCK_STATE_CLOSED)
				state = AIRLOCK_STATE_CLOSED
			// Either proceed to int open or do nothing
			else if(cycle_door(interior_door_ref, interior_target_pressure, interior_temperature_target))
				state = AIRLOCK_STATE_INTERIOR_OPEN

		if(AIRLOCK_STATE_CLOSED)
			// In closed state just try to close everything it doesn't matter
			var/obj/machinery/door/airlock/interior_airlock = interior_door_ref.resolve()
			if(interior_airlock && !interior_airlock.density)
				interior_airlock.secure_close()
			var/obj/machinery/door/airlock/exterior_airlock = exterior_door_ref.resolve()
			if(exterior_airlock && !exterior_airlock.density)
				exterior_airlock.secure_close()
			pump_shutoff()
			temp_regulator_shutoff()
			// CLosed -> Int Opening -> Int Open
			if(target_state == AIRLOCK_STATE_INTERIOR_OPEN)
				state = AIRLOCK_STATE_INTERIOR_OPENING
			// Closed -> Ext Opening -> Ext Open
			else if(target_state == AIRLOCK_STATE_EXTERIOR_OPEN)
				state = AIRLOCK_STATE_EXTERIOR_OPENING

		if(AIRLOCK_STATE_EXTERIOR_OPEN)
			// Ext Open -> Close -> Int Open
			if(target_state == AIRLOCK_STATE_INTERIOR_OPEN || target_state == AIRLOCK_STATE_CLOSED)
				state = AIRLOCK_STATE_CLOSED
			// Ext opening -> Ext open
			else
				var/obj/machinery/door/airlock/exterior_airlock = exterior_door_ref.resolve()
				pump_shutoff()
				temp_regulator_shutoff()
				if(exterior_airlock?.density)
					exterior_airlock.secure_open()

		if(AIRLOCK_STATE_EXTERIOR_OPENING)
			// Abort cycling
			if(target_state == AIRLOCK_STATE_CLOSED)
				state = AIRLOCK_STATE_CLOSED
			// Either proceed to ext open or do nothing
			else if(cycle_door(exterior_door_ref, exterior_target_pressure, exterior_temperature_target))
				state = AIRLOCK_STATE_EXTERIOR_OPEN

	if(state != old_state)
		// Recursively calls itself if the state changed to update to the newer state
		// Pretty safe as it's a finite state machine
		handle_state()

/obj/machinery/airlock_controller/process(seconds_per_tick)
	handle_state()
	processing = state != target_state
	update_appearance()
	SStgui.update_uis(src)

/obj/machinery/airlock_controller/ui_data(mob/user)
	var/list/data = list()

	data["airlockState"] = state

	var/list/reading = sensor_reading()
	data["sensorPressure"] = isnull(reading["pressure"]) ? "----" : round(reading["pressure"], 0.1)

	var/obj/machinery/door/airlock/interior_airlock = interior_door_ref.resolve()
	data["interiorStatus"] = isnull(interior_airlock) ? "----" : (interior_airlock.density ? "closed" : "open")

	var/obj/machinery/door/airlock/exterior_airlock = exterior_door_ref.resolve()
	data["exteriorStatus"] = isnull(exterior_airlock) ? "----" : (exterior_airlock.density ? "closed" : "open")

	data["pumpStatus"] = "----"
	for(var/datum/weakref/pump_ref in pump_refs)
		var/obj/machinery/atmospherics/components/binary/dp_vent_pump/pump = pump_ref.resolve()
		if(isnull(pump))
			continue

		data["pumpStatus"] = pump.on ? "[pump.pump_direction == ATMOS_DIRECTION_RELEASING ? "de" : ""]pressurizing" : "off"
		break

	return data

/obj/machinery/airlock_controller/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(SSsecurity_level.get_current_level_as_number() <= SEC_LEVEL_BLUE && !allowed(usr))
		balloon_alert(usr, "access denied")
		return

	switch(action)
		if("cycleClosed", "abort")
			target_state = AIRLOCK_STATE_CLOSED
		if("cycleExterior")
			target_state = AIRLOCK_STATE_EXTERIOR_OPEN
		if("cycleInterior")
			target_state = AIRLOCK_STATE_INTERIOR_OPEN

	return TRUE

/obj/machinery/airlock_controller/proc/try_cycle(mob/user)
	if(SSsecurity_level.get_current_level_as_number() <= SEC_LEVEL_BLUE && !allowed(user))
		balloon_alert(user, "access denied")
		return

	cycle()

/// Helper to cycle between the three "final" states
/obj/machinery/airlock_controller/proc/cycle()
	if(state == AIRLOCK_STATE_CLOSED)
		target_state = AIRLOCK_STATE_INTERIOR_OPEN
	else if(state == AIRLOCK_STATE_INTERIOR_OPEN)
		target_state = AIRLOCK_STATE_EXTERIOR_OPEN
	else if(state == AIRLOCK_STATE_EXTERIOR_OPEN)
		target_state = AIRLOCK_STATE_CLOSED

/// Returns a reading of the sensors, or null if no sensors are available
/obj/machinery/airlock_controller/proc/sensor_reading()
	var/total_pressure = 0
	var/total_temp = 0
	var/total_vol = 0
	var/num_sensors = 0

	for(var/datum/weakref/sensor_ref in sensor_refs)
		var/obj/machinery/airlock_sensor/sensor = sensor_ref.resolve()
		if(isnull(sensor))
			continue

		var/datum/gas_mixture/air = sensor.return_air()
		if(isnull(air))
			continue

		total_pressure += air.return_pressure()
		total_temp += air.return_temperature()
		total_vol += air.return_volume()
		num_sensors += 1
	if(num_sensors == 0)
		return null
	return list(
		"pressure" = total_pressure / num_sensors,
		"temperature" = total_temp / num_sensors,
		"volume" = total_vol / num_sensors,
	)

/obj/machinery/airlock_controller/update_icon_state()
	icon_state = "[base_icon_state]_[processing ? "process" : "standby"]"
	return ..()

/obj/machinery/airlock_controller/incinerator_ordmix
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_ORDMIX_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_ORDMIX_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_ORDMIX_AIRLOCK_INTERIOR
	sensor_tag = INCINERATOR_ORDMIX_AIRLOCK_SENSOR
	// These are all reversed for some reason
	interior_target_pressure = ONE_ATMOSPHERE * 0.98
	exterior_target_pressure = 0

/obj/machinery/airlock_controller/incinerator_atmos
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_ATMOS_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_ATMOS_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_ATMOS_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_ATMOS_AIRLOCK_INTERIOR
	sensor_tag = INCINERATOR_ATMOS_AIRLOCK_SENSOR
	// These are all reversed for some reason
	interior_target_pressure = ONE_ATMOSPHERE * 0.98
	exterior_target_pressure = 0

/obj/machinery/airlock_controller/incinerator_syndicatelava
	name = "Incinerator Access Console"
	airpump_tag = INCINERATOR_SYNDICATELAVA_DP_VENTPUMP
	exterior_door_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_CONTROLLER
	interior_door_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR
	sensor_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_SENSOR
	// These are all reversed for some reason
	interior_target_pressure = ONE_ATMOSPHERE * 0.98
	exterior_target_pressure = 0

/obj/machinery/airlock_controller/standard_pressure
	interior_target_pressure = ONE_ATMOSPHERE * 0.98
	exterior_target_pressure = ONE_ATMOSPHERE * 0.98

#undef AIRLOCK_STATE_EXTERIOR_OPEN
#undef AIRLOCK_STATE_EXTERIOR_OPENING
#undef AIRLOCK_STATE_INTERIOR_OPEN
#undef AIRLOCK_STATE_INTERIOR_OPENING
#undef AIRLOCK_STATE_CLOSED
