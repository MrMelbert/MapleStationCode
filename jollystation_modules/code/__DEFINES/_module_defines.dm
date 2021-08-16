/// -- Module defines for all jollystation_modules files. --

/// How much flavor text gets displayed before cutting off.
#define EXAMINE_FLAVOR_MAX_DISPLAYED 65

/// Language flag for languages added via quirk
#define LANGUAGE_QUIRK "quirk"

/// Defines for what loadout slot a corresponding item belongs to.
#define LOADOUT_ITEM_BELT "belt"
#define LOADOUT_ITEM_EARS "ears"
#define LOADOUT_ITEM_GLASSES "glasses"
#define LOADOUT_ITEM_GLOVES "gloves"
#define LOADOUT_ITEM_HEAD "head"
#define LOADOUT_ITEM_MASK "mask"
#define LOADOUT_ITEM_NECK "neck"
#define LOADOUT_ITEM_SHOES "shoes"
#define LOADOUT_ITEM_SUIT "suit"
#define LOADOUT_ITEM_UNIFORM "under"
#define LOADOUT_ITEM_INHAND "inhand_items" //Divides into the two below slots
#define LOADOUT_ITEM_LEFT_HAND "inhand_items_left"
#define LOADOUT_ITEM_RIGHT_HAND "inhand_items_right"
#define LOADOUT_ITEM_MISC "pocket_items" //Divides into the three below slots
#define LOADOUT_ITEM_BACKPACK_1 "pocket_items_1"
#define LOADOUT_ITEM_BACKPACK_2 "pocket_items_2"
#define LOADOUT_ITEM_BACKPACK_3 "pocket_items_3"

/// Global list of all loadout slots.
GLOBAL_LIST_INIT(loadout_slots, list(
	LOADOUT_ITEM_BELT,
	LOADOUT_ITEM_EARS,
	LOADOUT_ITEM_GLASSES,
	LOADOUT_ITEM_GLOVES,
	LOADOUT_ITEM_HEAD,
	LOADOUT_ITEM_MASK,
	LOADOUT_ITEM_NECK,
	LOADOUT_ITEM_SHOES,
	LOADOUT_ITEM_SUIT,
	LOADOUT_ITEM_UNIFORM,
	LOADOUT_ITEM_LEFT_HAND,
	LOADOUT_ITEM_RIGHT_HAND,
	LOADOUT_ITEM_BACKPACK_1,
	LOADOUT_ITEM_BACKPACK_2,
	LOADOUT_ITEM_BACKPACK_3,
))

/// Defines for extra info blurbs, for loadout items.
#define TOOLTIP_NO_ARMOR "This item has no armor and is entirely cosmetic."
#define TOOLTIP_NO_DAMAGE "This item has very low force and is cosmetic."
#define TOOLTIP_RANDOM_COLOR "This item has a random color and will change every round."
#define TOOLTIP_ACCESSORY "This item is an accessory, and will attempt to be attached to your jumpsuit on spawn."
#define TOOLTIP_BACKPACK_ITEM "This item is a pocket item, and will be added to your backpack on spawn."
#define TOOLTIP_PLASMAMAN_IMPORTANT "This item occupies a slot important for Plasmaman survival, and will not be equipped onto Plasmamen automatically."
#define TOOLTIP_SLOT_IMPORTANT "This item occupies a slot important for job equipment - any items that occupy that slot will be moved to your backpack automatically."
#define TOOLTIP_GREYSCALE "This item can be customized via the greyscale modification UI."

/// Modular traits
#define TRAIT_DISEASE_RESISTANT "disease_resistant"
