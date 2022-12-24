pico-8 cartridge // http://www.pico-8.com
version 36
__lua__


friction = 0.98
gravity = 0.1

nodes = {}
ropes = {}

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

function _init()
    add(nodes, new_node(16, 24))
    nodes[1].fixed = true
    add(nodes, new_node(40, 24))
    add(nodes, new_node(60, 24))

    add(ropes, new_rope(nodes[1], nodes[2]))
    add(ropes, new_rope(nodes[2], nodes[3]))
end

function _update60()
    for i,o in pairs(nodes) do
        if o.fixed then
        else
            o.vel_x = friction * (o.x - o.p_x)
            o.vel_y = friction * (o.y - o.p_y)

            o.vel_y = o.vel_y + gravity

            o.p_x = o.x
            o.p_y = o.y
            o.x = o.x + o.vel_x
            o.y = o.y + o.vel_y
        end
    end

    for i = 0,8 do
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
end


function _draw()
    cls(7)
    for i,o in pairs(nodes) do
        circ(o.x, o.y, 3, 5)
    end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
