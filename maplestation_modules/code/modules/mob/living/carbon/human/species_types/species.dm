/// -- Extensions of species and species procs. --
/datum/species
	/// Pain modifier that this species receives.
	var/species_pain_mod = 1

/datum/species/create_pref_damage_perks()
	var/list/perks = ..()

	if(isnum(species_pain_mod) && species_pain_mod != 1)
		var/negative = species_pain_mod > 1
		perks += list(list(
			SPECIES_PERK_TYPE = negative ? SPECIES_NEGATIVE_PERK : SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "band-aid",
			SPECIES_PERK_NAME = "Pain [negative ? "Vulnerability" : "Resilience"]",
			SPECIES_PERK_DESC = "[plural_form] take [negative ? "more" : "less"] pain on average.",
		))

	if (isnum(damage_modifier) && damage_modifier != 0)
		var/negative = damage_modifier < 1
		perks += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield",
			SPECIES_PERK_NAME = "[negative ? "Vulnerable" : "Armored"]",
			SPECIES_PERK_DESC = "[plural_form] are [negative ? "physically vulnerable" : "armored"], [negative ? "increasing" : "decreasing"] external damage taken by [abs(damage_modifier)]%.",
		))

	return perks
