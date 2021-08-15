/// -- A ton of global lists that hold singletons of all loadout items. --
/proc/generate_loadout_items(type_to_generate)
	. = list()
	if(!ispath(type_to_generate))
		CRASH("generate_loadout_items(): called with an invalid or null path as an argument!")

	for(var/found_item in subtypesof(type_to_generate))
		var/datum/loadout_item/item = new found_item()
		if(!istype(item))
			stack_trace("generate_loadout_items(): Instantiated a loadout item ([item]) that isn't of type /datum/loadout_item! (got type: [item.type])")
			qdel(item)
			continue

		if(!ispath(item.item_path))
			stack_trace("generate_loadout_items(): Instantiated a loadout item ([item.name]) with an invalid or null typepath! (got path: [item.item_path])")
			qdel(item)
			continue

		.[found_item] = item

/// Mask Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_masks, list(
	"Balaclava" = /obj/item/clothing/mask/balaclava,
	"Gas Mask" = /obj/item/clothing/mask/gas,
	"Black Bandana" = /obj/item/clothing/mask/bandana/black,
	"Blue Bandana" = /obj/item/clothing/mask/bandana/blue,
	"Gold Bandana" = /obj/item/clothing/mask/bandana/gold,
	"Green Bandana" = /obj/item/clothing/mask/bandana/green,
	"Red Bandana" = /obj/item/clothing/mask/bandana/red,
	"Skull Bandana" = /obj/item/clothing/mask/bandana/skull,
	"Face Mask" = /obj/item/clothing/mask/surgical,
	"Fake Moustache" = /obj/item/clothing/mask/fakemoustache,
	"Pipe" = /obj/item/clothing/mask/cigarette/pipe,
	"Corn Cob Pipe" = /obj/item/clothing/mask/cigarette/pipe/cobpipe,
	"Plague Doctor Mask" = /obj/item/clothing/mask/gas/plaguedoctor,
	"Joy Mask" = /obj/item/clothing/mask/joy,
	"Lollipop" = /obj/item/food/lollipop,
	//"Gum" = /obj/item/food/bubblegum,
))

/// Neck Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_necks, list(
	"Black Scarf" = /obj/item/clothing/neck/scarf/black,
	"Christmas Scarf" = /obj/item/clothing/neck/scarf/christmas,
	"Cyan Scarf" = /obj/item/clothing/neck/scarf/cyan,
	"Darkblue Scarf" = /obj/item/clothing/neck/scarf/darkblue,
	"Green Scarf" = /obj/item/clothing/neck/scarf/green,
	"Pink Scarf" = /obj/item/clothing/neck/scarf/pink,
	"Purple Scarf" = /obj/item/clothing/neck/scarf/purple,
	"Red Scarf" = /obj/item/clothing/neck/scarf/red,
	"Striped Blue Scarf" = /obj/item/clothing/neck/stripedbluescarf,
	"Striped Green Scarf" = /obj/item/clothing/neck/stripedgreenscarf,
	"Striped Red Scarf" = /obj/item/clothing/neck/stripedredscarf,
	"Orange Scarf" = /obj/item/clothing/neck/scarf/orange,
	"Yellow Scarf" = /obj/item/clothing/neck/scarf/yellow,
	"White Scarf" = /obj/item/clothing/neck/scarf,
	"Zebra Scarf" = /obj/item/clothing/neck/scarf/zebra,
	"Black Necktie" = /obj/item/clothing/neck/tie/black,
	"Blue Necktie" = /obj/item/clothing/neck/tie/blue,
	"Horrific Necktie" = /obj/item/clothing/neck/tie/horrible,
	"Loose Necktie" = /obj/item/clothing/neck/tie/detective,
	"Red Necktie" = /obj/item/clothing/neck/tie/red,
	"Stethoscope" = /obj/item/clothing/neck/stethoscope,
))

