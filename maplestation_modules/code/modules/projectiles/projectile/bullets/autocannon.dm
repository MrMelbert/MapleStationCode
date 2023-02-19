//Different autocannon rounds for mechs to use

/obj/projectile/bullet/autocannon_5
	name = "Autocannon/5 round"
	damage = 20 //20 damage for 2 round burst, but unlike the ac2, this has AP
	armour_penetration = 15
	wound_falloff_tile = -2 //higher wounding per range
	range = 60

/obj/projectile/bullet/autocannon_10
	name = "Autocannon/10 round"
	damage = 30
	armour_penetration = 40 //High AP is the ac10's speciality

/obj/projectile/bullet/autocannon_20 //secretly just cannonballs
	name = "Autocannon/20 round"
	damage = 60
	wound_bonus = 20
	bare_wound_bonus = 25
	speed = 1.2 //50 percent slower than a regular bullet
	range = 20
