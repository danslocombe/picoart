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

function project_dist_towards(x, y, tx, ty, dist)
    local dx = tx - x
    local dy = ty - y
    local delta_mag = mag(dx, dy)
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

function make_stem(start_x, start_y, dx, dy, fx, fy, count, force_options)
    local x = start_x
    local y = start_y
    local new_nodes = {}
    for i = 1,count do
        local n = new_node(x, y)
        add(nodes, n)
        add(new_nodes, n)
        if #new_nodes > 1 then
            add(ropes, new_rope(new_nodes[#new_nodes - 1], n))
        end
        x += dx
        y += dy
    end

    new_nodes[1].fixed = true

    --add(nodes, new_node(80, 80))
    --nodes[1].fixed = true
    --add(nodes, new_node(60, 60))
    --add(nodes, new_node(50, 50))
    --add(nodes, new_node(30, 30))
    --add(ropes, new_rope(nodes[3], nodes[4]))

    local k_base = 2
    local k_mult = 0.65

    if force_options != nil then
        k_base = force_options.k_base or k_base
        k_mult = force_options.k_mult or k_mult
    end

    add(hair_sources, {
        base_force_x = fx,
        base_force_y = fy,
        k_base = k_base,
        k_mult = k_mult,
        --hairs = {nodes[2], nodes[3], nodes[4]},
        hairs = new_nodes,
    })

    return new_nodes
end

function attach_branch(node, dx, dy, fx, fy, count, force_options)
    local branch = make_stem(node.x + dx, node.y + dy, dx, dy, fx, fy, count, force_options)
    branch[1].fixed = false
    add(ropes, new_rope(branch[1], node))
    return branch
end


function _init()
    local base_nodes = make_stem(100, 120, -6, -6, -2, -4, 10)
    attach_branch(base_nodes[4], 4, -1, 1, -1, 4, {
        k_base = 0
        --k_base = 0.2
    })

    attach_branch(base_nodes[4], -4, -1, -1, -1, 4, {
        k_base = 0
        --k_base = 0.2
    })

    attach_branch(base_nodes[8], 4, -1, 1, -1, 4, {
        k_base = 0
        --k_base = 0.2
    })

    attach_branch(base_nodes[8], -4, -1, -1, -1, 4, {
        k_base = 0
        --k_base = 0.2
    })
end

function dist_2(x0, y0, x1, y1)
    return (x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1)
end


function _update60()

    for i,o in pairs(nodes) do
        o.external_force_x = 0
        o.external_force_y = 0
    end

    for i,h in pairs(hair_sources) do
        local k = h.k_base
        local fx = h.base_force_x
        local fy = h.base_force_y
        local px = nil
        local py = nil
        for _,o in pairs(h.hairs) do
            k = k * h.k_mult
            if false and px != nil then
                local dx = o.x - px
                local dy = o.y - py
                local len = mag(dx, dy)
                local dx_norm = dx / len
                local dy_norm = dy / len
                --k = k * 0.95
                fx = dx_norm * k
                fy = dy_norm * k
            end
            --o.external_force_x = o.external_force_x + fx
            --o.external_force_y = o.external_force_y + fy
            o.external_force_x = k * fx
            o.external_force_y = k * fy
            px = o.x
            py = o.y
        end
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
        for i,rope in pairs(ropes) do
            line(rope.from.x, rope.from.y, rope.to.x, rope.to.y, 6)
        end
        for i,o in pairs(nodes) do
            circ(o.x, o.y, 2, 5)
        end
        if selectable_node != nil then
            circ(selectable_node.x, selectable_node.y, 3, 4)
        end
        local mx = stat(32)
        local my = stat(33)
        --circfill(mx, my, 2, 2)
        spr(1, mx, my)
    end
end

__gfx__
00000000888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
