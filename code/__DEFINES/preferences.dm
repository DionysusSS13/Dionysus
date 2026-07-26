
// Legacy preference toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define SOUND_ADMINHELP (1<<0)
#define SOUND_MIDI (1<<1)
#define SOUND_AMBIENCE (1<<2)
#define SOUND_LOBBY (1<<3)
#define MEMBER_PUBLIC (1<<4)
#define SOUND_INSTRUMENTS (1<<7)
#define SOUND_SHIP_AMBIENCE (1<<8)
#define SOUND_PRAYERS (1<<9)
#define ANNOUNCE_LOGIN (1<<10)
#define SOUND_ANNOUNCEMENTS (1<<11)
#define DISABLE_DEATHRATTLE (1<<12)
#define DISABLE_ARRIVALRATTLE (1<<13)
#define COMBOHUD_LIGHTING (1<<14)
#define DEADMIN_ALWAYS (1<<15)
#define DEADMIN_ANTAGONIST (1<<16)
#define DEADMIN_POSITION_HEAD (1<<17)
#define DEADMIN_POSITION_SECURITY (1<<18)
#define DEADMIN_POSITION_SILICON (1<<19)
#define SOUND_ENDOFROUND (1<<20)
#define ADMIN_IGNORE_CULT_GHOST (1<<21)
#define SOUND_COMBATMODE (1<<22)
#define SPLIT_ADMIN_TABS (1<<23)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|SOUND_ENDOFROUND|MEMBER_PUBLIC|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|SOUND_COMBATMODE)

// Legacy chat toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define CHAT_OOC (1<<0)
#define CHAT_DEAD (1<<1)
#define CHAT_GHOSTEARS (1<<2)
#define CHAT_GHOSTSIGHT (1<<3)
#define CHAT_PRAYER (1<<4)
#define CHAT_PULLR (1<<6)
#define CHAT_GHOSTWHISPER (1<<7)
#define CHAT_GHOSTPDA (1<<8)
#define CHAT_GHOSTRADIO (1<<9)
#define CHAT_BANKCARD  (1<<10)
#define CHAT_GHOSTLAWS (1<<11)
#define CHAT_LOGIN_LOGOUT (1<<12)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD|CHAT_GHOSTLAWS|CHAT_LOGIN_LOGOUT)

#define PARALLAX_INSANE "Insane"
#define PARALLAX_HIGH "High"
#define PARALLAX_MED "Medium"
#define PARALLAX_LOW "Low"
#define PARALLAX_DISABLE "Disabled"

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED 1
#define PARALLAX_DELAY_LOW 2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING "Living"
#define EXP_TYPE_CREW "Crew"
#define EXP_TYPE_COMMAND "Command"
#define EXP_TYPE_ENGINEERING "Engineering"
#define EXP_TYPE_MEDICAL "Medical"
#define EXP_TYPE_SCIENCE "Science"
#define EXP_TYPE_SUPPLY "Supply"
#define EXP_TYPE_SECURITY "Security"
#define EXP_TYPE_SILICON "Silicon"
#define EXP_TYPE_SERVICE "Service"
#define EXP_TYPE_ANTAG "Antag"
#define EXP_TYPE_SPECIAL "Special"
#define EXP_TYPE_GHOST "Ghost"
#define EXP_TYPE_ADMIN "Admin"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_NEVER 0
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//recommened client FPS
#define RECOMMENDED_FPS 100

// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_SPECIES (1<<0)
#define RANDOMIZE_NAME (1<<1)

// Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_SAVEFILE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_SAVEFILE_PLAYER "player"

/// Open the game preferences window
#define PREFERENCE_TAB_GAME 1

/// Open the keybindings window
#define PREFERENCE_TAB_KEYBINDINGS 2

/// Open the game preferences window
#define PREFERENCE_TAB_CHARACTER 3

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"
/// This preference has to be rendered with another.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"
// These will be in the appearance menu.
#define PREFERENCE_CATEGORY_APPEARANCE_HEAD "head"
#define PREFERENCE_CATEGORY_APPEARANCE_LEFT_ARM "left_arm"
#define PREFERENCE_CATEGORY_APPEARANCE_RIGHT_ARM "right_arm"
#define PREFERENCE_CATEGORY_APPEARANCE_GROIN "groin"
#define PREFERENCE_CATEGORY_APPEARANCE_TORSO "torso"
#define PREFERENCE_CATEGORY_APPEARANCE_LEFT_LEG "left_leg"
#define PREFERENCE_CATEGORY_APPEARANCE_RIGHT_LEG "right_leg"
#define PREFERENCE_CATEGORY_APPEARANCE_GENERAL "general"
// These will be in the employee menu.
#define PREFERENCE_CATEGORY_EMPLOYEE_PII "pii"
#define PREFERENCE_CATEGORY_EMPLOYEE_LOYALTIES "loyalties"
#define PREFERENCE_CATEGORY_EMPLOYEE_ALIASES_AFFILIATIONS "aliases_affiliations"
#define PREFERENCE_CATEGORY_EMPLOYEE_META "meta"
/// These will be in the ooc info menu.
#define PREFERENCE_CATEGORY_OOC "ooc"

// Playtime is tracked in minutes
/// The time needed to unlock hardcore random mode in preferences
#define PLAYTIME_HARDCORE_RANDOM 120 // 2 hours
/// The time needed to unlock the gamer cloak in preferences
#define PLAYTIME_VETERAN 300000 // 5,000 hours

#define SPRITE_ACCESSORY_NONE "None"

#define PREFERENCE_FEATURE_NONE "none" // I'm a special boy!
#define PREFERENCE_FEATURE_COLOR "color"
#define PREFERENCE_FEATURE_CHECKBOX "checkbox"
#define PREFERENCE_FEATURE_CHECKBOX_INVERSE "checkbox_inverse"
#define PREFERENCE_FEATURE_DROPDOWN "dropdown"
#define PREFERENCE_FEATURE_ICONNED_DROPDOWN "iconned_dropdown"
#define PREFERENCE_FEATURE_DROPDOWN_SWITCHER "dropdown_switcher"
#define PREFERENCE_FEATURE_ICONNED_DROPDOWN_SWITCHER "iconned_dropdown_switcher"
#define PREFERENCE_FEATURE_NUMBER "number"
#define PREFERENCE_FEATURE_LONG_TEXT "long_text"
#define PREFERENCE_FEATURE_SHORT_TEXT "short_text"
#define PREFERENCE_FEATURE_TRI_COLOR "tri_color"
#define PREFERENCE_FEATURE_ICON_BOX "icon_box"

/// Used on sprite accessories's color_src to allow setting up to three colorable layers for a sprite accessory.
#define TRI_COLOR_LAYERS "tri_color_layers"

#define PREFERENCES_SET_MUTANT_CHOICE_LIST(name, global_list) /datum/preference/choiced/mutant/##name/New() { \
	. = ..(); \
	sprite_accessory = ##global_list; \
}

#define PREF_CROP_AREA_HEAD list(10, 19, 22, 31)

#define TRAIT_NEGATIVE "negative"
#define TRAIT_POSITIVE "positive"
#define TRAIT_NEUTRAL "neutral"

/// Values in this section are only ever used for inspection
#define INSPECTION_ZONE_GENERAL "broad"
#define INSPECTION_ZONE_PREVIEW "preview"
#define INSPECTION_ZONE_ARMS "arms"
#define INSPECTION_ZONE_LEGS "legs"
#define INSPECTION_ZONE_HEAD "head"
#define INSPECTION_ZONE_CHEST "chest"
#define INSPECTION_ZONE_OOC "ooc"
