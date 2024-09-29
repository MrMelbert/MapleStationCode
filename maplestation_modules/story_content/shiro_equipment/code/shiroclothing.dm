/obj/item/clothing/under/shirodress
	name = "Doll’s Formal Uniform"
	desc = "A custom fit uniform made from higher quality fabric. Its pockets are deeper than the a standard uniform."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "dolldress"
	worn_icon_state = "dolldress"
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/neck/cloak/shirocloak
	name = "Side Cape"
	desc = "It's uncertain whether this is one half of a cape or a very small cape."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "dollcloak"
	worn_icon_state = "dollcloak"

// putting the stuff here, since its supposed to be able to be disabled easily.
/datum/loadout_item/under/formal/shirodress
	name = "Doll's Formal Uniform"
	item_path = /obj/item/clothing/under/shirodress
	additional_displayed_text = list("Character Item")

/datum/loadout_item/neck/shirocloak
	name = "Side Cape"
	item_path = /obj/item/clothing/neck/cloak/shirocloak
	additional_displayed_text = list("Character Item")

//THERES ALREADY A SHIRO FILE AHAHAHAHA

/obj/item/clothing/under/puppetdress
	name = "Puppet's Formalwear"
	desc = "A tight suit coat restrains a beautiful dress underneath. It doesn't want to come off..."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "shirodress"
	worn_icon_state = "shirodress"
	alternate_worn_layer = ABOVE_SHOES_LAYER

/obj/item/clothing/shoes/puppet
	name = "Absurd Boots"
	desc = "They may be fashionable, but they are in no way practical or comfortable."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "shiroboots"
	worn_icon_state = "shiroboots"
	strip_delay = 80
	equip_delay_self = 80
	equip_delay_other = 80

/obj/item/clothing/gloves/puppet
	name = "Velvet Gloves"
	desc = " Not quite an iron fist, but they're excessively tight around the hands."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "shirogloves"
	worn_icon_state = "shirogloves"

/obj/item/clothing/head/puppet
	name = "Puppet's Tophat"
	desc = "There's a small hair clip on its underside as it is too small to securely fit on one's head."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "shirohat"
	worn_icon_state = "shirohat"

/datum/loadout_item/under/formal/puppetdress
	name = "Puppet's Formalwear"
	item_path = /obj/item/clothing/under/puppetdress
	additional_displayed_text = list("Character Item")

/datum/loadout_item/gloves/shirogloves
	name = "Velvet Gloves"
	item_path = /obj/item/clothing/gloves/puppet
	additional_displayed_text = list("Character Item")

/datum/loadout_item/shoes/shiroboots
	name = "Absurd Boots"
	item_path = /obj/item/clothing/shoes/puppet
	additional_displayed_text = list("Character Item")

/datum/loadout_item/head/shirohat
	name = "Puppet's Tophat"
	item_path = /obj/item/clothing/head/puppet
	additional_displayed_text = list("Character Item")