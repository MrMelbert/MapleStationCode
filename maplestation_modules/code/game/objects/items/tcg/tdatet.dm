/* --Tiny Dances And The Everything Tree is based on the abandonded steam game "Prismata". I have attempted
to apply it to the ss13 card subsystem to see how it would work within the game, many of the mechanics have
been moved as best as possible with the main difference of how the cards are obtained being in packs instead
of copies of cards shared between two players. To help alleviate the RNG of cardpacks some cards are given the
{$Mass} tag which means they only need a single copy with a counter of some kind, such as a paper being labeled,
instead of having to hope for getting multiple of one unit. Out of curiosity I have decided to have every card
within a "set" and the different colored "variants" within this. Rarities without a letter before are red, g for
green, b for blue, with m for a mixed set containing green/blue costs and all resource cost units. It is intended
for tdatet_base to contain only 2 cards that are required to play, along with a 28 card booster box of red cards
to help start a game that players with the cardcollector trait will start with. This is an early test with
placeholder card art in the case that I want to rename them or remove altogether if too difficult to keep track of
such as the various build turns or exhausted mechanics. Perhaps if I really wanted to have this be added
to any major codebases I will scrub the Dances name so its not as blatant,
but so far they just reside in the red set. Balancing will be done after a few games, such as rarities.
DEBUG REMINDER Since these are using placeholder art, might want to remove the white square and N from the basic tcg template when finalizing the artwork.
*/
/obj/item/cardpack/tdatet
	name = "Trading Card Pack Red: Tiny Dances And The Everything Tree"
	desc = "Contains ten cards of varying rarity from the TDATET Red set. Collect them all!"
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "cardpack_tdatet"
	custom_price = PAYCHECK_CREW //A note to change custom prices if too expensive/cheap
	series = "tdatet"
	contains_coin = 0
	card_count = 9
	rarity_table = list(
		"common" = 900,
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5,
	)
	guar_rarity = list(
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5,
	)


/obj/item/cardpack/tdatet/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>You browse the back of the pack...</i>")
	. += "\t[span_info("Tiny Dances And The Everything Tree is a cute pack for those getting into cardgames.")]"
	. += "\t[span_info("A Work in Progress set, feel free to call the printing company with your ideas!")]"
	if(HAS_TRAIT(user, TRAIT_CARDCOLLECTOR))
		. += "\t[span_info("Dances is rather cute, but the card prints are awful.")]"
	return .

//Starter pack that gives 3 color resource genning cards since I choose not to figure out how to program spawning specific cards that will pass the create and destroy check.
/obj/item/cardpack/bdateb
	name = "Trading Card Pack Beginner: Tiny Dances And The Everything Tree"
	desc = "3 color creation cards to start dueling or trading with. Beginner Devices, Arm The Early Battalion!"
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "cardpack_tdatet"
	series = "bdateb"
	drop_all_cards = TRUE

/obj/item/cardpack/tdatet/green
	name = "Trading Card Pack Green: Tiny Dances And The Everything Tree"
	desc = "Contains ten cards of varying rarity from the TDATET Green set. Collect them all!"
	rarity_table = list(
		"guncommon" = 300,
		"grare" = 100,
		"gepic" = 30,
		"glegendary" = 5,
	)
	guar_rarity = list(
		"guncommon" = 300,
		"grare" = 100,
		"gepic" = 30,
		"glegendary" = 5,
	)

/obj/item/cardpack/tdatet/blue
	name = "Trading Card Pack Blue: Tiny Dances And The Everything Tree"
	desc = "Contains ten cards of varying rarity from the TDATET Blue set. Collect them all!"
	rarity_table = list(
		"buncommon" = 300,
		"brare" = 100,
		"bepic" = 30,
		"blegendary" = 5,
	)
	guar_rarity = list(
		"buncommon" = 300,
		"brare" = 100,
		"bepic" = 30,
		"blegendary" = 5,
	)

