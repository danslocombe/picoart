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

xoff_counter = 0
xoff_vel = 0

cls(0)
_set_fps(60)
poke(0x5f54, 0x60)
t=0
xdir = 0
--pp = {1,13,14}
cols_tree = {2,4,9}
--cols_tree = {3,7,9, 13, 1}
::a::
t+=1

--local a = cos(t / 100) + 1
--local b = rnd(2)
--a = 2
--xoff = 0
--if b < 0.05 * a then
--  xoff = -1
--elseif b > 0.95 * a then
--  xoff = 1
--end

--xoff_counter += 0.8 * sin(t / 100)
xoff_vel += 0.2 * sin(t / 100)
if rnd(1) < 0.02 then
  t = 0
end
if rnd(1) < 0.02 then
  t = 0.5
end

xoff_vel *= 0.52
xoff_counter += xoff_vel

xoff = 0
if (xoff_counter > 1) then
  xoff_counter -= 1
  xoff = 1
elseif (xoff_counter < -1) then
  xoff_counter += 1
  xoff = -1
end
yoff = 0.2


if rnd(1) < 0.01 then
  dump_noise(0.1)
end

sspr(xoff, yoff, 128, 128, -xoff, -yoff, 128, 128)
for i=0,1 do
  local col = cols_tree[flr(1+rnd(#cols_tree))]
  circ(rnd(128),rnd(128),0.1+rnd(1),col)
end

rectfill(5, 5, 30, 10, 0)
print(xoff_vel, 5, 5, 7)

rectfill(5, 20, 30, 30, 0)
print(xoff, 5, 20, 7)

flip()
goto a

__gfx__