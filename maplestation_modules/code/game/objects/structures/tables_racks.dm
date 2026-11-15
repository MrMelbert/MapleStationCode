/obj/structure/table

/obj/structure/table/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/crackable)

/obj/structure/table/tablepush(mob/living/user, mob/living/pushed_mob)
	. = ..()
	take_damage(20)

/obj/structure/table/atom_deconstruct(disassembled = TRUE)
	. = ..()
	if(!disassembled)
		playsound(src, 'sound/effects/bang.ogg', 90, TRUE)
		visible_message(span_danger("[src] breaks down!"),
			blind_message = span_danger("You hear something breaking."))
