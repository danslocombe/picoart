pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

screen_start = 0x6000
screen_size = 8192

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

function copy_noise()
--for i = 0,30 do
    local len = 50 + rnd(100)
    local pos = rnd(screen_size) + screen_start
    len = min(len, screen_start + screen_size - pos)
    local target_start = screen_start + rnd(screen_size - len)
    memcpy(target_start, pos, len)
--end
end

::_::
x = rnd(128)
y = rnd(128)

a = sin(t() / 10)
b = 1 -- + abs(cos(t() / 10))
ty = 64 + sin(a*2 + x / (40*b)) * 10
dd = abs(ty-y)
col = dd < 4 and 7 or dd < 8 and 12 or 1

--if rnd() < 0.01 then
--    copy_noise_small()
--    --dump_noise(0.1)
--end

if rnd() < 0.0001 then
    dump_noise(0.1)
end

if rnd() < 0.001 then
    copy_noise()
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
