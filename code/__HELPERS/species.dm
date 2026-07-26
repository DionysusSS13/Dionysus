
//This exists so sprite accessories can still be per-layer without having to include that layer's
//number in their sprite name, which causes issues when those numbers change.
/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_FRONT_LAYER)
			return "FRONT"
		if(FRONT_MUTATIONS_LAYER)
			return "FRONT_UNDER" // Named FRONT_UNDER for sake of codebase compatibility caue god knows folk are gonna port other codebase's shit here
