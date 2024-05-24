/// -- Module defines for all maplestation_modules files. --

/// How much flavor text gets displayed before cutting off.
#define EXAMINE_FLAVOR_MAX_DISPLAYED 65

/// Language flag for languages added via quirk
#define LANGUAGE_PREF "pref"

/// Some string files.
#define COMPANY_FILE "companies.json"
#define RESOURCE_EVENT_FILE "resource_events.json"

#define INFO_GREYSCALE "greyscale"
#define INFO_NAMED "name"
#define INFO_RESKIN "reskin"
#define INFO_LAYER "layer"

/// Max amonut of misc / backpack items that are allowed.
#define MAX_ALLOWED_MISC_ITEMS 3

/// Used to make something not recolorable even if it's capable
#define DONT_GREYSCALE -1

/// Defines for extra info blurbs, for loadout items.
#define TOOLTIP_NO_ARMOR "This item has no armor and is entirely cosmetic."
#define TOOLTIP_NO_DAMAGE "This item has very low force and is largely cosmetic."
#define TOOLTIP_RANDOM_COLOR "This item has a random color and will change every round."

// Modular traits
/// Essentially a buffed version of TRAIT_VIRUS_RESISTANCE, but not as strong as TRAIT_VIRUS_IMMUNE.
/// Outright prevents contraction of disease, but if you do get sick, you're not immune to it.
#define TRAIT_VIRUS_CONTACT_IMMUNE "virus_contact_immune"
/// Does not harm patients when undergoing CPR
#define TRAIT_CPR_CERTIFIED "cpr_certified"

/// Defines for speech sounds
#define SOUND_NORMAL "normal"
#define SOUND_QUESTION "question"
#define SOUND_EXCLAMATION "exclamation"

/// Max loadout presets available
#define MAX_LOADOUTS 5

/// How much "caffeine points" does 1 metabolization tick (0.2u) of a "weak" drink provide
#define CAFFEINE_POINTS_WEAK 0.1

/// How much "caffeine points" does 1 metabolization tick (0.2u) of coffee provide
#define CAFFEINE_POINTS_COFFEE 0.2

/// How much "caffeine points" does 1 metabolization tick (0.2u) of energy drinks provide
#define CAFFEINE_POINTS_ENERGY 0.8 //yes i know energy drinks actually have less caffeine than coffee IRL but this is the FUTURE
