/////////// cleric's den items.

//Primary reward: the cleric's mace design disk.
/obj/item/disk/data/floppy/cleric_mace
	name = "Enshrined Disc of Smiting"

/obj/item/disk/data/floppy/cleric_mace/Initialize(mapload)
	. = ..()
	var/datum/c4_file/fab_design_bundle/dundle = new(list(SStech.designs_by_type[/datum/design/cleric_mace]))
	dundle.name = FABRICATOR_FILE_NAME
	root.try_add_file(dundle)

/obj/item/paper/fluff/ruins/clericsden/contact
	info = "Father Aurellion, the ritual is complete, and soon our brothers at the bastion will see the error of our ways. After all, a god of clockwork or blood? Preposterous. Only the TRUE GOD should have so much power. Signed, Father Odivallus."

/obj/item/paper/fluff/ruins/clericsden/warning
	info = "FATHER ODIVALLUS DO NOT GO FORWARD WITH THE RITUAL. THE ASTEROID WE'RE ANCHORED TO IS UNSTABLE, YOU WILL DESTROY THE STATION. I HOPE THIS REACHES YOU IN TIME. FATHER AURELLION."
