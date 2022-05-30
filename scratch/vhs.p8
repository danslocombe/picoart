pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
cls(0)
poke(0x5f54, 0x60)
t=0
::a::
t+=1
cls(0)

local tt = (t % 200) / 200

if (t)
flip()
goto a
__gfx__