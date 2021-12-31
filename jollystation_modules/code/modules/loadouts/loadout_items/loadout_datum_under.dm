// --- Loadout item datums for under suits ---

/// Underslot - Jumpsuit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_jumpsuits, generate_loadout_items(/datum/loadout_item/under/jumpsuit))

/// Underslot - Formal Suit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_undersuits, generate_loadout_items(/datum/loadout_item/under/formal))

/// Underslot - Misc. Under Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_miscunders, generate_loadout_items(/datum/loadout_item/under/miscellaneous))

/datum/loadout_item/under
	category = LOADOUT_ITEM_UNIFORM

/datum/loadout_item/under/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout uniform was not equipped directly due to your envirosuit.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.uniform = item_path

// jumpsuit undersuits
/datum/loadout_item/under/jumpsuit

/datum/loadout_item/under/jumpsuit/greyscale
	name = "Greyscale Jumpsuit"
	can_be_greyscale = TRUE
	item_path = /obj/item/clothing/under/color/greyscale

/datum/loadout_item/under/jumpsuit/greyscale_skirt
	name = "Greyscale Jumpskirt"
	can_be_greyscale = TRUE
	item_path = /obj/item/clothing/under/color/jumpskirt/greyscale

/datum/loadout_item/under/jumpsuit/random
	name = "Random Jumpsuit"
	item_path = /obj/item/clothing/under/color/random
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/under/jumpsuit/random_skirt
	name = "Random Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/random
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)

/datum/loadout_item/under/jumpsuit/black
	name = "Black Jumpsuit"
	item_path = /obj/item/clothing/under/color/black

/datum/loadout_item/under/jumpsuit/black_skirt
	name = "Black Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/black

/datum/loadout_item/under/jumpsuit/blue
	name = "Blue Jumpsuit"
	item_path = /obj/item/clothing/under/color/blue

/datum/loadout_item/under/jumpsuit/blue_skirt
	name = "Blue Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/blue

/datum/loadout_item/under/jumpsuit/brown
	name = "Brown Jumpsuit"
	item_path = /obj/item/clothing/under/color/brown

/datum/loadout_item/under/jumpsuit/brown_skirt
	name = "Brown Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/brown

/datum/loadout_item/under/jumpsuit/darkblue
	name = "Dark Blue Jumpsuit"
	item_path = /obj/item/clothing/under/color/darkblue

/datum/loadout_item/under/jumpsuit/darkblue_skirt
	name = "Dark Blue Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/darkblue

/datum/loadout_item/under/jumpsuit/darkgreen
	name = "Dark Green Jumpsuit"
	item_path = /obj/item/clothing/under/color/darkgreen

/datum/loadout_item/under/jumpsuit/darkgreen_skirt
	name = "Dark Green Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/darkgreen

/datum/loadout_item/under/jumpsuit/green
	name = "Green Jumpsuit"
	item_path = /obj/item/clothing/under/color/green

/datum/loadout_item/under/jumpsuit/green_skirt
	name = "Green Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/green

/datum/loadout_item/under/jumpsuit/grey
	name = "Grey Jumpsuit"
	item_path = /obj/item/clothing/under/color/grey

/datum/loadout_item/under/jumpsuit/grey_skirt
	name = "Grey Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/grey

/datum/loadout_item/under/jumpsuit/lightbrown
	name = "Light Brown Jumpsuit"
	item_path = /obj/item/clothing/under/color/lightbrown

/datum/loadout_item/under/jumpsuit/ightbrown_skirt
	name = "Light Brown Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/lightbrown

/datum/loadout_item/under/jumpsuit/lightpurple
	name = "Light Purple Jumpsuit"
	item_path = /obj/item/clothing/under/color/lightpurple

/datum/loadout_item/under/jumpsuit/lightpurple_skirt
	name = "Light Purple Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/lightpurple

/datum/loadout_item/under/jumpsuit/maroon
	name = "Maroon Jumpsuit"
	item_path = /obj/item/clothing/under/color/maroon

/datum/loadout_item/under/jumpsuit/maroon_skirt
	name = "Maroon Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/maroon

/datum/loadout_item/under/jumpsuit/irange
	name = "Orange Jumpsuit"
	item_path = /obj/item/clothing/under/color/orange

/datum/loadout_item/under/jumpsuit/orange_skirt
	name = "Orange Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/orange

