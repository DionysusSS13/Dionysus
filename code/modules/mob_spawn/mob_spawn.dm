/obj/effect/mob_spawn
	name = "Mob Spawner"
	density = TRUE
	anchored = TRUE
	//So it shows up in the map editor
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "mobspawner"
	///A forced name of the mob, though can be overridden if a special name is passed as an argument
	var/mob_name
	///the type of the mob, you best inherit this
	var/mob_type = /mob/living/basic/cockroach
	////Human specific stuff. Don't set these if you aren't using a human, the unit tests will put a stop to your sinful hand.

	///sets the human as a species, use a typepath (example: /datum/species/skeleton)
	var/mob_species
	///equips the human with an outfit.
	var/datum/outfit/outfit
	///for mappers to override parts of the outfit. really only in here for secret away missions, please try to refrain from using this out of laziness
	var/list/outfit_override
	///sets a human's hairstyle
	var/hairstyle
	///sets a human's facial hair
	var/facial_hairstyle
	///sets a human's hair color (use special for gradients, sorry)
	var/haircolor
	///sets a human's facial hair color
	var/facial_haircolor
	///sets a human's skin tone
	var/skin_tone

/obj/effect/mob_spawn/Initialize(mapload)
	. = ..()
	if(faction)
		faction = string_list(faction)

/obj/effect/mob_spawn/proc/create(mob/mob_possessor, newname)
	var/mob/living/spawned_mob = new mob_type(get_turf(src)) //living mobs only
	name_mob(spawned_mob, newname)
	special(spawned_mob, mob_possessor)
	equip(spawned_mob)
	return spawned_mob

/obj/effect/mob_spawn/proc/special(mob/living/spawned_mob)
	SHOULD_CALL_PARENT(TRUE)
	if(faction)
		spawned_mob.faction = faction
	if(ishuman(spawned_mob))
		var/mob/living/carbon/human/spawned_human = spawned_mob
		if(mob_species)
			spawned_human.set_species(mob_species)
		spawned_human.underwear = "Nude"
		spawned_human.undershirt = "Nude"
		spawned_human.socks = "Nude"
		if(hairstyle)
			spawned_human.hairstyle = hairstyle
		else
			spawned_human.hairstyle = random_hairstyle(spawned_human.gender)
		if(facial_hairstyle)
			spawned_human.facial_hairstyle = facial_hairstyle
		else
			spawned_human.facial_hairstyle = random_facial_hairstyle(spawned_human.gender)
		if(haircolor)
			spawned_human.hair_color = haircolor
		else
			spawned_human.hair_color = "#[random_color()]"
		if(facial_haircolor)
			spawned_human.facial_hair_color = facial_haircolor
		else
			spawned_human.facial_hair_color = "#[random_color()]"
		if(skin_tone)
			spawned_human.skin_tone = skin_tone
		else
			spawned_human.skin_tone = skintone2hex(random_skin_tone())
		spawned_human.update_hair()
		spawned_human.update_body()

/obj/effect/mob_spawn/proc/name_mob(mob/living/spawned_mob, forced_name)
	var/chosen_name
	//passed arguments on mob spawns are number one priority
	if(forced_name)
		chosen_name = forced_name
	//then the mob name var
	else if(mob_name)
		chosen_name = mob_name
	//then if no name was chosen the one the mob has by default works great
	if(!chosen_name)
		return
	//not using an old name doesn't update records- but ghost roles don't have records so who cares
	spawned_mob.fully_replace_character_name(null, chosen_name)

/obj/effect/mob_spawn/proc/equip(mob/living/spawned_mob)
	if(outfit)
		var/mob/living/carbon/human/spawned_human = spawned_mob
		if(outfit_override)
			outfit = new outfit //create it now to apply vars
			for(var/outfit_var in outfit_override)
				if(!ispath(outfit_override[outfit_var]) && !isnull(outfit_override[outfit_var]))
					CRASH("outfit_override var on [mob_name] spawner has incorrect values! it must be an assoc list with outfit \"var\" = path | null")
				outfit.vars[outfit_var] = outfit_override[outfit_var]
		spawned_human.equipOutfit(outfit)
