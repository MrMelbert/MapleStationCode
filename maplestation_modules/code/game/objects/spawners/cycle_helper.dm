/obj/effect/mapping_helpers/cycling_airlock_old
	icon = 'maplestation_modules/icons/effects/mapping_helpers.dmi'
	icon_state = "airlock_setup"
	name = "guide in desc (viro / xeno cycling airlocks helper)"
	desc = "Place this in the center of your airlock setup, \
		Then place an inner_door marker on the interior door, \
		and an outer_door marker on the exterior door. \
		Make sure to set the dirs of the markers pointing to the walls you want the buttons on. \
		Buttons are placed on both doors, but the controller's placed on the inner door only. \
		\
		And that's it. \
		You don't need to manually set airlock IDs, you don't need to add bolt or \
		cycle link helpers, and you don't even need to set access directly, all that is handled for you - \
		\
		The only thing you need to do is set up the basic shell of the room. \
		Oh and also to set the access list / name on THIS OBJECT."
	late = TRUE
	/// UID for the airlock IDs
	var/static/autogen_uid = 0
	/// Name to prepend to airlocks and buttons
	var/prefix_name
	/// Access list for the airlocks and buttons
	var/list/access
	/// One access list for the airlocks and buttons
	var/list/one_access

/obj/effect/mapping_helpers/cycling_airlock_old/LateInitialize()
	var/obj/effect/mapping_helpers/cycling_airlock_old/marker/inner_door/inner_mark = locate() in range(2, src)
	var/obj/effect/mapping_helpers/cycling_airlock_old/marker/outer_door/outer_mark = locate() in range(2, src)

	if(!inner_mark || !outer_mark)
		CRASH("Couldn't find markers for the airlock cycle auto setup at ([x], [y], [z])")

	var/obj/machinery/door/airlock/inner = locate() in inner_mark.loc
	var/obj/machinery/door/airlock/outer = locate() in outer_mark.loc

	if(!inner || !outer)
		CRASH("Couldn't find both airlocks for the airlock cycle auto setup at ([x], [y], [z])")

	airlock_setup(inner_mark, outer_mark, inner, outer)
	autogen_uid += 1

	qdel(inner_mark)
	qdel(outer_mark)
	qdel(src)

/obj/effect/mapping_helpers/cycling_airlock_old/proc/airlock_setup(
	obj/effect/mapping_helpers/cycling_airlock_old/marker/inner_door/inner_mark,
	obj/effect/mapping_helpers/cycling_airlock_old/marker/outer_door/outer_mark,
	obj/machinery/door/airlock/inner,
	obj/machinery/door/airlock/outer,
)
	var/obj/machinery/door_buttons/access_button/inner_button = new(inner_mark.loc)
	var/obj/machinery/door_buttons/access_button/outer_button = new(outer_mark.loc)
	var/obj/machinery/door_buttons/airlock_controller/inner_controller = new(inner_mark.loc)
	switch(inner_mark.dir)
		if(WEST)
			inner_button.pixel_x = -26
			inner_controller.pixel_x = -38
		if(NORTH)
			inner_button.pixel_y = 26
			inner_controller.pixel_y = 38
		if(EAST)
			inner_button.pixel_x = 26
			inner_controller.pixel_x = 38
		if(SOUTH)
			inner_button.pixel_y = -26
			inner_controller.pixel_y = -38

	switch(outer_mark.dir)
		if(WEST)
			outer_button.pixel_x = -26
		if(NORTH)
			outer_button.pixel_y = 26
		if(EAST)
			outer_button.pixel_x = 26
		if(SOUTH)
			outer_button.pixel_y = -26

	var/final_uid = "__[autogen_uid]_AUTOSETUP_AIRLOCK"

	// Setting up buttons
	inner.id_tag = "[final_uid]_interior"
	outer.id_tag = "[final_uid]_exterior"
	inner_button.idDoor = inner.id_tag
	outer_button.idDoor = outer.id_tag
	// Setting up master controller
	inner_controller.idExterior = inner.id_tag
	inner_controller.idInterior = outer.id_tag
	inner_controller.idSelf = "[final_uid]_controller"
	inner_button.idSelf = inner_controller.idSelf
	outer_button.idSelf = inner_controller.idSelf
	// Setting up cycling (if the airlock is overriden)
	LAZYOR(inner.close_others, outer)
	LAZYOR(outer.close_others, inner)
	// Start round as bolted
	inner.locked = TRUE
	inner.autoclose = FALSE
	inner.update_appearance()
	outer.locked = TRUE
	outer.autoclose = FALSE
	outer.update_appearance()
	// Syncing
	inner_button.controller = inner_controller
	outer_button.controller = inner_controller
	inner_button.door = inner
	outer_button.door = outer
	inner_controller.interior_airlock = inner
	inner_controller.exterior_airlock = outer
	// And handle access
	inner.req_access = LAZYLISTDUPLICATE(access)
	outer.req_access = LAZYLISTDUPLICATE(access)
	inner_button.req_access = LAZYLISTDUPLICATE(access)
	outer_button.req_access = LAZYLISTDUPLICATE(access)
	inner_controller.req_access = LAZYLISTDUPLICATE(access)
	// One access too
	inner.req_one_access = LAZYLISTDUPLICATE(one_access)
	outer.req_one_access = LAZYLISTDUPLICATE(one_access)
	inner_button.req_one_access = LAZYLISTDUPLICATE(one_access)
	outer_button.req_one_access = LAZYLISTDUPLICATE(one_access)
	inner_controller.req_one_access = LAZYLISTDUPLICATE(one_access)
	// Finally, naming
	if(prefix_name)
		inner.name = "[prefix_name] Interior Airlock"
		outer.name = "[prefix_name] Exterior Airlock"
		inner_button.name = "[prefix_name] Interior Airlock Access"
		outer_button.name = "[prefix_name] Exterior Airlock Access"
		inner_controller.name = "[prefix_name] Airlock Controller"

