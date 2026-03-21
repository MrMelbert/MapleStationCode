// -- Scientist changes --
/datum/job/scientist
	description = "Do experiments, perform research, \
		identify strange anomalies, manufacture occasionally useful circuitry."
	total_positions = 3
	spawn_positions = 3 // 1 to do RND, 1 to do circuitry, 1 to do EXPERIMENTOR or cyto some other wacky science.
	family_heirlooms = list(
		/obj/item/book/manual/wiki/cytology,
		/obj/item/reagent_containers/cup/beaker,
	)
