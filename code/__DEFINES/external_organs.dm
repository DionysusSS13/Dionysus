///Uses the parent limb's drawcolor value.
#define ORGAN_COLOR_INHERIT (1<<0)
///Uses /organ/external/proc/override_color()'s return value
#define ORGAN_COLOR_OVERRIDE (1<<1)
///Uses the parent's haircolor
#define ORGAN_COLOR_HAIR (1<<2)
///Uses a static, pre-defined draw_color
#define ORGAN_COLOR_STATIC (1<<3)
///Uses the color stored in DNA. Look man, I'm not rewriting yet more of the rendering pipeline to make this work, I'm four hours into this and I want to be rid of this, please...
#define ORGAN_COLOR_DNA (1<<4)
