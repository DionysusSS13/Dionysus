/datum/preference/toggle/legacy_toggle
	savefile_identifier = PREFERENCE_SAVEFILE_PLAYER
	abstract_type = /datum/preference/toggle/legacy_toggle
	var/static/list/legacy_toggles = list(
		"admin_ignore_cult_ghost" = ADMIN_IGNORE_CULT_GHOST,
		"announce_login" = ANNOUNCE_LOGIN,
		"combohud_lighting" = COMBOHUD_LIGHTING,
		"deadmin_always" = DEADMIN_ALWAYS,
		"deadmin_antagonist" = DEADMIN_ANTAGONIST,
		"deadmin_position_head" = DEADMIN_POSITION_HEAD,
		"deadmin_position_security" = DEADMIN_POSITION_SECURITY,
		"deadmin_position_silicon" = DEADMIN_POSITION_SILICON,
		"split_admin_tabs" = SPLIT_ADMIN_TABS,

		"disable_arrivalrattle" = DISABLE_ARRIVALRATTLE,
		"disable_deathrattle" = DISABLE_DEATHRATTLE,
		"member_public" = MEMBER_PUBLIC,
		"sound_adminhelp" = SOUND_ADMINHELP,
		"sound_ambience" = SOUND_AMBIENCE,
		"sound_announcements" = SOUND_ANNOUNCEMENTS,
		"sound_combatmode" = SOUND_COMBATMODE,
		"sound_endofround" = SOUND_ENDOFROUND,
		"sound_instruments" = SOUND_INSTRUMENTS,
		"sound_lobby" = SOUND_LOBBY,
		"sound_midi" = SOUND_MIDI,
		"sound_prayers" = SOUND_PRAYERS,
		"sound_ship_ambience" = SOUND_SHIP_AMBIENCE,
	)

	var/static/list/legacy_chat_toggles = list(
		"chat_bankcard" = CHAT_BANKCARD,
		"chat_dead" = CHAT_DEAD,
		"chat_ghostears" = CHAT_GHOSTEARS,
		"chat_ghostlaws" = CHAT_GHOSTLAWS,
		"chat_ghostpda" = CHAT_GHOSTPDA,
		"chat_ghostradio" = CHAT_GHOSTRADIO,
		"chat_ghostsight" = CHAT_GHOSTSIGHT,
		"chat_ghostwhisper" = CHAT_GHOSTWHISPER,
		"chat_login_logout" = CHAT_LOGIN_LOGOUT,
		"chat_ooc" = CHAT_OOC,
		"chat_prayer" = CHAT_PRAYER,
		"chat_pullr" = CHAT_PULLR,
	)

/datum/preference/toggle/legacy_toggle/apply_to_client(client/client, value)
	if (istype(client, /datum/client_interface))
		return // Do not try to apply to fake clients

	var/legacy_flag = legacy_toggles[savefile_key]
	if (!isnull(legacy_flag))
		if (value)
			client?.prefs?.toggles |= legacy_flag
		else
			client?.prefs?.toggles &= ~legacy_flag

		// I know this looks silly, but this is the only one that cares
		// and NO NEW LEGACY TOGGLES should ever be added.
		if (legacy_flag == SOUND_LOBBY)
			if (value && isnewplayer(client.mob))
				client?.playtitlemusic()
			else
				client?.stoptitlemusic()

		if(legacy_flag == SOUND_SHIP_AMBIENCE)
			client?.mob?.refresh_looping_ambience()

		if(legacy_flag == SOUND_AMBIENCE)
			client?.update_ambience_pref()
		return TRUE
	return FALSE

/datum/preference/toggle/legacy_toggle/create_default_value()
	return category != PREFERENCE_CATEGORY_GAME_ADMIN

#define OLD_TOGGLE(CATEGORY, NAME, EXPLANATION) /datum/preference/toggle/legacy_toggle/##NAME { \
	savefile_key = #NAME; \
	explanation = ##EXPLANATION; \
	category = ##CATEGORY; \
}

