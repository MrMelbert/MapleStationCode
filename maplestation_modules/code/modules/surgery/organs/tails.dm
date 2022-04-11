/obj/item/organ/tail/cat/fox
	name = "fox tail"
	desc = "A severed fox tail. Geckers."
	tail_type = "Fox"
	icon = 'maplestation_modules/icons/obj/surgery.dmi'
	icon_state = "severedfoxtail"

/obj/item/organ/tail/cat/fox/Insert(mob/living/carbon/human/tail_owner, special = FALSE, drop_if_replaced = TRUE)
	..()
	if(istype(tail_owner))
		var/default_part = tail_owner.dna.species.mutant_bodyparts["tail_human"]
		if(!default_part || default_part == "None")
			if(tail_type)
				tail_owner.dna.features["tail_human"] = tail_owner.dna.species.mutant_bodyparts["tail_human"] = tail_type
				tail_owner.dna.update_uf_block(DNA_HUMAN_TAIL_BLOCK)
			else
				tail_owner.dna.species.mutant_bodyparts["tail_human"] = tail_owner.dna.features["tail_human"]
			tail_owner.update_body()

/obj/item/organ/tail/cat/fox/Remove(mob/living/carbon/human/tail_owner, special = FALSE)
	..()
	if(istype(tail_owner))
		tail_owner.dna.species.mutant_bodyparts -= "tail_human"
		color = tail_owner.hair_color
		tail_owner.update_body()
