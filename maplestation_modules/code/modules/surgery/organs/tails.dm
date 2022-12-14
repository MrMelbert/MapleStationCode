// melbert todo unticked while I figure out tail code
/obj/item/organ/external/tail/cat/fox
	name = "fox tail"
	desc = "A severed fox tail. Geckers."
	tail_type = "Fox"
	icon = 'maplestation_modules/icons/obj/surgery.dmi'
	icon_state = "severedfoxtail"

/obj/item/organ/external/tail/cat/fox/Insert(mob/living/carbon/human/tail_owner, special = FALSE, drop_if_replaced = TRUE)
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

/obj/item/organ/external/tail/cat/fox/Remove(mob/living/carbon/human/tail_owner, special = FALSE)
	..()
	if(istype(tail_owner))
		tail_owner.dna.species.mutant_bodyparts -= "tail_human"
		color = tail_owner.hair_color
		tail_owner.update_body()

/datum/design/foxtail
	name = "Fox Tail"
	id = "foxtail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/external/tail/cat/fox
	category = list("other")

/obj/item/disk/design_disk/limbs/felinid
	limb_designs = list(/datum/design/cat_tail, /datum/design/cat_ears, /datum/design/foxtail)
