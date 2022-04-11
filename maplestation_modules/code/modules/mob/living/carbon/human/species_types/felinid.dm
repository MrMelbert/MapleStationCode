// -- Felinid species additions --
/datum/species/human/felinid
	species_speech_sounds = list('maplestation_modules/sound/voice/meow1.ogg' = 50, \
									'maplestation_modules/sound/voice/meow2.ogg' = 50,
									'maplestation_modules/sound/voice/meow3.ogg' = 50)
	species_speech_sounds_ask = list()
	species_speech_sounds_exclaim = list()

//adds fox tail option
/datum/species/human/felinid/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
    . = ..()
    if(ishuman(C))
        var/mob/living/carbon/human/H = C
        if(H.dna.features["tail_human"] == "Fox")
            var/obj/item/organ/tail/cat/fox/tail = new
            tail.Insert(H, special = TRUE, drop_if_replaced = FALSE)
            mutant_organs += /obj/item/organ/tail/cat/fox
