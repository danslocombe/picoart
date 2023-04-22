pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

-- mouse support
poke(0x5f2d, 1)

body_x = 10
body_y_0 = 38
body_y = body_y_0

foot = {
    x=body_x,
    y=body_y+24,
    target_x = nil,
    target_y = nil,
    --top_bone_angle = 0
}


function dist2(x, y, x2, y2)
    return (x-x2)*(x-x2)+(y-y2)*(y-y2)
end

function lerp(x, x0, k)
    return (x + (k-1)*x0) / k
end

function lerp_angle(x, x0, k)
    return lerp(x + 1, x0 + 1, k) - 1
end

t = 0

local top_len = 12
local bottom_len = 16
local top_len2 = top_len * top_len
local bottom_len2 = bottom_len * bottom_len

local total_leg_len = top_len + bottom_len
local total_leg_len_2 = total_leg_len * total_leg_len

function update_foot(foot, vel)

    if foot.target_x == nil then
        local d2 = dist2(body_x, body_y, foot.x, foot.y)
        local stretch_factor = 0.94
        --print(sqrt(d2), 64, 10, 8)
        --print(sqrt(total_leg_len_2), 64, 20, 8)
        --local k = 8 * vel
        if foot.x < body_x and (1.5 / vel) * d2 > stretch_factor * total_leg_len_2 then
        --if body_x - foot.x > k then
            --foot.target_x = body_x + 13 * vel
            local yy = (foot.y - body_y) * (foot.y - body_y)
            local in_front = sqrt(total_leg_len_2 - yy)
            --print(body_y, 10, 10, 7)
            --print(yy, 10, 16, 7)
            --print(total_leg_len_2, 10, 26, 7)
            --print((total_leg_len_2 - yy), 10, 35, 7)
            --print(in_front, 10, 40, 7)
            --foot.target_x = body_x + 13 * vel
            local hack_factor = 1.5
            foot.target_x = body_x + hack_factor * in_front
            foot.target_y = foot.y
        end
    else
        foot.x = lerp(foot.target_x, foot.x, 3)
        foot.y = lerp(foot.target_y, foot.y, 3)

        if dist2(foot.x, foot.y, foot.target_x, foot.target_y) < 1 then
            foot.target_x = nil
            foot.target_y = nil
        end
    end

    --local exagerated_delta_x = (foot.x - body_x) * 3.5 -- (foot.x - body_x)
    --local ideal_angle = atan2(exagerated_delta_x, foot.y - body_y)
    ----local ideal_angle = atan2(foot.x - body_x, foot.y - body_y)
    ----local ideal_angle = atan2(body_x - foot.x, body_y - foot.y)
    --foot.top_bone_angle = lerp(ideal_angle, foot.top_bone_angle, 3)
end

--function acos(x)
-- return atan2(x,sqrt(1-x*x))
--    --return atan2(sqrt(1-x*x), x)
--end

function acos(x)
  local negate = (x < 0 and 1.0 or 0.0)
  x = abs(x)
  local ret = -0.0187293
  ret *= x
  ret += 0.0742610
  ret *= x
  ret -= 0.2121144
  ret *= x
  ret += 1.5707288
  ret *= sqrt(1.0-x)
  ret -= 2 * negate * ret
  local dan_hack = negate * 3.14159265358979 + ret
  return dan_hack / (2 * 3.14159265358979)
end

top_joint = 0
bottom_joint = 0

joint_x = 0
joint_y = 0
foot_x = 0
foot_y = 0

::_::
cls(0)

mouse_x = stat(32)-1
mouse_y = stat(33)-1

t += 1

vel = 2 + sin(t / 53)
--vel = 0

body_y = body_y_0 + 4 * vel


update_foot(foot, vel)

--foot.x = mouse_x
--foot.y = mouse_y

--line(body_x, body_y, foot.x, foot.y, 5)

--local len = 8
--local xx = body_x + len * cos(foot.top_bone_angle)
--local yy = body_y + len * sin(foot.top_bone_angle)
--line(body_x, body_y, xx, yy, 5)
--line(xx, yy, foot.x, foot.y, 5)


local x_off = (foot.x - body_x)
local y_off = (foot.y - body_y)
local x_off2 = x_off * x_off
local y_off2 = y_off * y_off

local bottom_joint_new = -acos((x_off2 + y_off2 - top_len2 - bottom_len2) / (2 * top_len * bottom_len))

--bottom_joint = lerp_angle(bottom_joint_new, bottom_joint, 3)
bottom_joint = bottom_joint_new
local top_joint_new = atan2(y_off, x_off) - atan2(bottom_len * sin(bottom_joint), top_len + bottom_len * cos(bottom_joint))
--top_joint = lerp_angle(top_joint_new, top_joint, 3)
top_joint = top_joint_new

local pos_k = 2

joint_x = lerp(body_x + top_len * cos(-top_joint), joint_x, pos_k)
joint_y = lerp(body_y + top_len * sin(-top_joint), joint_y, pos_k)

foot_x = lerp(joint_x + bottom_len * cos(-top_joint + bottom_joint), foot_x, pos_k)
foot_y = lerp(joint_y + bottom_len * sin(-top_joint + bottom_joint), foot_y, pos_k)

line(body_x, body_y, joint_x, joint_y, 3)
line(joint_x, joint_y, foot_x, foot_y, 1)
--line(joint_x, joint_y, foot.x, foot.y, 7)


circ(body_x, body_y, 4, 2)
body_x += vel

if body_x > 128 then
    body_x = 0
    foot.target_x = nil
    foot.target_y = nil
    foot.x = 0
    joint_x = 0
    foot_x = 0
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
