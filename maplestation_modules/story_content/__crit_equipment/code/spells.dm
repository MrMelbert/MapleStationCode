/datum/action/cooldown/spell/spirit_force
	name = "Spirit Force - A Vengeful Bloom"
	desc = "Utilize the latent wrath within your spirit. It will give you the strength to forge ahead."
	button_icon_state = "charge"

	sound = 'sound/magic/charge.ogg'

	school = SCHOOL_HOLY
	cooldown_time = 60 SECONDS

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/spirit_force/cast(mob/living/cast_on)
	. = ..()

	cast_on.add_filter("spirit_force", 2, list("type" = "drop_shadow", "x" = 0, "y" = 1, "color" = COLOR_DARK_RED, "size" = 2))
