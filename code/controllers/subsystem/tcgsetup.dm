SUBSYSTEM_DEF(trading_card_game)
	name = "Trading Card Game"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TCG
	var/card_directory = "strings/tcg"
	/// List of card files to load
	var/list/card_files = list("set_one.json", "set_two.json", "set_tdatet.json")
	/// List of keyword files
	/// These allow you to add on hovor logic to parts of a card's text, displaying extra info
	var/list/keyword_files = list("keywords.json")
	/// What cardpack types to load
	var/card_packs = list(/obj/item/cardpack/series_one, /obj/item/cardpack/resin, /obj/item/cardpack/tdatet)
	var/list/cached_guar_rarity = list()
	var/list/cached_rarity_table = list()
	/// List of all cards by series, with cards cached by rarity to make those lookups faster
	var/list/cached_cards = list()
	/// List of loaded keywords matched with their hovor text
	var/list/keywords = list()
	var/loaded = FALSE

//Let's load the cards before the map fires, so we can load cards on the map safely
/datum/controller/subsystem/trading_card_game/Initialize()
	reloadAllCardFiles(card_files, card_directory)
	return ..()
