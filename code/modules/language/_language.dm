/// maximum of 50 specific scrambled lines per language
#define SCRAMBLE_CACHE_LEN 50

/// Datum based languages. Easily editable and modular.
/datum/language
	/// Fluff name of language if any.
	var/name = "an unknown language"
	/// Short description for 'Check Languages'.
	var/desc = "A language."
	/// Character used to speak in language
	/// If key is null, then the language isn't real or learnable.
	var/key
	/// Various language flags.
	var/flags = NONE
	/// Used when scrambling text for a non-speaker.
	var/list/syllables
	/// List of characters that will randomly be inserted between syllables.
	var/list/special_characters
	/// Likelihood of making a new sentence after each syllable.
	var/sentence_chance = 5
	/// Likelihood of making a new sentence after each word.
	var/between_word_sentence_chance = 0
	/// Likelihood of getting a space in the random scramble string
	var/space_chance = 55
	/// Likelyhood of getting a space between words
	var/between_word_space_chance = 100
	/// Spans to apply from this language
	var/list/spans
	/// Cache of recently scrambled text
	/// This allows commonly reused words to not require a full re-scramble every time.
	var/list/scramble_cache = list()
	/// The 1000 most common words get permanently cached
	var/list/most_common_cache = list()

	/// The language that an atom knows with the highest "default_priority" is selected by default.
	var/default_priority = 0
	/// If TRUE, when generating names, we will always use the default human namelist, even if we have syllables set.
	/// This is to be used for languages with very outlandish syllable lists (like pirates).
	var/always_use_default_namelist = FALSE
	/// Icon displayed in the chat window when speaking this language.
	/// if you are seeing someone speak popcorn language, then something is wrong.
	var/icon = 'icons/misc/language.dmi'
	/// Icon state displayed in the chat window when speaking this language.
	var/icon_state = "popcorn"

	/// By default, random names picks this many names
	var/default_name_count = 2
	/// By default, random names picks this many syllables (min)
	var/default_name_syllable_min = 2
	/// By default, random names picks this many syllables (max)
	var/default_name_syllable_max = 4
	/// What char to place in between randomly generated names
	var/random_name_spacer = " "

	/// Assoc Lazylist of other language types that would have a degree of mutual understanding with this language.
	/// For example, you could do `list(/datum/language/common = 50)` to say that this language has a 50% chance to understand common words
	/// And yeah if you give a 100% chance, they can basically just understand the language
	var/list/mutual_understanding

/// Checks whether we should display the language icon to the passed hearer.
/datum/language/proc/display_icon(atom/movable/hearer)
	var/understands = hearer.has_language(src.type)
	if((flags & LANGUAGE_HIDE_ICON_IF_UNDERSTOOD) && understands)
		return FALSE
	if((flags & LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD) && !understands)
		return FALSE
	return TRUE

/// Returns the icon to display in the chat window when speaking this language.
/datum/language/proc/get_icon()
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/chat)
	return sheet.icon_tag("language-[icon_state]")

/// Simple helper for getting a default firstname lastname
/datum/language/proc/default_name(gender = NEUTER)
	if(gender != MALE)
		gender = pick(MALE, FEMALE)
	if(gender == FEMALE)
		return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))


/**
 * Generates a random name this language would use.
 *
 * * gender: What gender to generate from, if neuter / plural coin flips between male and female
 * * name_count: How many names to generate in, by default 2, for firstname lastname
 * * syllable_count: How many syllables to generate in each name, min
 * * syllable_max: How many syllables to generate in each name, max
 * * force_use_syllables: If the name should be generated from the syllables list.
 * Only used for subtypes which implement custom name lists. Also requires the language has syllables set.
 */
/datum/language/proc/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(gender != MALE)
		gender = pick(MALE, FEMALE)
	if(!length(syllables) || always_use_default_namelist)
		return default_name(gender)

	var/list/full_name = list()
	for(var/i in 1 to name_count)
		var/new_name = ""
		for(var/j in 1 to rand(default_name_syllable_min, default_name_syllable_max))
			new_name += pick_weight_recursive(syllables)
		full_name += capitalize(lowertext(new_name))

	return jointext(full_name, random_name_spacer)

/// Generates a random name, and attempts to ensure it is unique (IE, no other mob in the world has it)
/datum/language/proc/get_random_unique_name(...)
	var/result = get_random_name(arglist(args))
	for(var/i in 1 to 10)
		if(!findname(result))
			break
		result = get_random_name(arglist(args))

	return result

/// Handles caching words for scrambling, so recently used or very common words don't need to be re-scrambled.
/datum/language/proc/check_cache(input)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(most_common_cache[input])
		return most_common_cache[input]

	. = scramble_cache[input]
	if(.)
		scramble_cache -= input
		scramble_cache[input] = .
	return .

/// Adds a word to the cache
/datum/language/proc/add_to_cache(input, scrambled_text)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(GLOB.most_common_words[lowertext(input)])
		most_common_cache[input] = scrambled_text
		return
	// Add it to cache, cutting old entries if the list is too long
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len - SCRAMBLE_CACHE_LEN - 1)

/// Scrambles a sentence in this language.
/// Takes into account any languages the hearer knows that has mutual understanding with this language.
/datum/language/proc/scramble_sentence(input, list/mutual_languages = list())
	var/list/real_words = splittext(input, " ")
	var/list/scrambled_words = list()
	for(var/word in real_words)
		var/base_word = lowertext(word)
		var/base_prob = mutual_languages[type] || 0
		// the probability of managing to understand a word is based on how common it is
		// words not in the most common word list are automatically assumed to be the least common word
		var/commonness = (GLOB.most_common_words[base_word] || 1000)
		var/final_prob = base_prob + (base_prob * 0.2 * (1 - (min(commonness, 1000) / 500)))
		scrambled_words += prob(final_prob) ? base_word : scramble_word(word)

	// start building the word. first word is capitalized and otherwise untouched
	. = capitalize(popleft(scrambled_words))
	for(var/word in scrambled_words)
		if(prob(between_word_sentence_chance))
			. += ". "
			word = capitalize(word)
		else if(prob(between_word_space_chance))
			. += " "

		. += word

	// scrambling the words will drop punctuation, so re-add it at the end
	var/input_ending_two = copytext_char(input, -2)
	var/input_ending_one = copytext_char(input, -1)
	if(input_ending_two in list("!!", "??", "..", "?!", "!?"))
		. += input_ending_two

	else if(input_ending_one in list("!", "?" ,".", "~", ";", ":", "-"))
		. += input_ending_one

	return .

/// Scrambles a single word in this language.
/datum/language/proc/scramble_word(input)
	// If the input is cached already, move it to the end of the cache and return it
	. = check_cache(input)
	if(.)
		return .

	if(!length(syllables))
		. = stars(input)

	else
		var/input_size = length_char(input)
		var/add_space = FALSE
		var/add_period = FALSE
		. = ""
		while(length_char(.) < input_size)
			// add in the last syllable's period or space first
			if(add_period)
				. += ". "
			else if(add_space)
				. += " "
			// generate the next syllable (capitalize if we just added a period)
			var/next = (. && length(special_characters) && prob(1)) ? pick(special_characters) : pick_weight_recursive(syllables)
			if(add_period)
				next = capitalize(next)
			. += next
			// determine if the next syllable gets a period or space
			add_period = prob(sentence_chance)
			add_space = prob(space_chance)

	add_to_cache(input, .)

	return .

#undef SCRAMBLE_CACHE_LEN
