/turf/closed/constructed_wall/welder_act_secondary(mob/living/user, obj/item/tool)
	if(!Adjacent(tool))
		return ..()
	switch(deconstruction_stage)
		if(WALL_DECON_NONE)
			if(material_trim_top || material_trim_bottom)
				balloon_alert("remove the trim!")
				return TRUE
			balloon_alert_to_viewers("cutting frame...")
			if(!tool.use_tool(src, user, WALL_DECON_STEP_TIME, volume = 50))
				return TRUE
			deconstruction_stage = WALL_DECON_WALL_WEAKENED
			update_appearance(UPDATE_OVERLAYS)
			return TRUE
		if(WALL_DECON_WALL_WEAKENED)
			if(material_reinforcement && deconstruction_r_step == WALL_DECON_REINF_GRILLE_REMOVED)
				balloon_alert_to_viewers("removing bracing...")
				if(!tool.use_tool(src, user, WALL_DECON_STEP_REINF_TIME, volume = 50))
					return TRUE
				deconstruction_r_step = WALL_DECON_REINF_BRACING_REMOVED
				update_appearance(UPDATE_OVERLAYS)
				return TRUE
	return ..()

/turf/closed/constructed_wall/crowbar_act(mob/living/user, obj/item/tool)
	if(material_trim_top)
		balloon_alert_to_viewers("removing trim...")
		if(!tool.use_tool(src, user, WALL_DECON_STEP_TIME, volume = 50))
			return TRUE
		user.put_in_hands(new material_trim_top.sheet_type(drop_location(), 1))
		material_trim_top = null
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	if(material_trim_bottom)
		balloon_alert_to_viewers("removing trim...")
		if(!tool.use_tool(src, user, WALL_DECON_STEP_TIME, volume = 50))
			return TRUE
		user.put_in_hands(new material_trim_bottom.sheet_type(drop_location(), 1))
		material_trim_bottom = null
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	switch(deconstruction_stage)
		if(WALL_DECON_WALL_WEAKENED)
			// if we are reinforced, we need to remove the bulkhead first
			if(material_reinforcement && deconstruction_r_step != WALL_DECON_REINF_BOLTS_UNDONE)
				if(deconstruction_r_step == WALL_DECON_REINF_NONE)
					balloon_alert_to_viewers("removing bulkhead...")
					if(!tool.use_tool(src, user, WALL_DECON_STEP_REINF_TIME, volume = 50))
						return TRUE
					deconstruction_r_step = WALL_DECON_REINF_BULKHEAD_REMOVED
					update_appearance(UPDATE_OVERLAYS)
				return TRUE
			balloon_alert_to_viewers("removing plating...")
			if(!tool.use_tool(src, user, WALL_DECON_STEP_TIME, volume = 50))
				return TRUE
			deconstruct_to_girder()
			return TRUE
	return ..()

/turf/closed/constructed_wall/wrench_act(mob/living/user, obj/item/tool)
	if(!Adjacent(tool))
		return ..()
	if(deconstruction_r_step != WALL_DECON_REINF_BRACING_REMOVED)
		return ..()
	balloon_alert_to_viewers("undoing bolts...")
	if(!tool.use_tool(src, user, WALL_DECON_STEP_REINF_TIME, volume = 50))
		return TRUE
	deconstruction_r_step = WALL_DECON_REINF_BOLTS_UNDONE
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/turf/closed/constructed_wall/wirecutter_act(mob/living/user, obj/item/tool)
	if(!Adjacent(tool))
		return ..()
	switch(deconstruction_stage)
		if(WALL_DECON_WALL_WEAKENED)
			if(material_reinforcement && deconstruction_r_step == WALL_DECON_REINF_BULKHEAD_REMOVED)
				balloon_alert_to_viewers("removing grille...")
				if(!tool.use_tool(src, user, WALL_DECON_STEP_REINF_TIME, volume = 50, extra_checks = CALLBACK(src, PROC_REF(deconstruction_shock_check), user)))
					return TRUE
				deconstruction_r_step = WALL_DECON_REINF_GRILLE_REMOVED
				update_appearance(UPDATE_OVERLAYS)
				return TRUE
	return ..()

/turf/closed/constructed_wall/proc/deconstruct_to_girder()
	var/obj/structure/girder/girder = new(src)
	girder.material_plating = material_plating
	girder.material_reinforcement = material_reinforcement
	if(material_reinforcement)
		girder.reinforcement_secure = TRUE
	girder.anchored = TRUE
	girder.density = TRUE
	girder.start_smoothing()
	ScrapeAway()

/turf/closed/constructed_wall/proc/deconstruction_shock_check(mob/living/user)
	var/obj/structure/cable/cable = locate() in src
	if(isnull(cable))
		return TRUE
	return !cable.shock(user, prb = 75)
