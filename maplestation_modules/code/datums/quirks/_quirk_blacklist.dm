/// -- Separate file to add in additional blacklists for modular quirks. --
/datum/controller/subsystem/processing/quirks
	/// Modular quirk blacklist. This is added into the master blacklist on Initialize.
	var/static/list/module_blacklist = list(
		list("Allodynia", "Hyperalgesia", "Hypoalgesia"),
		list("Allodynia", "Bad Touch"),
	)
	/// Species blacklist. Quirks cannot be added to species in the supplied list.
	var/static/list/species_blacklist = list(
		"Light Drinker" = list(/datum/species/skrell),
	)
	/// Species whitelist. Quirks can only be added to species in the supplied list.
	var/static/list/species_whitelist = list(
		//"Language - High Draconic" = list(/datum/species/lizard),
	)

//Extends the initialization proc, adding the module blacklists we have after the main init finishes.
/datum/controller/subsystem/processing/quirks/Initialize()
	. = ..()
	quirk_blacklist.Add(module_blacklist)
