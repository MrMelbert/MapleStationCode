/proc/get_raw_mana_of_pools(list/datum/mana_pool/mana_pools)
	for (var/datum/mana_pool/pool as anything in mana_pools)
		. += pool.amount

/proc/get_total_attunements_of_pools(list/datum/mana_pool/mana_pools)
	. = list()
	for (var/datum/mana_pool/pool as anything in mana_pools)
		for (var/datum/attunement/iterated_attunement in pool.attunements)
			.[iterated_attunement] += pool.attunements[iterated_attunement]
