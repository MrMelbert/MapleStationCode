// NON-MODULE CHANGE : Values adjusted
//Bloody shoes/footprints
/// Minimum alpha of footprints
#define BLOODY_FOOTPRINT_BASE_ALPHA 20
/// How much blood a regular blood splatter contains
#define BLOOD_AMOUNT_PER_DECAL 100
/// How much blood an item can have stuck on it
#define BLOOD_ITEM_MAX 250
/// How much blood a blood decal can contain
#define BLOOD_POOL_MAX 500
/// Modifier used in math involving bloodiness, so the above values can be adjusted easily
#define BLOOD_PER_UNIT_MODIFIER 0.5
/// How much blood a footprint need to at least contain
#define BLOOD_FOOTPRINTS_MIN 5

// NON-MODULE CHANGE
// //Bloody shoe blood states
// /// Red blood
// #define BLOOD_STATE_HUMAN "blood"
// /// Green xeno blood
// #define BLOOD_STATE_XENO "xeno"
// /// Black robot oil
// #define BLOOD_STATE_OIL "oil"
// /// No blood is present
// #define BLOOD_STATE_NOT_BLOODY "no blood whatsoever"
// NON-MODULE CHANGE END

// Bitflags for mob dismemberment and gibbing
/// Mobs will drop a brain
#define DROP_BRAIN (1<<0)
/// Mobs will drop organs
#define DROP_ORGANS (1<<1)
/// Mobs will drop bodyparts (arms, legs, etc.)
#define DROP_BODYPARTS (1<<2)
/// Mobs will drop items
#define DROP_ITEMS (1<<3)

/// Mobs will drop everything
#define DROP_ALL_REMAINS (DROP_BRAIN | DROP_ORGANS | DROP_BODYPARTS | DROP_ITEMS)
