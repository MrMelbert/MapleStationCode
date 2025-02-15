/obj/item/stock_parts/cell/emproof/slime
	icon_state = "yellow-core"
	icon = 'maplestation_modules/icons/mob/simple/slimes.dmi'

/obj/item/stock_parts/cell/high/slime_hypercharged
	icon_state = "yellow-core"
	icon = 'maplestation_modules/icons/mob/simple/slimes.dmi'

/obj/item/stock_parts/cell/crap
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'
	icon_state = "aa_cell"

/obj/item/stock_parts/cell/crap/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/stock_parts/cell/upgraded
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'
	icon_state = "9v_cell"

/obj/item/stock_parts/cell/upgraded/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/stock_parts/cell/high
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'

/obj/item/stock_parts/cell/hyper
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'

/obj/item/stock_parts/cell/super
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'

/obj/item/stock_parts/cell/crystal_cell
	icon = 'maplestation_modules/icons/obj/machines/cell_charger.dmi'
