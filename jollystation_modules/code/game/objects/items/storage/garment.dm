// -- Garment bag stuff. --
// Modular additions to current bags
/obj/item/storage/bag/garment/research_director/PopulateContents()
	. = ..()
	new /obj/item/clothing/suit/rd_robes(src)

/obj/item/storage/bag/garment/chief_medical/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck(src)
	new /obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt(src)

/obj/item/storage/bag/garment/captain/PopulateContents()
	. = ..()
	new /obj/item/clothing/head/caphat/beret(src)

// New modular bags
/obj/item/storage/bag/garment/bridge_officer
	name = "bridge officer's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the bridge officer."

/obj/item/storage/bag/garment/bridge_officer/PopulateContents()
	new /obj/item/clothing/under/rank/security/bridge_officer/black/skirt (src)
	new /obj/item/clothing/under/rank/security/bridge_officer/black(src)
	new /obj/item/clothing/gloves/color/white(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/head/beret/black/bridge_officer(src)
	new /obj/item/clothing/glasses/sunglasses/gar(src)
	new /obj/item/clothing/suit/armor/vest/bridge_officer(src)

/obj/item/storage/bag/garment/asset_protection
	name = "asset protection officer's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the asset protection officer."

/obj/item/storage/bag/garment/asset_protection/PopulateContents()
	new /obj/item/clothing/head/beret/black/asset_protection(src)
	new /obj/item/clothing/suit/armor/vest/asset_protection(src)
	new /obj/item/clothing/suit/armor/vest/asset_protection/large(src)
	new /obj/item/clothing/under/rank/security/officer/blueshirt/asset_protection(src)
	new /obj/item/clothing/under/rank/security/officer/grey/asset_protection(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/gars(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch(src)

// This here's a special subtype that'll vacuum up all clothing items in the locker and put it in the bag roundstart.
/obj/item/storage/bag/garment/magic
	/// A list of types which, if we encounter, we won't grab up.
	/// Looks for exact types only - no subtypes.
	var/list/blacklisted_types

/obj/item/storage/bag/garment/magic/Initialize(mapload)
	. = ..()
	if(!isstructure(loc)) // We've gotta be inside something.
		return

	for(var/obj/item/clothing/locker_clothing in loc)
		if(locker_clothing.type in blacklisted_types)
			continue

		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, locker_clothing, null, TRUE, TRUE)

/obj/item/storage/bag/garment/magic/quartermaster
	name = "quartermaster's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the quartermaster."
	blacklisted_types = list(/obj/item/clothing/suit/fire/firefighter, /obj/item/clothing/mask/gas)
