/// -- Modular headsets --
// Bride Officer's headset
/obj/item/radio/headset/heads/bridge_officer
	name = "\proper the bridge officer's headset"
	desc = "The headset of the man or woman in charge of filing paperwork for the heads of staff."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/bridge_officer

// Asset Protection's headset
/obj/item/radio/headset/heads/asset_protection
	name = "\proper the asset protection officer's headset"
	desc = "The headset of the man or woman in charge of assisting and protecting the heads of staff."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/asset_protection

// Asset Protection's bowman
/obj/item/radio/headset/heads/asset_protection/alt
	name = "\proper the asset protection officer's bowman headset"
	desc = "The headset of the man or woman in charge of assisting and protecting the heads of staff. Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	inhand_icon_state = "com_headset_alt"

/obj/item/radio/headset/heads/asset_protection/alt/Initialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

// QM's headset, feat. command access.
/obj/item/radio/headset/heads/headset_qm
	name = "\proper the quartermaster's headset"
	desc = "A headset used by the QM, to pretend to have authority and order people around."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/qm
