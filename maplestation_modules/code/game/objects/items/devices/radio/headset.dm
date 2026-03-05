/// -- Modular headsets --
// Bridge Officer's headset
/obj/item/radio/headset/heads/bridge_officer
	name = "bridge officer's headset"
	article = "the"
	desc = "The headset of the person in charge of filing paperwork for the heads of staff."
	icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/bridge_officer

// Asset Protection's headset
/obj/item/radio/headset/heads/asset_protection
	name = "asset protection officer's headset"
	article = "the"
	desc = "The headset of the person in charge of assisting and protecting the heads of staff."
	icon_state = "com_headset"
	keyslot = /obj/item/encryptionkey/heads/asset_protection

// Asset Protection's bowman
/obj/item/radio/headset/heads/asset_protection/alt
	name = "asset protection officer's bowman headset"
	article = "the"
	desc = "The headset of the person in charge of assisting and protecting the heads of staff. Protects ears from flashbangs."
	icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/asset_protection/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/radio/headset/heads/noble_ambassador
	name = "noble ambassador's headset"
	article = "the"
	desc = "The headset of the ambassador from Mu, responsible for upholding their laws and ensuring the crew's wellbeing."
	worn_icon = 'maplestation_modules/icons/mob/clothing/ears.dmi'
	worn_icon_state = "noble_headset"
	icon = 'maplestation_modules/icons/obj/radio.dmi'
	icon_state = "noble_headset"
	keyslot = /obj/item/encryptionkey/heads/noble_ambassador

/obj/item/radio/headset/mu
	name = "\proper Mu headset"
	desc = "The headset used by those from Mu."
	worn_icon = 'maplestation_modules/icons/mob/clothing/ears.dmi'
	worn_icon_state = "noble_headset"
	icon = 'maplestation_modules/icons/obj/radio.dmi'
	icon_state = "noble_headset"
	keyslot = /obj/item/encryptionkey/headset_mu

/obj/item/radio/headset/mu/alt
	name = "\proper Mu bowman headset"
	desc = "A bowman headset used by internal agents from Mu. Has built-in ear protection."
	worn_icon_state = "noble_headset_alt"
	icon_state = "noble_headset_alt"

/obj/item/radio/headset/mu/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))
