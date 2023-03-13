/datum/export/organ/tongue/lizard/silver
	cost = CARGO_CRATE_VALUE * 62 // this shit is SO culturally, functionally, and scientifically important.

	unit_name = "silverscale tongue"
	export_types = (/obj/item/organ/internal/tongue/lizard/silver)

/datum/export/organ/tongue/lizard/silver/total_printout(datum/export_report/ex, notes = TRUE)
	. = ..()
	if(. && notes)
		. += " This will be invaluable towards our research of silverscale biology - please send more samples if you have any!"

/datum/species/lizard/silverscale
	plural_form = "Silverscales"

/datum/species/lizard/silverscale/get_species_description()
	return "An extremely rare and enigmatic breed of lizardperson, very little is known about them. \
	The only common characteristic between them is their extreme ego, absurd elitism, and untouchable mystery. \
	While they do venture out in hunting parties or in egregiously extravagant tours (both done in total enigma), one must ask: \
	Why is THIS one here?"

/datum/species/lizard/silverscale/get_species_lore()
	return list(
		"Theorized to be a sub-species of lizardperson (although only a theory, as not once has a silverscale allowed anyone outside their circle to study them), \
		the silverscale is one of the most enigmatic lifeforms in the known galaxy.",

		"Heavily associated with the high, HIGH nobility of the tiziran empire, these lifeforms are rarely seen anywhere outside of tizira, and even inside - \
		you may only catch a glimmer of silver in the corner of your eye before they teleport to more obscure locations, or receive an egregiously large tip (that often bounces) \
		from a customer you never see - and only catch the last name \"Silverscale\" in the receipt.",

		"Of those that HAVE interacted with silverscales (in the brief period they are allowed to) will often remark on just how large their ego is, just how \
		\"holier-than-thou\" they seem, and how extravagant their lifestyles are. The most common source of these interactions are silverscale hunting parties, \
		trawling the frontier for carp, sharks, and occasionally - the glorious plunder of a frontier inhabitant - although, these silverscales are often far less \
		\"noble\" than their tiziran-static counterparts, suggesting some diversity within the silverscale society.",

		"Despite the relative frequency of frontier interactions to core sightings, it is speculated there is a much larger silverscale prescense within the core tiziran \
		worlds. While little hard evidence exists of this fact (with the tiziran empire itself often refusing to provide information on \"private citizens\"), many a \
		frontier silverscale have referenced the greater society in threats, bargains, and the very, very rare plea.",

		"Even with all this enigma, though, one thing is known to those that research: The silvery tongue within every silverscale is of utmost important to them, \
		and only traitors to the mysterious \"society\" ever have it removed. It is said to be what gives them their ability to shapeshift into silver statues - how \
		it does this, nobody knows. How it CAME to do this, remains a mystery. What is known, though, is that these tongues fetch a pretty penny should one manage to obtain it - \
		and survive.",

		"Now, then. Before you make a silverscale, ask yourself: \"Why would such a high, HIGH noble, who is an EXTREME elitist, and NEVER shows their face, be HERE?\"."
	)

/datum/species/lizard/silverscale/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
	list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "cubes",
		SPECIES_PERK_NAME = "Statue Form",
		SPECIES_PERK_DESC = "Your tongue has the arcane ability to transform you into a silvery statue, but BE CAREFUL! If it breaks, you shatter into dust - and it is not very durable."
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "shield-alt",
		SPECIES_PERK_NAME = "Pierce Immunity",
		SPECIES_PERK_DESC = "Metallic, silver scales prevent embeds.",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "space-shuttle",
		SPECIES_PERK_NAME = "Pressure resistance",
		SPECIES_PERK_DESC = "Your metallic, silver scales are heavily resistant to pressure differentials. This does not mean you are immune to temperature! Drink some coffee, lizard!",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "cross",
		SPECIES_PERK_NAME = "Holy",
		SPECIES_PERK_DESC = "The silver within and outside you imbues you with holy energy, protecting you from certain magicks!",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "user-shield",
		SPECIES_PERK_NAME = "Virus protection",
		SPECIES_PERK_DESC = "[plural_form] are immune to diseases. Good when the virologist is evil - bad when they aren't.",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "user",
		SPECIES_PERK_NAME = "Silver glow",
		SPECIES_PERK_DESC = "Your scales constantly eminate a silvery glow - which looks pretty! Until it gives your identity away.",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "wind",
		SPECIES_PERK_NAME = "No breath",
		SPECIES_PERK_DESC = "Your lungs don't require air to generate oxygen. This is great! Except for the fact you can't do CPR on anyone, or do anything requiring lung air, except for talking.",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "syringe",
		SPECIES_PERK_NAME = "Impenetrable scales",
		SPECIES_PERK_DESC = "Your scales are tough enough to prevent ANYTHING from penetrating them! Including all types of syringes! Good when the chemist wants to shoot you with chloral - bad when the chemist wants to shoot you with libital.",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "comment",
		SPECIES_PERK_NAME = "Common illiteracy",
		SPECIES_PERK_DESC = "For one reason or another, you understand, but don't speak common. Make up a reason!",
	),
	list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "money-bill-wave",
		SPECIES_PERK_NAME = "Valuable Tongue",
		SPECIES_PERK_DESC = "Your tongue is worth tens of thousands of credits if sold to cargo. Without it, you are less than a silverscale. Don't let people steal it!",
	))

	return to_add
