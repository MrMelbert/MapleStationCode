/datum/skill/botany
	name = "Botany"
	title = "Botanist"
	blurb = "We grow or we die."
	earned_by = "growing plants"
	higher_levels_grant_you = "guaranteed seed samples from plants with zero yield \
		and safety around bees without a suit"

/datum/skill/botany/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("After lots of practice, I've begun to truly understand the intricacies and surprising depth behind [name]. \
		I now consider myself a master [title], and can guarantee a seed sample from plants, even with zero yield.")
	level_up_messages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("Through incredible determination and effort, I've reached the peak of my [name] abiltities. \
		I'm finally able to consider myself a legendary [title], and can now safely handle bees without a suit!")

	level_down_messages[SKILL_LEVEL_MASTER] = span_nicegreen("I'm losing my [name] expertise... I can no longer guarantee seed samples from plants with zero yield.")
	level_down_messages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("I feel as though my legendary [name] skills have deteriorated. I can no longer safely handle bees without a suit.")
