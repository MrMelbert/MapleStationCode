//Extends Hivelord, which is also the base for Legions!

/obj/effect/mob_spawn/human/corpse/damaged/legioninfested/Initialize(mapload)
	var/type = pickweight(list("Miner" = 69, "Ashwalker" = 10, "Golem" = 10,"Clown" = 10, pick(list("Shadow", "YeOlde","Operative", "Cultist")) = 1))
	switch(type)
		if("Miner")
			mob_species = pickweight(list(/datum/species/lizard = 70, /datum/species/human = 26, /datum/species/human/felinid = 17, /datum/species/skrell = 7, /datum/species/plasmaman = 2, /datum/species/skeleton = 2))
			if(mob_species == /datum/species/plasmaman)
				uniform = /obj/item/clothing/under/plasmaman
				head = /obj/item/clothing/head/helmet/space/plasmaman
				belt = /obj/item/tank/internals/plasmaman/belt
			else
				uniform = /obj/item/clothing/under/rank/cargo/miner/lavaland
				if (prob(4))
					belt = pickweight(list(/obj/item/storage/belt/mining = 2, /obj/item/storage/belt/mining/alt = 2))
				else if(prob(10))
					belt = pickweight(list(/obj/item/pickaxe = 8, /obj/item/pickaxe/mini = 4, /obj/item/pickaxe/silver = 2, /obj/item/pickaxe/diamond = 1))
				else
					belt = /obj/item/tank/internals/emergency_oxygen/engi
			if(mob_species != /datum/species/lizard)
				shoes = /obj/item/clothing/shoes/workboots/mining
			gloves = /obj/item/clothing/gloves/color/black
			mask = /obj/item/clothing/mask/gas/explorer
			if(prob(20))
				suit = /obj/item/clothing/suit/hooded/explorer
			if(prob(30))
				r_pocket = pickweight(list(/obj/item/stack/marker_beacon = 20, /obj/item/stack/spacecash/c1000 = 7, /obj/item/reagent_containers/hypospray/medipen/survival = 2, /obj/item/borg/upgrade/modkit/damage = 1 ))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/stack/spacecash/c1000 = 7, /obj/item/reagent_containers/hypospray/medipen/survival = 2, /obj/item/borg/upgrade/modkit/cooldown = 1 ))
		if("Ashwalker")
			mob_species = /datum/species/lizard/ashwalker
			uniform = /obj/item/clothing/under/costume/gladiator/ash_walker
			if(prob(95))
				head = /obj/item/clothing/head/helmet/gladiator
			else
				head = /obj/item/clothing/head/helmet/skull
				suit = /obj/item/clothing/suit/armor/bone
				gloves = /obj/item/clothing/gloves/bracer
			if(prob(5))
				back = pickweight(list(/obj/item/spear/bonespear = 3, /obj/item/fireaxe/boneaxe = 2))
			if(prob(10))
				belt = /obj/item/storage/belt/mining/primitive
			if(prob(30))
				r_pocket = /obj/item/kitchen/knife/combat/bone
			if(prob(30))
				l_pocket = /obj/item/kitchen/knife/combat/bone
		if("Clown")
			name = pick(GLOB.clown_names)
			outfit = /datum/outfit/job/clown
			belt = null
			backpack_contents = list()
			if(prob(70))
				backpack_contents += pick(list(/obj/item/stamp/clown = 1, /obj/item/reagent_containers/spray/waterflower = 1, /obj/item/food/grown/banana = 1, /obj/item/megaphone/clown = 1, /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = 1, /obj/item/pneumatic_cannon/pie = 1))
			if(prob(30))
				backpack_contents += list(/obj/item/stack/sheet/mineral/bananium = pickweight(list( 1 = 3, 2 = 2, 3 = 1)))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/bikehorn/golden = 3, /obj/item/bikehorn/airhorn= 1 ))
			if(prob(10))
				r_pocket = /obj/item/implanter/sad_trombone
		if("Golem")
			mob_species = pick(list(/datum/species/golem/adamantine, /datum/species/golem/plasma, /datum/species/golem/diamond, /datum/species/golem/gold, /datum/species/golem/silver, /datum/species/golem/plasteel, /datum/species/golem/titanium, /datum/species/golem/plastitanium))
			if(prob(30))
				glasses = pickweight(list(/obj/item/clothing/glasses/meson = 2, /obj/item/clothing/glasses/hud/health = 2, /obj/item/clothing/glasses/hud/diagnostic =2, /obj/item/clothing/glasses/science = 2, /obj/item/clothing/glasses/welding = 2, /obj/item/clothing/glasses/night = 1))
			if(prob(10))
				belt = pick(list(/obj/item/storage/belt/mining/vendor, /obj/item/storage/belt/utility/full))
			if(prob(50))
				neck = /obj/item/bedsheet/rd/royal_cape
			if(prob(10))
				l_pocket = pick(list(/obj/item/crowbar/power, /obj/item/screwdriver/power, /obj/item/weldingtool/experimental))
		if("YeOlde")
			mob_gender = FEMALE
			uniform = /obj/item/clothing/under/costume/maid
			gloves = /obj/item/clothing/gloves/color/white
			shoes = /obj/item/clothing/shoes/laceup
			head = /obj/item/clothing/head/helmet/knight
			suit = /obj/item/clothing/suit/armor/riot/knight
			if(prob(30))
				back = /obj/item/nullrod/scythe/talking
			else
				back = /obj/item/shield/riot/buckler
				belt = /obj/item/nullrod/claymore
			r_pocket = /obj/item/tank/internals/emergency_oxygen
			mask = /obj/item/clothing/mask/breath
		if("Operative") // Yeah lets NOT give miners a free BR Hardsuit thanks
			name = pick(GLOB.clown_names)
			outfit = /datum/outfit/job/clown
			belt = null
			backpack_contents = list()
			if(prob(70))
				backpack_contents += pick(list(/obj/item/stamp/clown = 1, /obj/item/reagent_containers/spray/waterflower = 1, /obj/item/food/grown/banana = 1, /obj/item/megaphone/clown = 1, /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = 1, /obj/item/pneumatic_cannon/pie = 1))
			if(prob(30))
				backpack_contents += list(/obj/item/stack/sheet/mineral/bananium = pickweight(list( 1 = 3, 2 = 2, 3 = 1)))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/bikehorn/golden = 3, /obj/item/bikehorn/airhorn= 1 ))
			if(prob(10))
				r_pocket = /obj/item/implanter/sad_trombone
		if("Shadow")
			mob_species = /datum/species/shadow
			neck = /obj/item/clothing/accessory/medal/plasma/nobel_science
			uniform = /obj/item/clothing/under/color/black
			shoes = /obj/item/clothing/shoes/sneakers/black
			suit = /obj/item/clothing/suit/toggle/labcoat
			glasses = /obj/item/clothing/glasses/blindfold
			back = /obj/item/tank/internals/oxygen
			mask = /obj/item/clothing/mask/breath
		if("Cultist") // cult bad
			name = pick(GLOB.clown_names)
			outfit = /datum/outfit/job/clown
			belt = null
			backpack_contents = list()
			if(prob(70))
				backpack_contents += pick(list(/obj/item/stamp/clown = 1, /obj/item/reagent_containers/spray/waterflower = 1, /obj/item/food/grown/banana = 1, /obj/item/megaphone/clown = 1, /obj/item/reagent_containers/food/drinks/soda_cans/canned_laughter = 1, /obj/item/pneumatic_cannon/pie = 1))
			if(prob(30))
				backpack_contents += list(/obj/item/stack/sheet/mineral/bananium = pickweight(list( 1 = 3, 2 = 2, 3 = 1)))
			if(prob(10))
				l_pocket = pickweight(list(/obj/item/bikehorn/golden = 3, /obj/item/bikehorn/airhorn= 1 ))
			if(prob(10))
				r_pocket = /obj/item/implanter/sad_trombone
	. = ..()
