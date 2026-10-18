// Used to stringify message targets before sending the signal datum.
#define STRINGIFY_PDA_TARGET(name, job) "[name] ([job])"

//N-spect scanner defines
#define INSPECTOR_PRINT_SOUND_MODE_NORMAL 1
#define INSPECTOR_PRINT_SOUND_MODE_CLASSIC 2
#define INSPECTOR_PRINT_SOUND_MODE_HONK 3
#define INSPECTOR_PRINT_SOUND_MODE_FAFAFOGGY 4
#define BANANIUM_CLOWN_INSPECTOR_PRINT_SOUND_MODE_LAST 4
#define CLOWN_INSPECTOR_PRINT_SOUND_MODE_LAST 4
#define INSPECTOR_ENERGY_USAGE_HONK (0.015 * STANDARD_CELL_CHARGE)
#define INSPECTOR_ENERGY_USAGE_NORMAL (0.005 * STANDARD_CELL_CHARGE)
#define INSPECTOR_TIME_MODE_SLOW 1
#define INSPECTOR_TIME_MODE_FAST 2
#define INSPECTOR_TIME_MODE_HONK 3

// Health analyzer stuff
// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more
#define SCANNER_CONDENSED 0
#define SCANNER_VERBOSE 1
// Not updating above count because you're not meant to switch to this mode.
#define SCANNER_NO_MODE -1
