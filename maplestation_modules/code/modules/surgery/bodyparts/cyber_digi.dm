/datum/design/borg_r_leg/digi
	name = "Digitigrade Cybernetic Right Leg"
	desc = "A cybernetic leg designed to give you a digitigrade stance. \
		Makes you better at sprinting, and gives you a bit more of a kick in combat, \
		though makes it difficult to wear normal shoes."
	id = "digitigrade_cyber_r_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/right/robot/digi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/borg_l_leg/digi
	name = "Digitigrade Cybernetic Left Leg"
	desc = /datum/design/borg_r_leg/digi::desc
	id = "digitigrade_cyber_l_leg"
	build_path = /obj/item/bodypart/leg/left/robot/digi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/advanced_r_leg/digi
	name = "Digitigrade Advanced Right Leg"
	desc = "An advanced robotic leg designed to give you a digitigrade stance. \
		Makes you better at sprinting, and gives you a bit more of a kick in combat, \
		though makes it difficult to wear normal shoes."
	id = "digitigrade_advanced_r_leg"
	build_path = /obj/item/bodypart/leg/right/robot/advanced/digi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

/datum/design/advanced_l_leg/digi
	name = "Digitigrade Advanced Left Leg"
	desc = /datum/design/advanced_r_leg/digi::desc
	id = "digitigrade_advanced_l_leg"
	build_type = MECHFAB
	build_path = /obj/item/bodypart/leg/left/robot/advanced/digi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_CYBERNETICS_ADVANCED_LIMBS
	)

// Limbs
/obj/item/bodypart/leg/right/robot/digi
	name = "cyborg digitigrade right leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_default.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_default.dmi'
	icon_state = "digitigrade_r_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	limb_id = BODYPART_ID_DIGITIGRADE
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20

/obj/item/bodypart/leg/right/robot/digi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 10)
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/right/robot::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/right/robot/::icon_static, \
		free_icon = initial(icon_static), \
	)

/obj/item/bodypart/leg/left/robot/digi
	name = "cyborg digitigrade left leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_default.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_default.dmi'
	icon_state = "digitigrade_l_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	limb_id = BODYPART_ID_DIGITIGRADE
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20

/obj/item/bodypart/leg/left/robot/digi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 10)
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/left/robot::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/left/robot::icon_static, \
		free_icon = initial(icon_static), \
	)

/obj/item/bodypart/leg/right/robot/surplus/digi
	name = "prosthetic digitigrade right leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_prosthetic.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_prosthetic.dmi'
	icon_state = "digitigrade_r_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	limb_id = BODYPART_ID_DIGITIGRADE

/obj/item/bodypart/leg/right/robot/surplus/digi/Initialize(mapload)
	. = ..()
	// 0 buff - +5 for digi, -5 for prosthetic
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/right/robot/surplus::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/right/robot/surplus::icon_static, \
		free_icon = initial(icon_static), \
	)

/obj/item/bodypart/leg/left/robot/surplus/digi
	name = "prosthetic digitigrade right leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_prosthetic.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_prosthetic.dmi'
	icon_state = "digitigrade_l_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	limb_id = BODYPART_ID_DIGITIGRADE

/obj/item/bodypart/leg/left/robot/surplus/digi/Initialize(mapload)
	. = ..()
	// 0 buff - +5 for digi, -5 for prosthetic
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/left/robot/surplus::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/left/robot/surplus::icon_static, \
		free_icon = initial(icon_static), \
	)

/obj/item/bodypart/leg/right/robot/advanced/digi
	name = "advanced digitigrade right leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_advanced.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_advanced.dmi'
	icon_state = "digitigrade_r_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	unarmed_damage_low = 12
	unarmed_damage_high = 18
	unarmed_effectiveness = 20
	limb_id = BODYPART_ID_DIGITIGRADE

/obj/item/bodypart/leg/right/robot/advanced/digi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 20)
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/right/robot/advanced::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/right/robot/advanced::icon_static, \
		free_icon = initial(icon_static), \
	)

/obj/item/bodypart/leg/left/robot/advanced/digi
	name = "advanced digitigrade right leg"
	icon_static = 'maplestation_modules/icons/mob/augmentation/digitigrade_advanced.dmi'
	icon = 'maplestation_modules/icons/mob/augmentation/digitigrade_advanced.dmi'
	icon_state = "digitigrade_l_leg"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE
	unarmed_damage_low = 12
	unarmed_damage_high = 18
	unarmed_effectiveness = 20
	limb_id = BODYPART_ID_DIGITIGRADE

/obj/item/bodypart/leg/left/robot/advanced/digi/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 20)
	AddElement( \
		/datum/element/digitigrade_limb/change_static_icon, \
		squashed_id = /obj/item/bodypart/leg/left/robot/advanced::limb_id, \
		free_id = initial(limb_id), \
		squashed_icon = /obj/item/bodypart/leg/left/robot/advanced::icon_static, \
		free_icon = initial(icon_static), \
	)

// Prefs menu
/datum/limb_option_datum/bodypart/cybernetic_r_leg/digi
	name = "Cybernetic Digitigrade Right Leg"
	tooltip = "Unique to Lizardpeople."
	limb_path = /obj/item/bodypart/leg/right/robot/digi

/datum/limb_option_datum/bodypart/cybernetic_r_leg/digi/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/limb_option_datum/bodypart/cybernetic_r_leg/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return islizard(apply_to)

/datum/limb_option_datum/bodypart/cybernetic_l_leg/digi
	name = "Cybernetic Digitigrade Left Leg"
	tooltip = "Unique to Lizardpeople."
	limb_path = /obj/item/bodypart/leg/left/robot/digi

/datum/limb_option_datum/bodypart/cybernetic_l_leg/digi/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/limb_option_datum/bodypart/cybernetic_l_leg/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return islizard(apply_to)

/datum/limb_option_datum/bodypart/prosthetic_r_leg/digi
	name = "Prosthetic Digitigrade Right Leg"
	tooltip = "Unique to Lizardpeople."
	limb_path = /obj/item/bodypart/leg/right/robot/surplus/digi

/datum/limb_option_datum/bodypart/prosthetic_r_leg/digi/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/limb_option_datum/bodypart/prosthetic_r_leg/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return islizard(apply_to)

/datum/limb_option_datum/bodypart/prosthetic_l_leg/digi
	name = "Prosthetic Digitigrade Left Leg"
	tooltip = "Unique to Lizardpeople."
	limb_path = /obj/item/bodypart/leg/left/robot/surplus/digi

/datum/limb_option_datum/bodypart/prosthetic_l_leg/digi/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/limb_option_datum/bodypart/prosthetic_l_leg/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return islizard(apply_to)
