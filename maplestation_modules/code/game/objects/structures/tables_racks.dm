/obj/structure/table
	var/crack_states_count = 10
	var/static/list/crack_states

/obj/structure/table/Initialize()
	. = ..()
	if(!crack_states)
	crack_states = list()
	for(var/i in 1 to crack_states_count)
		crack_states += "crack[i]"

	AddElement(/datum/element/crackable, 'icons/obj/pipes_n_cables/stationary_canisters.dmi', crack_states)

/obj/structure/table/tablepush(mob/living/user, mob/living/pushed_mob)
	. = ..()
	take_damage(20)
