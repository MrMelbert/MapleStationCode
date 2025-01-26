/obj/structure/sign/poster/official/puppets_3
	name = "The Puppets 3: Goobit's Revenge"
	desc = "A poster for the award-winning box-office-megabomb culmination of The Puppets franchise. \
	The film is notable for being both the highest-rated and lowest-earning movie of all time, due to the production company being legally required to refund every ticket \
	at 3 times the original price."
	icon_state = "puppets"
	icon = 'maplestation_modules/icons/obj/posters.dmi'

/obj/structure/sign/poster/official/puppets_3/examine(mob/user)
	. = ..()
	. += notice("A tagline on the bottom reads: \"The City needs a hero, but all they could find were these guys...\"")

/obj/structure/sign/poster/contraband/goobit
	name = "Goobit's Gambit"
	desc = "A poster of Goobit from the movie \"The Puppets 3: Goobit's Revenge\". This poster is notable for its use by eco-terrorist groups for propaganda. \
	These groups would regularly mimic the actions of Goobit by flooding entire planets water supply with vegetable oil in order to \"Make the planet strong\", \
	usually resulting in the deaths of all life on said planet. Possession of any pro-Goobit contraband is an act of high treason in most governments, with the average \
	felon found guilty of this being 3 years of age. Punishment for the crime tends to be excommunication via spaceraft, with all 1,659 recovered rafts being found empty, \
	but otherwise in expected condition."
	icon_state = "goobit"
	icon = 'maplestation_modules/icons/obj/posters.dmi'
