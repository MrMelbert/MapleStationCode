/datum/design/proto_mana_lens
	name = "Prototype Mana Lens"
	desc = "The first prototype of a device capable of reading the prescence of mana."
	id = "mana_lens"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2.5, /datum/material/gold = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/mana_lens
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/artificial_volite_large
	name = "Artificial Volite Gem"
	desc = "Produce a volite gem through non-magical manufacturing. Far less efficient than the magical way, of course."
	id = "artificial_volite_large"
	build_type = PROTOLATHE
	materials = list(/datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 2, /datum/material/uranium = SMALL_MATERIAL_AMOUNT * 2, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/mana_battery/mana_crystal/standard
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING // because this is meant to be inefficient (and uses bluespace crystals) this should be locked to the two departments that generally manage these

/datum/design/artificial_volite_small
	name = "Small Artificial Volite Gem"
	desc = "Produce a miniaturized volite gem through non-magical manufacturing. Far less efficient than the magical way, of course."
	id = "artificial_volite_small"
	build_type = PROTOLATHE
	materials = list(/datum/material/bluespace = SMALL_MATERIAL_AMOUNT, /datum/material/uranium = SMALL_MATERIAL_AMOUNT, /datum/material/gold = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/mana_battery/mana_crystal/small
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/techie_magic_wand
	name = "Arcane Field Modulator"
	desc = "An overengineered device produced and researched on board to manipulate and move residual mana within objects."
	id = "techie_magic_wand"
	build_type = PROTOLATHE
	materials = list(/datum/material/silver = SMALL_MATERIAL_AMOUNT, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/magic_wand/techie
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/stellar_oculory
	name = "Stellar oculory"
	desc = "The circuit board for a stellar oculory."
	id = "stellar_oculory"
	build_path = /obj/item/circuitboard/machine/stellar_oculory
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
