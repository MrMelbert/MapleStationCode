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
		"legendary" = 5)
	guar_rarity = list(
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5)


/obj/item/cardpack/tdatet/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>You browse the back of the pack...</i>")
	. += "\t[span_info("Tiny Dances And The Everything Tree is a cute pack for those getting into cardgames.")]"
	. += "\t[span_info("A Work in Progress set, feel free to call the printing company with your ideas!")]"
	if(HAS_TRAIT(user, TRAIT_CARDCOLLECTOR))
		. += "\t[span_info("Dances is rather cute, but the card prints are awful.")]"
	return .

/obj/item/cardpack/tdatet/green
	name = "Trading Card Pack Green: Tiny Dances And The Everything Tree"
	desc = "Contains ten cards of varying rarity from the TDATET Green set. Collect them all!"
	rarity_table = list(
		"guncommon" = 300,
		"grare" = 100,
		"gepic" = 30,
		"glegendary" = 5)
	guar_rarity = list(
		"guncommon" = 300,
		"grare" = 100,
		"gepic" = 30,
		"glegendary" = 5)

/obj/item/cardpack/tdatet/blue
	name = "Trading Card Pack Blue: Tiny Dances And The Everything Tree"
	desc = "Contains ten cards of varying rarity from the TDATET Blue set. Collect them all!"
	rarity_table = list(
		"buncommon" = 300,
		"brare" = 100,
		"bepic" = 30,
		"blegendary" = 5)
	guar_rarity = list(
		"buncommon" = 300,
		"brare" = 100,
		"bepic" = 30,
		"blegendary" = 5)

/obj/item/cardpack/tdatet/mixed
	name = "Trading Card Pack Mixed: Tiny Dances And The Everything Tree"
	desc = "Contains five cards of varying rarity from the TDATET Mixed set. This one has green/blue costs and all color resource costs, recommended to get after getting Green/Blue generators. Collect them all!"
	contains_coin = 0
	card_count = 4
	rarity_table = list(
		"muncommon" = 300,
		"mepic" = 30,
		"mlegendary" = 5)
	guar_rarity = list(
		"muncommon" = 150,
		"mepic" = 30,
		"mlegendary" = 5)

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
		"tdbasefoil" = 60)
	guar_rarity = list(
		"tdbase2" = 900,
		"tdbase2foil" = 60)

/obj/item/cardpack/tdatet_box
	name = "Trading Card Pack Red Box: Tiny Dances And The Everything Tree"
	desc = "Contains 28 cards of varying rarity from the TDATET Red set, 5 being a guaranteed uncommon or higher! Along with flipper. Great for getting started!"
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "cardpack_tdatet_case"
	series = "tdatet"
	contains_coin = 100
	card_count = 23
	rarity_table = list(
		"common" = 900,
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5)
	guaranteed_count = 5
	guar_rarity = list(
		"uncommon" = 300,
		"rare" = 100,
		"epic" = 30,
		"legendary" = 5)

/obj/item/cardpack/tdatet_box/debug
	name = "Trading Card Debug Box: Tiny Dances And The Everything Tree"
	desc = "Contains every card to admire and check. You have infact collected them all."
	drop_all_cards = TRUE

/obj/item/storage/card_binder/personal
	icon = 'maplestation_modules/icons/runtime/tcg/tdatet.dmi'
	icon_state = "binder_green"

/obj/item/storage/card_binder/personal/examine(mob/user) // just a minor addition to let examiner know how many cards are within a binder since i got tired counting manually.
	. = ..()
	. += span_notice("\The [src] has [contents.len] cards inside.")

/obj/machinery/vending/games //this will add to the library games vendor under the Other category.
	added_categories = list(
		list(
			"name" = "Other",
			"icon" = "star",
			"products" = list(
		/obj/item/cardpack/tdatet = 20,
		/obj/item/cardpack/tdatet_base = 20,
		/obj/item/cardpack/tdatet_box = 20,
		/obj/item/cardpack/tdatet/green = 10,
		/obj/item/cardpack/tdatet/blue = 10,
		/obj/item/cardpack/tdatet/mixed = 10,
			)
		),
	)
