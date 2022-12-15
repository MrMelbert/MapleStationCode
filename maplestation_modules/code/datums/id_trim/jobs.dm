/// --ID Trims for modular jobs. --
// -Modular changes for jobs.-
/datum/id_trim/job/research_director
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'

/datum/id_trim/job/scientist
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_SCIENCE, ACCESS_TECH_STORAGE)

// -New job trims.-
//Asset Protection
/datum/id_trim/job/asset_protection
	assignment = "Asset Protection"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_assetprotection"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudassetprotection"
	extra_access = list(ACCESS_ENGINE_EQUIP, ACCESS_SHIPPING)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_EVA,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_DETECTIVE, ACCESS_COMMAND, ACCESS_KEYCARD_AUTH, ACCESS_LAWYER,
		ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_MORGUE,
		ACCESS_RC_ANNOUNCE, ACCESS_RESEARCH, ACCESS_BRIG_ENTRANCE, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_ARMORY)
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/asset_protection


// Bridge Officer
/datum/id_trim/job/bridge_officer
	assignment = "Bridge Officer"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_bridgeofficer"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudbridgeofficer"
	extra_access = list(ACCESS_RESEARCH, ACCESS_SCIENCE)
	extra_wildcard_access = list(ACCESS_ARMORY)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_COMMAND,
		ACCESS_KEYCARD_AUTH, ACCESS_LAWYER, ACCESS_SHIPPING, ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL,
		ACCESS_MINERAL_STOREROOM, ACCESS_RC_ANNOUNCE, ACCESS_BRIG_ENTRANCE, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_VAULT)
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
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_ORDNANCE,
		ACCESS_ORDNANCE_STORAGE, ACCESS_RESEARCH, ACCESS_SCIENCE)
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
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_SCIENCE, ACCESS_XENOBIOLOGY)
	template_access = list(ACCESS_CAPTAIN, ACCESS_RD, ACCESS_CHANGE_IDS)
	job = /datum/job/xenobiologist
