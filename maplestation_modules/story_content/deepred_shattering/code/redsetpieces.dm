/obj/structure/redtech_indestructable
	name = "redtech setpiece"
	desc = "Report this to a coder."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/setpieces.dmi'
	icon_state = "server_off"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/redtech_indestructable/server_off
	name = "redtech server"
	desc = "A large quantum computing server machine, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "server_off"

/obj/structure/redtech_indestructable/heatsink_off
	name = "redtech heatsink"
	desc = "An excessively large heatsink, which thankfully seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "heatsink_off"

/obj/structure/redtech_indestructable/esoteric_off
	name = "esoteric redtech machinery"
	desc = "An odd piece of machinery which doesn't have a clear purpose, but is deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "esoteric_off"

/obj/structure/redtech_indestructable/dimensional_off
	name = "redtech dimensional lathe"
	desc = "A highly advanced dimensional manipulation device, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "dimensional_off"

/obj/structure/redtech_indestructable/singularity_off
	name = "redtech singularity link"
	desc = "A contained multipurpose compression device, which seems to be deactivated at the moment. Its construction looks nigh-indestructable."
	icon_state = "singularity_off"

/obj/structure/inert_AV
	name = "inert Anti Void"
	desc = "Something has gone terribly wrong."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/setpieces.dmi'
	icon_state = "inert_AV"

	density = TRUE
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 600

/obj/structure/inert_AV/worse
	icon_state = "inert_AV_worse"
	max_integrity = 1200

/datum/armor/inert_AV
	acid = 0
	bio = 100
	bomb = 0
	bullet = 100
	consume = 100
	energy = 0
	laser = 0
	fire = 0
	melee = 100
	wound = 100
