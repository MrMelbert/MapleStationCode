/obj/item/organ/ears/cat/cybernetic
	name = "cybernetic cat ears"
	icon = 'maplestation_modules/icons/obj/clothing/hats.dmi'
	icon_state = "cyber_kitty"
	damage_multiplier = 1.5 //slightly better than regular cat ears

/obj/item/organ/ears/cat/cybernetic/Insert(mob/living/carbon/human/ear_owner, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(ear_owner))
		color = ear_owner.hair_color
		ear_owner.dna.features["ears"] = ear_owner.dna.species.mutant_bodyparts["ears"] = "Cybernetic Cat"
		ear_owner.update_body()

/obj/item/organ/ears/cat/cybernetic/Remove(mob/living/carbon/human/ear_owner,  special = 0)
	..()
	if(istype(ear_owner))
		color = ear_owner.hair_color
		ear_owner.dna.features["ears"] = "None"
		ear_owner.dna.species.mutant_bodyparts -= "ears"
		ear_owner.update_body()

/obj/item/organ/ears/cat/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	damage += 40/severity
