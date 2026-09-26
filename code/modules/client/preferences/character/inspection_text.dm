/mob/living/carbon/proc/get_inspection_text(zone, ignore_visibility)
	var/zone_for_sanity_check
	switch(zone)
		if(INSPECTION_ZONE_GENERAL)
			return dna.inspection_text[INSPECTION_ZONE_GENERAL]
		if(INSPECTION_ZONE_OOC)
			return dna.inspection_text[INSPECTION_ZONE_OOC]

		if(INSPECTION_ZONE_ARMS)
			zone_for_sanity_check = get_bodypart(BODY_ZONE_L_ARM)?.body_zone || get_bodypart(BODY_ZONE_R_ARM)?.body_zone
		if(INSPECTION_ZONE_LEGS)
			zone_for_sanity_check = get_bodypart(BODY_ZONE_L_LEG)?.body_zone || get_bodypart(BODY_ZONE_R_LEG)?.body_zone
		if(INSPECTION_ZONE_CHEST)
			zone_for_sanity_check = BODY_ZONE_CHEST
		if(INSPECTION_ZONE_HEAD)
			zone_for_sanity_check = BODY_ZONE_HEAD

	if(!zone_for_sanity_check || !get_bodypart(zone_for_sanity_check))
		return

	if(!ignore_visibility && (zone_for_sanity_check in get_covered_body_zones()))
		return

	return dna.inspection_text[zone]

/datum/preference/text/inspection
	abstract_type = /datum/preference/text/inspection
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	savefile_key = "flavor_text"
	explanation = "Flavor Text"
	max_length = 256

	category = PREFERENCE_CATEGORY_OOC
	feature_identifier = PREFERENCE_FEATURE_LONG_TEXT

	/// Bodypart to apply text to.
	var/bodypart

/datum/preference/text/inspection/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(bodypart)
		LAZYSET(target.dna.inspection_text, bodypart, value)

/datum/preference/text/inspection/preview
	savefile_key = "preview_inspection_text"
	explanation = "Inspection Preview Text"
	placeholder = "This should be kept to short, important details about your character."
	feature_identifier = PREFERENCE_FEATURE_SHORT_TEXT
	bodypart = INSPECTION_ZONE_PREVIEW
	max_length = FLAVOR_PREVIEW_LIMIT

/datum/preference/text/inspection/general
	savefile_key = "general_inspection_text"
	explanation = "Inspection Text"
	placeholder = "This is your gigantic centerpiece detailing everything relevant to your character AS A SURFACE LEVEL LOOK."
	category = "misc" // We handle this specially cause it needs a fancy editor
	bodypart = INSPECTION_ZONE_GENERAL
	max_length = 16384 // Pretty large but it seems gone likes the look of big inspection texts soo

/datum/preference/text/inspection/head
	savefile_key = "head_inspection_text"
	explanation = "Head Inspection Text"
	placeholder = "This text shows when your head is visible."
	bodypart = INSPECTION_ZONE_HEAD

/datum/preference/text/inspection/torso
	savefile_key = "torso_inspection_text"
	explanation = "Torso Inspection Text"
	placeholder = "This text shows when your torso is uncovered."
	bodypart = INSPECTION_ZONE_CHEST

/datum/preference/text/inspection/arms
	savefile_key = "arms_inspection_text"
	explanation = "Arms Inspection Text"
	placeholder = "This text shows when your arms are uncovered, provided you have any."
	bodypart = INSPECTION_ZONE_ARMS

/datum/preference/text/inspection/legs
	savefile_key = "legs_inspection_text"
	explanation = "Legs Inspection Text"
	placeholder = "This text shows when your legs are uncovered, provided you have any."
	bodypart = INSPECTION_ZONE_LEGS

/datum/preference/text/inspection/ooc_notes
	savefile_key = "ooc_notes"
	explanation = "OOC Notes"
	placeholder = "These should be used for important OOC info, such as your discord, limits when it comes to RP topics, and other useful information. Do not use this to make antagonists feel bad for murdering you."
	bodypart = INSPECTION_ZONE_OOC
	max_length = 8192
