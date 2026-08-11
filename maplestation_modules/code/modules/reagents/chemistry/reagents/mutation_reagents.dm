/datum/reagent/unstable_mutation
	name = "Unstable Mutation Toxin"
	description = "An unstable mutation toxin. Can be converted into other toxins."
	color = "#5EFF3B" //RGB: 94, 255, 59
	taste_description = "like not really knowing what you're doing"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/unstable_mutation/empowered
	name = "Empowered Mutation Toxin"
	description = "A stronger version of unstable mutation toxin. This could make some interesting species."

/datum/reagent/mutationtoxin/skrell
	name = "Skrell Mutation Toxin"
	description = "A non-euclidian-looking toxin. It has protrusions."
	color = "#5EFF3B" //RGB: 94, 255, 59
	race = /datum/species/skrell
	taste_description = "calamari"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