/// Shoe Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_shoes, list(
	"Jackboots" = /obj/item/clothing/shoes/jackboots/loadout,
	"Winter Boots" = /obj/item/clothing/shoes/winterboots,
	"Work Boots" = /obj/item/clothing/shoes/workboots,
	"Mining Boots" = /obj/item/clothing/shoes/workboots/mining,
	"Laceup Shoes" = /obj/item/clothing/shoes/laceup,
	"Russian Boots" = /obj/item/clothing/shoes/russian,
	"Black Cowboy Boots" = /obj/item/clothing/shoes/cowboy/black,
	"Brown Cowboy Boots" = /obj/item/clothing/shoes/cowboy,
	"White Cowboy Boots" = /obj/item/clothing/shoes/cowboy/white,
	"Greyscale Sneakers_[GREYSCALE]" = /obj/item/clothing/shoes/sneakers/greyscale,
	"Black Sneakers" = /obj/item/clothing/shoes/sneakers/black,
	"Blue Sneakers" = /obj/item/clothing/shoes/sneakers/blue,
	"Brown Sneakers" = /obj/item/clothing/shoes/sneakers/brown,
	"Green Sneakers" = /obj/item/clothing/shoes/sneakers/green,
	"Purple Sneakers" = /obj/item/clothing/shoes/sneakers/purple,
	"Orange Sneakers" = /obj/item/clothing/shoes/sneakers/orange,
	"Rainbow Sneakers" = /obj/item/clothing/shoes/sneakers/rainbow,
	"Yellow Sneakers" = /obj/item/clothing/shoes/sneakers/yellow,
	"White Sneakers" = /obj/item/clothing/shoes/sneakers/white,
	"Sandals" = /obj/item/clothing/shoes/sandal,
))

/// Exosuit / Outersuit Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_exosuits, list(
	"Winter Coat" = /obj/item/clothing/suit/hooded/wintercoat,
	"Greyscale Winter Coat_[GREYSCALE]" = /obj/item/clothing/suit/hooded/wintercoat/custom,
	"Black Suit Jacket" = /obj/item/clothing/suit/toggle/lawyer/black,
	"Blue Suit Jacket" = /obj/item/clothing/suit/toggle/lawyer,
	"Denim Overalls" = /obj/item/clothing/suit/apron/overalls,
	"Purple Suit Jacket" = /obj/item/clothing/suit/toggle/lawyer/purple,
	"Purple Apron" = /obj/item/clothing/suit/apron/purple_bartender,
	"Greyscale Suspenders_[GREYSCALE]" = /obj/item/clothing/suit/toggle/suspenders/greyscale,
	"Blue Suspenders" = /obj/item/clothing/suit/toggle/suspenders/blue,
	"Grey Suspenders" = /obj/item/clothing/suit/toggle/suspenders/gray,
	"Red Suspenders" = /obj/item/clothing/suit/toggle/suspenders,
	"White Dress" = /obj/item/clothing/suit/whitedress,
	"Labcoat" = /obj/item/clothing/suit/toggle/labcoat,
	"Green Labcoat" = /obj/item/clothing/suit/toggle/labcoat/mad,
	"Goliath Cloak_[NO_ARMOR]" = /obj/item/clothing/suit/hooded/cloak/goliath_heirloom,
	"Poncho" = /obj/item/clothing/suit/poncho,
	"Green Poncho" = /obj/item/clothing/suit/poncho/green,
	"Red Poncho" = /obj/item/clothing/suit/poncho/red,
	"Hawaiian Shirt" = /obj/item/clothing/suit/hawaiian,
	"Bomber Jacket" = /obj/item/clothing/suit/jacket,
	"Military Jacket" = /obj/item/clothing/suit/jacket/miljacket,
	"Puffer Jacket" = /obj/item/clothing/suit/jacket/puffer,
	"Puffer Vest" = /obj/item/clothing/suit/jacket/puffer/vest,
	"Leather Jacket" = /obj/item/clothing/suit/jacket/leather,
	"Leather Coat" = /obj/item/clothing/suit/jacket/leather/overcoat,
	"Brown Letterman" = /obj/item/clothing/suit/jacket/letterman,
	"Red Letterman" = /obj/item/clothing/suit/jacket/letterman_red,
	"Blue Letterman" = /obj/item/clothing/suit/jacket/letterman_nanotrasen,
	"Bee Outfit" = /obj/item/clothing/suit/hooded/bee_costume,
	"Plague Doctor Suit" = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
))

