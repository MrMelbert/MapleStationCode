// Left
/datum/limb_option_datum/bodypart/cybernetic_l_leg/engineer
	name = "Nanotrasen Engineering Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_l_leg/security
	name = "Nanotrasen Security Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/security

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mining
	name = "Nanotrasen Mining Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_l_leg/bishop
	name = "Bishop Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_l_leg/bishop/mk2
	name = "Bishop MK2 Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_leg/hephaestus
	name = "Hephaestus Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_l_leg/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mariinsky
	name = "Mariinsky Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mcg
	name = "MCG Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_l_leg/sgm
	name = "SGM Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_l_leg/wtm
	name = "WTM Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_l_leg/xmg
	name = "XMG Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhenkov
	name = "Zhenkov Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhp
	name = "ZHP Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhp/digi
	name = "ZHP Cybernetic Digitigrade Left Leg"
	tooltip = "Unique to Digitigrade species."
	limb_path = /obj/item/bodypart/leg/left/robot/digi/zhp

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhp/digi/can_be_selected(datum/preferences/prefs)
	return digi_prefs_check(prefs)

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhp/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return digi_mob_check(apply_to)

/datum/limb_option_datum/bodypart/cybernetic_l_leg/monokai
	name = "Monokai Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/monokai

// Right
/datum/limb_option_datum/bodypart/cybernetic_r_leg/engineer
	name = "Nanotrasen Engineering Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_r_leg/security
	name = "Nanotrasen Security Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/security

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mining
	name = "Nanotrasen Mining Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_r_leg/bishop
	name = "Bishop Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_r_leg/bishop/mk2
	name = "Bishop MK2 Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_leg/hephaestus
	name = "Hephaestus Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_r_leg/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mariinsky
	name = "Mariinsky Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mcg
	name = "MCG Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_r_leg/sgm
	name = "SGM Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_r_leg/wtm
	name = "WTM Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_r_leg/xmg
	name = "XMG Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhenkov
	name = "Zhenkov Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhp
	name = "ZHP Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhp/digi
	name = "ZHP Cybernetic Digitigrade Right Leg"
	tooltip = "Unique to Digitigrade species."
	limb_path = /obj/item/bodypart/leg/right/robot/digi/zhp

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhp/digi/can_be_selected(datum/preferences/prefs)
	return digi_prefs_check(prefs)

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhp/digi/can_be_applied(mob/living/carbon/human/apply_to)
	return digi_mob_check(apply_to)

/datum/limb_option_datum/bodypart/cybernetic_r_leg/monokai
	name = "Monokai Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/monokai
