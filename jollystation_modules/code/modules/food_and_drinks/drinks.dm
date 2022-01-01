// -- Drink stuff --
/datum/reagent
	/// The file the glass's icon is located.
	var/glass_icon_file = 'icons/obj/drinks.dmi'

/obj/item/reagent_containers/food/drinks/drinkingglass/update_icon_state()
	if(!reagents.total_volume)
		icon = initial(icon)
		return ..()

	var/datum/reagent/most_reagent = reagents.get_master_reagent()
	if(get_glass_icon(most_reagent))
		icon = most_reagent.glass_icon_file
	else
		icon = initial(icon)
	return ..()