/// Underslot - Jumpsuit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_jumpsuits, list(
	"Greyscale Jumpsuit_[GREYSCALE]" = /obj/item/clothing/under/color/greyscale,
	"Greyscale Jumpskirt_[GREYSCALE]" = /obj/item/clothing/under/color/jumpskirt/greyscale,
	"Random Jumpsuit_[RANDOM_COLOR]" = /obj/item/clothing/under/color/random,
	"Random Jumpskirt_[RANDOM_COLOR]" = /obj/item/clothing/under/color/jumpskirt/random,
	"Black Jumpsuit" = /obj/item/clothing/under/color/black,
	"Black Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/black,
	"Blue Jumpsuit" = /obj/item/clothing/under/color/blue,
	"Blue Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/blue,
	"Brown Jumpsuit" = /obj/item/clothing/under/color/brown,
	"Brown Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/brown,
	"Dark Blue Jumpsuit" = /obj/item/clothing/under/color/darkblue,
	"Dark Blue Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/darkblue,
	"Dark Green Jumpsuit" = /obj/item/clothing/under/color/darkgreen,
	"Dark Green Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/darkgreen,
	"Green Jumpsuit" = /obj/item/clothing/under/color/green,
	"Green Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/green,
	"Grey Jumpsuit" = /obj/item/clothing/under/color/grey,
	"Grey Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/grey,
	"Light Brown Jumpsuit" = /obj/item/clothing/under/color/lightbrown,
	"Light Brown Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/lightbrown,
	"Light Purple Jumpsuit" = /obj/item/clothing/under/color/lightpurple,
	"Light Purple Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/lightpurple,
	"Maroon Jumpsuit" = /obj/item/clothing/under/color/maroon,
	"Maroon Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/maroon,
	"Orange Jumpsuit" = /obj/item/clothing/under/color/orange,
	"Orange Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/orange,
	"Pink Jumpsuit" = /obj/item/clothing/under/color/pink,
	"Pink Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/pink,
	"Rainbow Jumpsuit" = /obj/item/clothing/under/color/rainbow,
	"Rainbow Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/rainbow,
	"Red Jumpsuit" = /obj/item/clothing/under/color/red,
	"Red Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/red,
	"Teal Jumpsuit" = /obj/item/clothing/under/color/teal,
	"Teal Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/teal,
	"Yellow Jumpsuit" = /obj/item/clothing/under/color/yellow,
	"Yellow Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/yellow,
	"White Jumpsuit" = /obj/item/clothing/under/color/white,
	"White Jumpskirt" = /obj/item/clothing/under/color/jumpskirt/white,
))

/// Underslot - Formal Suit Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_undersuits, list(
	"Amish Suit" = /obj/item/clothing/under/suit/sl,
	"Assistant Formal" = /obj/item/clothing/under/misc/assistantformal,
	"Beige Suit" = /obj/item/clothing/under/suit/beige,
	"Black Suit" = /obj/item/clothing/under/suit/black,
	"Black Suitskirt" = /obj/item/clothing/under/suit/black/skirt,
	"Black Tango Dress" = /obj/item/clothing/under/dress/blacktango,
	"Black Two-Piece Suit" = /obj/item/clothing/under/suit/blacktwopiece,
	"Black Skirt" = /obj/item/clothing/under/dress/skirt,
	"Black Lawyer Suit" = /obj/item/clothing/under/rank/civilian/lawyer/black,
	"Black Lawyer Suitskirt" = /obj/item/clothing/under/rank/civilian/lawyer/black/skirt,
	"Blue Suit" = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
	"Blue Suitskirt" = /obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt,
	"Blue Lawyer Suit" = /obj/item/clothing/under/rank/civilian/lawyer/blue,
	"Blue Lawyer Suitskirt" = /obj/item/clothing/under/rank/civilian/lawyer/blue/skirt,
	"Blue Skirt" = /obj/item/clothing/under/dress/skirt/blue,
	"Blue Plaid Skirt" = /obj/item/clothing/under/dress/skirt/plaid/blue,
	"Burgundy Suit" = /obj/item/clothing/under/suit/burgundy,
	"Charcoal Suit" = /obj/item/clothing/under/suit/charcoal,
	"Checkered Suit" = /obj/item/clothing/under/suit/checkered,
	"Executive Suit" = /obj/item/clothing/under/suit/black_really,
	"Executive Suitskirt" = /obj/item/clothing/under/suit/black_really/skirt,
	"Executive Suit Alt" = /obj/item/clothing/under/rank/civilian/lawyer/female,
	"Executive Suitskirt Alt" = /obj/item/clothing/under/rank/civilian/lawyer/female/skirt,
	"Green Suit" = /obj/item/clothing/under/suit/green,
	"Green Plaid Skirt" = /obj/item/clothing/under/dress/skirt/plaid/green,
	"Navy Suit" = /obj/item/clothing/under/suit/navy,
	"Maid Outfit" = /obj/item/clothing/under/costume/maid,
	"Maid Uniform" = /obj/item/clothing/under/rank/civilian/janitor/maid,
	"Purple Suit" = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
	"Purple Suitskirt" = /obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt,
	"Purple Skirt" = /obj/item/clothing/under/dress/skirt/purple,
	"Purple Plaid Skirt" = /obj/item/clothing/under/dress/skirt/plaid/purple,
	"Red Suit" = /obj/item/clothing/under/suit/red,
	"Red Lawyer Suit" = /obj/item/clothing/under/rank/civilian/lawyer/red,
	"Red Lawyer Suitskirt" = /obj/item/clothing/under/rank/civilian/lawyer/red/skirt,
	"Red Evening Gown" = /obj/item/clothing/under/dress/redeveninggown,
	"Red Skirt" = /obj/item/clothing/under/dress/skirt/red,
	"Red Plaid Skirt" = /obj/item/clothing/under/dress/skirt/plaid,
	"Sailor Suit" = /obj/item/clothing/under/costume/sailor,
	"Sailor Dress" = /obj/item/clothing/under/dress/sailor,
	"Scratch Suit" = /obj/item/clothing/under/suit/white_on_white,
	"Striped Dress" = /obj/item/clothing/under/dress/striped,
	"Sensible Suit" = /obj/item/clothing/under/rank/civilian/curator,
	"Sensible Suitskirt" = /obj/item/clothing/under/rank/civilian/curator/skirt,
	"Sundress" = /obj/item/clothing/under/dress/sundress,
	"Tan Suit" = /obj/item/clothing/under/suit/tan,
	"Teal Suit" = /obj/item/clothing/under/suit/teal,
	"Teal Suitskirt" = /obj/item/clothing/under/suit/teal/skirt,
	"Tuxedo Suit" = /obj/item/clothing/under/suit/tuxedo,
	"Waiter's Suit" = /obj/item/clothing/under/suit/waiter,
	"Wedding Dress" = /obj/item/clothing/under/dress/wedding_dress,
	"White Suit" = /obj/item/clothing/under/suit/white,
	"White Suitskirt" = /obj/item/clothing/under/suit/white/skirt,
))

