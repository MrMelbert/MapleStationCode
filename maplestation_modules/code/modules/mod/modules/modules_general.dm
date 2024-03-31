///Helmet Desynchronizer - Allows undeploying the helmet once the suit is activated.
/obj/item/mod/module/helmet_desync
	name = "MOD helmet desynchronizer"
	desc = "A module designed to allow the helmet to operate independently from the rest of the modsuit modules. \
		Allows the helmet of the modsuit to be undeployed once the suit is activated. Head modules are kept operational for maximum efficiency." //and totally not because slot-restricted modules arent a thing yet and are coming in a refactor // update: it's been a year, the refactor still hasn't been made. rip
	icon_state = "regulator"
	complexity = 1
	incompatible_modules = list(/obj/item/mod/module/helmet_desync)

/obj/item/mod/module/helmet_desync/on_install()
	mod.helmet_desync = TRUE

/obj/item/mod/module/helmet_desync/on_uninstall(deleting = FALSE)
	mod.helmet_desync = FALSE
