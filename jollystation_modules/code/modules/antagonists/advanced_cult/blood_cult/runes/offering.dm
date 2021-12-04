/obj/effect/rune/conversion/blood_convert
	cultist_name = "Sanctimonious Offer"
	cultist_desc = "offers a non-cultist above it to Nar'Sie, either converting them or tormenting them if they are protected."
	invocation = "Mah'weyh pleggh at e'ntrath!"
	icon_state = "3"
	color = RUNE_COLOR_OFFER
	on_conversion_message = "Your blood pulses. Your head throbs. \
		The world goes red. All at once you are aware of a horrible, horrible, truth. \
		The veil of reality has been ripped away and something evil takes root."
	conversion_unallowed_invocations = list(
		"Weyah at ntrath!",
		"P'th jayaha lonela!",
		"Mah'weyh pleggh at e'ntrath!",
		)
	conversion_blocked_invocations = list(
		"Weyah at ntrath!",
		"Leva at sh'ereth nwah!",
		"Nar'Sie, cla'sh, m'dbh!",
		"Mah'weyh pleggh at e'ntrath!",
		)
	conversion_success_invocations = list(
		"Weyah at ntrath!",
		"Va'tung, ifthn, Va'tung!",
		"Nar'Sie, dm'thpg, m'dbh!",
		"Mah'weyh pleggh at e'ntrath!",
		)
