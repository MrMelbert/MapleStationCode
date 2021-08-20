/// -- Defines for antag datums and advanced antag datums. --
/// Whether the antagonist can see exploitable info on people they examine.
#define CAN_SEE_EXPOITABLE_INFO (1<<0)

/// Initial / base TC for advanced traitors.
#define TRAITOR_PLUS_INITIAL_TC 8
/// Max amount of TC advanced traitors can get.
#define TRAITOR_PLUS_MAX_TC 40

/// Initial / base processing points for malf AI advanced traitors.
#define TRAITOR_PLUS_INITIAL_MALF_POINTS 20
/// Max amount of processing points for malf AI advanced traitors.
#define TRAITOR_PLUS_MAX_MALF_POINTS 60

/// Initial / base charges a heretic gets.
#define HERETIC_PLUS_INITIAL_INFLUENCE 0
/// Max amount of influence charges for heretic advanced traitors.
#define HERETIC_PLUS_MAX_INFLUENCE 5
/// This number is added onto the max influences if ascencion is given up.
#define HERETIC_PLUS_NO_ASCENSION_MAX 3
/// This number is added onto the max influences if sacrificing is given up.
#define HERETIC_PLUS_NO_SAC_MAX 3

/// Max amount of goals an advanced traitor can add.
#define TRAITOR_PLUS_MAX_GOALS 5
/// Max amount of similar objectives an advanced traitor can add.
#define TRAITOR_PLUS_MAX_SIMILAR_OBJECTIVES 5

/// Max char length of goals.
#define TRAITOR_PLUS_MAX_GOAL_LENGTH 250
/// Max char length of notes.
#define TRAITOR_PLUS_MAX_NOTE_LENGTH 175

/// Intensity levels for advanced antags.
#define TRAITOR_PLUS_INTENSITIES list( \
	"5 = Mass killings, destroying entire departments", \
	"4 = Mass sabotage (engine delamination)", \
	"3 = Assassination / Grand Theft", \
	"2 = Kidnapping / Theft", \
	"1 = Minor theft or basic antagonizing" )

/// Infiltrator uplink
#define UPLINK_INFILTRATOR (1 << 3)

/// Infiltrator antag type
#define ROLE_INFILTRATOR "Infiltrator"
