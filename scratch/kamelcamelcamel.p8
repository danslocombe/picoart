pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

-- inverse kinematics taken from
-- https://hive.blog/hive-196387/@juecoree/forward-and-reverse-kinematics-for-3r-planar-manipulator

t = 0
floor = 80
particles = {}
animals = {}

function make_camel()
    local body_x = 90
    local body_y_0 = 40
    local body_y = body_y_0

    local head_x = body_x
    local head_y = body_y

    local top_len = 8
    local mid_len = 12
    local bottom_len = 16

    local total_leg_len = top_len + mid_len + bottom_len
    local body_len_r = 16


    local feet = {}
    add(feet, make_foot(body_x, false))
    add(feet, make_foot(body_x + 25, false))
    add(feet, make_foot(body_x + 32, true))
    add(feet, make_foot(body_x + 48, true))

    local legs = {}
    add(legs, make_leg(false))
    add(legs, make_leg(false))
    add(legs, make_leg(true))
    add(legs, make_leg(true))

    return {
        body_x = body_x,
        body_y_0 = body_y_0,
        body_y = body_y,

        head_x = head_x,
        head_y = head_y,

        top_len = top_len,
        mid_len = mid_len,
        bottom_len = bottom_len,
        top_len2 = top_len * top_len,
        mid_len2 = mid_len * mid_len,
        bottom_len2 = bottom_len * bottom_len,

        total_leg_len = total_leg_len,
        total_leg_len_2 = total_leg_len * total_leg_len,

        body_len_r = body_len_r,

        feet = feet,
        legs = legs,
    }
end

function make_bipedal()
    local body_x = 10
    local body_y_0 = 30
    local body_y = body_y_0

    local head_x = body_x
    local head_y = body_y

    local top_len = 6
    local mid_len = 16
    local bottom_len = 24

    local total_leg_len = top_len + mid_len + bottom_len
    local body_len_r = 5


    local feet = {}
    add(feet, make_foot(body_x, false))
    add(feet, make_foot(body_x + 25, false))

    local legs = {}
    add(legs, make_leg(false))
    add(legs, make_leg(true))

    return {
        body_x = body_x,
        body_y_0 = body_y_0,
        body_y = body_y,

        head_x = head_x,
        head_y = head_y,

        top_len = top_len,
        mid_len = mid_len,
        bottom_len = bottom_len,
        top_len2 = top_len * top_len,
        mid_len2 = mid_len * mid_len,
        bottom_len2 = bottom_len * bottom_len,

        total_leg_len = total_leg_len,
        total_leg_len_2 = total_leg_len * total_leg_len,

        body_len_r = body_len_r,

        feet = feet,
        legs = legs,
    }
end

function make_pede()
    local body_x = 10
    local body_y_0 = 55
    local body_y = body_y_0

    local head_x = body_x
    local head_y = body_y

    local top_len = 32
    local mid_len = 16
    local bottom_len = 4

    local total_leg_len = top_len + mid_len + bottom_len
    local body_len_r = 5

    local leg_pair_count = 1

    local feet = {}
    local legs = {}

    local offset = 0
    for i=0,leg_pair_count do
        add(feet, make_foot(body_x + offset, false))
        add(feet, make_foot(body_x + offset + 25, false))
        add(legs, make_leg(false))
        add(legs, make_leg(true))
        offset -= 12
    end

    return {
        body_x = body_x,
        body_y_0 = body_y_0,
        body_y = body_y,

        head_x = head_x,
        head_y = head_y,

        top_len = top_len,
        mid_len = mid_len,
        bottom_len = bottom_len,
        top_len2 = top_len * top_len,
        mid_len2 = mid_len * mid_len,
        bottom_len2 = bottom_len * bottom_len,

        total_leg_len = total_leg_len,
        total_leg_len_2 = total_leg_len * total_leg_len,

        body_len_r = body_len_r,
        leg_pair_count = leg_pair_count,

        feet = feet,
        legs = legs,
    }
end

