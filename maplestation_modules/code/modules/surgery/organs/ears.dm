/obj/item/organ/internal/ears/cat/cybernetic
	name = "cybernetic cat ears"
	desc = "Replacement cat ears that are better than the original model. You're getting closer to becoming the ultimate creature."
	icon = 'maplestation_modules/icons/obj/clothing/hats.dmi'
	icon_state = "cyber_kitty"
	damage_multiplier = 1.5 //slightly better than regular cat ears

/datum/bodypart_overlay/mutant/cat_ears/cybernetic // snowflaked because these are for seperate organs
	feature_key = "catcyber"

/obj/item/organ/internal/ears/cat/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	apply_organ_damage(40 /  severity)

/datum/sprite_accessory/ears/cat/cyber
	name = "Cybernetic Cat"
	icon_state = "catcyber"
	icon = 'maplestation_modules/icons/mob/mutant_bodyparts.dmi'
	locked = TRUE