#define OLD_TOGGLE_DESCRIPTION(CATEGORY, NAME, EXPLANATION, DESCRIPTION) /datum/preference/toggle/legacy_toggle/##NAME { \
	savefile_key = #NAME; \
	explanation = ##EXPLANATION; \
	description = ##DESCRIPTION; \
	category = ##CATEGORY; \
}

// Shoehorn them into being macros cause I cba making these by hand. Regex replace go brr.
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, admin_ignore_cult_ghost, "Prevent being summoned as a cult ghost", "When enabled and observing, prevents Spirit Realm from forcing you into a cult ghost.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, announce_login, "Announce login", "Admins will be notified when you login.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_ADMIN, combohud_lighting, "Enable fullbright Combo HUD")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, deadmin_always, "Auto deadmin - Always", "When enabled, you will automatically deadmin.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, deadmin_antagonist, "Auto deadmin - Antagonist", "When enabled, you will automatically deadmin as an antagonist.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, deadmin_position_head, "Auto deadmin - Head of Staff", "When enabled, you will automatically deadmin as a head of staff.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, deadmin_position_security, "Auto deadmin - Security", "When enabled, you will automatically deadmin as a member of security.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, deadmin_position_silicon, "Auto deadmin - Silicon", "When enabled, you will automatically deadmin as a silicon.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, disable_arrivalrattle, "Notify for new arrivals", "When enabled, you will be notified as a ghost for new crew.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, disable_deathrattle, "Notify for deaths", "When enabled, you will be notified as a ghost whenever someone dies.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_CHAT, member_public, "Publicize BYOND membership", "When enabled, a BYOND logo will be shown next to your name in OOC.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_ADMIN, sound_adminhelp, "Enable adminhelp sounds")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_SOUND, sound_ambience, "Enable ambience")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_SOUND, sound_announcements, "Enable announcement sounds", "When enabled, hear sounds for command reports, notices, etc.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_SOUND, sound_combatmode, "Enable combat mode sound", "When enabled, hear sounds when toggling combat mode.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_SOUND, sound_endofround, "Enable end of round sounds", "When enabled, hear a sound when the server is rebooting.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_SOUND, sound_instruments, "Enable instruments", "When enabled, be able hear instruments in game.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_SOUND, sound_lobby, "Enable lobby music")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_SOUND, sound_midi, "Enable admin music", "When enabled, admins will be able to play music to you.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_ADMIN, sound_prayers, "Enable prayer sound")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_SOUND, sound_ship_ambience, "Enable ship ambience")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_ADMIN, split_admin_tabs, "Split admin tabs", "When enabled, will split the 'Admin' panel into several tabs.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_CHAT, chat_bankcard, "Enable income updates", "Receive notifications for your bank account.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_ADMIN, chat_dead, "Enable deadchat")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostears, "Hear all messages", "When enabled, you will be able to hear all speech as a ghost. When disabled, you will only be able to hear nearby speech.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostlaws, "Enable law change updates", "When enabled, be notified of any new law changes as a ghost.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostpda, "Enable PDA notifications", "When enabled, be notified of any PDA messages as a ghost.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostradio, "Enable radio", "When enabled, be notified of any radio messages as a ghost.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostsight, "See all emotes", "When enabled, see all emotes as a ghost.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_ghostwhisper, "See all whispers", "When enabled, you will be able to hear all whispers as a ghost. When disabled, you will only be able to hear nearby whispers.")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_GHOST, chat_login_logout, "See login/logout messages", "When enabled, be notified when a player logs in or out.")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_CHAT, chat_ooc, "Enable OOC")
OLD_TOGGLE(PREFERENCE_CATEGORY_GAME_ADMIN, chat_prayer, "Listen to prayers")
OLD_TOGGLE_DESCRIPTION(PREFERENCE_CATEGORY_GAME_CHAT, chat_pullr, "Enable pull request notifications", "Be notified when a pull request is made, closed, or merged.")


#undef OLD_TOGGLE
