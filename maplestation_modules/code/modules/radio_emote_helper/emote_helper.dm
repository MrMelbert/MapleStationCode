/mob/verb/how_do_i_radio_emote
	set name = "Radio Emote Help"
	set category = "IC"

	var/header = {"<span class='boldannounce'>
How do I emote on radio?
</span>"}

	var/text = {"<span class='info'>
You can do a custom radio emote by the following:

;\[Your emote here\]*
.h\[Your emote here\]*
;coughs awkwardly.*

This will send just your emote over the radio channel you specify.
It won't include punctuation, so be sure to add one on your own.

You can also use this to create a custom \"say emote\" (that is, what your message follows - normally, it's \"says\")

;\[Your emote here\]*\[Your text here\]
.h\[Your emote here\]*\[Your text here\]
;sputters awkwardly while fiddling with their mic*What the hell?

It will automatically insert a comma for you, so you don't need to worry about that.
</span>"}

	to_chat(usr, examine_block("[header][text]"))
