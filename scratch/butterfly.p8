pico-8 cartridge // http://www.pico-8.com
version 36
__lua__

function exp(x)
    -- shitty taylor series about 0
    return 1 + x*x/2 + x*x*x / 6 + x*x*x*x / 24 + x*x*x*x*x / 120
end

function sqr(x)
    return x * x
end

function pow5(x)
    return x*x*x*x*x
end

theta_base = 0

bg_col = 0

::_::

vel = 0.0001 + 0.001 * sqr(sin(time() / 20))
bg_col += vel * 3
theta_base += vel

local colcol = 1 + flr(bg_col)
for i = 0,60 do
    local x = rnd(128)
    local y = rnd(128)
    pset(x, y, colcol)
    --circ(x, y, 1, 0)
end

--for i = 0,100 do
local butterfly_col = 0 -- + colcol
for i = 0,10 do
    local theta = theta_base + rnd() * 0.01
    local r = exp(sin(theta)) - 2 * cos(4*theta) + pow5(sin((2 * theta - 0.5) / 24))
    local k = 20
    local rk = r * k

    local x = 64 + rk * cos(theta)
    local y = 64 + rk * sin(theta)
    --pset(x, y, 7)
    circ(x, y, 1, butterfly_col)
end

goto _
