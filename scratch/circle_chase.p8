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


_set_fps(60)
t = 0
pal = {0, 7, 10}
::_::
t += 1
x = rnd(128)
y = rnd(128)
--local xmod = x + sin(time()) * 8
--local xmod = 64 + (64 - x) * (1 + (time() * 4) / 2) % 128
xmod = x
d2 = (xmod-64)*(xmod-64)+(y-64)*(y-64)
d2_from_circ = abs(d2-1024)
if d2_from_circ < 256 then
  --local ta = time() / 3
  local ta = -0.25
  --local ta = 0.5 -- t / 10000
  local tx = cos(ta)
  local ty = sin(ta)

  local dx = (x - 64) / 32
  local dy = (y - 64) / 32

  local dot = tx * dx + ty * dy

  -- simple
  --local k = (dot + 1) * 0.5
  --local thresh = 0
  --col = dot < thresh and 14 or 15 
  
  
  -- rand
  local k = (dot + 1)  * 0.5
  col = (rnd() < k*k) and 14 or 15

  -- dan trying to be smart
  --local c = 3
  --local k = 10
  --local x0 = sigmoid(k * dot + c)
  --local x1 = sigmoid(k * dot - c)
  --local r = rnd() 
  --col = (r < x0 and pal[1]) or (r < x1 and pal[2]) or pal[3]
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