function make_foot(x, front)
    return {
        x=x,
        y=floor,
        lerp_r = 0,
        lerp_k = 0,
        lerp_cx = 0,
        target_x = nil,
        target_y = nil,
        front = front,
        stomped_this_cycle = false,
    }
end

function make_leg(front)
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
        front = front,
    }
end

function update_foot(animal, foot, vel, body_x, body_y)

    if foot.target_x == nil then
        local d2 = dist2(body_x, body_y, foot.x, foot.y)
        local stretch_factor = 0.64
        if foot.front then
            stretch_factor *= 0.2
        else
            stretch_factor *= 0.6
        end
        --print(sqrt(d2), 64, 10, 8)
        --print(sqrt(total_leg_len_2), 64, 20, 8)
        --local k = 8 * vel
        --if foot.x < body_x and (1.5 / vel) * d2 > stretch_factor * total_leg_len_2 then
        if foot.x < body_x and 0.5 * d2 > stretch_factor * animal.total_leg_len_2 then
        --if body_x - foot.x > k then
            --foot.target_x = body_x + 13 * vel
            local yy = (foot.y - body_y) * (foot.y - body_y)
            local in_front = sqrt(animal.total_leg_len_2 - yy)
            --print(body_y, 10, 10, 7)
            --print(yy, 10, 16, 7)
            --print(total_leg_len_2, 10, 26, 7)
            --print((total_leg_len_2 - yy), 10, 35, 7)
            --print(in_front, 10, 40, 7)
            --foot.target_x = body_x + 13 * vel
            --local hack_factor = 1.5 -- + rnd(1)
            local hack_factor = 1.7
            if foot.front then
                hack_factor *= 1.1
            end
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

            for i = 0,4 do
                local d = 3
                local theta = rnd()
                add(particles, {
                    x = foot.x + d * cos(theta),
                    y = foot.y + d * sin(theta),
                    yvel = -0.6,
                    size = 3,
                })
            end
        end
    end

    circ(foot.x, foot.y, 2, 6)
    --local exagerated_delta_x = (foot.x - body_x) * 3.5 -- (foot.x - body_x)
    --local ideal_angle = atan2(exagerated_delta_x, foot.y - body_y)
    ----local ideal_angle = atan2(foot.x - body_x, foot.y - body_y)
    ----local ideal_angle = atan2(body_x - foot.x, body_y - foot.y)
    --foot.top_bone_angle = lerp(ideal_angle, foot.top_bone_angle, 3)
end

function update_leg(animal, foot, leg, body_x, body_y, actual_body_x)
    local x_off_end = (foot.x - actual_body_x)
    if leg.front then
        x_off_end = (foot.x - body_x)
    end
    local y_off_end = (foot.y - body_y)

    local gamma = atan2(x_off_end, y_off_end) -- + 0.2 * sin(t / 100)

    local x3_off = ((foot.x - animal.bottom_len * cos(gamma)) - body_x)
    local y3_off = ((foot.y - animal.bottom_len * sin(gamma)) - body_y)

    local x3_off2 = x3_off * x3_off
    local y3_off2 = y3_off * y3_off

    local alpha_num = (x3_off2 + y3_off2 - animal.top_len2 - animal.mid_len2)
    local alpha_denom = (2 * animal.top_len * animal.mid_len)

    --print(alpha_num, 80, 10, 7)
    --print(alpha_denom, 80, 20, 7)

    local alpha = acos(alpha_num / alpha_denom)

    local beta_num = (animal.mid_len * sin(alpha))
    local beta_denom = sqrt(x3_off2 + y3_off2)
    --print(beta_num, 80, 80, 7)
    --print(beta_denom, 80, 90, 7)
    local beta = asin( beta_num / beta_denom)
    --print(beta, 80, 110, 7)
    leg.top_joint = atan2(x3_off, y3_off) - beta
    leg.mid_joint = ( alpha )

    local pos_k = 2

    leg.joint_x = lerp(body_x + animal.top_len * cos(leg.top_joint), leg.joint_x, pos_k)
    leg.joint_y = lerp(body_y + animal.top_len * sin(leg.top_joint), leg.joint_y, pos_k)

    leg.mid_x = lerp(leg.joint_x + animal.mid_len * cos(leg.top_joint - leg.mid_joint), leg.mid_x, pos_k)
    leg.mid_y = lerp(leg.joint_y + animal.mid_len * sin(leg.top_joint - leg.mid_joint), leg.mid_y, pos_k)

    leg.bottom_joint = atan2(foot.x - leg.mid_x, foot.y - leg.mid_y)

    leg.foot_x = lerp(leg.mid_x + animal.bottom_len * cos(leg.bottom_joint), leg.foot_x, pos_k)
    leg.foot_y = lerp(leg.mid_y + animal.bottom_len * sin(leg.bottom_joint), leg.foot_y, pos_k)

    line(body_x, body_y, leg.joint_x, leg.joint_y, 12)
    line(leg.joint_x, leg.joint_y, leg.mid_x, leg.mid_y, 14)
    circ(leg.mid_x, leg.mid_y, 2, 15)
    line(leg.mid_x, leg.mid_y, leg.foot_x, leg.foot_y, 10)
