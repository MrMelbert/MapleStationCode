/// Helper macro to add assoc list from to assoc list to, removing elements less than zero after combination
#define COMBINE_ASSOC_LISTS_DROP_ZERO(list_to, list_from)\
	for(var/item in list_from) { \
		list_to[item] += list_from[item]; \
		if(list_to[item] <= 0) { list_to -= item }; \
	};

/// -- Extension of /obj/machinery/vending to add products, contraband, and premium items to vendors. --
/obj/machinery/vending
	/// Assoc lazylist of products you want to add or remove.
	var/list/added_products
	/// Assoc lazylist of contraband you want to add or remove.
	var/list/added_contraband
	/// Assoc lazylist of premium items you want to add or remove.
	var/list/added_premium
	/**
	 * Assoc lazylist of categories to add
	 *
	 * Allows for both adding new categories, modifying existing categories, and organizing existing products into categories
	 * All without touching the vending machines directly
	 *
	 * * Having an added category matching the name of an existing category will combine the categories,
	 * meaning products defined here will be added to the category. This works with subctraction, if you want to remove
	 * an item from a certain category entirely.
	 *
	 * * Having an added category with items already present in the generic products list will remove them
	 * and have them be in your category instead
	 *
	 * * Otherwise, categories here will just be added to the categories like normal.
	 */
	var/list/added_categories

/obj/machinery/vending/Initialize()
	COMBINE_ASSOC_LISTS_DROP_ZERO(products, added_products)
	COMBINE_ASSOC_LISTS_DROP_ZERO(contraband, added_contraband)
	COMBINE_ASSOC_LISTS_DROP_ZERO(premium, added_premium)
	// If we're a product sorted vendor, and we have a products list,
	// we need to add all of our the products to a category, or else they will be dropped
	// We'll just put all of the leftover products in an "other products" category
	if(LAZYLEN(product_categories) && length(products))
		var/list/other_stuff = list(
			"name" = "Other Products",
			"icon" = "cart-shopping",
			"products" = products.Copy(),
		)
		UNTYPED_LIST_ADD(product_categories, other_stuff)
	// And now combine new categories into potential exisitng ones
	if(LAZYLEN(added_categories))
		combine_categories()

	return ..()

/// Combines the added_categories list and the product_categories list
/obj/machinery/vending/proc/combine_categories()
	var/list/default_stuff
	// This is not a product category supported vendor by default
	// We need a category for JUST existing products, or else they will be dropped
	// (Similar to the handling done in initialize)
	if(!LAZYLEN(product_categories))
		default_stuff = list(
			"name" = "Products",
			"icon" = "cart-shopping",
			"products" = products.Copy(),
		)
		UNTYPED_LIST_ADD(product_categories, default_stuff)

	// Go through all the categories we want to add
	for(var/list/new_category as anything in added_categories)
		var/handled = FALSE
		// Compare them against existing categories
		for(var/list/old_category as anything in product_categories)
			// If an existing category has a matching name, we should combine them
			if(old_category["name"] != new_category["name"])
				continue

			// Go ahead and add all of the new product into the old product lists
			COMBINE_ASSOC_LISTS_DROP_ZERO(old_category["products"], new_category["products"])
			handled = TRUE
			break

		// Remove all default products if they're also in our new products list
		if(default_stuff)
			for(var/path in new_category["products"])
				default_stuff["products"] -= path

		// If we didn't combine with another category, we can add the new category to the categories list
		if(!handled)
			UNTYPED_LIST_ADD(product_categories, new_category)

/*
	Here's a template for adding and removing items.
	Just list the typepath of the vendor you want modify and edit the three lists accordingly.

	An item not already in the list will be added with the value you set.
	An item already in the list will have it's amount adjusted by the value you set.
	If you set a negative value, it will remove items from an existing item.

	If an item's amount is below 0 after adjusting it, it will be removed from the list entirely.
	Use -99 if you want an item to be guaranteed removed from the list.

/obj/machinery/vending/hydroseeds
	added_products = list(
		/obj/item/seeds/harebell = 3,
		/obj/item/seeds/apple = -1,
		/obj/item/seeds/corn = 1,
	)
	added_premium = list(
		/obj/item/food/grown/rose = 2,
		/obj/item/seeds/shrub = 2,
		/obj/item/reagent_containers/spray/waterflower = -99,
	)
	added_contraband = list(
		/obj/item/seeds/rainbow_bunch = 2,
		/obj/item/seeds/random = 1,
	)
	added_categories = list(
		list(
			"name" = "Vegetables",
			"icon" = "corn",
			"products" = list(
				/obj/item/seeds/corn = 3,
				/obj/item/seeds/tomato = -3,
			)
		),
		list(
			"name" = "Fruit",
			"icon" = "apple",
			"products" = list(
				/obj/item/seeds/apple = 3,
				/obj/item/seeds/tomato = 3,
			)
		),
	)

*/

#undef COMBINE_ASSOC_LISTS_DROP_ZERO
