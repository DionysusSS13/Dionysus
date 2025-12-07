from .dirs import *

CONVEX = "convex" # Four sides
CONCAVE = "concave" # Pyramid
VERTICAL = "vertical"
HORIZONTAL = "horizontal"
FLAT = "flat" # Eight sides

SHAPES = {
    CONVEX: NONE,
    CONCAVE: NORTH | SOUTH | EAST | WEST,
    VERTICAL: NORTH | SOUTH,
    HORIZONTAL: EAST | WEST,
    FLAT: NORTHEAST | SOUTHEAST | SOUTHWEST | NORTHWEST,
}

# I cba figuring out the best way to iterate this
OUTPUT_CARDINALS = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
]
OUTPUT_DIAGONALS = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    21,
    23,
    29,
    31,
    38,
    39,
    46,
    47,
    55,
    63,
    74,
    75,
    78,
    79,
    95,
    110,
    111,
    127,
    137,
    139,
    141,
    143,
    157,
    159,
    175,
    191,
    203,
    207,
    223,
    239,
    255
]
