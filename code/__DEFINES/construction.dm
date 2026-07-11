/*ALL DEFINES RELATED TO CONSTRUCTION, CONSTRUCTING THINGS, OR CONSTRUCTED OBJECTS GO HERE*/

//Defines for construction states

//girder construction states
#define GIRDER_NORMAL 0
#define GIRDER_REINF_STRUTS 1
#define GIRDER_REINF 2
#define GIRDER_TRAM 3

//rwall construction states
#define INTACT 0
#define SUPPORT_LINES 1
#define COVER 2
#define CUT_COVER 3
#define ANCHOR_BOLTS 4
#define SUPPORT_RODS 5
#define SHEATH 6

//default_unfasten_wrench() return defines
#define CANT_UNFASTEN 0
#define FAILED_UNFASTEN 1
#define SUCCESSFUL_UNFASTEN 2

//ai core defines
#define EMPTY_CORE 0
#define CIRCUIT_CORE 1
#define SCREWED_CORE 2
#define CABLED_CORE 3
#define GLASS_CORE 4
#define AI_READY_CORE 5

//Construction defines for the pinion airlock
#define GEAR_SECURE 1
#define GEAR_LOOSE 2

//floodlights because apparently we use defines now
#define FLOODLIGHT_NEEDS_WIRES 0
#define FLOODLIGHT_NEEDS_LIGHTS 1
#define FLOODLIGHT_NEEDS_SECURING 2

// Stationary gas tanks
#define TANK_FRAME 0
#define TANK_PLATING_UNSECURED 1

//other construction-related things

//windows affected by Nar'Sie turn this color.
#define NARSIE_WINDOW_COLOUR "#7D1919"

#define IRON_VALUE_PER_UNIT 0.0004

//The amount of materials you get from a sheet of mineral like iron/diamond/glass etc
#define MINERAL_MATERIAL_AMOUNT 2000
//The maximum size of a stack object.
#define MAX_STACK_SIZE 50
//maximum amount of cable in a coil
#define MAXCOIL 30

//tablecrafting defines
#define CAT_NONE ""
#define CAT_WEAPONRY "Weaponry"
#define CAT_WEAPON "Weapons"
#define CAT_AMMO "Ammunition"
#define CAT_ROBOT "Robots"
#define CAT_MISC "Misc"
#define CAT_PRIMAL  "Tribal"
#define CAT_CLOTHING "Clothing"
#define CAT_FOOD "Foods"
#define CAT_BREAD "Breads"
#define CAT_BURGER "Burgers"
#define CAT_CAKE "Cakes"
#define CAT_EGG "Egg-Based Food"
#define CAT_LIZARD "Lizard Food"
#define CAT_MEAT "Meats"
#define CAT_SEAFOOD "Seafood"
#define CAT_MISCFOOD "Misc. Food"
#define CAT_MEXICAN "Mexican Food"
#define CAT_MOTH "Mothic Food"
#define CAT_PASTRY "Pastries"
#define CAT_PIE "Pies"
#define CAT_PIZZA "Pizzas"
#define CAT_SALAD "Salads"
#define CAT_SANDWICH "Sandwiches"
#define CAT_SOUP "Soups"
#define CAT_SPAGHETTI "Spaghettis"
#define CAT_ICE "Frozen"
#define CAT_DRINK "Drinks"
#define CAT_CHEMISTRY "Chemistry"
#define CAT_ATMOSPHERIC "Atmospheric"

/// How many sheets does it cost to make a fulltile window
#define SHEETS_FOR_FULLTILE_WINDOW 2
