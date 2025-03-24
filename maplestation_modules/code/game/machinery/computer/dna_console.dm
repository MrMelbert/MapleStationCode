/obj/item/chromosome
	weight = 50

/obj/item/chromosome/stabilizer
	weight = 10

/generate_chromosome()
	var/static/list/chromosomes
	if(!chromosomes)
		chromosomes = list()
		for(var/chromeindex in subtypesof(/obj/item/chromosome))
			var/obj/item/chromosome/chrome = chromeindex
			if(!initial(chrome.weight))
				break
			chromosomes[chromeindex] = initial(chrome.weight)
	var/obj/item/chromosome/newchrome = pick_weight(chromosomes)
	// Pity chance
	if(!ispath(newchrome, /obj/item/chromosome/stabilizer))
		chromosomes[/obj/item/chromosome/stabilizer] += 5
	else
		chromosomes[/obj/item/chromosome/stabilizer] = 10
	return newchrome
