pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

-- mouse support
poke(0x5f2d, 1)

body_x = 64
body_y_0 = 64
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

function make_person(x, y, arm_len, body_len, leg_len)
    --local top_len = 8
    --local mid_len = 14
    --local bottom_len = 12
    local top_len = leg_len
    local mid_len = body_len
    local bottom_len = arm_len
    local top_len2 = top_len * top_len
    local mid_len2 = mid_len * mid_len
    local bottom_len2 = bottom_len * bottom_len

    local total_leg_len = top_len + mid_len + bottom_len
    local total_leg_len_2 = total_leg_len * total_leg_len

    local face_color = 15
    if rnd() < 0.5 then
        face_color = 4
    end

    return {

        body_x = x,
        body_y = y,

        top_len = top_len,
        mid_len = mid_len,
        bottom_len = bottom_len,
        top_len2 = top_len2,
        mid_len2 = mid_len2,
        bottom_len2 = bottom_len2,

        total_leg_len = total_leg_len,
        total_leg_len_2 = total_leg_len_2,

        top_joint = 0,
        mid_joint = 0,
        bottom_joint = 0,
        joint_x = 0,
        joint_y = 0,
        mid_x = 0,
        mid_y = 0,
        foot_x = 0,
        foot_y = 0,
        
        hair_color = flr(rnd(16)),
        jean_color = 12,
        face_color = face_color,
        top_color = 9,
    }
end

people = {}
add(people, make_person(64, 64, 8, 14, 12))
add(people, make_person(32, 69, 9, 13, 12))
add(people, make_person(94, 69, 8, 14, 10))
add(people, make_person(54, 74, 8, 10, 8))
add(people, make_person(32, 79, 9, 10, 8))
add(people, make_person(84, 79, 8, 10, 8))
add(people, make_person(64, 94, 8, 14, 12))
add(people, make_person(32, 99, 9, 13, 12))
add(people, make_person(94, 99, 8, 14, 10))


function update_person(person)

    target_x = mouse_x
    target_y = mouse_y

    local x_off = (target_x - person.body_x)
    local y_off = (target_y - person.body_y)
    local x_off2 = x_off * x_off
    local y_off2 = y_off * y_off

    local alpha = acos((x_off2 + y_off2 - person.top_len2 - person.mid_len2) / (2 * person.top_len * person.mid_len))
    local beta = asin((person.mid_len * sin(alpha)) / sqrt(x_off2 + y_off2))
    person.top_joint = atan2(x_off, y_off) - beta
    person.mid_joint = - ( 0.5 - alpha)

    local pos_k = 2

    person.joint_x = lerp(person.body_x + person.top_len * cos(person.top_joint), person.joint_x, pos_k)
    person.joint_y = lerp(person.body_y + person.top_len * sin(person.top_joint), person.joint_y, pos_k)

    person.mid_x = lerp(person.joint_x + person.mid_len * cos(-person.top_joint + person.mid_joint), person.mid_x, pos_k)
    person.mid_y = lerp(person.joint_y + person.mid_len * sin(-person.top_joint + person.mid_joint), person.mid_y, pos_k)

    person.bottom_joint = atan2(target_x - person.mid_x, target_y - person.mid_y)

    person.foot_x = lerp(person.mid_x + person.bottom_len * cos(person.bottom_joint), person.foot_x, pos_k)
    person.foot_y = lerp(person.mid_y + person.bottom_len * sin(person.bottom_joint), person.foot_y, pos_k)

    line(person.body_x, person.body_y, person.joint_x, person.joint_y, person.jean_color)
    line(person.body_x+4, person.body_y, person.joint_x, person.joint_y, person.jean_color)
    line(person.joint_x, person.joint_y, person.mid_x, person.mid_y, person.top_color)
    circfill(person.joint_x, person.joint_y, 1, person.jean_color)
    line(person.mid_x-3, person.mid_y, person.foot_x, person.foot_y, person.top_color)
    --line(person.mid_x+3, person.mid_y, person.foot_x+4, person.foot_y, 10)
    line(person.mid_x+3, person.mid_y, person.foot_x+4, person.foot_y, person.top_color)
    circfill(person.mid_x, person.mid_y - 4, 4, person.hair_color)
    circfill(person.mid_x, person.mid_y, 2, person.face_color)

    --circ(person.body_x, person.body_y, 4, 11)
end

::_::
--cls(0)

--mouse_x = stat(32)-1
--mouse_y = stat(33)-1

rr = 10 + 64 * abs(cos(t / 1000))
tt = 30
mouse_x = 64 + rr * sin(t / tt)
if t < 100 then
    mouse_y = 64 - 10
else
    mouse_y = 64 - rr * abs(cos(t / tt))
end

for i = 0,1024 do
    local col = flr(t / 300)
    local x = rnd(128)
    local y = rnd(128)
    local angle = atan2(x - 64, y - 64)
    if col > 1 and (flr((angle * 10) + t * 0.1) % 2 == 0 ) then
        col += 1
    end
    circfill(x, y, 2, col)
end

-- guidelines
--line(body_x, 0, body_x, 128, 5)
--line(body_x - 128, body_y - 128, body_x + 128, body_y + 128, 5)
--line(body_x + 128, body_y - 128, body_x - 128, body_y + 128, 5)
--line(0, body_y, 128, body_y, 5)

t += 1

for i,o in pairs(people) do
    update_person(o)
end

circ(mouse_x, mouse_y, 2, 13)

flip()
goto _

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
