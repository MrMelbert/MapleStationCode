/// -- Extension of /obj/machinery/vending to add products, contraband, and premium items to vendors. --
/obj/machinery/vending
	/// Assoc list of products you want to add (typepath - amount)
	var/list/added_products
	/// Assoc list of contraband you want to add (typepath - amount)
	var/list/added_contraband
	/// Assoc list of premium items you want to add (typepath - amount)
	var/list/added_premium

/obj/machinery/vending/Initialize()
	add_module_items(products, added_products)
	add_module_items(contraband, added_contraband)
	add_module_items(premium, added_premium)

	return ..()

/// Adds the items from list_to_add into list_adding_to, removing items if they become negative.
/obj/machinery/vending/proc/add_module_items(list/list_adding_to, list/list_to_add)
	if(!LAZYLEN(list_to_add))
		return

	for(var/item in list_to_add)
		if(list_adding_to[item])
			list_adding_to[item] += list_to_add[item]
			if(list_adding_to[item] <= 0)
				list_adding_to -= item
		else
			list_adding_to[item] = list_to_add[item]
/*
	Here's a template for adding and removing items.
	Just list the typepath of the vendor you want modify and edit the three lists accordingly.

	An item not already in the list will be added with the value you set.
	An item already in the list will have it's amount adjusted by the value you set.
	If you set a negative value, it will remove items from an existing item.

	If an item's amount is below 0 after adjusting it, it will be removed from the list entirely.
	Use -99 if you want an item to be guaranteed removed from the list.

/obj/machinery/vending/hydroseeds
	added_products = list(/obj/item/seeds/harebell = 3,
						/obj/item/seeds/apple = 1,
						/obj/item/seeds/corn = -1,
						)
	added_premium = list(/obj/item/food/grown/rose = 2,
						/obj/item/seeds/shrub = 2,
						/obj/item/reagent_containers/spray/waterflower = -99,
						)
	added_contraband = list(/obj/item/seeds/rainbow_bunch = 2,
							/obj/item/seeds/random = 1,
							)

*/
