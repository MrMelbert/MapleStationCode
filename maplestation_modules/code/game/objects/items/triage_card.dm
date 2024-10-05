/obj/item/paper/triage
	name = "triage card"
	desc = "A card used to determine the severity of a patient's condition at a glance."
	default_raw_text = "It's so over" // filler text
	var/severity = "none"

/obj/item/paper/triage/Initialize(mapload)
	name = "\"[severity]\" [name]"
	default_raw_text = {"
		<center>
			<h2>TAG - TRIAGE</h2>
		</center>
		<b>Name:</b><br>
		\[______________________________\]<br>
		<center>
			<h3>- [uppertext(severity)] -<h3>
			<h4>[severity_to_subtitle()]</h4>
		</center>
		<b>Injuries:</b><br>
		\[________________________________________\]<br>
		\[________________________________________\]<br>
		\[________________________________________\]<br>
		\[________________________________________\]<br>
		\[________________________________________\]<br>
	"}
	return ..()

/obj/item/paper/triage/proc/severity_to_subtitle()
	switch(severity)
		if("expectant / deceased")
			return "NO RESPIRATION"
		if("immediate")
			return "LIFE THREATENING"
		if("delayed")
			return "SERIOUS INJURIES - NOT LIFE THREATENING"
		if("minimal")
			return "MINOR INJURIES - WALKING WOUNDED"
	return "UNKNOWN"

/obj/item/paper/triage/examine(mob/user)
	. = ..()
	switch(severity)
		if("expectant / deceased")
			. += span_notice("This card indicates that the patient is deceased or is not expected to survive.")
		if("immediate")
			. += span_notice("This card indicates that the patient is in a critical condition and requires immediate attention.")
		if("delayed")
			. += span_notice("This card indicates that the patient is seriously injured, but not in immediate danger.")
		if("minimal")
			. += span_notice("This card indicates that the patient is only slightly injured.")

	. += span_smallnoticeital("There is a guide to triage on the back of the card, if you <i>look closer</i>.")

/obj/item/paper/triage/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>The back of [src] has a guide to performing triage:</i>")
	. += "&bull; \"Is the victim walking and can respond to simple orders?\" If so, mark as <b>minimal</b>."
	. += "&bull; \"Has the victim stopped breathing entirely (without even gasping for air)?\" If so, mark as <b>expectant / deceased</b>."
	. += "&bull; \"Is the victim bleeding, failing to follow simple commands, lacking a pulse, having difficulties breathing?\" If so, mark as <b>immediate</b>."
	. += "&bull; Otherwise, mark as <b>delayed</b>."

/obj/item/paper/triage/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(!isliving(interacting_with))
		return .

	var/px = text2num(LAZYACCESS(modifiers, ICON_X))
	var/py = text2num(LAZYACCESS(modifiers, ICON_Y))

	if(isnull(px) || isnull(py))
		return .

	user.do_attack_animation(interacting_with, used_item = src)
	interacting_with.balloon_alert(user, "card attached")
	interacting_with.AddComponent(/datum/component/sticker, src, get_dir(interacting_with, src), px, py)
	return . | ITEM_INTERACT_SUCCESS

/obj/item/paper/triage/minor
	color = COLOR_ASSEMBLY_GREEN
	severity = "minimal"

/obj/item/paper/triage/major
	color = COLOR_ASSEMBLY_YELLOW
	severity = "delayed"

/obj/item/paper/triage/critical
	color = COLOR_ASSEMBLY_RED
	severity = "immediate"

/obj/item/paper/triage/dead
	color = COLOR_ASSEMBLY_BLACK
	severity = "expectant / deceased"

/obj/item/paper_bin/triage
	name = "triage card stack"
	desc = "A stack of triage cards for quickly assessing the severity of a patient's condition."
	icon_state = "nobasesprite"
	bin_overlay_string = "nobinsprite"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	inhand_icon_state = "paper"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound = 'sound/items/handling/paper_pickup.ogg'
	total_paper = 20

/obj/item/paper_bin/triage/fire_act(exposed_temperature, exposed_volume)
	total_paper -= round(exposed_volume / 25, 1)
	if(total_paper <= 0)
		qdel(src)
	else
		update_appearance()

/obj/item/paper_bin/triage/dump_contents(atom/droppoint, collapse = FALSE)
	. = ..()
	if(total_paper <= 0)
		qdel(src)

/obj/item/paper_bin/triage/remove_paper(amount)
	. = ..()
	if(total_paper <= 0)
		qdel(src)

/obj/item/paper_bin/triage/Exited(atom/movable/gone, direction)
	. = ..()
	if(total_paper <= 0 && !QDELING(src))
		qdel(src)

/obj/item/paper_bin/triage/minor
	papertype = /obj/item/paper/triage/minor

/obj/item/paper_bin/triage/major
	papertype = /obj/item/paper/triage/major

/obj/item/paper_bin/triage/critical
	papertype = /obj/item/paper/triage/critical

/obj/item/paper_bin/triage/dead
	papertype = /obj/item/paper/triage/dead

/obj/item/storage/box/triage_cards
	name = "triage card box"
	desc = "A box containing triage cards, used for quickly assessing the severity of a patient's condition."
	custom_price = PAYCHECK_CREW

/obj/item/storage/box/triage_cards/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 6

/obj/item/storage/box/triage_cards/PopulateContents()
	new /obj/item/paper_bin/triage/minor(src)
	new /obj/item/paper_bin/triage/major(src)
	new /obj/item/paper_bin/triage/critical(src)
	new /obj/item/paper_bin/triage/dead(src)
	new /obj/item/pen(src)

/obj/machinery/vending/medical
	added_products = list(
		/obj/item/storage/box/triage_cards = 4,
	)
