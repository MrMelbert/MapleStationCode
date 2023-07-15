/obj/item/clothing/under/rank/captain/malheur
	name = "disheveled Malheur Research cook's uniform"
	desc = "A disheveled Malheur Research Association Uniform. Whoever the wearer is they don't dress for looks"
	icon_state = "suit"
	inhand_icon_state = "chef"
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'
	can_adjust = FALSE

/obj/item/clothing/gloves/captain/malheur
	name = "\improper Malheur Research chef's glove"
	desc = "Gloves come in a pair normally, wonder where the other glove could be."
	icon_state = "glove"
	gender = "neuter"
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'

/obj/item/clothing/shoes/malheur
	name = "\improper Malheur Research buckled loafers"
	desc = "Ordinary loafers, but they appear to be made with a reinforced leather. Must be standard wear for Malheur Research Uniforms."
	icon_state = "loafers"
	equip_delay_other = 50
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'

/obj/item/clothing/neck/malheur
	name = "heroic scarf"
	desc = "\"Heroes wear red, right?\" Its looks like it can be a bit tighter."
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'
	icon_state = "scarf"
	var/adjusted = FALSE

/obj/item/clothing/neck/malheur/examine(mob/user)
	. = ..()
	if(adjusted)
		. += "Alt-click on [src] to wear it normally."
	else
		. += "Alt-click on [src] to tighten it."

/obj/item/clothing/neck/malheur/AltClick(mob/user)
	. = ..()
	if(adjusted)
		icon_state = "scarf"
	else
		icon_state = "scarf_1"
	user.balloon_alert(user, "scarf adjusted")
	var/mob/living/carbon/human/hum = user
	hum.update_worn_neck()
	hum.update_body()
	adjusted = !adjusted

// Bag time
/obj/item/storage/bag/garment/captain/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/captain/malheur(src)
	new /obj/item/clothing/gloves/captain/malheur(src)
	new /obj/item/clothing/shoes/malheur(src)
	new /obj/item/clothing/neck/malheur(src)
