/// Centcom stuff
/datum/access_group/centcom
	name = "Centcom"
	access = list(
		ACCESS_CENT_BAR, \
		ACCESS_CENT_CAPTAIN, \
		ACCESS_CENT_TELEPORTER, \
		ACCESS_CENT_STORAGE, \
		ACCESS_CENT_LIVING, \
		ACCESS_CENT_MEDICAL, \
		ACCESS_CENT_SPECOPS, \
		ACCESS_CENT_THUNDER, \
		ACCESS_CENT_GENERAL, \
	)

/// Syndi access
/datum/access_group/syndicate
	name = "Syndicate"
	access = list(
		ACCESS_SYNDICATE_LEADER, \
		ACCESS_SYNDICATE, \
	)

/// Internal Cult access that prevents non-cult from using their doors.
/datum/access_group/cult
	name = "Bloodcult"
	access = list(ACCESS_BLOODCULT)
