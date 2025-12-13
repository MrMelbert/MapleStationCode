/obj/item/organ/tongue/robot/android
	name = "android tongue"
	liked_foodtypes = NONE
	disliked_foodtypes = NONE
	toxic_foodtypes = NONE

/obj/item/organ/tongue/robot/synth
	name = "synth tongue"
	/// Internal tongue that we use to modify speech instead
	var/obj/item/organ/tongue/fake_tongue

	var/list/old_speech_sounds = null
	var/list/old_speech_sounds_question = null
	var/list/old_speech_sounds_exclamation = null

/obj/item/organ/tongue/robot/synth/Destroy()
	QDEL_NULL(fake_tongue)
	return ..()

/obj/item/organ/tongue/robot/synth/handle_speech(datum/source, list/speech_args)
	if(isnull(fake_tongue))
		return ..()

	fake_tongue.handle_speech(source, speech_args)

/obj/item/organ/tongue/robot/synth/proc/disguise_tongue(obj/item/organ/tongue/source_tongue)
	fake_tongue = new source_tongue()

	old_speech_sounds = speech_sound_list
	old_speech_sounds_question = speech_sound_list_question
	old_speech_sounds_exclamation = speech_sound_list_exclamation

	speech_sounds_enabled = source_tongue.speech_sounds_enabled
	speech_sound_list = source_tongue.speech_sound_list.Copy()
	speech_sound_list_question = source_tongue.speech_sound_list_question.Copy()
	speech_sound_list_exclamation = source_tongue.speech_sound_list_exclamation.Copy()

/obj/item/organ/tongue/robot/synth/proc/restore_tongue()
	if(isnull(fake_tongue))
		return

	QDEL_NULL(fake_tongue)

	speech_sounds_enabled = initial(speech_sounds_enabled)
	speech_sound_list = old_speech_sounds
	speech_sound_list_question = old_speech_sounds_question
	speech_sound_list_exclamation = old_speech_sounds_exclamation
