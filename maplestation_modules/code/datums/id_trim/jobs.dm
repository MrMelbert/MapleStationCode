/// --ID Trims for modular jobs. --
// -Modular changes for jobs.-
/datum/id_trim/job/cargo_technician
	extra_access = list(ACCESS_MINING, ACCESS_MINING_STATION) // Removed Quartermaster's office from extra access.

/datum/id_trim/job/quartermaster
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	extra_access = list(ACCESS_RESEARCH, ACCESS_RND)

/datum/id_trim/job/quartermaster/New()
	minimal_access |= list(ACCESS_HEADS, ACCESS_SEC_DOORS, ACCESS_SECURITY)
	if(minimal_access.Remove(ACCESS_QM))
		minimal_wildcard_access |= list(ACCESS_QM)
	return ..()

/datum/id_trim/job/research_director
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'

/datum/id_trim/job/scientist
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_RND, ACCESS_TECH_STORAGE)

// -New job trims.-
//Asset Protection
/datum/id_trim/job/asset_protection
	assignment = "Asset Protection"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_assetprotection"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudassetprotection"
	extra_access = list(ACCESS_ENGINE, ACCESS_MAILSORTING)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS,
					ACCESS_FORENSICS_LOCKERS, ACCESS_HEADS, ACCESS_KEYCARD_AUTH, ACCESS_LAWYER, ACCESS_MAINT_TUNNELS,
					ACCESS_MECH_SECURITY, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_MORGUE, ACCESS_RC_ANNOUNCE,
					ACCESS_RESEARCH, ACCESS_SEC_DOORS, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_ARMORY)
	config_job = "asset_protection"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/asset_protection


// Bridge Officer
/datum/id_trim/job/bridge_officer
	assignment = "Bridge Officer"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_bridgeofficer"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudbridgeofficer"
	extra_access = list(ACCESS_RESEARCH, ACCESS_RND)
	extra_wildcard_access = list(ACCESS_ARMORY)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_HEADS, ACCESS_KEYCARD_AUTH,
					ACCESS_LAWYER, ACCESS_MAILSORTING, ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM,
					ACCESS_RC_ANNOUNCE, ACCESS_SEC_DOORS, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_VAULT)
	config_job = "bridge_officer"
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)
	job = /datum/job/bridge_officer

// ordnance technician
/datum/id_trim/job/ordnance_tech
	assignment = "Ordnance Technician"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_ordnance_tech"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudordnancetechnician"
	extra_access = list(ACCESS_GENETICS, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_ORDNANCE, ACCESS_ORDNANCE_STORAGE,
					ACCESS_RESEARCH, ACCESS_RND)
	config_job = "ordnance_technician"
	template_access = list(ACCESS_CAPTAIN, ACCESS_RD, ACCESS_CHANGE_IDS)
	job = /datum/job/ordnance_tech

// Xenobiologist
/datum/id_trim/job/xenobiologist
	assignment = "Xenobiologist"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_xenobiologist"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudxenobiologist"
	extra_access = list(ACCESS_GENETICS, ACCESS_ROBOTICS, ACCESS_ORDNANCE, ACCESS_ORDNANCE_STORAGE)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_RND, ACCESS_XENOBIOLOGY)
	config_job = "xenobiologist"
	template_access = list(ACCESS_CAPTAIN, ACCESS_RD, ACCESS_CHANGE_IDS)
	job = /datum/job/xenobiologist
