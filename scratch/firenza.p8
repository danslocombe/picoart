pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

function dump_noise(mag)
  local screen_start = 0x6000
  local screen_size = 8000
  for i=1,mag * 30 do
    local len = 50 + rnd(100)
    local pos = rnd(screen_size) + screen_start
    len = min(len, screen_start + screen_size - pos)
    memset(pos, rnd(64), len)
  end
end

cls(7)
_set_fps(60)
poke(0x5f54, 0x60)
t=0
pp = {1,13,14, 15}
pp2 = {7, 12, 13}
pal = pp2
spiral = 0

::a::

t+=1

theta = rnd(1)
offrad = 1
xoff = offrad * cos(theta)
yoff = offrad * sin(theta)

k = 5
sspr(xoff + k, yoff + k, 128-2*k, 128-2*k, -xoff, -yoff, 128, 128)

if rnd(1) < 0.01 then
  --dump_noise(0.1)
end

for i=0,80 do
  local col = pal[flr(1+rnd(#pal))]
  spiral += 1
  local angle = spiral / 3000
  circ(64 + 10*cos(angle), 64 + 10*sin(angle), 0.1 + rnd(1), col)
end

if t == 125 then
  pal = pp2
  circfill(64, 64, 8, pal[1])
  --dump_noise(1)
elseif t > 250 then
  pal = pp
  circfill(64, 64, 8, pal[1])
  --cls(pal[1])
  --dump_noise(1)
  t = 0
end


flip()
goto a

