// -- Bodypart pain definitions. --
/obj/item/bodypart
	/// The amount of pain this limb is experiencing (A bit for default)
	var/pain = 15
	var/last_pain = 15
	/// The max amount of pain this limb can experience
	var/max_pain = 70

/obj/item/bodypart/chest
	max_pain = 120

/obj/item/bodypart/head
	max_pain = 100
