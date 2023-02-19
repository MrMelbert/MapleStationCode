/// -- Extensions of species and species procs. --
/datum/species
	/// Assoc list of [sounds that play on speech for mobs of this species] to [volume].
	var/species_speech_sounds = list(
		'maplestation_modules/sound/voice/speak_1.ogg' = 120,
		'maplestation_modules/sound/voice/speak_2.ogg' = 120,
		'maplestation_modules/sound/voice/speak_3.ogg' = 120,
		'maplestation_modules/sound/voice/speak_4.ogg' = 120,
	)
	/// Assoc list of [sounds that play on question for mobs of this species] to [volume].
	var/species_speech_sounds_ask = list(
		'maplestation_modules/sound/voice/speak_1_ask.ogg' = 120,
		'maplestation_modules/sound/voice/speak_2_ask.ogg' = 120,
		'maplestation_modules/sound/voice/speak_3_ask.ogg' = 120,
		'maplestation_modules/sound/voice/speak_4_ask.ogg' = 120,
	)
	/// Assoc list of [sounds that play on exclamation for mobs of this species] to [volume].
	var/species_speech_sounds_exclaim = list(
		'maplestation_modules/sound/voice/speak_1_exclaim.ogg' = 120,
		'maplestation_modules/sound/voice/speak_2_exclaim.ogg' = 120,
		'maplestation_modules/sound/voice/speak_3_exclaim.ogg' = 120,
		'maplestation_modules/sound/voice/speak_4_exclaim.ogg' = 120,
	)
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

	return perks

/datum/species/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null)
	if(HAS_TRAIT(H, TRAIT_SHARPNESS_VULNERABLE) && sharpness)
		damage *= 2
	return ..()
