pico-8 cartridge // http://www.pico-8.com
version 34
__lua__

-- based on https://twitter.com/nar_rrrr/status/1518395447726944256?t=O71Yqzdk5BBSrC0j13zg5Q&s=09

function projectile(x0, y0, xvel0, yvel0, gravity, imax, f)
  local i = 0
  local x = x0
  local y = y0
  local xprev = x0
  local yprev = y0
  local yvel = yvel0
  local xvel = xvel0
  while y < 86 and i < imax do
    yvel += gravity
    y += yvel
    x += xvel
    f(x, y, xprev, yprev, i)
    xprev = x
    yprev = y
    i += 1
  end
end


function rspr_seance(sx, sy, tx, ty, w, h, scale, a, modp, modd, bgcol)
  local k = scale
  local kw = k*w
  local kh = k*h

  local sx_mid = sx + w/2
  local sy_mid = sy + h/2
  local tx_mid = tx + kw/2
  local ty_mid = ty + kh/2

  --a = -0.25
  --modp = 1

  local sample_angle_min = a
  local sample_angle_max = a + modp
  local sample_angle_mid = modp / 2

  local buffer = 0
  for y=-buffer,kh-1+buffer do
    for x=-buffer,kw-1+buffer do
      if true then
      --if rnd() < 0.85 then
        local d_tx = x - kw/2
        local d_ty = y - kh/2
        local dist = modd + sqrt((d_tx * d_tx) + (d_ty * d_ty)) / k
        local angle = atan2(d_ty, d_tx)
        local sample_angle = (a + modp * angle) -- + rnd(0.005))
        sget_x = (sx_mid + dist*cos(sample_angle))
        sget_y = (sy_mid + dist*sin(sample_angle))

        if sget_x >= sx and sget_x <= sx + w and sget_y >= sy and sget_y <= sy + h then
          local col = sget(sget_x, sget_y)

          if (col != bgcol) then
            pset(tx + x, ty + y, col)
          end
        end
      end
    end
  end
end

function rspr(x,y,rot,mx,my,w,flip,scale)
  scale=scale or 1
  w*=scale*4

  local cs, ss = cos(rot)*.125/scale,sin(rot)*.125/scale
  local sx, sy = mx+.5+cs*-w, my+w/8+ss*-w
  local hx = flip and -w or w

  local halfw = -w
  for py=y-w, y+w do
    tline(x-hx, py, x+hx, py, sx-ss*halfw, sy+cs*halfw, cs, ss)
    halfw+=1
  end
end

x0 = 64
y0 = 40
period_x0 = 1/395
period_y0 = 1/273

t = 0
cx = 54
cy = 40
function _update60()
  t += 1
  srand(t)
  for i = 0,300 do
    circ(rnd(128), rnd(128), 1, 5)
  end
  --cls(5)

  local p_x0 = x0
  local p_y0 = y0

  x0 = cx + sin(t*period_x0) * 10
  y0 = cy + sin(t*period_y0) * 5

  local xvel = 1.2 + -0.5 * sin(t*period_x0)
  local yvel = -4 + -0.5 * sin(t*period_y0)

  poses = {}
  projectile(x0, y0, xvel, yvel, 1, 100, function(x, y, xp, yp, i)
    local args = {x= x, y= y, xp= xp, yp= yp, i= i}
    add(poses, args)
    --circ(x, y, 3, 8)
  end)

  for index=1,#poses do
    local args = poses[1 + #poses - index]
    local x = args.x
    local y = args.y
    local xp = args.xp
    local yp = args.yp
    local i = args.i
    srand(i)
    for j=0,10 do
      local theta = rnd(1)
      local k = 7
      local xvel_fur = 0.5 * k *cos(theta)
      local yvel_fur = k*sin(theta)
      projectile(x, y, xvel_fur, yvel_fur, 0.22, 4, function(xx, yy, xxprev, yyprev, index)
        --line(xx, yy, xxprev, yyprev, 7)
        local radio = 3 + sin(t / 100 + i / 10)
        circfill(xx, yy, 3, 6 + i % 2)
        --circfill(xx, yy, 3, i)
      end)
    end
  end

  palt(0, false)
  --spr(0, p_x0, p_y0)
  --spr(0, x0, y0)
  a = 0
  modp = 1
  modp = abs(sin(t/1000))
  modd = abs(sin(t/1231))
  srand(t)
  rspr(x0, y0, 0, 8, 0, 8, 1)
  --rspr(0, 0, x0, y0, 8, 8, 2, a, modp, modd, 11)
  --local theta = atan2(y0 - cy, x0 - cx)
  --local l_eye_xoff = 3*cos(theta)
  --local l_eye_yoff = sin(theta)
  --line(x0-3,y0,p_x0-3,p_y0, 5)

  --line(x0+3,y0,p_x0+3,p_y0, 5)

  --line(x0-1,y0+3,p_x0-1,p_y0+3, 5)
  --line(x0,y0+3,p_x0,p_y0+3, 5)
  --line(x0+1,y0+3,p_x0+1,p_y0+3, 5)
  --line(x0,y0+4,p_x0,p_y0+4, 5)

  --line(x0+2,y0+3,p_x0+2,p_y0+3, 0)

end
__gfx__
66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666660e1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666660e1999100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
660660660e1989100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666660e1999100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666006660e1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
