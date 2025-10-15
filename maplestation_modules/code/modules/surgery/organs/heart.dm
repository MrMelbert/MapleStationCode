/obj/item/organ/heart/werewolf
	name = "massive heart"
	desc = "An absolutely monstrous heart."
	icon_state = "heart-on"
	base_icon_state = "heart"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD

/obj/item/organ/heart/werewolf/Initialize(mapload)
	. = ..()
	transform = transform.Scale(1.5)

/obj/item/organ/heart/werewolf/on_mob_insert(mob/living/carbon/heart_owner)
	. = ..()
	// Gives rage to the heart owner.
	var/datum/action/cooldown/spell/werewolf_rage/rage = new(heart_owner)
	rage.Grant(heart_owner)

/obj/item/organ/heart/werewolf/on_mob_remove(mob/living/carbon/heart_owner, special = FALSE)
	. = ..()
	var/datum/action/cooldown/spell/werewolf_rage/rage = locate() in heart_owner.actions
	qdel(rage)