end

function update_bipedal(animal, t)
    vel = 2 + 0.2 * sin(t / 53)
    animal.body_y = animal.body_y_0 + 6 * vel

    update_foot(animal, animal.feet[1], vel, animal.body_x, animal.body_y)
    update_foot(animal, animal.feet[2], vel, animal.body_x, animal.body_y)
    update_leg(animal, animal.feet[1], animal.legs[1], animal.body_x, animal.body_y - 30, animal.body_x)
    update_leg(animal, animal.feet[2], animal.legs[2], animal.body_x, animal.body_y - 30, animal.body_x)

    for i = 0,2*animal.body_len_r do
        local xx = animal.body_x - animal.body_len_r + i
        pset(xx, animal.body_y - 4 - 8 * sin(i / (4 * animal.body_len_r)), 12)
    end

    for i = 0,2*animal.body_len_r - 10 do
        local xx = animal.body_x - animal.body_len_r + 5 + i + 2 * vel - 2
        pset(xx, animal.body_y - 8 + 6 * sin(i / (4 * animal.body_len_r - 20)), 12)
    end

    animal.head_x = lerp(animal.body_x + (vel - 1.5) * 15, animal.head_x, 3)
    animal.head_y = lerp(animal.body_y - 23 + vel * 2, animal.head_y, 3)
    circ(animal.head_x, animal.head_y, 3, 7)
    circ(animal.head_x+4, animal.head_y, 2, 7)
    circ(animal.head_x-2, animal.head_y-2, 2, 7)

    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y-8, animal.body_x + animal.body_len_r * 2, animal.body_y-8, animal.head_x-2, animal.head_y + 8, animal.head_x-2, animal.head_y, 24, 3)
    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y, animal.body_x + animal.body_len_r * 2, animal.body_y, animal.head_x+2, animal.head_y + 8, animal.head_x+2, animal.head_y, 24, 3)

    animal.body_x += vel
    wrap_animal(animal)
end

