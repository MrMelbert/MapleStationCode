// Sidepaths for knowledge between Knock and Moon.

/datum/heretic_knowledge/spell/mind_gate
	name = "Mind Gate"
	desc = "Grants you Mind Gate, a spell \
		which deals you 20 brain damage but the target suffers a hallucination,\
		is left confused for 10 seconds, suffers oxygen loss and brain damage."
	gain_text = "My mind swings open like a gate, and its insight will let me percieve the truth."
	next_knowledge = list(
		/datum/heretic_knowledge/key_ring,
		/datum/heretic_knowledge/spell/moon_smile,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/mind_gate
	cost = 1
	route = PATH_SIDE
	depth = 4

/datum/heretic_knowledge/unfathomable_curio
	name = "Unfathomable Curio"
	desc = "Allows you to transmute 3 rods, a brain and a belt into an Unfathomable Curio\
			, a belt that can hold blades and items for rituals. Whilst worn will also \
			veil you, allowing you to take 5 hits without suffering damage, this veil will recharge very slowly \
			outside of combat. When examined the examiner will suffer brain damage and blindness."
	gain_text = "The mansus holds many a curio, some are not meant for the mortal eye."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/burglar_finesse,
		/datum/heretic_knowledge/spell/moon_parade,
	)
	required_atoms = list(
		/obj/item/organ/internal/lungs = 1,
		/obj/item/stack/rods = 3,
		/obj/item/storage/belt = 1,
	)
	result_atoms = list(/obj/item/storage/belt/unfathomable_curio)
	cost = 1
	route = PATH_SIDE
	research_tree_icon_path = 'icons/obj/clothing/belts.dmi'
	research_tree_icon_state = "unfathomable_curio"
	depth = 8

/datum/heretic_knowledge/painting
	name = "Unsealed Arts"
	desc = "Allows you to transmute a canvas and an additional item to create a piece of art, these paintings \
			have different effects depending on the additional item added. Possible paintings: \
			The sister and He Who Wept: Eyes. When a non-heretic looks at the painting they will begin to hallucinate everyone as heretics. \
			The First Desire: Any bodypart. Increases the hunger of non-heretics, when examined drops an organ or body part at your feet. \
			Great chaparral over rolling hills: Any grown food. Spreads kudzu when placed, when examined grants a flower. \
			Lady out of gates: Gloves. Causes non-heretics to scratch themselves, when examined removes all your mutations. \
			Climb over the rusted mountain: Trash. Causes non-heretics to rust the floor they walk on. \
			These effects are mitigated for a few minutes when a non-heretic suffering an effect examines the painting that caused the effect."
	gain_text = "A wind of inspiration blows through me, past the walls and past the gate inspirations lie, yet to be depicted. \
				They yearn for mortal eyes again, and I shall grant that wish."
	next_knowledge = list(
		/datum/heretic_knowledge/spell/burglar_finesse,
		/datum/heretic_knowledge/spell/moon_parade,
	)
	required_atoms = list(/obj/item/canvas = 1)
	result_atoms = list(/obj/item/canvas)
	cost = 1
	route = PATH_SIDE
	research_tree_icon_path = 'icons/obj/signs.dmi'
	research_tree_icon_state = "eldritch_painting_weeping"
	depth = 8

/datum/heretic_knowledge/painting/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	if(locate(/obj/item/organ/internal/eyes) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/weeping)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/organ/internal/eyes = 1,
		)
		return TRUE

	if(locate(/obj/item/bodypart) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/desire)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/bodypart = 1,
		)
		return TRUE

	if(locate(/obj/item/food/grown) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/vines)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/food/grown = 1,
		)
		return TRUE

	if(locate(/obj/item/clothing/gloves) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/beauty)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/clothing/gloves = 1,
		)
		return TRUE

	if(locate(/obj/item/trash) in atoms)
		src.result_atoms = list(/obj/item/wallframe/painting/eldritch/rust)
		src.required_atoms = list(
			/obj/item/canvas = 1,
			/obj/item/trash = 1,
		)
		return TRUE

	user.balloon_alert(user, "no additional atom present!")
	return FALSE
