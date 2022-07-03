///Modular file for adding onto coins. Used for Ricoshots.

///Ricoshots. Shoot a coin for extra speed and damage on the projectile, but you've gotta aim it.
/obj/item/coin/bullet_act(obj/projectile/hitting_projectile, piercing_hit = FALSE)
	playsound(src, hitting_projectile.hitsound, 50, TRUE)
	if(hitting_projectile.damage >= 40) //If we do too much damage, the coin just shatters
		visible_message("[src] shatters from [hitting_projectile]'s impact!")
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 50, TRUE)
		qdel(src)
		return BULLET_ACT_FORCE_PIERCE //We hit so hard we're going through.
	if(piercing_hit == TRUE)
		visible_message("[hitting_projectile] pierces through [src]!")
		playsound(src, 'sound/effects/picaxe3.ogg', 50, TRUE) //I wanted to use sounds already in the game and this fits quite well.
		return BULLET_ACT_HIT
	visible_message("[hitting_projectile] ricoshots off of [src] and gains momentum!")
	playsound(src, 'sound/items/coinflip.ogg', 50, TRUE)
	flick("coin_[coinflip]_flip", src) //Flips the coin for some flair. You can actually hit the coin while it's flipping if you're fast enough.
	hitting_projectile.speed /= 2 //lower speed = faster
	hitting_projectile.damage *= 1.5
	return BULLET_ACT_FORCE_PIERCE //Force a piercing shot so that the projectile doesn't get deleted
