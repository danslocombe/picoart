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


_set_fps(60)
::_::
for i =0,1024 do
  x = rnd(128)
  y = rnd(128)

  col = flr((x + y) / 32) % 2 == 0 and 7 or 11


  --circ(x, y, 1, col)
  pset(x, y,  col)
  if rnd() < 0.1 then
      stretch_noise_vert()
  end
end
flip()
goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
