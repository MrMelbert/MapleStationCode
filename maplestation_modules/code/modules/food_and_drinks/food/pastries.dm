//Macaron randomness variable + override
/obj/item/food/cookie/macaron
	/// Randomize the icon_state between multiple states on initialize
	var/randomize_icon_state = TRUE

/obj/item/food/cookie/macaron/Initialize(mapload)
	. = ..()
	if(randomize_icon_state)
		icon_state = "[base_icon_state]_[rand(1, 4)]"