/datum/loadout_item/under/jumpsuit/pin
	name = "Pink Jumpsuit"
	item_path = /obj/item/clothing/under/color/pink

/datum/loadout_item/under/jumpsuit/pink_skirt
	name = "Pink Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/pink

/datum/loadout_item/under/jumpsuit/rainbow
	name = "Rainbow Jumpsuit"
	item_path = /obj/item/clothing/under/color/rainbow

/datum/loadout_item/under/jumpsuit/rainbow_skirt
	name = "Rainbow Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/rainbow

/datum/loadout_item/under/jumpsuit/red
	name = "Red Jumpsuit"
	item_path = /obj/item/clothing/under/color/red

/datum/loadout_item/under/jumpsuit/red_skirt
	name = "Red Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/red

/datum/loadout_item/under/jumpsuit/teal
	name = "Teal Jumpsuit"
	item_path = /obj/item/clothing/under/color/teal

/datum/loadout_item/under/jumpsuit/teal_skirt
	name = "Teal Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/teal

/datum/loadout_item/under/jumpsuit/yellow
	name = "Yellow Jumpsuit"
	item_path = /obj/item/clothing/under/color/yellow

/datum/loadout_item/under/jumpsuit/yellow_skirt
	name = "Yellow Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/yellow

/datum/loadout_item/under/jumpsuit/white
	name = "White Jumpsuit"
	item_path = /obj/item/clothing/under/color/white

/datum/loadout_item/under/jumpsuit/white_skirt
	name = "White Jumpskirt"
	item_path = /obj/item/clothing/under/color/jumpskirt/white

// formal undersuits
/datum/loadout_item/under/formal

/datum/loadout_item/under/formal/amish_suit
	name = "Amish Suit"
	item_path = /obj/item/clothing/under/suit/sl

/datum/loadout_item/under/formal/assistant
	name = "Assistant Formal"
	item_path = /obj/item/clothing/under/misc/assistantformal

/datum/loadout_item/under/formal/beige_suit
	name = "Beige Suit"
	item_path = /obj/item/clothing/under/suit/beige

/datum/loadout_item/under/formal/black_suit
	name = "Black Suit"
	item_path = /obj/item/clothing/under/suit/black


/datum/loadout_item/under/formal/executive_suit_alt
	name = "Beige and Blue Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/beige

/datum/loadout_item/under/formal/executive_skirt_alt
	name = "Beige and Blue Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/beige/skirt

/datum/loadout_item/under/formal/black_suitskirt
	name = "Black Suitskirt"
	item_path = /obj/item/clothing/under/suit/black/skirt

/datum/loadout_item/under/formal/black_tango
	name = "Black Tango Dress"
	item_path = /obj/item/clothing/under/dress/blacktango

/datum/loadout_item/under/formal/Black_twopiece
	name = "Black Two-Piece Suit"
	item_path = /obj/item/clothing/under/suit/blacktwopiece

/datum/loadout_item/under/formal/black_skirt
	name = "Black Skirt"
	item_path = /obj/item/clothing/under/dress/skirt

/datum/loadout_item/under/formal/black_lawyer_suit
	name = "Black Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black

/datum/loadout_item/under/formal/black_lawyer_skirt
	name = "Black Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/black/skirt

/datum/loadout_item/under/formal/blue_suit
	name = "Blue Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit

/datum/loadout_item/under/formal/blue_suitskirt
	name = "Blue Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt

/datum/loadout_item/under/formal/blue_lawyer_suit
	name = "Blue Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue

/datum/loadout_item/under/formal/blue_lawyer_skirt
	name = "Blue Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/blue/skirt

/datum/loadout_item/under/formal/blue_skirt
	name = "Blue Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/blue

/datum/loadout_item/under/formal/blue_skirt_plaid
	name = "Blue Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/blue

/datum/loadout_item/under/formal/burgundy_suit
	name = "Burgundy Suit"
	item_path = /obj/item/clothing/under/suit/burgundy

/datum/loadout_item/under/formal/charcoal_suit
	name = "Charcoal Suit"
	item_path = /obj/item/clothing/under/suit/charcoal

/datum/loadout_item/under/formal/checkered_suit
	name = "Checkered Suit"
	item_path = /obj/item/clothing/under/suit/checkered

