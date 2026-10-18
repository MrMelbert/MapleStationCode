// overrides so we dont do goofy things like protolathes printing things out at 0x cost
// as well as new functionality if thought of

/obj/machinery/rnd/production/compute_efficiency()
	. = ..()

	return max(..(), 0.25)

// returns >100% reduced chance of malfunction with tier 5 parts. ignore how tier 3 parts already remove malfunctions
/obj/machinery/teleport/hub/RefreshParts()
	. = ..()

	if(accuracy > 5)
		accuracy = 5

// can do negative brain damage. funny, but probably bad
/obj/machinery/netpod/on_server_upgraded(obj/machinery/quantum_server/source)
	if (disconnect_damage < 0)
		disconnect_damage = 0