// Used to set up atmos-cycling airlocks (makes the airlock into a vacuum)
/obj/effect/mapping_helpers/cycling_airlock_old/atmos
	icon_state = "airlock_setup_atmos"
	name = "guide in desc (vacuum / toxins cycling airlocks helper)"
	desc = "This follows much of the same guide as the non-atmos one, but it has one noticable difference. \
		\
		You have to manually map in the vent pump (and associated atmos), as well as the sensor. \
		But fortunately, you don't need to set them up manually, just map them up and toss in the helper. \
		There's also no buttons, just the controller, but you still need to set the door markers. \
		The controller's put on the outer door.\
		\
		You can also set the pressure (or temp) that the cycle waits for before opening the doors."

	// Leave these `null` if you only want to check temperature
	/// Pressure you want the airlock to be when the INTERIOR door is OPEN
	var/inner_pressure = null
	/// Pressure you want the airlock to be when the EXTERIOR door is OPEN
	var/outer_pressure = null
	/// Leeway applied to the controller recording pressure
	var/pressure_leeway = null

	// Leave these `null` if you only want to check pressure
	/// Temperature you want the airlock to be when the interior airlock is open
	var/inner_temp = null
	/// Temperature you want the airlock to be when the exterior airlock is openw
	var/outer_temp = null
	/// Leeway applied to the controller recording temperature
	var/temp_leeway = null

