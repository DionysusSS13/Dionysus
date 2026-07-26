/datum/preference/text/record
	savefile_identifier = PREFERENCE_SAVEFILE_CHARACTER
	abstract_type = /datum/preference/text/record
	max_length = 8192
	feature_identifier = PREFERENCE_FEATURE_NONE

/datum/preference/text/record/medical
	explanation = "Medical Records"
	savefile_key = "medical_record"

/datum/preference/text/record/security
	explanation = "Security Records"
	savefile_key = "security_record"

/datum/preference/text/record/exploitable
	explanation = "Exploitable Records"
	savefile_key = "exploitable_record"

/datum/preference/text/record/station
	explanation = "Station Records"
	savefile_key = "station_record"

/datum/preference/text/record/sealed
	explanation = "Sealed Records"
	savefile_key = "sealed_record"
