pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

-- inverse kinematics taken from
-- https://hive.blog/hive-196387/@juecoree/forward-and-reverse-kinematics-for-3r-planar-manipulator

body_x = 10
body_y_0 = 40
body_y = body_y_0

head_x = body_x
head_y = body_y

floor = body_y + 40

function draw_bezier(x0, y0, x1, y1, x2, y2, x3, y3, k, col)
    for i = 0,k do
        local t = i/k
        local t2 = t*t
        local t3 = t2*t
        local inv_t = 1-t
        local inv_t2 = inv_t * inv_t
        local inv_t3 = inv_t2 * inv_t
        local k1 = 3*inv_t2*t
        local k2 = 3*inv_t*t2
        local x = inv_t3*x0 + k1*x1 + k2*x2 + t3*x3
        local y = inv_t3*y0 + k1*y1 + k2*y2 + t3*y3
        pset(x, y, col)
    end
end

function make_foot(x)
    return {
        x=x,
        y=floor,
        lerp_r = 0,
        lerp_k = 0,
        lerp_cx = 0,
        target_x = nil,
        target_y = nil,
    }
end

feet = {}
foot = make_foot(body_x)
add(feet, foot)
foot2 = make_foot(body_x + 25)
add(feet, foot2)
foot3 = make_foot(body_x + 32)
add(feet, foot3)
foot4 = make_foot(body_x + 48)
add(feet, foot4)


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

function make_leg()
    return {
        top_joint = 0,
        mid_joint = 0,
        bottom_joint = 0,

        joint_x = 0,
        joint_y = 0,
        mid_x = 0,
        mid_y = 0,
        foot_x = 0,
        foot_y = 0,
    }
end

legs = {}
leg = make_leg()
add(legs, leg)
leg2 = make_leg()
add(legs, leg2)
leg3 = make_leg()
add(legs, leg3)
leg4 = make_leg()
add(legs, leg4)

function update_foot(foot, vel, body_x, body_y)

    if foot.target_x == nil then
        local d2 = dist2(body_x, body_y, foot.x, foot.y)
        local stretch_factor = 0.64
        --print(sqrt(d2), 64, 10, 8)
        --print(sqrt(total_leg_len_2), 64, 20, 8)
        --local k = 8 * vel
        --if foot.x < body_x and (1.5 / vel) * d2 > stretch_factor * total_leg_len_2 then
        if foot.x < body_x and 0.5 * d2 > stretch_factor * total_leg_len_2 then
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
            --local hack_factor = 1.5 -- + rnd(1)
            local hack_factor = 1.7
            foot.target_x = body_x + hack_factor * in_front
            foot.target_y = foot.y

            foot.lerp_r = (foot.target_x - foot.x) / 2
            foot.lerp_cx = (foot.target_x + foot.x) / 2
        end
    else
        -- circular lerp
        --foot.x = lerp(foot.target_x, foot.x, 3)
        --foot.y = lerp(foot.target_y, foot.y, 3)

        foot.lerp_k += 0.05
        foot.x = foot.lerp_cx + foot.lerp_r * cos(0.5 - foot.lerp_k)
        foot.y = foot.target_y + 0.25 * foot.lerp_r * sin(0.5 - foot.lerp_k)

        if dist2(foot.x, foot.y, foot.target_x, foot.target_y) < 1 then
            foot.x = foot.target_x
            foot.y = foot.target_y
            foot.lerp_k = 0
            foot.target_x = nil
            foot.target_y = nil
        end
    end

    circ(foot.x, foot.y, 2, 6)
    --local exagerated_delta_x = (foot.x - body_x) * 3.5 -- (foot.x - body_x)
    --local ideal_angle = atan2(exagerated_delta_x, foot.y - body_y)
    ----local ideal_angle = atan2(foot.x - body_x, foot.y - body_y)
    ----local ideal_angle = atan2(body_x - foot.x, body_y - foot.y)
    --foot.top_bone_angle = lerp(ideal_angle, foot.top_bone_angle, 3)
end

