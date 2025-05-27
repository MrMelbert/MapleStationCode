/datum/element/decal/blood

/datum/element/decal/blood/Attach(datum/target, _icon, _icon_state, _dir, _plane, _layer, _alpha, _color, _smoothing, _cleanable=CLEAN_TYPE_BLOOD, _description, mutable_appearance/_pic)
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	. = ..()
	RegisterSignal(target, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name), TRUE)

/datum/element/decal/blood/Detach(atom/source)
	UnregisterSignal(source, COMSIG_ATOM_GET_EXAMINE_NAME)
	return ..()

/datum/element/decal/blood/generate_appearance(_icon, _icon_state, _dir, _plane, _layer, _color, _alpha, _smoothing, source)
	var/obj/item/I = source
	if(!_icon)
		_icon = 'icons/effects/blood.dmi'
	if(!_icon_state)
		_icon_state = "itemblood"
	var/icon = I.icon
	var/icon_state = I.icon_state
	if(!icon || !icon_state)
		// It's something which takes on the look of other items, probably
		icon = I.icon
		icon_state = I.icon_state
	var/static/list/blood_splatter_appearances = list()
	//try to find a pre-processed blood-splatter. otherwise, make a new one
	var/index = "[REF(icon)]-[icon_state]"
	pic = blood_splatter_appearances[index]

	if(!pic)
		var/icon/blood_splatter_icon = icon(I.icon, I.icon_state, , 1) //icon of the item that will become splattered
		var/icon/blood_icon = icon(_icon, _icon_state) //icon of the blood that we apply
		blood_icon.Scale(blood_splatter_icon.Width(), blood_splatter_icon.Height())
		blood_splatter_icon.Blend("#fff", ICON_ADD) //fills the icon_state with white (except where it's transparent)
		blood_splatter_icon.Blend(blood_icon, ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
		pic = mutable_appearance(blood_splatter_icon, I.icon_state)
		blood_splatter_appearances[index] = pic
	return TRUE

/datum/element/decal/blood/apply_overlay(obj/item/source, list/overlay_list)
	pic.color = source.get_blood_dna_color() || COLOR_BLOOD // NON-MODULE CHANGE
	return ..()

/datum/element/decal/blood/proc/get_examine_name(atom/source, mob/user, list/override)
	SIGNAL_HANDLER

	var/list/all_dna = GET_ATOM_BLOOD_DNA(source)
	var/list/all_blood_names = list()
	for(var/dna_sample in all_dna)
		var/datum/blood_type/blood = find_blood_type(all_dna[dna_sample])
		all_blood_names |= LOWERTEXT(initial(blood.reagent_type.name))

	override[EXAMINE_POSITION_BEFORE] = "[english_list(all_blood_names, nothing_text = "blood")] stained"
