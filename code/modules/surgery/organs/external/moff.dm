///A moth's antennae
/obj/item/organ/antennae
	name = "antennae"
	///Unremovable is until the features are completely finished
	organ_flags = ORGAN_UNREMOVABLE | ORGAN_EDIBLE
	visual = TRUE
	cosmetic_only = TRUE

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_ANTENNAE
	layers = list(BODY_FRONT_LAYER, BODY_BEHIND_LAYER)
	feature_key = "moth_antennae"
	preference = "feature_moth_antennae"

	dna_block = DNA_MOTH_ANTENNAE_BLOCK

	///Are we burned?
	var/burnt = FALSE
	///Store our old sprite here for if our antennae wings are healed
	var/original_sprite = ""

/obj/item/organ/antennae/Insert(mob/living/carbon/reciever, special, drop_if_replaced)
	. = ..()
	if(!.)
		return

	RegisterSignal(reciever, COMSIG_HUMAN_BURNING, PROC_REF(try_burn_antennae))
	RegisterSignal(reciever, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(heal_antennae))

/obj/item/organ/antennae/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()

	UnregisterSignal(organ_owner, list(COMSIG_HUMAN_BURNING, COMSIG_LIVING_POST_FULLY_HEAL))

/obj/item/organ/antennae/get_global_feature_list()
	return GLOB.moth_antennae_list

/obj/item/organ/antennae/can_draw_on_bodypart(mob/living/carbon/human/human)
	return TRUE

///check if our antennae can burn off ;_;
/obj/item/organ/antennae/proc/try_burn_antennae(mob/living/carbon/human/human)
	SIGNAL_HANDLER

	if(!burnt && human.bodytemperature >= 800 && human.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(human, span_danger("Your precious antennae burn to a crisp!"))

		burn_antennae()
		human.update_body_parts()

/obj/item/organ/antennae/proc/burn_antennae()
	burnt = TRUE
	original_sprite = sprite_datum.name
	set_sprite("Burnt Off")

///heal our antennae back up!!
/obj/item/organ/antennae/proc/heal_antennae()
	SIGNAL_HANDLER

	if(burnt)
		burnt = FALSE
		set_sprite(original_sprite)