/// Underslot - Misc. Under Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_miscunders, list(
	"Camo Pants" = /obj/item/clothing/under/pants/camo,
	"Classic Jeans" = /obj/item/clothing/under/pants/classicjeans,
	"Black Jeans" = /obj/item/clothing/under/pants/blackjeans,
	"Black Pants" = /obj/item/clothing/under/pants/black,
	"Black Shorts" = /obj/item/clothing/under/shorts/black,
	"Blue Shorts" = /obj/item/clothing/under/shorts/blue,
	"Green Shorts" = /obj/item/clothing/under/shorts/green,
	"Grey Shorts" = /obj/item/clothing/under/shorts/grey,
	"Jeans" = /obj/item/clothing/under/pants/jeans,
	"Khaki Pants" = /obj/item/clothing/under/pants/khaki,
	"Must Hang Jeans" = /obj/item/clothing/under/pants/mustangjeans,
	"Purple Shorts" = /obj/item/clothing/under/shorts/purple,
	"Red Pants" = /obj/item/clothing/under/pants/red,
	"Red Shorts" = /obj/item/clothing/under/shorts/red,
	"Tan Pants" = /obj/item/clothing/under/pants/tan,
	"Track Pants" = /obj/item/clothing/under/pants/track,
	"Young Folks Jeans" = /obj/item/clothing/under/pants/youngfolksjeans,
	"White Pants" = /obj/item/clothing/under/pants/white,
	"Kilt" = /obj/item/clothing/under/costume/kilt,
	"Gladiator Armor" = /obj/item/clothing/under/costume/gladiator/loadout,
	"Treasure Hunter" = /obj/item/clothing/under/rank/civilian/curator/treasure_hunter,
	"Overalls" = /obj/item/clothing/under/misc/overalls,
))

/// Inhand Items (2 allowed, placed in hand)
GLOBAL_LIST_INIT(loadout_inhand_items, list(
	"Cane" = /obj/item/cane,
	"Briefcase" = /obj/item/storage/briefcase,
	"Secure Briefcase" = /obj/item/storage/secure/briefcase,
	"Skateboard" = /obj/item/melee/skateboard,
	"Bone Spear_[NO_DAMAGE]" = /obj/item/spear/bonespear/ceremonial,
	"Mixed Bouquet" = /obj/item/bouquet,
	"Sunflower Bouquet" = /obj/item/bouquet/sunflower,
	"Poppy Bouquet" = /obj/item/bouquet/poppy,
	"Rose Bouquet" = /obj/item/bouquet/rose,
))

