// Liver stuff
/obj/item/organ/internal/liver
	/// Typecache of food we can eat that will never give us disease.
	var/list/disease_free_foods

// Lizard liver to Let Them Eat Rat
/obj/item/organ/internal/liver/lizard
	name = "lizardperson liver"
	desc = "A liver native to a Lizardperson of Tiziran... or maybe one of its colonies."
	color = COLOR_VERY_DARK_LIME_GREEN

/obj/item/organ/internal/liver/lizard/Initialize(mapload)
	. = ..()
	disease_free_foods = typecacheof(/obj/item/food/deadmouse)