/datum/loadout_item/under/formal/executive_suit
	name = "Executive Suit"
	item_path = /obj/item/clothing/under/suit/black_really

/datum/loadout_item/under/formal/executive_skirt
	name = "Executive Suitskirt"
	item_path = /obj/item/clothing/under/suit/black_really/skirt

/datum/loadout_item/under/formal/green_suit
	name = "Green Suit"
	item_path = /obj/item/clothing/under/suit/green

/datum/loadout_item/under/formal/green_skirt_plaid
	name = "Green Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/green

/datum/loadout_item/under/formal/navy_suit
	name = "Navy Suit"
	item_path = /obj/item/clothing/under/suit/navy

/datum/loadout_item/under/formal/maid_outfit
	name = "Maid Outfit"
	item_path = /obj/item/clothing/under/costume/maid

/datum/loadout_item/under/formal/maid_uniform
	name = "Maid Uniform"
	item_path = /obj/item/clothing/under/rank/civilian/janitor/maid

/datum/loadout_item/under/formal/purple_suit
	name = "Purple Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit

/datum/loadout_item/under/formal/purple_suitskirt
	name = "Purple Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt

/datum/loadout_item/under/formal/purple_skirt
	name = "Purple Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/purple

/datum/loadout_item/under/formal/purple_skirt_plaid
	name = "Purple Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid/purple

/datum/loadout_item/under/formal/red_suit
	name = "Red Suit"
	item_path = /obj/item/clothing/under/suit/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	name = "Red Lawyer Suit"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red

/datum/loadout_item/under/formal/red_lawyer_skirt
	name = "Red Lawyer Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/lawyer/red/skirt

/datum/loadout_item/under/formal/red_gown
	name = "Red Evening Gown"
	item_path = /obj/item/clothing/under/dress/redeveninggown

/datum/loadout_item/under/formal/red_skirt
	name = "Red Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/red

/datum/loadout_item/under/formal/red_skirt_plaid
	name = "Red Plaid Skirt"
	item_path = /obj/item/clothing/under/dress/skirt/plaid

/datum/loadout_item/under/formal/sailor
	name = "Sailor Suit"
	item_path = /obj/item/clothing/under/costume/sailor

/datum/loadout_item/under/formal/sailor_skirt
	name = "Sailor Dress"
	item_path = /obj/item/clothing/under/dress/sailor

/datum/loadout_item/under/formal/scratch_suit
	name = "Scratch Suit"
	item_path = /obj/item/clothing/under/suit/white_on_white

/datum/loadout_item/under/formal/striped_skirt
	name = "Striped Dress"
	item_path = /obj/item/clothing/under/dress/striped

/datum/loadout_item/under/formal/sensible_suit
	name = "Sensible Suit"
	item_path = /obj/item/clothing/under/rank/civilian/curator

/datum/loadout_item/under/formal/sensible_skirt
	name = "Sensible Suitskirt"
	item_path = /obj/item/clothing/under/rank/civilian/curator/skirt

/datum/loadout_item/under/formal/sundress
	name = "Sundress"
	item_path = /obj/item/clothing/under/dress/sundress

/datum/loadout_item/under/formal/tan_suit
	name = "Tan Suit"
	item_path = /obj/item/clothing/under/suit/tan

/datum/loadout_item/under/formal/teal_suit
	name = "Teal Suit"
	item_path = /obj/item/clothing/under/suit/teal

/datum/loadout_item/under/formal/teal_skirt
	name = "Teal Suitskirt"
	item_path = /obj/item/clothing/under/suit/teal/skirt

/datum/loadout_item/under/formal/tuxedo
	name = "Tuxedo Suit"
	item_path = /obj/item/clothing/under/suit/tuxedo

/datum/loadout_item/under/formal/waiter
	name = "Waiter's Suit"
	item_path = /obj/item/clothing/under/suit/waiter

/datum/loadout_item/under/formal/wedding
	name = "Wedding Dress"
	item_path = /obj/item/clothing/under/dress/wedding_dress

/datum/loadout_item/under/formal/white_suit
	name = "White Suit"
	item_path = /obj/item/clothing/under/suit/white

/datum/loadout_item/under/formal/white_skirt
	name = "White Suitskirt"
	item_path = /obj/item/clothing/under/suit/white/skirt

// misc undersuits
/datum/loadout_item/under/miscellaneous

