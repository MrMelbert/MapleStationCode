/// -- Text helpers. --
/// Provides a preview of [string] up to [len - 3], after which it appends "..." if it pasts the length.
/proc/TextPreview(string, len = 40)
	var/char_len = length_char(string)
	if(char_len <= len)
		if(!char_len)
			return "\[...\]"
		else
			return string
	else
		return "[copytext_char(string, 1, len - 3)]..."

/// Removes all <blah blah> tags in a string of text.
/// May result in some formatting errors, floating whitespace. Not perfect.
/proc/remove_all_tags(string)
	if(!string)
		return

	var/first_bracket = findtext(string, "<")
	var/second_bracket = findtext(string, ">")
	if(first_bracket && second_bracket)
		return replacetext(string, regex("<.*?>", "g"), "")
	return string

/// Scramble a string up.
/// intensity = number of times we recursively call ourselves to scramble.
/proc/scramble_text(string, intensity = 5)
	if(!string || intensity <= 0)
		return string // base case (returns null or the scrambled string)

	var/string_len = length(string)
	var/first_spot = rand(1, string_len - 1)
	var/second_spot = rand(1, string_len - 1)

	var/list/final_string = list()
	if(first_spot == second_spot)
		final_string += string
	else if(first_spot > second_spot) // our first char is later in the string than our second char
		final_string += copytext(string, 1, second_spot - 1)
		final_string += copytext(string, second_spot, second_spot + 1)
		final_string += copytext(string, second_spot + 2, first_spot - 1)
		final_string += copytext(string, first_spot, first_spot + 1)
		final_string += copytext(string, first_spot + 2, string_len)
	else
		final_string += copytext(string, 1, first_spot - 1)
		final_string += copytext(string, first_spot, first_spot + 1)
		final_string += copytext(string, first_spot + 2, second_spot - 1)
		final_string += copytext(string, second_spot, second_spot + 1)
		final_string += copytext(string, second_spot + 2, string_len)
	return scramble_text(final_string.Join(), intensity - 1)
