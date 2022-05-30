pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
cls(0)
_set_fps(60)
poke(0x5f54, 0x60)
t=0
pp = {1,13,14,12}
yline = 0
::a::
--sspr(k, k, 128-2*k, 128-2*k, 0, 0, 128, 128)
t+=1

--local chrom = {8,11,12}
local chrom = {7,7,7}

--local dyline = rnd(10) - 4
local dyline = 1.0
k = 30
yline = (yline + dyline) % 300
for i=0,k do
  local y = yline - (k / 2) + i

  local xoff = 10/(1 + abs(i-k/2))
  sspr(0, y, 128, 1, xoff, y, 128, 1)
end

--yline = (yline + 17) % 700
--for i=0,1 do
--  yline = (yline - 1) % 700
--  for j=0,3 do
--    local y = yline - j * 50
--    if rnd() < 0.9 then
--      --for i,p in pairs(chrom) do
--        --pal(13,7)
--        --pal(14,p)
--        local xoff = i*20*sin((t + y) / 200)
--        sspr(0, y, 128, 1, xoff, y, 128, 1)
--        pal()
--      --end
--    end
--  end
--end
--k = 12*sin(t / 200) - 3
--if k > 0 then
--  pal(13,8)
--  pal(14,9)
--  pal()
--else
--  theta = rnd()
--  xoff = 0.2*cos(theta)
--  yoff = 0.2*sin(theta)
--  sspr(xoff, yoff, 128, 128, -xoff, -yoff, 128, 128)
--end
for i=0,1000 do
  --line(32, 32, 48, 48, 0)
  --line(32, 32, 48, 48, 0)
  local x = rnd(128)
  local y = rnd(128)
  if x < 32 or y < 32 or x > 96 or y > 96 then
    circ(x, y, 1,0)
  elseif x < 48 or y < 38 or x > 80 or y > 95 then
    circ(x, y, 1,pp[1])
  else
    local col = pp[flr(1+rnd(3))]
    if rnd() < 1 then
      local r = 0.8 + 0.1*sin(t / 1000)
      if (x < r*y and r*x < 128-y)or(r*x>y and r*x > 128-y) then
        col = pp[flr(rnd(2))]
      elseif (y > 64) then
        col = pp[flr(1+rnd(2))] + flr(y / 16)
      end
    end
    circ(x, y, 1,col)
  end
  --local off = 32
  --circ(off+rnd(128-2*off),off+rnd(128-2*off),0.2+rnd(3),col)
end
flip()
goto a

__gfx__