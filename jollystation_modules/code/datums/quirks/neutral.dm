/// -- Neutral quirks module file. Add neutral quirks to the end of this file. --

/// Height changing quirks.
/datum/quirk/size_change
	name = "Size D - Average Height"
	desc = "You are average. (0% size change)"
	value = 0
	gain_text = "<span class='notice'>You feel average.</span>"
	lose_text = "<span class='notice'>You still feel average.</span>"
	medical_record_text = "Patient is of average height."
	abstract_parent_type = /datum/quirk/size_change
	/// The amount we resize the quirk holder for.
	var/resize_amount = 1
	/// the amount we offset the person for, with their new size.
	var/y_offset = 0

/datum/quirk/size_change/add()
	if(resize_amount > 1.1)
		ADD_TRAIT(quirk_holder, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(resize_amount < 0.9)
		ADD_TRAIT(quirk_holder, TRAIT_DWARF, ROUNDSTART_TRAIT)

	quirk_holder.resize = resize_amount
	quirk_holder.update_transform()
	quirk_holder.base_pixel_y += y_offset
	quirk_holder.pixel_y += y_offset

/datum/quirk/size_change/remove()
	if(resize_amount > 1.1)
		REMOVE_TRAIT(quirk_holder, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(resize_amount < 0.9)
		REMOVE_TRAIT(quirk_holder, TRAIT_DWARF, ROUNDSTART_TRAIT)

	quirk_holder.resize = 1/resize_amount
	quirk_holder.update_transform()
	quirk_holder.base_pixel_y -= y_offset
	quirk_holder.pixel_y -= y_offset

// All the height changing quirks.
// They're alphabetized because the quirk list is and I wanted to sort them by height order.

// Very very larage
/datum/quirk/size_change/vv_large
	name = "Size A - Extremely Large"
	desc = "You're massive. (50% larger)"
	gain_text = "<span class='notice'>You feel even more taller.</span>"
	lose_text = "<span class='notice'>You feel even more shorter.</span>"
	medical_record_text = "Patient has extremely un-natural height and size."
	resize_amount = 1.5
	y_offset = 8

// Very large
/datum/quirk/size_change/v_large
	name = "Size B - Very Large"
	desc = "You're huge. (20% larger)"
	gain_text = "<span class='notice'>You feel even taller.</span>"
	lose_text = "<span class='notice'>You feel even shorter.</span>"
	medical_record_text = "Patient has very un-natural height and size."
	resize_amount = 1.2
	y_offset = 3

// Large
/datum/quirk/size_change/large
	name = "Size C - Large"
	desc = "You're large and in charge. (10% larger)"
	gain_text = "<span class='notice'>You feel taller.</span>"
	lose_text = "<span class='notice'>You feel shorter.</span>"
	medical_record_text = "Patient has un-natural height and size."
	resize_amount = 1.1
	y_offset = 2

// Short
/datum/quirk/size_change/short
	name = "Size E - Small"
	desc = "You're pretty small. (10% smaller)"
	gain_text = "<span class='notice'>You feel shorter.</span>"
	lose_text = "<span class='notice'>You feel taller.</span>"
	medical_record_text = "Patient is un-naturally short in stature."
	resize_amount = 0.9
	y_offset = -2

// Very Short
/datum/quirk/size_change/v_short
	name = "Size F - Very Small"
	desc = "You're VERY small. (20% smaller)"
	gain_text = "<span class='notice'>You feel even shorter.</span>"
	lose_text = "<span class='notice'>You feel even taller.</span>"
	medical_record_text = "Patient is very un-naturally short in stature."
	resize_amount = 0.8
	y_offset = -3

// Very Very Short
/datum/quirk/size_change/vv_short
	name = "Size G - Extremely Small"
	desc = "You're EXTREMELY small. (30% smaller)"
	gain_text = "<span class='notice'>You feel even more shorter.</span>"
	lose_text = "<span class='notice'>You feel even more taller.</span>"
	medical_record_text = "Patient is extremely un-naturally short in stature."
	resize_amount = 0.7
	y_offset = -5

///Language quirks
// Draconic
/datum/quirk/trilingual/draconic
	name = "Language - Draconic"
	desc = "You're trilingual - you know the draconic language along with common and your native tongue."
	value = 0
	gain_text = "<span class='notice'>You understand Draconic.</span>"
	lose_text = "<span class='notice'>You no longer understand Draconic.</span>"
	medical_record_text = "Patient is trilingual and knows Draconic."
	added_language = /datum/language/draconic

// Moffic
/datum/quirk/trilingual/moffic
	name = "Language - Moffic"
	desc = "You're trilingual - you know the moffic language along with common and your native tongue."
	value = 0
	gain_text = "<span class='notice'>You understand Moffic.</span>"
	lose_text = "<span class='notice'>You no longer understand Moffic.</span>"
	medical_record_text = "Patient is trilingual and knows Moffic."
	added_language = /datum/language/moffic

// Nekomimetic
/datum/quirk/trilingual/nekomimetic
	name = "Language - Nekomimetic"
	desc = "You're trilingual - you know the Nekomimetic language along with common and your native tongue."
	value = 0
	gain_text = "<span class='notice'>You understand Nekomimetic.</span>"
	lose_text = "<span class='notice'>You no longer understand Nekomimetic.</span>"
	medical_record_text = "Patient is trilingual and knows Nekomimetic."
	added_language = /datum/language/nekomimetic

// Skrellian
/datum/quirk/trilingual/skrell
	name = "Language - Skrellian"
	desc = "You're trilingual - you know the Skrellian language along with common and your native tongue."
	value = 0
	gain_text = "<span class='notice'>You understand Skrellian.</span>"
	lose_text = "<span class='notice'>You no longer understand Skrellian.</span>"
	medical_record_text = "Patient is trilingual and knows Skrellian."
	added_language = /datum/language/skrell
