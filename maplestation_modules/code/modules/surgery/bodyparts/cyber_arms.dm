// Designs
/datum/design/advanced_r_arm/clawed
	name = "Advanced Clawed Right Arm"
	desc = "An advanced robotic arm with in built sharp claws. Makes you formidable in close combat, \
		though unfortunately the claws are not retractable, and may make it difficult to manipulate small objects."
	id = "clawed_advanced_r_arm"
	build_path = /obj/item/bodypart/arm/left/robot/advanced/claws

/datum/design/advanced_l_arm/clawed
	name = "Advanced Clawed Left Arm"
	desc = /datum/design/advanced_r_arm/clawed::desc
	id = "clawed_advanced_l_arm"
	build_path = /obj/item/bodypart/arm/right/robot/advanced/claws

/datum/design/advanced_r_arm/lifting
	name = "Advanced Lifting Right Arm"
	desc = "An advanced robotic arm with enhanced lifting capabilities. Makes you formidable in close combat - \
		particularly grappling - and better at construction of large objects, \
		though unfortunately the bulkier design may make it difficult to manipulate small objects."
	id = "punchy_advanced_r_arm"
	build_path = /obj/item/bodypart/arm/left/robot/advanced/lifting

/datum/design/advanced_l_arm/lifting
	name = "Advanced Lifting Left Arm"
	id = "punchy_advanced_l_arm"
	build_path = /obj/item/bodypart/arm/right/robot/advanced/lifting

// Limbs
/obj/item/bodypart/arm/left/robot/advanced/claws
	name = "advanced clawed robotic left arm"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20
	unarmed_attack_verb = "slash"
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	icon_static = 'icons/mob/augmentation/augments_security.dmi'
	icon = 'icons/mob/augmentation/augments_security.dmi'

/obj/item/bodypart/arm/right/robot/advanced/claws
	name = "advanced clawed robotic right arm"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20
	unarmed_attack_verb = "slash"
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	icon_static = 'icons/mob/augmentation/augments_security.dmi'
	icon = 'icons/mob/augmentation/augments_security.dmi'

/obj/item/bodypart/arm/left/robot/advanced/lifting
	name = "advanced lifting robotic left arm"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20
	unarmed_attack_effect = ATTACK_EFFECT_SMASH
	bodypart_traits = list(TRAIT_CHUNKYFINGERS, TRAIT_QUICKER_CARRY, TRAIT_QUICK_BUILD)
	icon_static = 'icons/mob/augmentation/augments_engineer.dmi'
	icon = 'icons/mob/augmentation/augments_engineer.dmi'

/obj/item/bodypart/arm/right/robot/advanced/lifting
	name = "advanced lifting robotic right arm"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 20
	unarmed_attack_effect = ATTACK_EFFECT_SMASH
	bodypart_traits = list(TRAIT_CHUNKYFINGERS, TRAIT_QUICKER_CARRY, TRAIT_QUICK_BUILD)
	icon_static = 'icons/mob/augmentation/augments_engineer.dmi'
	icon = 'icons/mob/augmentation/augments_engineer.dmi'
