/// Whether or not to announce when the player logs in or out.
/datum/preference/toggle/broadcast_login_logout
	explanation = "Broadcast login/logout"
	category = PREFERENCE_CATEGORY_GAME_GAMEPLAY
	description = "When enabled, disconnecting and reconnecting will announce to deadchat."
	savefile_key = "broadcast_login_logout"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
