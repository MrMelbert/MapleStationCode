/// -- Separate file to add in additional blacklists for modular quirks. --

#define SIZE_QUIRKS list("Size A - Extremely Large", "Size B - Very Large", "Size C - Large", "Size E - Small", "Size F - Very Small", "Size G - Extremely Small")
#define LANG_QUIRKS list("Language - Trilingual", "Language - Draconic", "Language - Moffic", "Language - Nekomimetic", "Language - Skrellian", "Language - High Draconic")
#define PAIN_QUIRKS list("Allodynia", "Hyperalgesia", "Hypoalgesia")
#define TOUCH_QUIRKS list("Allodynia", "Bad Touch")
#define PROSTHETICS_L_LEG list("Prosthetic Limb - Random", "Prosthetic Limb - Left Leg")
#define PROSTHETICS_R_LEG list("Prosthetic Limb - Random", "Prosthetic Limb - Right Leg")
#define PROSTHETICS_L_ARM list("Prosthetic Limb - Random", "Prosthetic Limb - Left Arm")
#define PROSTHETICS_R_ARM list("Prosthetic Limb - Random", "Prosthetic Limb - Right Arm")

/datum/controller/subsystem/processing/quirks
	// Add in quirk blackists here.
	var/static/list/module_blacklist = list(
		SIZE_QUIRKS,
		PAIN_QUIRKS,
		LANG_QUIRKS,
		TOUCH_QUIRKS,
		PROSTHETICS_L_LEG,
		PROSTHETICS_R_LEG,
		PROSTHETICS_L_ARM,
		PROSTHETICS_R_ARM,
	)
	var/static/list/species_blacklist = list(
		"Light Drinker" = list(/datum/species/skrell),
		"Language - Draconic" = list(/datum/species/lizard),
		"Language - Moffic" = list(/datum/species/moth),
		"Language - Nekomimetic" = list(/datum/species/human/felinid),
		"Language - Skrellian" = list(/datum/species/skrell),
	)
	var/static/list/species_whitelist = list(
		"Language - High Draconic" = list(/datum/species/lizard),
	)

//Extends the initialization proc, adding the module blacklists we have after the main init finishes.
/datum/controller/subsystem/processing/quirks/Initialize()
	. = ..()
	quirk_blacklist.Add(module_blacklist)

#undef SIZE_QUIRKS
#undef LANG_QUIRKS
#undef PAIN_QUIRKS
#undef TOUCH_QUIRKS
#undef PROSTHETICS_L_LEG
#undef PROSTHETICS_R_LEG
#undef PROSTHETICS_L_ARM
#undef PROSTHETICS_R_ARM