function update_leg(foot, leg, body_x, body_y, actual_body_x)
    local x_off_end = (foot.x - actual_body_x)
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

    local alpha = acos(alpha_num / alpha_denom)

    local beta_num = (mid_len * sin(alpha))
    local beta_denom = sqrt(x3_off2 + y3_off2)
    --print(beta_num, 80, 80, 7)
    --print(beta_denom, 80, 90, 7)
    local beta = asin( beta_num / beta_denom)
    --print(beta, 80, 110, 7)
    leg.top_joint = atan2(x3_off, y3_off) - beta
    leg.mid_joint = ( alpha )

    local pos_k = 2

    leg.joint_x = lerp(body_x + top_len * cos(leg.top_joint), leg.joint_x, pos_k)
    leg.joint_y = lerp(body_y + top_len * sin(leg.top_joint), leg.joint_y, pos_k)

    leg.mid_x = lerp(leg.joint_x + mid_len * cos(leg.top_joint - leg.mid_joint), leg.mid_x, pos_k)
    leg.mid_y = lerp(leg.joint_y + mid_len * sin(leg.top_joint - leg.mid_joint), leg.mid_y, pos_k)

    leg.bottom_joint = atan2(foot.x - leg.mid_x, foot.y - leg.mid_y)

    leg.foot_x = lerp(leg.mid_x + bottom_len * cos(leg.bottom_joint), leg.foot_x, pos_k)
    leg.foot_y = lerp(leg.mid_y + bottom_len * sin(leg.bottom_joint), leg.foot_y, pos_k)

    line(body_x, body_y, leg.joint_x, leg.joint_y, 12)
    line(leg.joint_x, leg.joint_y, leg.mid_x, leg.mid_y, 14)
    circ(leg.mid_x, leg.mid_y, 2, 15)
    line(leg.mid_x, leg.mid_y, leg.foot_x, leg.foot_y, 10)
end

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


::_::
cls(0)

t += 1

--vel = 2 + sin(t / 53)
vel = 2 + 0.5 * sin(t / 53)
--vel = 1.5
--vel = 0

body_y = body_y_0 + 6 * vel


--foot.x = mouse_x
--foot.y = mouse_y
body_len_r = 16
update_foot(foot, vel, body_x - body_len_r, body_y)
update_foot(foot2, vel, body_x - body_len_r, body_y)
update_leg(foot, leg, body_x - body_len_r, body_y, body_x)
update_leg(foot2, leg2, body_x - body_len_r, body_y, body_x)

update_foot(foot3, vel, body_x + body_len_r, body_y)
update_foot(foot4, vel, body_x + body_len_r, body_y)
update_leg(foot3, leg3, body_x + body_len_r, body_y, body_x)
update_leg(foot4, leg4, body_x + body_len_r, body_y, body_x)

circ(body_x - body_len_r, body_y, 4, 11)
circ(body_x + body_len_r, body_y, 4, 11)

circ(body_x - body_len_r + 4, body_y - 2, 8, 12)
circ(body_x + body_len_r - 2, body_y - 2, 8, 12)

for i = 0,2*body_len_r do
    local xx = body_x - body_len_r + i
    pset(xx, body_y - 4 - 8 * sin(i / (4 * body_len_r)), 12)
end

for i = 0,2*body_len_r - 10 do
    local xx = body_x - body_len_r + 5 + i + 2 * vel - 2
    pset(xx, body_y - 8 + 6 * sin(i / (4 * body_len_r - 20)), 12)
end

head_x = lerp(body_x + 28 + vel * 10, head_x, 3)
head_y = lerp(body_y - 23 + vel * 2, head_y, 3)
circ(head_x, head_y, 3, 7)
circ(head_x+4, head_y, 2, 7)
circ(head_x-2, head_y-2, 2, 7)

draw_bezier(body_x + body_len_r, body_y-8, body_x + body_len_r * 2, body_y-8, head_x-2, head_y + 8, head_x-2, head_y, 24, 3)
draw_bezier(body_x + body_len_r, body_y, body_x + body_len_r * 2, body_y, head_x+2, head_y + 8, head_x+2, head_y, 24, 3)
--for x = body_x + body_len_r,head_x do
--    local i = x - (body_x + body_len_r)
--    local i_norm = i / (head_x - (body_x + body_len_r))
--    y = body_y + (head_y - body_y) * i_norm
--    pset(x, y, 3)
--end

body_x += vel

 
wrap = 128 + 54
if body_x > 128 + 24 then
    head_x -= wrap
    body_x -= wrap
    for i,o in pairs(feet) do
        if o.target_x != nil then
            o.target_x -= wrap
            o.lerp_cx -= wrap
        end
        o.x -= wrap
        --o.y = floor
    end

    for i,o in pairs(legs) do
        o.joint_x -= wrap
        o.foot_x -= wrap
        o.mid_x -= wrap
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
