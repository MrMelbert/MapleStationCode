// this is the containment area for magic related chems, or changes to chems to add interactivity
/datum/reagent/consumable/ethanol/wizz_fizz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	//Its a magic drink. it regens mana, if mildly
	if(drinker?.mana_pool)
		var/datum/mana_pool/drinker_pool = drinker?.mana_pool
		if(drinker_pool.amount < drinker_pool.softcap) // only adjust when below the softcap
			drinker_pool.adjust_mana(1.5) // regen mana by 1.5 per tick, no attunement
/* TODOS: make drinks/chems for this
* Telepole & Pod Tesla regen mana if electrically attuned/or it has an electric attunement (me when the charge build)
* Sea Breeze (lizard drink) & Tropical Storm (mothic drink) mildly regens mana if water attuned
*/
