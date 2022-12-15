/datum/reagent/unstable_mutation
	name = "Unstable Mutation Toxin"
	description = "An unstable mutation toxin. Can be converted into other toxins."
	color = "#5EFF3B" //RGB: 94, 255, 59
	taste_description = "like not really knowing what you're doing"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/unstable_mutation/empowered
	name = "Empowered Mutation Toxin"
	description = "A stronger version of unstable mutation toxin. This could make some interesting species."

/*
Disabled as synths don't exist
/datum/reagent/mutationtoxin/synth
	name = "Synth Mutation Toxin"
	description = "A synthetic-looking toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/synth
	taste_description = "metallic bones"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
*/

/datum/reagent/mutationtoxin/skrell
	name = "Skrell Mutation Toxin"
	description = "A non-euclidian-looking toxin. It has protrusions."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/skrell
	taste_description = "calamari"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/mutationtoxin/reploid
	name = "Reploid Mutation Toxin"
	description = "A synthetic toxin."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/reploid
	taste_description = "maverick dreams"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
