pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

screen_start = 0x6000
screen_size = 8192
line_length = 8192 / 128 -- =64

function dump_noise(mag)
  for i=1,mag * 30 do
    local len = 50 + rnd(100)
    local pos = rnd(screen_size) + screen_start
    len = min(len, screen_start + screen_size - pos)
    memset(pos, rnd(64), len)
  end
end

function copy_noise_small()
    local len = 50 + rnd(100)
    local pos = rnd(screen_size) + screen_start
    len = min(len, screen_start + screen_size - pos)
    memcpy(pos + len,  pos, len)
end

function copy_noise_vert()
  len = line_length * 3
  local pos = screen_start + rnd(screen_size)
  -- cap at end
  len = min(len, screen_start + screen_size - pos)

  offset_rows = flr(rnd(10)) + 1
  local target_start = pos + offset_rows * line_length
  local target_end = target_start + len
    
  -- check for overflow
  if not (target_end < screen_start) then
    memcpy(target_start, pos, len)
  end
end

function stretch_noise_vert()
  local offset = rnd(screen_size)
  local pos = screen_start + offset

  local to_end_of_line = line_length - (offset % line_length)
  local len = min(rnd(2) + rnd(2), to_end_of_line)
  local len = rnd(to_end_of_line)

  offset_rows = flr(rnd(2)) + 1

  for i=1,offset_rows do
    local target_start = pos + i * line_length
    local target_end = target_start + len

    -- check for overflow
    if (target_end < screen_start) then
      return
    end

    memcpy(target_start, pos, len)
  end
    
end

function exp(x)
  -- shitty taylor series about 0
  return 1 + x + x*x/2 + x*x*x / 6 + x*x*x*x / 24 + x*x*x*x*x / 120
end

function sigmoid(x)
  return 1 / (1 + exp(-x))
end


camera(-64, -64)
_set_fps(60)
t = 0
pal = {0, 7, 10}
::_::
t += 1
x = rnd(128)-64
y = rnd(128)-64

--k = 1 / (1 + 0.5 * sin(time() * 0.15))
--
--xmod = k*x * sin(time())
--ymod = k*y

xmod = x
ymod = y

--if abs(xmod) < 12 then
  --xmod *= 2
--end

--cc = 24
--while (xmod*xmod + ymod*ymod) < cc*cc do
--  ymod *= 4
--  xmod *= 4
--  --cc *= 2
--end

d2 = xmod*xmod + ymod*ymod
d2_from_circ = abs(d2-1024)

a = atan2(y, x)

d2_from_circ += sin(a * (5 + 5*sin(time() * 0.063))) * 128

if d2_from_circ < 256 then
  local ta = -0.25
  local tx = cos(ta)
  local ty = sin(ta)

  local dx = x/32
  local dy = y/32

  local dot = tx * dx + ty * dy

  local k = (dot + 1)  * 0.5
  col = (rnd() < k) and 14 or 15
elseif d2_from_circ < 512 then
  col = 1
else
  col = 12
end
circ(x, y, 1, col)
goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