/obj/item/cardpack/tdatet/mixed
	name = "Trading Card Pack Mixed: Tiny Dances And The Everything Tree"
	desc = "Contains five cards of varying rarity from the TDATET Mixed set. This one has green/blue costs and all color resource costs, recommended to get after getting Green/Blue generators. Collect them all!"
	contains_coin = 0
	card_count = 4
	rarity_table = list(
		"muncommon" = 300,
		"mepic" = 30,
		"mlegendary" = 5,
	)
	guar_rarity = list(
		"muncommon" = 150,
		"mepic" = 30,
		"mlegendary" = 5,
	)

/obj/item/cardpack/tdatet_base
	name = "Trading Card Base: Tiny Dances And The Everything Tree"
	desc = "Contains the 2 base cards of the game and flipper to start your adventure!"
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "cardpack_tdatet"
	custom_price = 25
	series = "tdatet"
	contains_coin = 100
	card_count = 1
	rarity_table = list(
		"tdbase" = 900,
		"tdbasefoil" = 60,
	)
	guar_rarity = list(
		"tdbase2" = 900,
		"tdbase2foil" = 60,
	)

/obj/item/cardpack/tdatet_box
	name = "Trading Card Pack Red Box: Tiny Dances And The Everything Tree"
	desc = "Contains 25 cards of varying rarity from the TDATET Red set, 5 being a guaranteed rare or higher!"
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "cardpack_tdatet_case"
	series = "tdatet"
	contains_coin = 0
	card_count = 20
	rarity_table = list(
		"common" = 900,
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5,
	)
	guaranteed_count = 5
	guar_rarity = list(
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5,
	)

/obj/item/cardpack/tdatet_box/debug
	name = "Trading Card Debug Box: Tiny Dances And The Everything Tree"
	desc = "Contains every card to admire and check. You have infact collected them all."
	drop_all_cards = TRUE

/obj/item/storage/card_binder/personal
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "binder_green"

/obj/item/storage/card_binder/personal/examine(mob/user) // just a minor addition to let examiner know how many cards are within a binder since i got tired counting manually.
	. = ..()
	. += span_notice("[src] has [contents.len] cards inside.")

/obj/machinery/vending/games //this will add to the library games vendor under the Other category.
	added_categories = list(
		list(
			"name" = "Other",
			"icon" = "star",
			"products" = list(
				/obj/item/storage/box/tdatet_starter = 20,
				/obj/item/cardpack/tdatet = 20,
				/obj/item/cardpack/tdatet/green = 20,
				/obj/item/cardpack/tdatet/blue = 20,
				/obj/item/cardpack/tdatet/mixed = 20,
				/obj/item/toy/counter = 20,
			)
		),
	)

