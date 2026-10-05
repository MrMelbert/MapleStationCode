///Uses the parent limb's drawcolor value.
#define ORGAN_COLOR_INHERIT (1<<0)
///Uses /organ/external/proc/override_color()'s return value
#define ORGAN_COLOR_OVERRIDE (1<<1)
///Uses the parent's haircolor
#define ORGAN_COLOR_HAIR (1<<2)

// BEGIN NON-MODULE CHANGE
// in a chain, inherit the mob's mutant color, a forced mutant color, before the true draw color
#define ORGAN_COLOR_MUTANT_OVERRIDE (1<<3)
// END NON-MODULE CHANGE

///Tail wagging
#define WAG_ABLE (1<<0)
#define WAG_WAGGING (1<<1)

/// Tail spine defines
#define SPINE_KEY_LIZARD "lizard"
