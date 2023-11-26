pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

t = 0

function draw_concentric_circles(x, y, rcount)
    for i=1,rcount do
        local r = i * 4
        local count = 14 -- + 2 * i
        for j=0,count do
            local theta = j/count + t / 400 + r * 0.01
            local xx = x + r * cos(theta)
            local yy = y + r * sin(theta)
            local dtheta = 0.02
            local xx1 = x + r * cos(theta+dtheta)
            local yy1 = y + r * sin(theta+dtheta)
            --circ(xx, yy, 1, 10)
            --line(xx, yy+1, xx1, yy1-1, 14)
            --line(xx, yy, xx1, yy1, 9)
            line(xx, yy, xx1, yy1, 14)
        end
    end
end

function draw_star(x, y, r)
    draw_concentric_circles(x, y, r)
    spr(3, x - 4, y - 4)
end

::_::
t += 1;

cls(0)
--for i=0,256 do
--    circ(rnd(128), rnd(128), 2, 0)
--end

local moon_cx = 88
local moon_cy = 48
draw_concentric_circles(moon_cx, moon_cy, 8)
sspr(8, 0, 16, 16, moon_cx - 16, moon_cy - 16, 32, 32)

draw_star(24, 24, 4)
draw_star(44, 44, 3)
draw_star(54, 14, 3)
draw_star(114, 74, 2)


--for i=0,32 do
--r = t % 46
--if r < 32 then
--    circ(x + 8, y + 8, r, 10 )
--end


flip()


goto _

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000a00a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000000000000000000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000aaa0000000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000aaaaa0000000000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000aaaa00000000a00a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000aaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000