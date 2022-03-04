///Datums that effectively work like sprite accessories but are instead used for reploid limbs so we get more control on how they're used.
///Simply put in an init_replod_limb_subtypes with your subtype in the world thing down below and you're golden.
/proc/init_reploid_limb_subtypes(prototype, list/L, roundstart = TRUE)
	if(!istype(L))
		L = list()

	for(var/path in subtypesof(prototype))
		var/datum/reploid_limb/D = new path()

		if(D.icon_state)
			L[D.name] = D
		else
			L += D.name

	return L

/world/New()
	. = ..()
	init_reploid_limb_subtypes(/datum/reploid_limb/ipc, GLOB.reploid_limbs_ipc_list) //Very fucking cursed, but this is ran at the same time as initialization of sprite accessories.

/datum/reploid_limb
	/// The icon file the limbs are located in.
	var/icon
	/// The icon_state of the limbs.
	var/icon_state
	/// The preview name of the limb type.
	var/name
	/// Determines if the limb type is colorable or not.
	var/colorable

///Applies the limbs_id to the species
/datum/reploid_limb/proc/apply_limb_id(var/datum/species/target)
	target.limbs_id = icon_state //Yes, limbs_id is icon state. Welcome to species code!

///IPC LIMBS///
/datum/reploid_limb/ipc
	icon = 'jollystation_modules/icons/mob/ipc_parts.dmi'
	colorable = FALSE

/datum/reploid_limb/ipc/synth
	name = "Synthetic Frame"
	icon_state = "synth"

/datum/reploid_limb/ipc/bishop
	name = "Bishop Cyberkinetics"
	icon_state = "bshipc"

/datum/reploid_limb/ipc/bishop2
	name = "Bishop Cyberkinetics 2.0"
	icon_state = "bs2ipc"

/datum/reploid_limb/ipc/hephaestus
	name = "Hephaestus Industries"
	icon_state = "hsiipc"

/datum/reploid_limb/ipc/hephaestus2
	name = "Hephaestus Industries 2.0"
	icon_state = "hi2ipc"

/datum/reploid_limb/ipc/shellguard
	name = "Shellguard Munitions Standard Series"
	icon_state = "sgmipc"

/datum/reploid_limb/ipc/ward
	name = "Ward-Takahashi Manufacturing"
	icon_state = "wtmipc"

/datum/reploid_limb/ipc/xion
	name = "Xion Manufacturing Group"
	icon_state = "xmgipc"

/datum/reploid_limb/ipc/xion2
	name = "Xion Manufacturing Group 2.0"
	icon_state = "xm2ipc"

/datum/reploid_limb/ipc/zenghu
	name = "Zeng-Hu Pharmaceuticals"
	icon_state = "zhpipc"

/datum/reploid_limb/ipc/morpheus
	name = "Morpheus Cyberkinetics (Greyscale)"
	icon_state = "mcgipc"
	colorable = TRUE
