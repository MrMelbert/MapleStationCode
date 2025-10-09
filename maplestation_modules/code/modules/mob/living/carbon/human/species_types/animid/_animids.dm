/datum/animalid_type
	/// Bespoke ID for this animalid type. Must be unique.
	var/id

	/// Organs and limbs applied with this animalid type
	var/list/components
	/// A blood type this animalid type uses, if any
	var/blood_type

	/// Used in the UI - name of this animalid type
	var/name
	/// Fontawesome icon for this animalid type
	var/icon = FA_ICON_QUESTION
	/// Used in the UI - pros of this animalid type
	var/list/pros
	/// Used in the UI - cons of this animalid type
	var/list/cons
	/// Used in the UI - neutral traits of this animalid type
	var/list/neuts
