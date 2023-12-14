/obj/item/clothing/under/rank/captain/malheur
	name = "disheveled Malheur Research cook's uniform"
	desc = "A disheveled Malheur Research Association Uniform. Whoever the wearer is, they don't dress for looks."
	icon_state = "suit"
	inhand_icon_state = "chef"
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'
	can_adjust = FALSE

/obj/item/clothing/gloves/captain/malheur
	name = "\improper Malheur Research chef's glove"
	desc = "Gloves come in a pair normally... Wonder where the other glove could be."
	icon_state = "glove"
	gender = NEUTER
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'

/obj/item/clothing/shoes/malheur
	name = "\improper Malheur Research buckled loafers"
	desc = "Ordinary loafers, but they appear to be made with a reinforced leather. Must be standard wear for Malheur Research Uniforms."
	icon_state = "loafers"
	equip_delay_other = 5 SECONDS
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'

/obj/item/clothing/neck/malheur
	name = "heroic scarf"
	desc = "\"Heroes wear red, right?\" It looks like it can be a bit tighter."
	icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/laurence_equipment/icons/laurclothes_worn.dmi'
	icon_state = "scarf"

/obj/item/clothing/neck/malheur/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "tightness")

// Bag time
/obj/item/storage/bag/garment/cap_cust/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/captain/malheur(src)
	new /obj/item/clothing/gloves/captain/malheur(src)
	new /obj/item/clothing/shoes/malheur(src)
	new /obj/item/clothing/neck/malheur(src)
