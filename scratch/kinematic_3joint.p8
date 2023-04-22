pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

-- mouse support
poke(0x5f2d, 1)

body_x = 64
body_y_0 = 44
body_y = body_y_0

foot = {
    x=body_x,
    y=body_y+34,
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

local top_len = 8
local mid_len = 12
local bottom_len = 16
local top_len2 = top_len * top_len
local mid_len2 = mid_len * mid_len
local bottom_len2 = bottom_len * bottom_len

local total_leg_len = top_len + mid_len + bottom_len
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

function asin(x)
  local negate = (x < 0 and 1.0 or 0.0)
  x = abs(x)
  local ret = -0.0187293
  ret *= x
  ret += 0.0742610
  ret *= x
  ret -= 0.2121144
  ret *= x
  ret += 1.5707288
  ret = 3.14159265358979*0.5 - sqrt(1.0 - x)*ret
  local dan_hack = ret - 2 * negate * ret
  return dan_hack / (2 * 3.14159265358979)
end

top_joint = 0
mid_joint = 0
bottom_joint = 0

joint_x = 0
joint_y = 0
mid_x = 0
mid_y = 0
foot_x = 0
foot_y = 0

::_::
cls(0)

-- guidelines
--line(body_x, 0, body_x, 128, 5)
--line(body_x - 128, body_y - 128, body_x + 128, body_y + 128, 5)
--line(body_x + 128, body_y - 128, body_x - 128, body_y + 128, 5)
--line(0, body_y, 128, body_y, 5)
--circ(body_x, body_y, total_leg_len, 5)

mouse_x = stat(32)-1
mouse_y = stat(33)-1

t += 1

vel = 2 + sin(t / 53)
--vel = 0

body_y = body_y_0 + 4 * vel


--foot.x = mouse_x
--foot.y = mouse_y
update_foot(foot, vel)


local x_off_end = (foot.x - body_x)
local y_off_end = (foot.y - body_y)

local gamma = atan2(x_off_end, y_off_end) -- + 0.2 * sin(t / 100)

local x3_off = ((foot.x - bottom_len * cos(gamma)) - body_x)
local y3_off = ((foot.y - bottom_len * sin(gamma)) - body_y)

local x3_off2 = x3_off * x3_off
local y3_off2 = y3_off * y3_off

local alpha_num = (x3_off2 + y3_off2 - top_len2 - mid_len2)
local alpha_denom = (2 * top_len * mid_len)

--print(alpha_num, 80, 10, 7)
--print(alpha_denom, 80, 20, 7)
print(alpha_num / alpha_denom, 80, 10, 7)

local alpha = acos(alpha_num / alpha_denom)
print(alpha, 80, 20, 7)

local beta_num = (mid_len * sin(alpha))
local beta_denom = sqrt(x3_off2 + y3_off2)
--print(beta_num, 80, 80, 7)
--print(beta_denom, 80, 90, 7)
local beta = asin( beta_num / beta_denom)
--print(beta, 80, 110, 7)
top_joint = atan2(x3_off, y3_off) + beta
mid_joint = ( - alpha )

local pos_k = 2

joint_x = lerp(body_x + top_len * cos(top_joint), joint_x, pos_k)
joint_y = lerp(body_y + top_len * sin(top_joint), joint_y, pos_k)

print(top_joint, 10, 10, 7)
print(mid_joint, 10, 20, 7)

mid_x = lerp(joint_x + mid_len * cos(top_joint - mid_joint), mid_x, pos_k)
mid_y = lerp(joint_y + mid_len * sin(top_joint - mid_joint), mid_y, pos_k)

bottom_joint = atan2(foot.x - mid_x, foot.y - mid_y)

foot_x = lerp(mid_x + bottom_len * cos(bottom_joint), foot_x, pos_k)
foot_y = lerp(mid_y + bottom_len * sin(bottom_joint), foot_y, pos_k)

line(body_x, body_y, joint_x, joint_y, 12)
line(joint_x, joint_y, mid_x, mid_y, 14)
circ(mid_x, mid_y, 2, 15)
line(mid_x, mid_y, foot_x, foot_y, 10)

--circ(mouse_x, mouse_y, 2, 6)
circ(foot.x, foot.y, 2, 6)


circ(body_x, body_y, 4, 11)
body_x += vel

if body_x > 128 then
    body_x = 0
    foot.target_x = nil
    foot.target_y = nil
    foot.x = 0
    joint_x = 0
    foot_x = 0
    mid_x = 0
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
