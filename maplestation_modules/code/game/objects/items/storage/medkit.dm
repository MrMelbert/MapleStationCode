/obj/item/storage/medkit
	icon = 'maplestation_modules/icons/obj/storage/medkit.dmi'
	lefthand_file = 'maplestation_modules/icons/mob/inhands/medical_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/medical_righthand.dmi'

/obj/item/storage/medkit/emergency
	inhand_icon_state = "medkit-emergency"

/obj/item/storage/medkit/surgery
	inhand_icon_state = "medkit-surgical"

/obj/item/storage/medkit/advanced
	inhand_icon_state = "medkit-advanced"

/obj/item/storage/medkit/tactical/premium
	icon_state = "medkit_tactical_premium"
	inhand_icon_state = "medkit-tactical-premium"

// Medkit variant that can be printed from a lathe, not actually a medkit subtype to disallow making medibots, c'est la vie
/obj/item/storage/plastic_medkit
	name = "plastic medkit"
	desc = "a cheaply produced plastic medkit, quickly produced using a protolathe."
	icon = 'maplestation_modules/icons/obj/storage/medkit.dmi'
	icon_state = "medkit_plastic"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/medical_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	drop_sound = 'maplestation_modules/sound/items/drop/device.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/device.ogg'
	// Copied from actual medkits, forgive me but I don't want to fiddle around with making medkits *not* always allow medibots, and the storage hasn't been properly datumized here
	var/static/list/list_of_everything_medkits_can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/spray,
		/obj/item/lighter,
		/obj/item/storage/box/bandages,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/blood_filter,
		/obj/item/shears,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical,
		/obj/item/stack/sticky_tape,
		/obj/item/razor,
	)

/obj/item/storage/medkit/plastic/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.storage_sound = 'maplestation_modules/sound/items/storage/briefcase.ogg'
	atom_storage.set_holdable(list_of_everything_medkits_can_hold)
