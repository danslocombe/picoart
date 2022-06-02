pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- spiky donut
--
-- recently i ran across a 
-- microcontroller wired
-- to a set of leds arranged in
-- a circle
-- 
-- i wanted to design something
-- for the unusual setup
-- i didnt, but i did use
-- the ideas to build this
-- tweetcart
--
--
-- my idea was to have two
-- "poles" at opposite sides
-- that spill out colour.
-- the colour would somehow
-- interact as it met in the
-- middle
-- 
-- being me, i went straight
-- to dithering
-- i looked for a random
-- distribution that could
-- smoothly transition between
-- the colours
--
-- something like this:
-- 
--   light pole here at the top
--             |
--            ____
--          /x____ \
--         / /    \x\
--         |x|    | | - donut
--         \x\    /x/
--          \xxxxxx/
--             |
--         dark pole
--
-- with x being dark coloured
-- points
-- at the top the points would
-- be almost all light
-- at the bottom the points would
-- be almost all dark
-- around the middle they would
-- be distributed like sprinkles
-- 
-- the approach i took is this:
-- fix a unit vector vp pointing
-- to the light pole 
-- (lets say straight up)
-- for each point on the unit
-- donut, find the vector from
-- the centre to that point v
-- then dot v with vp
-- this gives a value k in [-1,1]
-- which can be normalized 
-- to k_norm in [0, 1]
-- then generate a random
-- value x in [0, 1]
-- if x < k_norm, colour
-- the point dark otherwise
-- colour it light
-- 
-- this works great!
-- it also leads to the question:
-- what is the distribution of x?
-- or the general question
-- "given two uniform random unit
-- vectors,  what is the probability
-- distribution of their 
-- dot product?"
--
-- [answer left as an exercise
-- to the reader]
-- 
-- spiky donuts takes the above
-- algorithm and modulates it a bit
--
o=128u=-64ta=-0.25tx=cos(ta)ty=sin(ta)camera(u,u)_set_fps(60)::_::x=rnd(o)+u
y=rnd(o)+u
d2=x*x+y*y
e=abs(d2-1024)e+=sin(atan2(y,x)*(9+9*sin(time()/16)))*200
col = e<256and((rnd()<(tx*x/32+ty*y/32+1)/2)and 14or 15)or(e<512and 1)or 12
circ(x, y, 1, col)goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
