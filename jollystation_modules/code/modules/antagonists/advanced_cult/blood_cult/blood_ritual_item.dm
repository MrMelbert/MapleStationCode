
/obj/item/melee/cultblade/dagger/advanced
	desc = "A special and strange dagger said to be used by cultists to prepare rituals, scribe runes, and combat heretics alike."

/obj/item/melee/cultblade/dagger/advanced/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/advanced_ritual_item, \
		can_scrape_runes = FALSE, \
		can_move_buildings = FALSE)

/obj/item/melee/cultblade/dagger/advanced/attack_self(mob/user)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) // Hacky hacky hacky
