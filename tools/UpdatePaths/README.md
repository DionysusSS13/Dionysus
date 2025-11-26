## UpdatePaths

```
Replacement syntax example:
    /turf/open/floor/iron/warningline : /obj/effect/turf_decal {dir = @OLD ;tag = @SKIP;icon_state = @SKIP}
    /turf/open/floor/iron/warningline : /obj/effect/turf_decal {@OLD} , /obj/thing {icon_state = @OLD:name; name = "meme"}
    /turf/open/floor/iron/warningline{dir=2} : /obj/thing
    /obj/effect/landmark/start/virologist : @DELETE
    /mob/living{resize = @ANY} : /mob/living{@OLD; resize = @SKIP}
Syntax for subtypes also exist, to update a path's type but maintain subtypes:
    /obj/structure/closet/crate/@SUBTYPES : /obj/structure/new_box/@SUBTYPES {@OLD}
	You may also use @SUBTYPES anywhere inside the new path. Useful for mass appending new subtypes and replacing base types at the same time.
New paths properties:
    @DELETE - if used as new path name the old path will be deleted
    @OLD - if used as property name copies all modified properties from original path to this one
    property = @SKIP - will not copy this property through when global @OLD is used.
    property = @OLD - will copy this modified property from original object even if global @OLD is not used
    property = @OLD:name - will copy [name] property from original object even if global @OLD is not used
    Anything else is copied as written.
Old paths properties:
    Will be used as a filter.
    property = @UNSET - will apply the rule only if the property is not mapedited
    property = @ANY - will apply the rule when the property is mapedited, regardless of its value.
```
