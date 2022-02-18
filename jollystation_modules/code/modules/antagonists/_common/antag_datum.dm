/// -- Extension of the base antagonist datum. --
/// Extra vars for datum/antagonists
/datum/antagonist
	/// Whether this antag can see exploitable info on examine.
	var/antag_flags = CAN_SEE_EXPOITABLE_INFO
	/// Whether we spawn with our equpiment or we wait to receive it.
	var/finalize_antag = TRUE
	/// The advanced antag datum we are linked to.
	var/datum/advanced_antag_datum/linked_advanced_datum
	/// Some blacklisted objectives we don't want showing up in the similar objectives pool
	var/static/list/blacklisted_similar_objectives = list(
		"custom",
		"absorb",
		"nuclear",
		"capture",
		)

/// Antagonist-level proc to show this antagonist their advanced antag panel, should they have the datum.
/datum/antagonist/proc/show_advanced_traitor_panel(mob/user)
	if(!linked_advanced_datum)
		return

	linked_advanced_datum.show_advanced_antag_panel(user)

/datum/antagonist/get_admin_commands()
	. = ..()
	if(linked_advanced_datum)
		.["View Goals"] = CALLBACK(src, .proc/show_advanced_traitor_panel, usr)

/datum/antagonist/antag_listing_commands()
	. = ..()
	if(linked_advanced_datum)
		. += "<a href='?_src_=holder;[HrefToken()];admin_check_goals=[REF(src)]'>Show Goals</a>"

/// An extension of the admin topic for the extra buttons.
/datum/admins/Topic(href, href_list)
	. = ..()
	if(href_list["admin_check_goals"])
		var/datum/antagonist/our_antag = locate(href_list["admin_check_goals"])
		if(!check_rights(R_ADMIN))
			return

		our_antag.show_advanced_traitor_panel(usr)
		return

/datum/antagonist/proc/finalize_antag()
	return FALSE

/datum/antagonist/on_removal()
	if(linked_advanced_datum)
		qdel(linked_advanced_datum)
	return ..()
