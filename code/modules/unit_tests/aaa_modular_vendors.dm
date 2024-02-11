/datum/unit_test/modular_vendors

/datum/unit_test/modular_vendors/Run()
	var/obj/machinery/vending/test_vendor/vendor = allocate(/obj/machinery/vending/test_vendor)
	var/list/expected_paths = list(/obj/item/food/grown/rose = 3, /obj/item/food/grown/apple = 2)
	var/list/got_paths = list()

	for(var/datum/data/vending_product/product as anything in vendor.product_records)
		got_paths[product.product_path] = product.max_amount

	for(var/path in got_paths)
		var/got_amount = (path in got_paths) ? got_paths[path] : 0
		var/expected_amount = (path in expected_paths) ? expected_paths[path] : 0
		if(got_amount == expected_amount)
			continue
		TEST_FAIL("[path] was expected to have a stock of [expected_amount], but actually had a stock of [got_amount]!")

/obj/machinery/vending/test_vendor
	products = list(
		/obj/item/food/grown/poppy = 2,
		/obj/item/food/grown/rose = 2,
	)
	added_products = list(
		/obj/item/food/grown/rose = 1,
		/obj/item/food/grown/apple = 2,
		/obj/item/food/grown/poppy = -99,
	)
