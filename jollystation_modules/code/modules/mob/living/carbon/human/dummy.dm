///Sets up dummies properly with no special organs.
/mob/living/carbon/human/dummy/consistent/setup_human_dna()
	. = ..()
	dna.features["head_tentacles"] = "Long"
	dna.features["ipc_screen"] = "None"
	dna.features["reploid_antenna"] = "None"