/// Pocket / Backpack / Accessory Slot Items (3 allowed, placed in backpack)
GLOBAL_LIST_INIT(loadout_pocket_items, list(
	"Maid Apron_[ACCESSORY]" = /obj/item/clothing/accessory/maidapron,
	"Waistcoat_[ACCESSORY]" = /obj/item/clothing/accessory/waistcoat,
	"Pocket Protector_[ACCESSORY]" = /obj/item/clothing/accessory/pocketprotector,
	"Pocket Protector (Filled)_[ACCESSORY]" = /obj/item/clothing/accessory/pocketprotector/full,
	"Ribbon_[ACCESSORY]" = /obj/item/clothing/accessory/medal/ribbon,
	"Blue and Green Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/hydro_cosmetic,
	"Brown Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/cargo_cosmetic,
	"Purple Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/science_cosmetic,
	"Red Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/deputy_cosmetic,
	"Yellow Reflective Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/engine_cosmetic,
	"White Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/med_cosmetic,
	"White and Blue Armband_[ACCESSORY]" = /obj/item/clothing/accessory/armband/medblue_cosmetic,
	"Name-Inscribed Dogtags_[SETS_NAME]_[ACCESSORY]" = /obj/item/clothing/accessory/cosmetic_dogtag,
	"Bone Talismin_[NO_ARMOR]_[ACCESSORY]" = /obj/item/clothing/accessory/armorless_talisman,
	"Skull Codpiece_[NO_ARMOR]_[ACCESSORY]" = /obj/item/clothing/accessory/armorless_skullcodpiece,
	"Pack of Gum" = /obj/item/storage/box/gum,
	"Pack of Nicotine Gum" = /obj/item/storage/box/gum/nicotine,
	"Pack of HP+ Gum" = /obj/item/storage/box/gum/happiness,
	"Black Lipstick" = /obj/item/lipstick/black,
	"Blue Lipstick" = /obj/item/lipstick/blue,
	"Green Lipstick" = /obj/item/lipstick/green,
	"Jade Lipstick" = /obj/item/lipstick/jade,
	"Purple Lipstick" = /obj/item/lipstick/purple,
	"Red Lipstick" = /obj/item/lipstick,
	"White Lipstick" = /obj/item/lipstick/white,
	"Razor" = /obj/item/razor,
	"Lighter" = /obj/item/lighter,
	"Bee Plush" = /obj/item/toy/plush/beeplushie,
	"Carp Plush" = /obj/item/toy/plush/carpplushie,
	"Greyscale Lizard Plush_[GREYSCALE]" = /obj/item/toy/plush/lizard_plushie/greyscale,
	"Random Lizard Plush_[RANDOM_COLOR]" = /obj/item/toy/plush/lizard_plushie,
	"Moth Plush" = /obj/item/toy/plush/moth,
	"Nar'sie Plush" = /obj/item/toy/plush/narplush,
	"Nukie Plush" = /obj/item/toy/plush/nukeplushie,
	"Peacekeeper Plush" = /obj/item/toy/plush/pkplush,
	"Plasmaman Plush" = /obj/item/toy/plush/plasmamanplushie,
	"Ratvar Plush" = /obj/item/toy/plush/ratplush,
	"Rouny Plush" = /obj/item/toy/plush/rouny,
	"Snake Plush" = /obj/item/toy/plush/snakeplushie,
	"Card Binder" = /obj/item/storage/card_binder,
	"Playing Card Deck" = /obj/item/toy/cards/deck,
	"Kotahi Deck" = /obj/item/toy/cards/deck/kotahi,
	"Wizoff Deck" = /obj/item/toy/cards/deck/wizoff,
	"Dice Bag" = /obj/item/storage/pill_bottle/dice,
	"D1" = /obj/item/dice/d1,
	"D2" = /obj/item/dice/d2,
	"D4" = /obj/item/dice/d4,
	"D6" = /obj/item/dice/d6,
	"D6 (Ebony)" = /obj/item/dice/d6/space,
	"D6 (Space)" = /obj/item/dice/d6/ebony,
	"D8" = /obj/item/dice/d8,
	"D10" = /obj/item/dice/d10,
	"D12" = /obj/item/dice/d12,
	"D20" = /obj/item/dice/d20,
	"D100" = /obj/item/dice/d100,
	"D00" = /obj/item/dice/d00,
))

/datum/loadout_item
	var/name
	var/is_plasmaman_important = FALSE
	var/is_important_slot = FALSE
	var/is_greyscale = TRUE
	var/category
	var/item_path
	var/list/additional_tooltip_contents

/datum/loadout_item/proc/equip_outfit_with_item(mob/living/equipper, datum/outfit/outfit, visual)
	return TRUE

/datum/loadout_item/proc/post_equip_item(mob/living/equipper)
	return TRUE
