// uses pickweight
GLOBAL_LIST_INIT_TYPED(leyline_amounts, /datum/leyline_amount, list(
	/datum/leyline_amount/one = 5000,
	/datum/leyline_amount/two = 500,
	/datum/leyline_amount/three = 200,
	/datum/leyline_amount/four = 10
))

/datum/leyline_amount
	var/amount = 0

/datum/leyline_amount/one
	amount = 1

/datum/leyline_amount/two
	amount = 2

/datum/leyline_amount/three
	amount = 3

/datum/leyline_amount/four
	amount = 4


