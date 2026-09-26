/datum/preference/numeric/tooltip_delay
	explanation = "Tooltip delay (in milliseconds)"
	category = PREFERENCE_CATEGORY_GAME_TOOLTIPS
	description = "How long should it take to see a tooltip when hovering over items?"
	savefile_key = "tip_delay"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

	minimum = 0
	maximum = 5000

/datum/preference/numeric/tooltip_delay/create_default_value()
	return 500

/datum/preference/toggle/enable_tooltips
	explanation = "Enable tooltips"
	category = PREFERENCE_CATEGORY_GAME_TOOLTIPS
	description = "Do you want to see tooltips when hovering over items?"
	savefile_key = "enable_tips"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
