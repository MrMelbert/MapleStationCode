// Some ID trim changes

// Notably absent: Cardboard trims and RPG trims, because the former is PITA and the latter is ???

// Modular job ID trims
/datum/id_trim/job/research_director
	trim_state = "trim_scientist"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'

/datum/id_trim/job/scientist
	trim_state = "trim_scientist"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_SCIENCE, ACCESS_TECH_STORAGE)

/datum/id_trim/job/quartermaster
	trim_state = "trim_quartermaster"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'

// New job trims

// Asset Protection
/datum/id_trim/job/asset_protection
	assignment = "Asset Protection"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_assetprotection"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudassetprotection"
	department_state = "departmenthead"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	extra_access = list(ACCESS_ENGINE_EQUIP, ACCESS_SHIPPING)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_EVA,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_DETECTIVE, ACCESS_COMMAND, ACCESS_KEYCARD_AUTH, ACCESS_LAWYER,
		ACCESS_MAINT_TUNNELS, ACCESS_MECH_SECURITY, ACCESS_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_MORGUE,
		ACCESS_RC_ANNOUNCE, ACCESS_RESEARCH, ACCESS_BRIG_ENTRANCE, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_ARMORY)
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOS, ACCESS_CHANGE_IDS)
	job = /datum/job/asset_protection
	honorifics = list("Officer", "Bodyguard")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL

// Bridge Officer
/datum/id_trim/job/bridge_officer
	assignment = "Bridge Officer"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_bridgeofficer"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudbridgeofficer"
	department_state = "departmenthead"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	extra_access = list(ACCESS_RESEARCH, ACCESS_SCIENCE)
	extra_wildcard_access = list(ACCESS_ARMORY)
	minimal_access = list(ACCESS_BRIG, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_COURT, ACCESS_COMMAND,
		ACCESS_KEYCARD_AUTH, ACCESS_LAWYER, ACCESS_SHIPPING, ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL,
		ACCESS_MINERAL_STOREROOM, ACCESS_RC_ANNOUNCE, ACCESS_BRIG_ENTRANCE, ACCESS_SECURITY, ACCESS_WEAPONS)
	minimal_wildcard_access = list(ACCESS_VAULT)
	template_access = list(ACCESS_CAPTAIN, ACCESS_HOP, ACCESS_CHANGE_IDS)
	job = /datum/job/bridge_officer
	honorifics = list("Officer", "Assistant", "Steward", "Stewardess")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL

// ordnance technician
/datum/id_trim/job/ordnance_tech
	assignment = "Ordnance Technician"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_ordnance_tech"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudordnancetechnician"
	department_color = COLOR_SCIENCE_PINK
	subdepartment_color = COLOR_SCIENCE_PINK
	extra_access = list(ACCESS_GENETICS, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_ORDNANCE,
		ACCESS_ORDNANCE_STORAGE, ACCESS_RESEARCH, ACCESS_SCIENCE)
	template_access = list(ACCESS_CAPTAIN, ACCESS_RD, ACCESS_CHANGE_IDS)
	job = /datum/job/ordnance_tech
	honorifics = list("Researcher", "Doctor")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL

// Xenobiologist
/datum/id_trim/job/xenobiologist
	assignment = "Xenobiologist"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_xenobiologist"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudxenobiologist"
	department_color = COLOR_SCIENCE_PINK
	subdepartment_color = COLOR_SCIENCE_PINK
	extra_access = list(ACCESS_GENETICS, ACCESS_ROBOTICS, ACCESS_ORDNANCE, ACCESS_ORDNANCE_STORAGE)
	minimal_access = list(ACCESS_AUX_BASE, ACCESS_MECH_SCIENCE, ACCESS_MINERAL_STOREROOM, ACCESS_RESEARCH, ACCESS_SCIENCE, ACCESS_XENOBIOLOGY)
	template_access = list(ACCESS_CAPTAIN, ACCESS_RD, ACCESS_CHANGE_IDS)
	job = /datum/job/xenobiologist
	honorifics = list("Researcher", "Doctor")
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL

/datum/id_trim/job/noble_ambassador
	assignment = "Noble Ambassador"
	intern_alt_name = "Noble Squire"
	trim_icon = 'maplestation_modules/icons/obj/card.dmi'
	trim_state = "trim_noble"
	sechud_icon = 'maplestation_modules/icons/mob/huds/hud.dmi'
	sechud_icon_state = "hudnoble"
	department_color = COLOR_COMMAND_BLUE
	subdepartment_color = COLOR_COMMAND_BLUE
	minimal_access = list(
		ACCESS_AUX_BASE,
		ACCESS_BAR,
		ACCESS_BRIG_ENTRANCE,
		ACCESS_CARGO,
		ACCESS_CHAPEL_OFFICE,
		ACCESS_CREMATORIUM,
		ACCESS_COMMAND,
		ACCESS_COURT,
		ACCESS_ENGINEERING,
		ACCESS_EVA,
		ACCESS_GATEWAY,
		ACCESS_HYDROPONICS,
		ACCESS_JANITOR,
		ACCESS_KEYCARD_AUTH,
		ACCESS_KITCHEN,
		ACCESS_LAWYER,
		ACCESS_LIBRARY,
		ACCESS_MEDICAL,
		ACCESS_MINERAL_STOREROOM,
		ACCESS_MORGUE,
		ACCESS_MORGUE_SECURE,
		ACCESS_PSYCHOLOGY,
		ACCESS_RC_ANNOUNCE,
		ACCESS_SCIENCE,
		ACCESS_SERVICE,
		ACCESS_TELEPORTER,
		ACCESS_THEATRE,
		ACCESS_WEAPONS, //nt scared shitless of finding out what happens if they weapons permit check a noble
	)
	minimal_wildcard_access = list()
	extra_access = list()
	extra_wildcard_access = list()
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
	)
	job = /datum/job/noble_ambassador
	honorifics = list(
		"Ambassador",
		"Attaché",
		"Baron",
		"Baroness",
		"Consul",
		"Count",
		"Countess",
		"Delegate",
		"Diplomat",
		"Duchess",
		"Duke",
		"Earl",
		"Emissary",
		"Envoy",
		"Lady",
		"Legate",
		"Legation",
		"Lord",
		"Madam",
		"Marchioness",
		"Marquess",
		"Marquis",
		"Minister",
		"Noble",
		"Representative",
		"Sir",
		"Viscount",
		"Viscountess",
		"Vizier",
		"Vizieress",
	)
	honorific_positions = HONORIFIC_POSITION_FIRST | HONORIFIC_POSITION_LAST | HONORIFIC_POSITION_FIRST_FULL
