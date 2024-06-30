## THIS FOLDER IS TEMPORARY

This is a folder of sprites & code taken from the modern upstream of tgstation, meaning that when we next upstream, this can be safely deleted with little to no issue.

If you add to this folder, be SURE everything you add does not touch the base code at ALL.
If it NEEDS TO, then WRITE DOWN WHERE IT DOES BELOW


### LIST OF PLACES WE TOUCH MAIN CODE:

- FILE - PROC/TYPE
- code\modules\reagents\chemistry\reagents.dm - /datum/reagent/proc/get_taste_description(mob/living/taster)
- code\__DEFINES\traits\declarations.dm - TRAIT_DETECTIVES_TASTE
