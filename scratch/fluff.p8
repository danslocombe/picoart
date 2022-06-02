pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

-- based on https://twitter.com/nar_rrrr/status/1518395447726944256?t=O71Yqzdk5BBSrC0j13zg5Q&s=09

cls(5)
--_set_fps(60)
--_set_fps(1)

t = 0
cx = 0
cy = 0
::a::
t += 1
for i=0,128 do
  circ(rnd(128), rnd(128), 1, 5)
end
cls(5)

pcx = cx
pcy = cy
cx = 64 + sin(t / 95) * 10
cy = 40 + sin(t / 173) * 5

for i=0,90 do
  x = cx
  y = cy

  xvel_0_k = 1.8
  xvel = rnd(2*xvel_0_k) - xvel_0_k

  yvel_0_k = 2.5
  yvel = -rnd(2*yvel_0_k)

  --iters = 1 + flr(rnd(2)) + flr(rnd(2))
  iters = 1
  --iters = 1
  for iter=0,iters do
    yvel += 1
    xp = x
    yp = y
    x += xvel
    y += yvel
  end

  --circfill(x, y, 3, 15)
  circfill(x, y, 3, 6)
  line(x, y, xp, yp, 7)
  --a = 10
  --b = 2*a
  --circfill(64 + rnd(b)-a, 64 + rnd(b)-a, 3, 6)
end
if t > 1 then
  --pset(cx -3, cy, 0)
  --pset(cx +3, cy, 0)
  line(cx-3,cy,pcx-3,pcy, 0)
  line(cx+3,cy,pcx+3,pcy, 0)
  --line(cx -3, cy + 3, cx + 3, cy + 4)
end
flip()
goto a


--nodes = {}
--ropes = {}
--
--function tick_ropes()
--  for i,node in pairs(nodes) do
--  end
--
--  for i,rope in pairs(ropes) do
--  end
--end
--
--::a::
--flip()
--goto a