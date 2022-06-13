/obj/effect/rune/conversion/clock_convert
	name = "sigil"
	desc = "An odd collection of symbols that glint when shined light upon."
	cultist_name = "Sigil of Submission"
	cultist_desc = "subject a non-cultist to the eternal power of the machine, converting the victim to your cult. \
		If you opted out of conversion, or the victim is mindshielded, subjects them to torment instead."
	invocation = "Fho'zvg Gb Engine!"
	icon = 'maplestation_modules/icons/effects/clockwork_effects.dmi'
	icon_state = "sigilsubmission"
	color = RUNE_COLOR_OFFER
	on_conversion_message = "Your eyes twitch. Your head throbs. \
		You can hear every machine around you tick at once. \
		The veil of reality has been ripped away and something evil takes root."
	conversion_unallowed_invocations = list(
		"Zl wbhearl vf zl bja...",
		"Ohg Engine'f Yv'tug Fuv-arf...",
		"Vagb Lbhe Zvaq, Urer'gvp!",
		)
	conversion_blocked_invocations = list(
		"Engine'f Yv'tug Vf Haf'gbc-cnoyr...",
		"Ab Fuv'ryq Abe Zvaq Pna Erf'v-fg.",
		"Rzoen'pr Gur Yv'tug, Urer'gvp!",
		"Lbh Pna'abg Rf-pncr Uvf Tybel!",
		)
	conversion_success_invocations = list(
		"Ongur Va Gur Yv'tug Bs Engine!",
		"Fhozvg Gb Gurve Juvz!",
		"Zrepl Jvyy Or Tvira Ba Uvf Nev'iny.",
		"Fheeraqre, Jrnx-Zvaq'rq!",
		)
