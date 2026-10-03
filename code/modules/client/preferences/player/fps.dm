/datum/preference/numeric/fps
	explanation = "FPS"
	category = PREFERENCE_CATEGORY_GAME_GAMEPLAY
	description = "Sets the maximum FPS for the client"
	savefile_key = "clientfps"
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER

	minimum = -1
	maximum = 240

/datum/preference/numeric/fps/create_default_value()
	return -1

/datum/preference/numeric/fps/apply_to_client(client/client, value)
	client.fps = (value < 0) ? RECOMMENDED_FPS : value

/datum/preference/numeric/fps/compile_constant_data()
	var/list/data = ..()

	data["recommended_fps"] = RECOMMENDED_FPS

	return data