/obj/item/paper/fluff/tdatet_rules //Rules for the game, may need to update later on.
	name = "TDATET rules"
	desc = "Rules to start and play a game of Tiny Dances And The Everything Tree."
	default_raw_text = @{"

Thank you for testing out our initial prints of Tiny Dances And The Everything Tree!
While the cards are in an early alpha state we wish for you to playtest the various rules and give feedback.

Store all your cards in an easy to grab binder with up to 60 cards instead of a deck. You are able to play any card you can afford.
Set out your Default Dances and Miner Dances cards by counters of some kind (such as a paper) to count how many of that unit you have, you may use counters for any cards labeled Mass.
Both players get 2 Default Dances and 6 Miner Dances, with the 2nd player starting with an additional Miner Dances.
Most units will not be active to defend or attack until the next turn unless the unit's card says otherwise.
A player that has no more units loses, either player may concede as well. If players are unable to add or remove units it is a draw.
Be sure to check on your economy units and have enough cards to support your units. Gold and Green are the only resources that are saved between turns, so you may need a counter for those.
Check out the other color set packs at your local game vendor or order online to expand your strategy with more color resources! Be sure to trade and swap cards to have a good balance.
	"}

/obj/item/toy/counter //looking at various bits of the ticket counter and card decks, this will store and display a number. Leftclick to add 1, Right click to subract 1, with Altclick to input a number directly.
	name = "counter - 0"
	desc = "Keeps a number on its display."
	icon = 'maplestation_modules/icons/runtime/tcg/counter.dmi'
	icon_state = "counter"
	custom_price = PAYCHECK_LOWER
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = UNIQUE_RENAME
	var/base_name = "counter"
	var/current_number = 0

/obj/item/toy/counter/Initialize(mapload)
	. = ..()
	register_context()
	AddElement(/datum/element/drag_pickup)

/obj/item/toy/counter/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(!isturf(loc))
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Set number"
		return CONTEXTUAL_SCREENTIP_SET

	context[SCREENTIP_CONTEXT_LMB] = "Add one"
	context[SCREENTIP_CONTEXT_RMB] = "Subtract one"
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Set number"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/toy/counter/examine(mob/user)
	. = ..()
	. += span_notice("The counter display has #[current_number].")
	. += span_notice("Alt Button to set a number. Needs to be set down to add or subtract, when in inventory can click to pick up. When set down click-drag to pickup. Goes from 0 to 999. Left button to add 1, Right Button to subtract 1.")

/obj/item/toy/counter/update_name()
	. = ..()
	if(renamedByPlayer)
		base_name = name
		renamedByPlayer = FALSE
	name = "[base_name] - [current_number]"

/obj/item/toy/counter/attack_hand(mob/living/user)
	if(!isturf(loc))
		return ..()
	current_number = clamp(current_number + 1, 0, 999)
	update_appearance(UPDATE_NAME|UPDATE_ICON)
	balloon_alert(user, "raised to [current_number]")
	playsound(src, 'sound/misc/fingersnap1.ogg', 5, TRUE)
	add_fingerprint(user)
	return TRUE

/obj/item/toy/counter/attack_hand_secondary(mob/living/user)
	if(!isturf(loc))
		return SECONDARY_ATTACK_CONTINUE_CHAIN
	current_number = clamp(current_number - 1, 0, 999)
	update_appearance(UPDATE_NAME|UPDATE_ICON)
	balloon_alert(user, "lowered to [current_number]")
	playsound(src, 'sound/misc/fingersnap1.ogg', 5, TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/toy/counter/AltClick(mob/living/user)
	. = ..()
	if(!user.canUseTopic(src, be_close = TRUE, need_hands = !iscyborg(user)))
		return
	var/amount = tgui_input_number(usr, message = "New Number To Display", title = "Number Input", default = 0, max_value = 999, min_value = 0, timeout = 0, round_value = TRUE)
	if(!isnull(amount))
		current_number = amount
		update_icon(UPDATE_OVERLAYS)
		update_appearance(UPDATE_NAME)
		balloon_alert(user, "set to [current_number]")
	playsound(src, 'sound/misc/knuckles.ogg', 5, TRUE)

/obj/item/toy/counter/update_overlays()
	. = ..()

	var/ones = current_number % 10
	var/mutable_appearance/ones_overlay = mutable_appearance('maplestation_modules/icons/runtime/tcg/counter.dmi', "num_[ones]")
	ones_overlay.pixel_w = 0
	. += ones_overlay

	var/tens = (current_number / 10) % 10
	var/mutable_appearance/tens_overlay = mutable_appearance('maplestation_modules/icons/runtime/tcg/counter.dmi', "num_[tens]")
	tens_overlay.pixel_w = -5
	. += tens_overlay

	var/huns = (current_number / 100) % 10
	var/mutable_appearance/huns_overlay = mutable_appearance('maplestation_modules/icons/runtime/tcg/counter.dmi', "num_[huns]")
	huns_overlay.pixel_w = -10
	. += huns_overlay

/obj/item/storage/box/tdatet_starter
	name = "TDATET starter box"
	desc = "Contains rules, cards, and counters to help start your dueling journey."
	custom_price = PAYCHECK_COMMAND

/obj/item/storage/box/tdatet_starter/PopulateContents()
	var/static/list/items_inside = list(
		/obj/item/cardpack/tdatet_box = 1,
		/obj/item/cardpack/tdatet_base = 1,
		/obj/item/cardpack/bdateb = 1,
		/obj/item/paper/fluff/tdatet_rules = 1,
		/obj/item/toy/counter = 5,
	)
	generate_items_inside(items_inside, src)

