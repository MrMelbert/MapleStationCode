///Modular Modsuit Modules that do anything non-specific.

///Helmet Desynchronizer - Allows undeploying the helmet once the suit is activated.
/obj/item/mod/module/helmet_desync
	name = "MOD helmet desynchronizer"
	desc = "A module designed to allow the helmet to operate independently from the rest of the modsuit modules. \
		Allows the helmet of the modsuit to be undeployed once the suit is activated. Head modules are kept operational for maximum efficiency." //and totally not because slot-restricted modules arent a thing yet and are coming in a refactor
	icon_state = "regulator"
	complexity = 3
	incompatible_modules = list(/obj/item/mod/module/helmet_desync)

/obj/item/mod/module/helmet_desync/on_install()
	mod.helmet_desync = TRUE

/obj/item/mod/module/helmet_desync/on_uninstall()
	mod.helmet_desync = FALSE
