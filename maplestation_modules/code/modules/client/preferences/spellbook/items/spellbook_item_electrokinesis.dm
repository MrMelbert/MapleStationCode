GLOBAL_LIST_INIT(spellbook_electrokinesis_items, generate_spellbook_items(SPELLBOOK_CATEGORY_ELECTROKINESIS))

/datum/spellbook_item/spell/shock_touch
	name = "Shocking Grasp"
	description = "Empower your hand to deliver a shock to your target. \
		While the zap is not powerful enough to stun or kill, it will cause them to drop their held items - or restart a stopped heart."
	lore = "A spell which has gained notoriety for its utility in the medical field. \
		Many wizards have found use in it, to jolt a patient out of a coma, or to restart a heart which has stopped beating. \
		However, it is also a favorite of clowns, who use it as a less-obvious joybuzzer.\n\n\
		Oddly, some Geneticists have found latent genes in their test subjects which allow them to use a similar ability, \
		without the need for learning any magic or using any mana. It has yet to be determined if humanoidkind has an innate, untapped ability \
		to manipulate electricity that this spell and the genetic ability are tapping into, or if it is simply a coincidence."

	category = SPELLBOOK_CATEGORY_ELECTROKINESIS

	our_action_typepath = /datum/action/cooldown/spell/touch/shock/magical
