// fox tails. Renault Geckers.
/obj/item/organ/tail/fox // redundant, this is either a failsafe, or if someone specifically wants a fox tail for whatever purpose (EG. Limbgrower), that is detached from cat tails
	name = "fox tail"
	icon = 'maplestation_modules/icons/obj/surgery.dmi'
	icon_state = "severedfoxtail"

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/fox
	wag_flags = WAG_ABLE
	preference = "feature_human_tail"


/datum/bodypart_overlay/mutant/tail/fox // also redundant, used exclusively for above, the ones accesible through character creator are just different sprite_accessories on cat_tail
	feature_key = "tail_cat"
	color_source = ORGAN_COLOR_HAIR
	sprite_datum = /datum/sprite_accessory/tails/human/fox

/datum/sprite_accessory/tails/human/fox
	name = "Fox"
	icon_state = "fox"
	icon = 'maplestation_modules/icons/mob/mutant_bodyparts.dmi'
	color_src = HAIR_COLOR
	locked = TRUE

/datum/design/fox_tail
	name = "Fox Tail"
	id = "foxtail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/fox
	category = list(SPECIES_HUMAN)

// five fox tails, because having 9 would be impossible to sprite and have it look good

/obj/item/organ/tail/fivefox // ditto.
	name = "five fox tails"
	icon = 'maplestation_modules/icons/obj/surgery.dmi'
	icon_state = "severedfivefoxtail"

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/cat/fivefox
	wag_flags = WAG_ABLE
	preference = "feature_human_tail"

/datum/bodypart_overlay/mutant/tail/cat/fivefox // ditto.
	feature_key = "tail_cat"
	color_source = ORGAN_COLOR_HAIR
	sprite_datum = /datum/sprite_accessory/tails/human/fivefox

/datum/sprite_accessory/tails/human/fivefox
	name = "Five Fox"
	icon_state = "fivefox"
	icon = 'maplestation_modules/icons/mob/mutant_bodyparts.dmi'
	color_src = HAIR_COLOR
	locked = TRUE

/datum/design/fivefox_tail
	name = "Five Fox Tails"
	id = "fivefoxtails"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/fivefox
	category = list(SPECIES_HUMAN)
