// the many spells that are used to turn into versions of a werewolf

/datum/action/cooldown/spell/shapeshift/lycanthrope // use this for the simplemob forms, like standard wolves
	name = "Lycanthropic Shift"
	desc = "Channel the wolf within yourself and turn into one of your possible forms. \
		Be careful, for you can still die within this form."
	invocation = "RAAAAAAAAWR!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	possible_shapes = list(
		/mob/living/simple_animal/hostile/asteroid/wolf, // room to add other forms
	)

/datum/action/cooldown/spell/werewolf_form
	name = "Werewolf Change"
	desc = "Change to and from your full werewolf form. \
	You will gain the full effects of this, both negative and positive."
	invocation = "ARRRROOOOO!" // i don't know man
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_HUMAN
	var/mob/living/carbon/human/lycanthrope
	var/datum/species/owner_base_species // what species we are other than a werewolf
	// yes this might cause other implications, such as mass species change, or with synths (synthcode moment) but i'll look into it later down the line

/datum/action/cooldown/spell/werewolf_form/Grant(mob/grant_to)
	. = ..()
	if (!ishuman(grant_to))
		return stack_trace("A non human was given werewolf form!") // only human mobs should be given this
	else
		lycanthrope = grant_to
		owner_base_species = lycanthrope.dna.species

/datum/action/cooldown/spell/werewolf_form/cast(atom/cast_on)
	. = ..()
	if(istype(lycanthrope.dna.species, /datum/species/werewolf))
		lycanthrope.balloon_alert(lycanthrope, "changing back")
		lycanthrope.set_species(owner_base_species)
	else
		lycanthrope.balloon_alert(lycanthrope, "turning")
		lycanthrope.set_species(/datum/species/werewolf)
