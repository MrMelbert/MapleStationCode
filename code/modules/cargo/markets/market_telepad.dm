/obj/item/circuitboard/machine/ltsrbt
	name = "LTSRBT (Machine Board)"
	icon_state = "bluespacearray"
	build_path = /obj/machinery/ltsrbt
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/datum/stock_part/ansible = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/scanning_module = 2)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/machinery/ltsrbt
	name = "Long-To-Short-Range-Bluespace-Transceiver"
	desc = "The LTSRBT is a compact teleportation machine for receiving and sending items outside the station and inside the station.\nUsing teleportation frequencies stolen from NT it is near undetectable.\nEssential for any illegal market operations on NT stations.\n"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "exonet_node"
	circuit = /obj/item/circuitboard/machine/ltsrbt
	density = TRUE

	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 2

	/// Divider for energy_usage_per_teleport.
	var/power_efficiency = 1
	/// Power used per teleported which gets divided by power_efficiency.
	var/energy_usage_per_teleport = 10 KILO JOULES
	/// The time it takes for the machine to recharge before being able to send or receive items.
	var/recharge_time = 0
	/// Current recharge progress.
	var/recharge_cooldown = 0
	/// Base recharge time in seconds which is used to get recharge_time.
	var/base_recharge_time = 100
	/// Current /datum/market_purchase being received.
	var/receiving
	/// Current /datum/market_purchase being sent to the target uplink.
	var/transmitting
	/// Queue for purchases that the machine should receive and send.
	var/list/datum/market_purchase/queue = list()

/obj/machinery/ltsrbt/Initialize(mapload)
	. = ..()
	SSblackmarket.telepads += src

/obj/machinery/ltsrbt/Destroy()
	SSblackmarket.telepads -= src
	// Bye bye orders.
	if(SSblackmarket.telepads.len)
		for(var/datum/market_purchase/P in queue)
			SSblackmarket.queue_item(P)
	. = ..()

/obj/machinery/ltsrbt/RefreshParts()
	. = ..()
	recharge_time = base_recharge_time
	// On tier 4 recharge_time should be 20 and by default it is 80 as scanning modules should be tier 1.
	for(var/datum/stock_part/scanning_module/scanning_module in component_parts)
		recharge_time -= scanning_module.tier * 10
	recharge_cooldown = recharge_time

	power_efficiency = 0
	for(var/datum/stock_part/micro_laser/laser in component_parts)
		power_efficiency += laser.tier
	// Shouldn't happen but you never know.
	if(!power_efficiency)
		power_efficiency = 1

/// Adds /datum/market_purchase to queue unless the machine is free, then it sets the purchase to be instantly received
/obj/machinery/ltsrbt/proc/add_to_queue(datum/market_purchase/purchase)
	if(!recharge_cooldown && !receiving && !transmitting)
		receiving = purchase
		return
	queue += purchase

/obj/machinery/ltsrbt/process(seconds_per_tick)
	if(machine_stat & NOPOWER)
		return

	if(recharge_cooldown > 0)
		recharge_cooldown -= seconds_per_tick
		return

	var/turf/T = get_turf(src)
	if(receiving)
		var/datum/market_purchase/P = receiving

		if(!P.item || ispath(P.item))
			P.item = P.entry.spawn_item(T)
		else
			var/atom/movable/M = P.item
			M.forceMove(T)

		use_energy(energy_usage_per_teleport / power_efficiency)
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(5, 1, get_turf(src))
		sparks.attach(P.item)
		sparks.start()

		receiving = null
		transmitting = P

		recharge_cooldown = recharge_time
		return
	else if(transmitting)
		var/datum/market_purchase/P = transmitting
		if(!P.item)
			QDEL_NULL(transmitting)
		if(!(P.item in T.contents))
			QDEL_NULL(transmitting)
			return
		do_teleport(P.item, get_turf(P.uplink))
		use_energy(energy_usage_per_teleport / power_efficiency)
		QDEL_NULL(transmitting)

		recharge_cooldown = recharge_time
		return

	if(queue.len)
		receiving = pick_n_take(queue)