function update_pede(animal, t)
    vel = 2 + 0.2 * sin(t / 53)
    animal.body_y = animal.body_y_0 + 6 * vel

    local offset = 0
    for i=0,animal.leg_pair_count do
        local leg_body_y = animal.body_y - 20
        local index = 1 + 2*i
        update_foot(animal, animal.feet[index], vel, animal.body_x + offset, leg_body_y)
        update_foot(animal, animal.feet[index+1], vel, animal.body_x + offset, leg_body_y)
        update_leg(animal, animal.feet[index], animal.legs[index], animal.body_x + offset, leg_body_y, animal.body_x + offset)
        update_leg(animal, animal.feet[index+1], animal.legs[index+1], animal.body_x + offset, leg_body_y, animal.body_x + offset)
        offset -= 12
    end

    --update_foot(animal, animal.feet[1], vel, animal.body_x, animal.body_y)
    --update_foot(animal, animal.feet[2], vel, animal.body_x, animal.body_y)
    --update_leg(animal, animal.feet[1], animal.legs[1], animal.body_x, animal.body_y, animal.body_x)
    --update_leg(animal, animal.feet[2], animal.legs[2], animal.body_x, animal.body_y, animal.body_x)

    for i = 0,2*animal.body_len_r do
        local xx = animal.body_x - animal.body_len_r + i
        pset(xx, animal.body_y - 4 - 8 * sin(i / (4 * animal.body_len_r)), 12)
    end

    for i = 0,2*animal.body_len_r - 10 do
        local xx = animal.body_x - animal.body_len_r + 5 + i + 2 * vel - 2
        pset(xx, animal.body_y - 8 + 6 * sin(i / (4 * animal.body_len_r - 20)), 12)
    end

    animal.head_x = lerp(animal.body_x + (vel) * 15, animal.head_x, 3)
    animal.head_y = lerp(animal.body_y - 2 + vel * 2, animal.head_y, 3)
    circ(animal.head_x, animal.head_y, 3, 7)
    circ(animal.head_x+4, animal.head_y, 2, 7)
    circ(animal.head_x-2, animal.head_y-2, 2, 7)

    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y, animal.body_x + animal.body_len_r * 2, animal.body_y-8, animal.head_x-2, animal.head_y + 8, animal.head_x-2, animal.head_y, 24, 3)
    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y+8, animal.body_x + animal.body_len_r * 2, animal.body_y, animal.head_x+2, animal.head_y + 8, animal.head_x+2, animal.head_y, 24, 3)

    animal.body_x += vel
    wrap_animal(animal)
end

function update_camel(animal, t)
    vel = 2 + 0.2 * sin(t / 53)
    animal.body_y = animal.body_y_0 + 6 * vel

    update_foot(animal, animal.feet[1], vel, animal.body_x - animal.body_len_r, animal.body_y)
    update_foot(animal, animal.feet[2], vel, animal.body_x - animal.body_len_r, animal.body_y)
    update_leg(animal, animal.feet[1], animal.legs[1], animal.body_x - animal.body_len_r, animal.body_y, animal.body_x)
    update_leg(animal, animal.feet[2], animal.legs[2], animal.body_x - animal.body_len_r, animal.body_y, animal.body_x)

    update_foot(animal, animal.feet[3], vel, animal.body_x + animal.body_len_r, animal.body_y)
    update_foot(animal, animal.feet[4], vel, animal.body_x + animal.body_len_r, animal.body_y)
    update_leg(animal, animal.feet[3], animal.legs[3], animal.body_x + animal.body_len_r, animal.body_y, animal.body_x)
    update_leg(animal, animal.feet[4], animal.legs[4], animal.body_x + animal.body_len_r, animal.body_y, animal.body_x)

    circ(animal.body_x - animal.body_len_r, animal.body_y, 4, 11)
    circ(animal.body_x + animal.body_len_r, animal.body_y, 4, 11)

    circ(animal.body_x - animal.body_len_r + 4, animal.body_y - 2, 8, 12)
    circ(animal.body_x + animal.body_len_r - 2, animal.body_y - 2, 8, 12)

    for i = 0,2*animal.body_len_r do
        local xx = animal.body_x - animal.body_len_r + i
        pset(xx, animal.body_y - 4 - 8 * sin(i / (4 * animal.body_len_r)), 12)
    end

    for i = 0,2*animal.body_len_r - 10 do
        local xx = animal.body_x - animal.body_len_r + 5 + i + 2 * vel - 2
        pset(xx, animal.body_y - 8 + 6 * sin(i / (4 * animal.body_len_r - 20)), 12)
    end

    animal.head_x = lerp(animal.body_x + 28 + vel * 10, animal.head_x, 3)
    animal.head_y = lerp(animal.body_y - 23 + vel * 2, animal.head_y, 3)
    circ(animal.head_x, animal.head_y, 3, 7)
    circ(animal.head_x+4, animal.head_y, 2, 7)
    circ(animal.head_x-2, animal.head_y-2, 2, 7)

    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y-8, animal.body_x + animal.body_len_r * 2, animal.body_y-8, animal.head_x-2, animal.head_y + 8, animal.head_x-2, animal.head_y, 24, 3)
    draw_bezier(animal.body_x + animal.body_len_r, animal.body_y, animal.body_x + animal.body_len_r * 2, animal.body_y, animal.head_x+2, animal.head_y + 8, animal.head_x+2, animal.head_y, 24, 3)

    --fill_double_bez({
    --    x0 = body_x + body_len_r,
    --    y0 = body_y-8,
    --    x1 = body_x + body_len_r * 2,
    --    y1 = body_y-8, 
    --    x2 = head_x-2,
    --    y2 = head_y + 8,
    --    x3 = head_x-2,
    --    y3 = head_y
    --},
    --{
    --    x0 = body_x + body_len_r,
    --    y0 = body_y,
    --    x1 = body_x + body_len_r * 2,
    --    y1 = body_y, 
    --    x2 = head_x-2,
    --    y2 = head_y + 8,
    --    x3 = head_x-2,
    --    y3 = head_y
    --}, 24, 3)

    --for x = body_x + body_len_r,head_x do
    --    local i = x - (body_x + body_len_r)
    --    local i_norm = i / (head_x - (body_x + body_len_r))
    --    y = body_y + (head_y - body_y) * i_norm
    --    pset(x, y, 3)
    --end

    animal.body_x += vel
    wrap_animal(animal)
