pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- spiky donut, made at home
--
-- recently ran across a microcontroller wired to a set of leds arranged in a circle
-- i wanted to design something for this unusual setup
--
-- i settled on constructing two "poles" at opposite sides that spill out colour and somehow
-- interact as they meet 
-- being me, i went straight to dithering, and looked for a random distribution that could
-- smoothly transition between the colours
--
-- something like this:
-- 
--            ____
--          /x____ \
--         / /    \x\
--        |x|     |x|
--         \x\    /x/
--          \xxxxxx/
--
-- 
-- so you can do this as follows:
-- fix a unit vector vp pointing to one of the poles (lets say straight up)
-- for each point on the donut, find the vector from the centre to that point v
-- then dot v with vp
-- this gives a value k in [-1, 1] which can be normalized to knorm in [0, 1]
-- then generate a random value x in [0, 1]
-- if x < k, colour the point dark otherwise colour it light
-- 
-- this works great but lead me to the question, what is the distribution of x?
-- or the general question "given two random unit vectors what is the 
-- distribution of their dot product?"
-- [answer left as an exercise to the reader, but it is a fun one]
-- 
-- spiky donuts is this with some spikes thrown in
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
