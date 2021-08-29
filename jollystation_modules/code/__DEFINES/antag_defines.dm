/// -- Defines for antag datums and advanced antag datums. --
/// Whether the antagonist can see exploitable info on people they examine.
#define CAN_SEE_EXPOITABLE_INFO (1<<0)

/// Initial / base TC for advanced traitors.
#define ADV_TRAITOR_INITIAL_TC 8
/// Max amount of TC advanced traitors can get.
#define ADV_TRAITOR_MAX_TC 40
/// Amount of TC gained per intensity level
#define ADV_TRAITOR_TC_PER_INTENSITY 2

/// Initial / base processing points for malf AI advanced traitors.
#define ADV_TRAITOR_INITIAL_MALF_POINTS 20
/// Max amount of processing points for malf AI advanced traitors.
#define ADV_TRAITOR_MAX_MALF_POINTS 60
/// Amount of rocessing points gained per intensity level
#define ADV_TRAITOR_MALF_POINTS_PER_INTENSITY 5

/// Initial / base charges a heretic gets.
#define ADV_HERETIC_INITIAL_INFLUENCE 0
/// Max amount of influence charges for heretic advanced traitors.
#define ADV_HERETIC_MAX_INFLUENCE 5
/// This number is added onto the max influences if ascencion is given up.
#define ADV_HERETIC_NO_ASCENSION_MAX 3
/// This number is added onto the max influences if sacrificing is given up.
#define ADV_HERETIC_NO_SAC_MAX 3
/// Number of influences gained per intensity level
#define ADV_HERETIC_INFLUENCE_PER_INTENSITY 0.33

/// The initial number of points for changelings
#define ADV_CHANGELING_INITIAL_POINTS 4
/// The max number of points for changelings
#define ADV_CHANGELING_MAX_POINTS 12
/// How many points a changeling gets per intensity level
#define ADV_CHANGELING_POINTS_PER_INTENSITY 0.5
/// How much chem storage a changeling gets per genetic point
#define ADV_CHANGELING_CHEM_PER_POINTS 7.5

/// Max amount of goals an advanced traitor can add.
#define ADV_TRAITOR_MAX_GOALS 5
/// Max amount of similar objectives an advanced traitor can add.
#define ADV_TRAITOR_MAX_SIMILAR_OBJECTIVES 5

/// Max char length of goals.
#define ADV_TRAITOR_MAX_GOAL_LENGTH 250
/// Max char length of notes.
#define ADV_TRAITOR_MAX_NOTE_LENGTH 175

/// Intensity levels for advanced antags.
#define ADV_TRAITOR_INTENSITIES list( \
	"5 = Mass killings, destroying entire departments", \
	"4 = Mass sabotage (engine delamination)", \
	"3 = Assassination / Grand Theft", \
	"2 = Kidnapping / Theft", \
	"1 = Minor theft or basic antagonizing" )

/// Infiltrator uplink
#define UPLINK_INFILTRATOR (1 << 3)

/// Infiltrator antag type
#define ROLE_INFILTRATOR "Infiltrator"
