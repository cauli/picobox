pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

#include math_helpers.lua
#include rasterizer.lua

#include generators.lua

#include theme.lua
#include blocks.lua
#include levels.lua
#include wave_function_collapser.lua

#include nanogolf.lua

#include draw.lua

__gfx__
000b000000b0000000000000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000b000000b000000bb00000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b00b0b00000b0b00b00b0000b00b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b0000bbb0000b00b000bb000b0000bb00000000000000000005880000000000000000000000000000000000000000000000000000000000000000000000000
00b0b00b00b0b00b00b0000b00b0b00b000000000000000000005880000000000000000000000000000000000000000000000000000000000000000000000000
b0000b00b000b000000bb000b0000b00b00000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0b000b00b0000b00b0000b0b0b000b00b00000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0b0000000b0000000b0000000b000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eee00eee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ee0000ee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eee00eee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000001101013010030100000023020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
