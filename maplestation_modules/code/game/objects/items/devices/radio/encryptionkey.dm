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

// Noble Ambassador's Key
/obj/item/encryptionkey/heads/noble_ambassador
	name = "\proper the noble ambassador's encryption key"
	icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#9d77a3#fdc052"

/obj/item/encryptionkey/headset_mu
	name = "\improper Mu radio encryption key"
	icon_state = "/obj/item/encryptionkey/headset_mu"
	post_init_icon_state = "cypherkey_centcom"
	independent = TRUE
	channels = list(RADIO_CHANNEL_MU = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_centcom
	greyscale_colors = "#9d77a3#fdc052"
