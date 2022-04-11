// -- Modular spans and fonts.
#define span_message(str) ("<span class='message'>" + str + "</span>")
#define span_italics(str) ("<span class='italics'>" + str + "</span>")
#define span_readable_yellow(str) ("<font color = '#c5c900'>" + str + "</font>")

/// The color of brass
#define BRASS_COLOR "#BE8700"
/// The color of alloys
#define ALLOY_COLOR "#42474D"

// Clock cult spans
#define span_brass(str) ("<font color = [BRASS_COLOR]>" + str + "</font>")
#define span_brasstalics(str) ("<i><font color = [BRASS_COLOR]>" + str + "</font></i>")
#define span_large_brass(str) ("<font size = '185%' color = [BRASS_COLOR]>" + str + "</font>")
#define span_heavy_brass(str) ("<font color = [BRASS_COLOR]><b><i>" + str + "</i></b></font>")
#define span_alloy(str) ("<font color = [ALLOY_COLOR]>" + str + "</font>")
#define span_large_alloy(str) ("<font size = '185%' color = [ALLOY_COLOR]>" + str + "</font>")
#define span_heavy_alloy(str) ("<font color = [ALLOY_COLOR]><b><i>" + str + "</i></b></font>")
//ratvar: color: #BE8700; font-size: 370%; font-weight: bold; font-style: italic;

// Simple macro for a bold text that says 'examine closer'
#define EXAMINE_CLOSER_BOLD span_bold("examine closer")

/// The color for LOOC chat.
#define LOOC_SPAN_COLOR "#00a8c5"
/// The color the prefix for LOOC uses.
#define LOOC_PREFIX_COLOR "#5f008b"
