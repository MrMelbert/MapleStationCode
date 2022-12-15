/// -- Modular encryption keys --
// Bridge Officer's Key
/obj/item/encryptionkey/heads/bridge_officer
	name = "\proper the bridge officer's encryption key"
	icon_state = "hop_cypherkey"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_COMMAND = 1)

// Asset Protection's Key
/obj/item/encryptionkey/heads/asset_protection
	name = "\proper the asset protection's encryption key"
	icon_state = "hos_cypherkey"
	channels = list(RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_COMMAND = 1)