end

function wrap_animal(animal)
    wrap = 128 + 74
    if animal.body_x > 128 + 24 then
        animal.head_x -= wrap
        animal.body_x -= wrap
        for i,o in pairs(animal.feet) do
            if o.target_x != nil then
                o.target_x -= wrap
                o.lerp_cx -= wrap
            end
            o.x -= wrap
            --o.y = floor
        end

        for i,o in pairs(animal.legs) do
            o.joint_x -= wrap
            o.foot_x -= wrap
            o.mid_x -= wrap
        end
    end
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

function fill_double_bez(c0, c1, k, col)
    for i = 0,k do
        local t = i/k
        local t2 = t*t
        local t3 = t2*t
        local inv_t = 1-t
        local inv_t2 = inv_t * inv_t
        local inv_t3 = inv_t2 * inv_t
        local k1 = 3*inv_t2*t
        local k2 = 3*inv_t*t2

        local x0 = inv_t3*c0.x0 + k1*c0.x1 + k2*c0.x2 + t3*c0.x3
        local y0 = inv_t3*c0.y0 + k1*c0.y1 + k2*c0.y2 + t3*c0.y3

        local x1 = inv_t3*c1.x0 + k1*c1.x1 + k2*c1.x2 + t3*c1.x3
        local y1 = inv_t3*c1.y0 + k1*c1.y1 + k2*c1.y2 + t3*c1.y3

        line(x0, y0, x1, y1, col)
    end
end

function dist2(x, y, x2, y2)
    return (x-x2)*(x-x2)+(y-y2)*(y-y2)
end

function lerp(x, x0, k)
    return (x + (k-1)*x0) / k
end

function lerp_angle(x, x0, k)
    return lerp(x + 1, x0 + 1, k) - 1
end

--local camel = make_camel()
--local bipedal = make_bipedal()
local pede = make_pede()

::_::
cls(0)

t += 1
--update_camel(camel, t)
--update_bipedal(bipedal, t)
update_pede(pede, t)

for i,p in pairs(particles) do
    p.yvel += 0.04
    p.y += p.yvel
    p.size = p.size * 0.9
    if p.size < 0.01 or p.yvel > 0.1 then
        del(particles, p)
    end

    local half_size = p.size * 0.5
    rectfill(p.x -half_size, p.y - half_size, p.x + half_size, p.y + half_size, 7)
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
