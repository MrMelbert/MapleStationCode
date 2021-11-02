/datum/chemical_reaction/slime/slimelizard //override the reaction
	results = list(/datum/reagent/unstable_mutation = 1)
	required_reagents = list(/datum/reagent/uranium/radium = 1)
	required_other = TRUE
	required_container = /obj/item/slime_extract/green

/datum/chemical_reaction/mutation_toxin
	reaction_tags = REACTION_TAG_EASY

/datum/chemical_reaction/mutation_toxin/lizard_mutation
	results = list(/datum/reagent/mutationtoxin/lizard = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/consumable/frostoil = 1) //lizerds are cold-blooded

/datum/chemical_reaction/mutation_toxin/felinid_mutation
	results = list(/datum/reagent/mutationtoxin/felinid = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/mutation_toxin/moth_mutation
	results = list(/datum/reagent/mutationtoxin/moth = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/consumable/tinlux = 1) //Tinea Luxor, makes it a bit harder than the rest but its funny because glow

/datum/chemical_reaction/mutation_toxin/fly_mutation
	results = list(/datum/reagent/mutationtoxin/fly = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/yuck = 1)

/datum/chemical_reaction/mutation_toxin/jelly_mutation
	results = list(/datum/reagent/mutationtoxin/jelly = 2)
	required_reagents = list(/datum/reagent/mutationtoxin = 1, /datum/reagent/water = 1) //water down the toxin

/datum/chemical_reaction/mutation_toxin/abductor_mutation
	results = list(/datum/reagent/mutationtoxin/abductor = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/toxin/mutetoxin = 1) //get it abductors are mute

/datum/chemical_reaction/mutation_toxin/empowered_mutation
	results = list(/datum/reagent/unstable_mutation/empowered = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/medicine/earthsblood = 1) //the stronger unstable mutation toxin

/datum/chemical_reaction/mutation_toxin/ash_mutation
	results = list(/datum/reagent/mutationtoxin/ash = 2)
	required_reagents = list(/datum/reagent/unstable_mutation/empowered = 1, /datum/reagent/mutationtoxin/lizard = 1)

/datum/chemical_reaction/mutation_toxin/skeleton_mutation
	results = list(/datum/reagent/mutationtoxin/skeleton = 2)
	required_reagents = list(/datum/reagent/unstable_mutation/empowered = 1, /datum/reagent/consumable/milk = 1)

/datum/chemical_reaction/mutation_toxin/shadow_mutation
	results = list(/datum/reagent/mutationtoxin/shadow = 2)
	required_reagents = list(/datum/reagent/unstable_mutation/empowered = 1, /datum/reagent/liquid_dark_matter = 1)

/datum/chemical_reaction/mutation_toxin/synth_mutation
	results = list(/datum/reagent/mutationtoxin/synth = 2)
	required_reagents = list(/datum/reagent/unstable_mutation/empowered = 1, /datum/reagent/iron = 1)

/datum/chemical_reaction/mutation_toxin/skrell_mutation
	results = list(/datum/reagent/mutationtoxin/skrell = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/toxin/carpotoxin = 1) //i dunno i just picked a fish thing because skrell have tentacles

/datum/chemical_reaction/mutation_toxin/reploid_mutation
	results = list(/datum/reagent/mutationtoxin/reploid = 2)
	required_reagents = list(/datum/reagent/unstable_mutation = 1, /datum/reagent/silicon = 1)
