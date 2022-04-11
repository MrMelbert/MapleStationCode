// -- The file that allows digitigrade clothes to work --

// When digigrade_leg_swap is done, make sure to update the DMIs.
/mob/living/carbon/human/Digitigrade_Leg_Swap(swap_back)
	. = ..()
	w_uniform?.swap_digitigrade_dmi(src)
	wear_suit?.swap_digitigrade_dmi(src)
	shoes?.swap_digitigrade_dmi(src)

/obj/item/clothing
	/// Whether this clothing item has digi support.
	var/has_digi_support = FALSE
	/// Var to not squish digi legs on certain clothes.
	var/should_not_squish = FALSE
	/// Icon file for this worn on digi lizards
	var/digitigrade_file
	/// Greyscale config for this worn on digi lizards
	var/digitigrade_greyscale_config_worn

/obj/item/clothing/Initialize()
	. = ..()
	// If we have digi support, we shouldn't squish legs
	if(has_digi_support)
		should_not_squish = TRUE

/obj/item/clothing/equipped(mob/user, slot)
	. = ..()
	if(has_digi_support) // Try to swap if we have digi support
		swap_digitigrade_dmi(user, slot)

/obj/item/clothing/visual_equipped(mob/user, slot)
	. = ..()
	if(has_digi_support) // Try to swap if we have digi support
		swap_digitigrade_dmi(user, slot)

/*
 * Swap our clothing item to an alternate dmi if applicable.
 *
 * user - the mob who has equipped the clothing
 * slot - the slot equipped to
 */
/obj/item/clothing/proc/swap_digitigrade_dmi(mob/user)
	if(!user)
		return FALSE
	if(!has_digi_support)
		return FALSE

	if(user.is_digitigrade())
		if(worn_icon == digitigrade_file)
			return FALSE

		if(greyscale_config_worn)
			greyscale_config_worn = digitigrade_greyscale_config_worn
		else
			worn_icon = digitigrade_file

	else
		if(worn_icon == initial(worn_icon))
			return FALSE

		if(greyscale_config_worn)
			greyscale_config_worn = initial(greyscale_config_worn)
		else
			worn_icon = initial(worn_icon)

	update_greyscale()
	update_slot_icon()
	return TRUE
