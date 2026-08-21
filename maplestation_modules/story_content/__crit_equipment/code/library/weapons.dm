/obj/item/melee/kanabo
	name = "kanabō"
	desc = "A spiked club associated with Oni. It's incredibly heavy."
	icon = 'maplestation_modules/story_content/__crit_equipment/icons/kanabo.dmi'
	icon_state = "kanabo"
	inhand_icon_state = "kanabo"
	lefthand_file = 'maplestation_modules/story_content/__crit_equipment/icons/kanabo_lefthand.dmi'
	righthand_file = 'maplestation_modules/story_content/__crit_equipment/icons/kanabo_righthand.dmi'
	force = 35
	wound_bonus = 15
	throwforce = 25
	demolition_mod = 1.25 // VERY destructive!
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/iron = SHEET_MATERIAL_AMOUNT)
	w_class = WEIGHT_CLASS_BULKY
	drop_sound = 'maplestation_modules/sound/items/drop/wooden.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/wooden.ogg'