/datum/loadout_item/under/miscellaneous/camo
	name = "Camo Pants"
	item_path = /obj/item/clothing/under/pants/camo

/datum/loadout_item/under/miscellaneous/jeans_classic
	name = "Classic Jeans"
	item_path = /obj/item/clothing/under/pants/classicjeans

/datum/loadout_item/under/miscellaneous/jeans_black
	name = "Black Jeans"
	item_path = /obj/item/clothing/under/pants/blackjeans

/datum/loadout_item/under/miscellaneous/black
	name = "Black Pants"
	item_path = /obj/item/clothing/under/pants/black

/datum/loadout_item/under/miscellaneous/black_short
	name = "Black Shorts"
	item_path = /obj/item/clothing/under/shorts/black

/datum/loadout_item/under/miscellaneous/blue_short
	name = "Blue Shorts"
	item_path = /obj/item/clothing/under/shorts/blue

/datum/loadout_item/under/miscellaneous/green_short
	name = "Green Shorts"
	item_path = /obj/item/clothing/under/shorts/green

/datum/loadout_item/under/miscellaneous/grey_short
	name = "Grey Shorts"
	item_path = /obj/item/clothing/under/shorts/grey

/datum/loadout_item/under/miscellaneous/jeans
	name = "Jeans"
	item_path = /obj/item/clothing/under/pants/jeans

/datum/loadout_item/under/miscellaneous/khaki
	name = "Khaki Pants"
	item_path = /obj/item/clothing/under/pants/khaki

/datum/loadout_item/under/miscellaneous/jeans_musthang
	name = "Must Hang Jeans"
	item_path = /obj/item/clothing/under/pants/mustangjeans

/datum/loadout_item/under/miscellaneous/purple_short
	name = "Purple Shorts"
	item_path = /obj/item/clothing/under/shorts/purple

/datum/loadout_item/under/miscellaneous/red
	name = "Red Pants"
	item_path = /obj/item/clothing/under/pants/red

/datum/loadout_item/under/miscellaneous/red_short
	name = "Red Shorts"
	item_path = /obj/item/clothing/under/shorts/red

/datum/loadout_item/under/miscellaneous/tam
	name = "Tan Pants"
	item_path = /obj/item/clothing/under/pants/tan

/datum/loadout_item/under/miscellaneous/track
	name = "Track Pants"
	item_path = /obj/item/clothing/under/pants/track

/datum/loadout_item/under/miscellaneous/jeans_youngfolk
	name = "Young Folks Jeans"
	item_path = /obj/item/clothing/under/pants/youngfolksjeans

/datum/loadout_item/under/miscellaneous/white
	name = "White Pants"
	item_path = /obj/item/clothing/under/pants/white

/datum/loadout_item/under/miscellaneous/kilt
	name = "Kilt"
	item_path = /obj/item/clothing/under/costume/kilt

/datum/loadout_item/under/miscellaneous/gladiator
	name = "Gladiator Armor"
	item_path = /obj/item/clothing/under/costume/gladiator/loadout

/datum/loadout_item/under/miscellaneous/treasure_hunter
	name = "Treasure Hunter"
	item_path = /obj/item/clothing/under/rank/civilian/curator/treasure_hunter

/datum/loadout_item/under/miscellaneous/overalls
	name = "Overalls"
	item_path = /obj/item/clothing/under/misc/overalls

/datum/loadout_item/under/miscellaneous/pj_blue
	name = "Mailman Jumpsuit"
	item_path = /obj/item/clothing/under/misc/mailman

/datum/loadout_item/under/miscellaneous/vice_officer
	name = "Vice Officer Jumpsuit"
	item_path = /obj/item/clothing/under/misc/vice_officer

/datum/loadout_item/under/miscellaneous/soviet
	name = "Soviet Uniform"
	item_path = /obj/item/clothing/under/costume/soviet

/datum/loadout_item/under/miscellaneous/redcoat
	name = "Redcoat"
	item_path = /obj/item/clothing/under/costume/redcoat

/datum/loadout_item/under/miscellaneous/pj_red
	name = "Red PJs"
	item_path = /obj/item/clothing/under/misc/pj/red

/datum/loadout_item/under/miscellaneous/pj_blue
	name = "Blue PJs"
	item_path = /obj/item/clothing/under/misc/pj/blue
