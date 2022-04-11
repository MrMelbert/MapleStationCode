// Brass chair that don't spin.
/obj/structure/chair/brass
	name = "engraved brass chair"
	desc = "A chair made of brass. It doesn't spin automatically..."
	icon_state = "brass_chair"
	buildstacktype = /obj/item/stack/sheet/brass
	buildstackamount = 2
	item_chair = null

/obj/structure/chair/brass/Initialize(mapload)
	. = ..()
	ADD_CLOCKCULT_FILTER(src)
	new /obj/effect/temp_visual/brass/girder(loc)

/obj/structure/chair/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()