/obj/effect/mapping_helpers/cycling_airlock_old/atmos/airlock_setup(
	obj/effect/mapping_helpers/cycling_airlock_old/marker/inner_door/inner_mark,
	obj/effect/mapping_helpers/cycling_airlock_old/marker/outer_door/outer_mark,
	obj/machinery/door/airlock/inner,
	obj/machinery/door/airlock/outer,
)
	var/list/obj/machinery/airlock_sensor/sensors = list()
	var/list/obj/machinery/atmospherics/components/binary/dp_vent_pump/high_volume/pumps = list()
	for(var/obj/machinery/machine in range(1, src))
		if(istype(machine, /obj/machinery/airlock_sensor))
			sensors += machine
		if(istype(machine, /obj/machinery/atmospherics/components/binary/dp_vent_pump/high_volume))
			pumps += machine

	if(!length(pumps) || !length(sensors))
		CRASH("Couldn't find the pump or sensor for the airlock cycle auto setup at ([x], [y], [z])")

	var/obj/machinery/airlock_controller/inner_controller = new(inner_mark.loc)
	switch(inner_mark.dir)
		if(WEST)
			inner_controller.pixel_x = -32
		if(NORTH)
			inner_controller.pixel_y = 32
		if(EAST)
			inner_controller.pixel_x = 32
		if(SOUTH)
			inner_controller.pixel_y = -32

	var/final_uid = "__[autogen_uid]_AUTOSETUP_AIRLOCK_ATMOS"

	// Setting up the objects
	inner.id_tag = "[final_uid]_interior"
	outer.id_tag = "[final_uid]_exterior"
	inner_controller.id_tag = "[final_uid]_controller"
	GLOB.objects_by_id_tag[inner_controller.id_tag] = inner_controller // gotta do this manually for airlock sensors
	var/pump_tag = "[final_uid]_pump"
	var/sensor_tag = "[final_uid]_sensor"
	for(var/obj/machinery/airlock_sensor/sensor as anything in sensors)
		sensor.id_tag = sensor_tag
		sensor.master_tag = inner_controller.id_tag
	for(var/obj/pump as anything in pumps)
		pump.id_tag = pump_tag
	// Setting up master controller
	inner_controller.interior_door_tag = inner.id_tag
	inner_controller.exterior_door_tag = outer.id_tag
	inner_controller.airpump_tag = pump_tag
	inner_controller.sensor_tag = sensor_tag
	inner_controller.exterior_target_pressure = outer_pressure
	inner_controller.interior_target_pressure = inner_pressure
	inner_controller.pressure_leeway = pressure_leeway
	inner_controller.exterior_temperature_target = outer_temp
	inner_controller.interior_temperature_target = inner_temp
	inner_controller.temperature_leeway = temp_leeway
	// Setting up cycling (if the airlock is overriden)
	LAZYOR(inner.close_others, outer)
	LAZYOR(outer.close_others, inner)
	// Start round as bolted
	inner.locked = TRUE
	inner.autoclose = FALSE
	inner.update_appearance()
	outer.locked = TRUE
	outer.autoclose = FALSE
	outer.update_appearance()
	// Syncing
	inner_controller.interior_door_ref = WEAKREF(inner)
	inner_controller.exterior_door_ref = WEAKREF(outer)
	for(var/obj/sensor as anything in sensors)
		LAZYADD(inner_controller.sensor_refs, WEAKREF(sensor))
	for(var/obj/pump as anything in pumps)
		LAZYADD(inner_controller.pump_refs, WEAKREF(pump))
	// And handle access
	inner.req_access = LAZYLISTDUPLICATE(access)
	outer.req_access = LAZYLISTDUPLICATE(access)
	inner_controller.req_access = LAZYLISTDUPLICATE(access)
	// One access too
	inner.req_one_access = LAZYLISTDUPLICATE(one_access)
	outer.req_one_access = LAZYLISTDUPLICATE(one_access)
	inner_controller.req_one_access = LAZYLISTDUPLICATE(one_access)
	// Finally, naming
	if(prefix_name)
		inner.name = "[prefix_name] Interior Airlock"
		outer.name = "[prefix_name] Exterior Airlock"
		inner_controller.name = "[prefix_name] Airlock Controller"
		for(var/obj/sensor as anything in sensors)
			sensor.name = "[prefix_name] Airlock Sensor"
		for(var/obj/pump as anything in pumps)
			pump.name = "[prefix_name] Airlock Pump"

// Preset for telecomms
/obj/effect/mapping_helpers/cycling_airlock_old/atmos/tcomms
	prefix_name = "Server Room"
	one_access = list("ce", "tcomms")
	inner_temp = T20C
	outer_temp = T20C * 0.275
	temp_leeway = T20C * 0.01

/obj/effect/mapping_helpers/cycling_airlock_old/atmos/vacuum
	inner_pressure = ONE_ATMOSPHERE
	inner_temp = T20C
	outer_pressure = 0
	pressure_leeway = ONE_ATMOSPHERE * 0.03
	temp_leeway = T20C * 0.01

// For assisting in placement of certain elements in the airlock
/obj/effect/mapping_helpers/cycling_airlock_old/marker

/obj/effect/mapping_helpers/cycling_airlock_old/marker/LateInitialize()
	return

/obj/effect/mapping_helpers/cycling_airlock_old/marker/inner_door
	icon_state = "airlock_setup_inner"
	name = "marks the interior door"
	desc = "Set this marker's dir to point to which wall you want the button on."

/obj/effect/mapping_helpers/cycling_airlock_old/marker/outer_door
	icon_state = "airlock_setup_outer"
	name = "marks the exterior door"
	desc = "Set this marker's dir to point to which wall you want the button on."
