pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

body_x = 10
body_y = 44

foot = {
    x=body_x,
    y=body_y+16,
    target_x = nil,
    target_y = nil,
    top_bone_angle = 0
}


function dist2(x, y, x2, y2)
    return (x-x2)*(x-x2)+(y-y2)*(y-y2)
end

function lerp(x, x0, k)
    return (x + (k-1)*x0) / k
end

t = 0

function update_foot(foot, vel)

    if foot.target_x == nil then
        local k = 6 * vel
        --if foot.x < body_x and dist2(body_x, body_y, foot.x, foot.y) > k*k then
        if body_x - foot.x > k then
            foot.target_x = body_x + 13 * vel
            foot.target_y = foot.y
        end
    else
        foot.x = lerp(foot.target_x, foot.x, 3)
        foot.y = lerp(foot.target_y, foot.y, 3)

        if dist2(foot.x, foot.y, foot.target_x, foot.target_y) < 4*4 then
            foot.target_x = nil
            foot.target_y = nil
        end
    end

    local exagerated_delta_x = (foot.x - body_x) * 3.5 -- (foot.x - body_x)
    local ideal_angle = atan2(exagerated_delta_x, foot.y - body_y)
    --local ideal_angle = atan2(foot.x - body_x, foot.y - body_y)
    --local ideal_angle = atan2(body_x - foot.x, body_y - foot.y)
    foot.top_bone_angle = lerp(ideal_angle, foot.top_bone_angle, 3)
end

::_::
cls(0)

t += 1

vel = 2 + sin(t / 53)
body_y = 36 + 4 * vel

update_foot(foot, vel)
--line(body_x, body_y, foot.x, foot.y, 5)

local len = 8
local xx = body_x + len * cos(foot.top_bone_angle)
local yy = body_y + len * sin(foot.top_bone_angle)
line(body_x, body_y, xx, yy, 5)
line(xx, yy, foot.x, foot.y, 5)

circ(body_x, body_y, 4, 5)
body_x += vel

if body_x > 128 then
    body_x = 0
    foot.target_x = nil
    foot.target_y = nil
    foot.x = 0
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
