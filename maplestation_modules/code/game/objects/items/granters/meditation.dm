/obj/item/book/granter/action/spell/meditation
	name = "Nanotrasen Approved Meditation Guidebook"
	granted_action = /datum/action/cooldown/spell/meditate
	action_name = "meditation"
	icon = 'maplestation_modules/icons/obj/service/library.dmi'
	pages_to_mastery = 5
	icon_state = "bookmeditation"
	desc = "The backside is littered with phrases such as: 'Get all access to your mind!' '10 Quick Tips to make your willpower Robust!' and 'Copyright Nanotrasen Inspiration Machine 2565.'"
	remarks = list(
		"So I just hold still and just... do nothing?",
		"There are several sections about the productive benefits about meditation, but very little about the actual quality of life benefits.",
		"Theres an already out of date coupon for 'healing crystals' in the pages.",
		"You know, despite the eight spoked wheel representing the Noble Eightfold Path of Buddhism printed on the front, there has been no actual reference to Buddhism or its principles.",
		"At this rate I should probably find what works for me on my own.",
		"Focus on my breathing, and clear my mind of thoughts. Oh wait, I need to keep reading.",
		"It says that I should ideally find a comfortable or non-intrusive place to meditate in, and then recommends a list of various mats and seats to try. Or I could just make one with some cloth.",
	)

/obj/item/book/granter/action/spell/meditation/recoil(mob/living/user)
	. = ..()
	to_chat(user, "That copy was dreadfully uninformative, unoriginal, and honestly boring.")
	user.emote("yawn")

/obj/item/book/granter/action/spell/lesser_splattercasting
	name = "Nanotrasen Unapproved Meditation Guidebook"
	granted_action = /datum/action/cooldown/spell/meditate/lesser_splattercasting
	action_name = "lesser splattercasting"
	icon = 'maplestation_modules/icons/obj/service/library.dmi'
	pages_to_mastery = 5
	icon_state = "booklessersplattercasting"
	desc = "The backside is littered with phrases such as: 'How to make your mind valid!' 'Greytiding success in your future!' and 'Copyright Syndicate Inspiration Machine 2565.'"
	remarks = list(
		"Wait, isn't blood magic banned by the Syndicate too?",
		"Can they stop with the joke of repeatedly appending the same information with 'evil?' I don't think the Syndicate personally thinks they're evil.",
		"It says that a sharp object isn't entirely needed, just intent and mastery.",
		"Ideally I should have some method of recovering the blood available, such as iron or a Bloody Mary.",
		"A prepared site where I can focus more clearly without environmental disturbances is best, especially since people will be confused about what I'm doing.",
		"Doing this after drinking a Nar'Sour would be pretty funny, actually.",
		"Another section of dry motivational quotes. Great.",
		"This is just a blank red page.",
		"Wait, why was there a blank red page? Doesn't blood turn brownish when it dries on paper?",
	)

/obj/item/book/granter/action/spell/lesser_splattercasting/recoil(mob/living/user)
	. = ..()
	to_chat(user, "That copy was also dreadfully uninformative, unoriginal, and honestly boring.")
	user.emote("yawn")
