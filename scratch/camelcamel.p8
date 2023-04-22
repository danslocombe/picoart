pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

head_x = 60
aa = 0
t = 0

function sqr(a) 
    return a * a
end

k_den = 12
k = 1 / k_den
count = 2/k

::_::
--cls(0)
for i=0,512 do
    circ(rnd(128),40 + rnd(80), 1, 0)
end

-- draw person
person_x = head_x - k_den
local y = 60 - 8 + 4 * sin(k * person_x)
circ(person_x, y, 2, 8)
circ(person_x, y+2, 2, 8)
circ(person_x, y+4, 2, 8)


--camel head
y = 60 + 4 * sin(k * head_x)
line(head_x, y, head_x + 4, y, 9)

local draw_legs_x_min = nil
local draw_legs_x_max = nil

for i=0,count do
    local x = head_x - i
    local y = 60 + 4 * sin(k * x)
    if i == 0 then
        --circ(x, y, 2, 6)
    end
    circ(x, y, 1, 9)
    --local yy = 68 + 8 * abs(sin(0.25 + k * (1 / 3) * x))
    --local yy = 64 + 10 * (sin(x / 40))

    local qi = i - k_den * 0.25
    if qi > k_den * 0 and qi < k_den * 2 then
        if ((head_x) % (k_den)) == 0 then
            local yy = 72 + 4 * abs(sin(k * (3 / 12) * (x)))
            pset(x, yy, 9)
            if draw_legs_x_min == nil then
                draw_legs_x_min = x
            end
            draw_legs_x_max = x
        end
    end
end

if draw_legs_x_min != nil then
    local a0 = -0.25 + aa
    local len = 10
    local y = 76
    line(draw_legs_x_min, y, draw_legs_x_min + len * cos(a0), y + len * sin(a0), 9)
    line(draw_legs_x_max, y, draw_legs_x_max + len * cos(a0), y + len * sin(a0), 9)
    a0 = -0.25 - aa
    line(draw_legs_x_min, y, draw_legs_x_min + len * cos(a0), y + len * sin(a0), 9)
    line(draw_legs_x_max, y, draw_legs_x_max + len * cos(a0), y + len * sin(a0), 9)
end


head_x = (head_x + 1) % 180
aa = 0.08 * sin(t / 16)
t += 1

flip()

goto _

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
