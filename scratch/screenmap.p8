pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
cls(0)
_set_fps(60)
poke(0x5f54, 0x60)
t=0
pp = {1,13,14}
::a::
t+=1
k = 12*sin(t / 200) - 3

if k > 0 then
  pal(13,8)
  pal(14,9)
  sspr(k, k, 128-2*k, 128-2*k, 0, 0, 128, 128)
  pal()
else
  theta = rnd()
  xoff = 0.2*cos(theta)
  yoff = 0.2*sin(theta)
  sspr(xoff, yoff, 128, 128, -xoff, -yoff, 128, 128)
end
for i=0,80 do
  local col = pp[flr(1+rnd(3))]
  circ(rnd(128),rnd(128),0.2+rnd(3),col)
end
flip()
goto a

__gfx__