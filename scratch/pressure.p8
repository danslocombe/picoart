pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

poke(0x5f2d, 1)

friction = 0.98
gravity = 0.1

nodes = {}
ropes = {}
hair_sources = {}
selectable_node = nil

ROPE_ITERS = 8

t = 0

function project_dist_towards(x, y, tx, ty, dist)
    local dx = tx - x
    local dy = ty - y
    local delta_mag = mag(dx, dy)
    if (delta_mag == 0) then
        return {
            x = x,
            y = y
        }
    end
    local dx_dist = dx * dist / delta_mag 
    local dy_dist = dy * dist / delta_mag 

    return {
        x = x + dx_dist,
        y = y + dy_dist,
    }
end

function mag(x, y)
    return sqrt(x * x + y * y)
end

function new_node(x, y)
    return {
        x = x,
        y = y,
        p_x = x,
        p_y = y,
        vel_x = 0,
        vel_y = 0,
    }
end

function new_rope(from, to)
    return {
        from = from,
        to = to,
        length = mag(to.x - from.x, to.y - from.y),
    }
end

function make_circle(cx, cy, r, count)
    local start_count = #nodes
    for i = 0,count do
        local x = cx + r * cos(i/(count + 1))
        local y = cy + r * sin(i/(count + 1))
        add(nodes, new_node(x, y))
    end

    end_counts = #nodes

    for i = start_count+2,#nodes do
        add(ropes, new_rope(nodes[i-1], nodes[i]))
    end

    --add(ropes, new_rope(nodes[start_count+1], nodes[#nodes]))
    add(ropes, new_rope(nodes[#nodes], nodes[start_count+1]))
end

function _init()
    make_circle(64, 64, 20, 10)
    --nodes[1].fixed = true
end

function dist_2(x0, y0, x1, y1)
    return (x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1)
end

temp = 0

function _update60()
    t += 1

    if (btn(4)) then
        temp += 0.2
        if temp > 1 then temp = 1 end
    else
        temp = temp * 0.95
    end


    for i,o in pairs(nodes) do
        o.external_force_x = 0
        o.external_force_y = 0
    end

    -- for now assume one object
    -- shoelace formula to compute area
    local area = 0
    local prev = #nodes
    for i,o in pairs(nodes) do
        local o_prev = nodes[prev]
        area += (o.x + o_prev.x) * (o.y - o_prev.y)
        prev = i
    end
    area = area * 0.5

    local pressure_force_k = 0.1 * (1 + 200 * temp) / area
    for i,o in pairs(ropes) do
        local dx = o.to.x - o.from.x
        local dy = o.to.y - o.from.y
        --local rope_dyn_len = mag(dx, dy)
        --local normal_dx = -dy / rope_dyn_len
        --local normal_dy = dx / rope_dyn_len

        --local f = pressure_force_k * rope_dyn_len

        local normal_dx = dy * pressure_force_k
        local normal_dy = -dx * pressure_force_k

        o.from.external_force_x += normal_dx
        o.from.external_force_y += normal_dy
        o.to.external_force_x += normal_dx
        o.to.external_force_y += normal_dy
    end

    for i,o in pairs(nodes) do
        if o.fixed then
        else
            o.vel_x = friction * (o.x - o.p_x)
            o.vel_y = friction * (o.y - o.p_y)

            o.vel_x = o.vel_x + o.external_force_x
            o.vel_y = o.vel_y + o.external_force_y + gravity

            o.p_x = o.x
            o.p_y = o.y
            o.x = o.x + o.vel_x
            o.y = o.y + o.vel_y
        end
    end

    for i = 0,ROPE_ITERS do
        for _,o in pairs(ropes) do
            local c_x = (o.from.x + o.to.x) / 2
            local c_y = (o.from.y + o.to.y) / 2
            local half_len = o.length / 2

            if (o.from.fixed and o.to.fixed) then
                -- Nothing to do
            elseif o.from.fixed then
                local to_projected = project_dist_towards(c_x, c_y, o.to.x, o.to.y, half_len)
                o.to.x = to_projected.x
                o.to.y = to_projected.y
            elseif o.to.fixed then
                local from_projected = project_dist_towards(c_x, c_y, o.from.x, o.from.y, half_len)
                o.from.x = from_projected.x
                o.from.y = from_projected.y
            else
                -- Both free
                local from_projected = project_dist_towards(c_x, c_y, o.from.x, o.from.y, half_len)
                o.from.x = from_projected.x
                o.from.y = from_projected.y
                local to_projected = project_dist_towards(c_x, c_y, o.to.x, o.to.y, half_len)
                o.to.x = to_projected.x
                o.to.y = to_projected.y
            end
        end
    end

    local mx = stat(32)
    local my = stat(33)

    if (stat(34) == 0) then
        selectable_node = nil
    end
    for _,o in pairs(nodes) do
        if (dist_2(mx, my, o.x, o.y) < 8) then
            selectable_node = o
        end
    end

    if selectable_node != nil and stat(34) != 0 then
        selectable_node.x = mx
        selectable_node.y = my
    end

    for i,o in pairs(nodes) do
        if o.x < 28 then o.x = 28 end
        if o.x > 100 then o.x = 100 end
        if o.y > 100 then o.y = 100 end
    end
end

viewmode = 1

function _draw()
    if btnp(0) then
        cls(0)
        viewmode = 0
    elseif btnp(1) then
        viewmode = 1
    end

    if (viewmode == 0) then
        for i = 0,128 do
            local x = rnd(128) \ 1
            local y = rnd(128) \ 1
            local min_dist_2 = 10000
            for j,o in pairs(nodes) do
                local d2 = dist_2(o.x, o.y, x, y)
                if d2 < min_dist_2 then
                    min_dist_2 = d2
                end
            end

            if min_dist_2 < 128 then
                circfill(x, y, 4, 7)
            else
                circ(x, y, 1, 0)
            end
        end
    else
        cls(7)

        local temp_h = 40
        rectfill(10, 90, 12, 90 - temp_h * temp, 0)


        for i,rope in pairs(ropes) do
            line(rope.from.x, rope.from.y, rope.to.x, rope.to.y, 6)
        end
        for i,o in pairs(nodes) do
            circ(o.x, o.y, 2, 5)
            --local efk = 16
            --line(o.x, o.y, o.x + efk * o.external_force_x, o.y + efk * o.external_force_y, 11)
        end
        if selectable_node != nil then
            circ(selectable_node.x, selectable_node.y, 3, 4)
        end

        local cx = 0
        local cy = 0
        for i,o in pairs(nodes) do
            cx += o.x
            cy += o.y
        end
        cx = cx / #nodes
        cy = cy / #nodes

        local eye_spr = 2 + (t/3) % 4

        if ((flr(t / 5)) % 31) == 0 then
            eye_spr = 6
        end

        if (temp < 0.4) then
            eye_spr = 7 + (t/3) % 2
        end

        if (temp < 0.1) then
            eye_spr = 9
            if ((flr(t / 5)) % 31) == 0 then
                eye_spr = 10
            end
        end

        palt(0, false)
        palt(15, true)
        local left_eye_x = cx - 4
        local right_eye_x = cx + 4
        local eye_y = cy - 2
        spr(eye_spr, left_eye_x - 4, eye_y - 4)
        spr(eye_spr, right_eye_x - 4, eye_y - 4)

        if (temp > 0.5) then
            --rectfill(left_eye_x - 2, eye_y + 4, left_eye_x + 2, eye_y + 5, 14)
            --rectfill(right_eye_x - 2, eye_y + 4, right_eye_x + 2, eye_y + 5, 14)
        end

        local mx = stat(32)
        local my = stat(33)
        --circfill(mx, my, 2, 2)
        palt(0, true)
        spr(1, mx, my)
    end
end

__gfx__
0000000088800000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
0000000088000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
0070070080800000fff00fffffff0ffffff00ffffff00fffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
0007700000080000ff000ffffff000ffff0000fffff00fffff000ffffff00fffffff0fffffffffffffffffff0000000000000000000000000000000000000000
0007700000000000fff0fffffff00ffffff00ffffff00ffff0fff0fffff00ffffff0fffffff0ffffffffffff0000000000000000000000000000000000000000
0070070000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
