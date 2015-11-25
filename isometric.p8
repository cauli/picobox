pico-8 cartridge // http://www.pico-8.com
version 5
__lua__
tw = 50
th = 25
tz = 12.5/2

rndcol = flr(rnd()*16)
rndcol2 = flr(rnd()*16)
rndcol3 = flr(rnd()*16)
rndcol4 = flr(rnd()*16)
rndcol5 = flr(rnd()*16)


-- height climbable
height_climbable = 5

-- physics parameters
gravity = 0.3
friction = 0.98
bounce = 0.9

blocks = {}

c1 = 3
c2 = 9
c3 = 11
c4 = 12
c5 = 1
c6 = 5


--c1 = 5
--c2 = 0
--c3 = 14
--c4 = rndcol4
--c5 = 13
--c6 = flr(rnd()*16)
lg = 5

debug_quadrants = true

triangles = 0

sqrt0 = sqrt


distance_to_hole = 9999

function sqrt(n)
  if (n <= 0) return 0
  if (n >= 32761) return 181.0
  return sqrt0(n)
end

-- http://gamedev.stackexchange.com/questions/25579/how-to-detect-what-portion-of-a-rectangle-a-point-is-in
function get_quadrant(x,y)

  -- top view of block
  --0,0..........1,0
  -- ..         ..
  -- .  .  a  .  .       
  -- .   b . d   .
  -- .  .  c  .  .  
  -- ..         ..
  --0,1...........1,1

  local min = {}
  local max = {}

  min.x = 0
  min.y = 0
  max.x = 1
  max.y = 1


  if (x < min.x or x > max.x or y < min.y or y > max.y)then
    return nil
  else
    local ab = (y - min.y) * (max.x - min.x) > (max.y-min.y) * (x - min.x);
    local ad = (y - min.y) * (max.x - min.x) > (max.y-min.y) * (max.x - x);
   
    if(ab and ad) then
     return "a"
    elseif(ab and not ad) then
     return "b"
    elseif(not ab and not ad) then 
      return "c"
    else
      return "d"
    end
  end

  return nil
end

function min3(a,b,c)
  local mab = min(a,b)
  return min(mab,c)
end

function max3(a,b,c)
  local mab = max(a,b)
  return max(mab,c)
end

function orient2d(a, b, c)
    return (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x);
end

function clip(v)
  return max(-1,min(128,v))
end

function lerp(a,b,alpha)
  return a*(1.0-alpha)+b*alpha
end

-- written by nusan
-- taken from Pico8 3d Renderer http://www.lexaloffle.com/bbs/?tid=2731&autoplay=1#pp
-- by orange451
function trifill2( p1, p2, p3, c )
  triangles += 1

  local v1 = p1
  local v2 = p2
  local v3 = p3
  local x1 = flr(p1.x)
  local y1 = flr(p1.y)
  local x2 = flr(p2.x)
  local y2 = flr(p2.y)
  local x3 = flr(p3.x)
  local y3 = flr(p3.y)

  -- order triangle points so that y1 is on top
  if(y2<y1) then
    if(y3<y2) then
      local tmp = y1
      y1 = y3
      y3 = tmp
      tmp = x1
      x1 = x3
      x3 = tmp
    else
      local tmp = y1
      y1 = y2
      y2 = tmp
      tmp = x1
      x1 = x2
      x2 = tmp
    end
  else
    if(y3<y1) then
      local tmp = y1
      y1 = y3
      y3 = tmp
      tmp = x1
      x1 = x3
      x3 = tmp
    end
  end

  y1 += 0.001 -- offset to avoid divide per 0

  local miny = min(y2,y3)
  local maxy = max(y2,y3)

  local fx = x2
  if(y2<y3) then
    fx = x3
  end

  local d12 = (y2-y1)
  if(d12 != 0) d12 = 1.0/d12
  local d13 = (y3-y1)
  if(d13 != 0) d13 = 1.0/d13

  local cl_y1 = clip(y1)
  local cl_miny = clip(miny)
  local cl_maxy = clip(maxy)

  for y=cl_y1,cl_miny do
    local sx = lerp(x1,x3, (y-y1) * d13 )
    local ex = lerp(x1,x2, (y-y1) * d12 )
    rectfill(sx,y,ex,y,c)
  end
  local sx = lerp(x1,x3, (miny-y1) * d13 )
  local ex = lerp(x1,x2, (miny-y1) * d12 )

  local df = (maxy-miny)
  if(df != 0) df = 1.0/df

  for y=cl_miny,cl_maxy do
    local sx2 = lerp(sx,fx, (y-miny) * df )
    local ex2 = lerp(ex,fx, (y-miny) * df )
    rectfill(sx2,y,ex2,y,c)
  end
end


-- https://fgiesen.wordpress.com/2013/02/08/triangle-rasterization-in-practice/
function trifill(v0, v1, v2, col)
    triangles += 1
    color(col)
    -- Compute triangle bounding box
    minX = min3(v0.x, v1.x, v2.x);
    minY = min3(v0.y, v1.y, v2.y);
    maxX = max3(v0.x, v1.x, v2.x);
    maxY = max3(v0.y, v1.y, v2.y);

    -- Clip against screen bounds
    minX = max(minX, 0);
    minY = max(minY, 0);
    maxX = min(maxX, 128 - 1);
    maxY = min(maxY, 128 - 1);

    local ix = 0
    local iy = 0
    local ix1 = 0
    local iy1 = 0
    -- Rasterize
    local p = {};
    for iy = minY, maxY do
      iy1 += 1
      p.y = iy1

      for ix = minX, maxX do
          --ix += 1
          p.x = ix1
          
          w0 = orient2d(v1, v2, p);
          w1 = orient2d(v2, v0, p);
          w2 = orient2d(v0, v1, p);

          -- If p is on or inside all edges, render pixel.
          if (w0 >= 0 and w1 >= 0 and w2 >= 0) then
              --renderPixel(p, w0, w1, w2);
              pset(p.x, p.y)
          end     
      end
    end

end

--
-- triangle fill ported by yellowafterlife
-- https://gist.github.com/yellowafterlife/34de710baa4422b22c3e
-- from http://forum.devmaster.net/t/advanced-rasterization/6145
--
function trifill(p1, p2, p3, col)
  triangles += 1
  color(col)

  local x1 = p1.x
  local y1 = p1.y
  local x2 = p2.x
  local y2 = p2.y
  local x3 = p3.x
  local y3 = p3.y
  
  local dx12 = x1 - x2
  local dx23 = x2 - x3
  local dx31 = x3 - x1
  local dy12 = y1 - y2
  local dy23 = y2 - y3
  local dy31 = y3 - y1
  local minx = min(x1, min(x2, x3))
  local maxx = max(x1, max(x2, x3))
  local miny = min(y1, min(y2, y3))
  local maxy = max(y1, max(y2, y3))
  local c1 = dy12 * x1 - dx12 * y1
  local c2 = dy23 * x2 - dx23 * y2
  local c3 = dy31 * x3 - dx31 * y3
  if dy12 < 0 or dy12 == 0 and dx12 > 0 then
    c1 += 1
  end
  if dy23 < 0 or dy23 == 0 and dx23 > 0 then
    c2 += 1
  end
  if dy31 < 0 or dy31 == 0 and dx31 > 0 then
    c3 += 1
  end
  local cy1 = c1 + dx12 * miny - dy12 * minx
  local cy2 = c2 + dx23 * miny - dy23 * minx
  local cy3 = c3 + dx31 * miny - dy31 * minx
  for y = flr(miny), flr(maxy)  do
    local cx1 = cy1
    local cx2 = cy2
    local cx3 = cy3
    for x = flr(minx), flr(maxx) do
      if cx1 > -1 and cx2 > -1 and cx3 > -1 then
        pset(x, y)
      end
      cx1 -= dy12
      cx2 -= dy23
      cx3 -= dy31
    end
    cy1 += dx12
    cy2 += dx23
    cy3 += dx31
  end
end


function px_to_grid(x,y)
  local current_grid = {}
  current_grid.x = flr((x / (tw/2) + y / (th/2)) /2);
  current_grid.y = flr((y / (th/2) -(x/ (tw/2))) /2);
  return current_grid
end


function px_to_grid_float(x,y)
  local current_grid = {}
  current_grid.x = (x / (tw/2) + y / (th/2)) /2;
  current_grid.y = (y / (th/2) -(x/ (tw/2))) /2;
  return current_grid
end

-- returns a point object
-- p.x 
-- p.y
function make_point(x,y)
  local p = {}
  p.x = x
  p.y = y
  return p
end

-- grid coordinates
function make_ball(x0,y0,z0)
  local b = {}

  -- convert to global
  local x = (x0-y0) * tw/2
  local y = (x0+y0) * th/2
  local z = (z0 * tz) - tz

  b.x = x
  b.y = y
  b.z = z

  b.oldx = x
  b.oldy = y
  b.oldz = z


  b.latest_safe_x = x
  b.latest_safe_y = y
  b.latest_safe_z = z

  b.vx = vx
  b.vy = vy
  b.vz = vz

  b.color = 7

  b.floor_height = 0
  b.last_floor_height = b.floor_height

  b.may_be_stuck = false
  b.stuck_frame_count = 0
  return b
end

--        ..1..
--     ...     ...
--  4..           ..2
--  .  ...     ......
--  .     ..3...THIS.
--  8..     ..WALL..6
--     .    ......
--        ..7..  

function hit_x_wall(b)
  local tempy = b.vy
  b.vy = b.vx
  b.vx = tempy

  b.vx = -b.vx
  b.vy = -b.vy

  ball.color = 11

  -- We always set May Be Stuck to true when hitting a wall.
  -- Then we count the may_be_stuck frames and, if > than Threshold,
  -- We set the ball to the latest safe position
  ball.may_be_stuck = true
end

--        ..1..
--     ...     ...
--  4..           ..2
--  ......     ...  .
--  ..THIS..3..     .
--  8...WALL.     ..6
--     ......  ...
--        ..7..  

function hit_y_wall(b)
  local tempy = -b.vy
  b.vy = -b.vx
  b.vx = tempy

  b.vx = -b.vx
  b.vy = -b.vy

  ball.color = 10

  -- We always set May Be Stuck to true when hitting a wall.
  -- Then we count the may_be_stuck frames and, if > than Threshold,
  -- We set the ball to the latest safe position
  ball.may_be_stuck = true
end

function move_ball(b)

  b.vx = (b.x - b.oldx) * friction
  b.vy = (b.y - b.oldy) * friction
  b.vz = (b.z - b.oldz) * friction

  -- if ball is below floor
  if(ball.z < ball.floor_height)then
      -- if difference between height of floor and ball is not that big
      -- (climbable)
      if(ball.floor_height - ball.z < height_climbable)then

        ball.may_be_stuck = false
        ball.z = ball.floor_height

        if(abs(ball.vz) < 0.5)then
          ball.vz = 0
        else
          ball.vz *= -1
          sfx(0)
        end

        if(debug_quadrants)then
          ball.color = 9
        end
      -- (unclimbable)
      else
        b.x = b.oldx
        b.y = b.oldy
        b.z = b.oldz

        if(ball.quadrant == "b" or ball.quadrant == "d")then
          hit_x_wall(b)
        elseif(ball.quadrant == "a" or ball.quadrant == "c")then
          hit_y_wall(b)
        end

        if(abs(ball.vz) < 0.5)then
          ball.vz = 0
        else
          ball.vz *= -1
          sfx(0)
        end

      end
  else
     ball.may_be_stuck = false
     ball.color = 7
  end

  if(ball.z < 0)then
    ball.z = 0.5
  end

  b.oldx = b.x
  b.oldy = b.y
  b.oldz = b.z
  
  b.x += b.vx
  b.y += b.vy
  b.z += b.vz

  b.z -= gravity

  ball.last_floor_height = ball.floor_height
  
  b.current_grid =       px_to_grid(b.x, b.y)
  b.current_grid_float = px_to_grid_float(ball.x, ball.y + ball.z)

end

function draw_ball(b)
  pset(b.x, b.y - b.floor_height, 0) -- shadow
  pset(b.x, b.y - b.z, ball.color)
end


function make_block(x0,y0,z0,i,has_hole)
  -- i == 100
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  |  ---     ---  |
  --  |     --3--     |
  --  8--     |     --6
  --     ---  |  ---
  --        --7--

  -- i == 101
  --        __1..
  --     ___  |  ...
  --  4__     |     ..2
  --  |  ___  |  ...  .
  --  |     __3..     .
  --  8__     |     ..6
  --     ___  |  ...
  --        __7..

  -- i ==102
  --        __1__
  --    ___       ___
  --  4_______________2
  --  |  ...     ...  |
  --  |     ..3..     |
  --  8_______________6
  --     ...  .  ...
  --        ..7..  

  -- i == 103
  --        ..2__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  


  -- i == 0
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..  

  -- i == 1 
  --        ..1.\
  --     ...     \..
  --  4.\         \ ..x
  --  .  \..     ..\  .
  --  .   \ ..x..   \ .
  --  8..  \  .     ..6
  --     ...\ .  ...
  --        ..7..

  -- i == 2 
  --        ..1..
  --     ... /   ...
  --  x..  /        ..2
  --  .  ./.     .../ .
  --  . /   ..x..  /  .
  --  8..     .  /  ..6
  --     ...  . /...
  --        ..7..

  -- i == 3
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- i == 4
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3--------
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..


  -- i == 5
  --        ./1..
  --     ../  |  ...
  --  4../    |     ..2
  --  ./      |  ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- i == 9
  --        ..1..
  --     ...     ...
  --  4..     5-------2
  --  .       |      /|
  --  .       |    /  |
  --  8..     |  /  __6
  --     ...  |/ ___
  --        ..7__

  -- i == 10
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .     / 3 \     .  
  --  .   /   |   \   . 
  --  8 /     |     \ 6
  --     ___  |   ___
  --        __7__
  -- i == 11
  --        ..1..
  --     ...     ...
  --  4_______5      ..2
  --  |\      |   ..   .  
  --  |  \    |..      . 
  --  8    \  |       6
  --    ___  \|  ...
  --        __7..
  -- i == 12
  --        ..1..
  --     ... / \ ...
  --  4..  /     \  ..2
  --  .  /         \  .  
  --  ./             \. 
  --  8---------------6
  --     ...  .  ...
  --        ..7..

  -- i == 100
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  |  ---     ---  |
  --  |     --3--     |
  --  8--     |     --6
  --     ---  |  ---
  --        --7--

  -- i == 101
  --        __1..
  --     ___  |  ...
  --  4__     |     ..2
  --  |  ___  |  ...  .
  --  |     __3..     .
  --  8__     |     ..6
  --     ___  |  ...
  --        __7..

  -- i ==102
  --        __1__
  --    ___       ___
  --  4_______________2
  --  |  ...     ...  |
  --  |     ..3..     |
  --  8_______________6
  --     ...  .  ...
  --        ..7..  

  -- i == 103
  --        ..2__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  

  local block = {}
  block.x0 = x0
  block.y0 = y0
  block.z0 = z0
  block.i =  i
  block.has_hole = has_hole
  block.friction = 0.99

  block.x = (block.x0-block.y0) * tw/2
  block.y = (block.x0+block.y0) * th/2
  block.z = tz + (block.z0 * tz)

  if(i == 0)then
    block.slope = 0
    block.directionup = nil
    block.directiondown = nil
  elseif(i == 1) then
    block.slope = 0.25
    block.directionup = "w"
    block.directiondown = "e"
  elseif(i == 2) then
    block.slope = 0.25
    block.directionup = "n"
    block.directiondown = "s"
  elseif(i == 3) then
    block.slope = 0.25
    block.directionup = "e"
    block.directiondown = "w"
  elseif(i == 4) then
    block.slope = 0.25
    block.directionup = "s"
    block.directiondown = "n"
  elseif(i == 5) then
    block.slope = 0.5
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == 6) then
    block.slope = 0.5
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == 7) then
    block.slope = 0.5
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == 8) then
    block.slope = 0.5
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "d" 
    block.slope2 = "a"
  elseif(i == 9) then
    block.slope = 0.5
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == 10) then
    block.slope = 0.5
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "a" 
    block.slope2 = "d"
  elseif(i == 11) then
    block.slope = 0.5
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == 12) then
    block.slope = 0.5
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == 100)then
    block.slope = 0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "d"  
  elseif(i == 101)then
    block.slope = 0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "b"
  elseif(i == 102)then
    block.slope = 0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "b"
    block.top2 = "c"
  elseif(i == 103)then
    block.slope = 0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "c"
    block.top2 = "d"
  end

  return block
end

function draw_block(block)
  local x = block.x
  local y = block.y
  local z = block.z

  -- top 4
  local p1 = make_point(x, y-z) -- ttc
  local p2 = make_point(x+tw/2,y+th/2-z)   -- tcr
  local p3 = make_point(x,y+th-z) -- tbc
  local p4 = make_point(x-tw/2,y+th/2-z) -- tcl

  local pc = make_point(x, y)

  -- bottom 4
  local p5 = make_point(x, y)  -- btc
  local p6 = make_point(x+tw/2, y+th/2) -- bcr
  local p7 = make_point(x, y+th)  -- bbc
  local p8 = make_point(x-tw/2, y+th/2)  -- bcl
  
  if(block.i == 0)then
    --draw top
    trifill2(p3,p2,p1,c1)
    trifill2(p1,p4,p3,c1)

    --draw left
    trifill2(p8,p7,p3,c2)
    trifill2(p3,p4,p8,c2)
   
    --draw right
    trifill2(p7,p6,p2,c3)
    trifill2(p2,p3,p7,c3)

    if(block.has_hole)then
      palt(14, true)
      palt(0,false)
      spr(21,pc.x-4,pc.y-4)

      palt() 

      spr(22,pc.x-4,pc.y-4)
      spr(6,pc.x-4,pc.y-4-8)
    end
  elseif(block.i == 100)then

      -- i == 100
      --        ..1..
      --     ...     ...
      --  4_______________2
      --  |  ---     ---  |
      --  |     --3--     |
      --  8--     |     --6
      --     ---  |  ---
      --        --7--


    --draw top
    trifill2(p4,p3,p2,c1) --t

    trifill2(p8,p7,p3,c2) -- l
    trifill2(p4,p8,p3,c2) -- l

    trifill2(p2,p3,p7,c3) -- r
    trifill2(p7,p6,p2,c3) 
  elseif(block.i == 101)then
    -- i == 101
    --        __1..
    --     ___  |  ...
    --  4__     |     ..2
    --  |  ___  |  ...  .
    --  |     __3..     .
    --  8__     |     ..6
    --     ___  |  ...
    --        __7..


    --draw top
    trifill2(p4,p3,p1,c1)

    trifill2(p8,p7,p3,c2) -- l
    trifill2(p4,p8,p3,c2) -- l

  elseif(block.i == 102)then
  -- i ==102
  --        __1__
  --    ___       ___
  --  4_______________2
  --  |  ...     ...  |
  --  |     ..3..     |
  --  8_______________6
  --     ...  .  ...
  --        ..7..  

    --draw top
    trifill2(p4,p2,p1,c1)

    --draw 'front' (se)
    color(c3)
    rectfill(p4.x,p4.y,p6.x,p6.y)

  elseif(block.i == 103)then
  -- i == 103
  --        ..1__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  
    --draw top
    trifill2(p1,p3,p2,c1)

    trifill2(p2,p3,p7,c3) -- r
    trifill2(p7,p6,p2,c3) 
  elseif(block.i == 1)then
    --draw top
    trifill2(p1,p4,p7,c1)
    trifill2(p7,p6,p1,c1)

    --draw left
    trifill2(p8,p7,p4,c2)
  elseif(block.i == 2)then

    -- draw top
    trifill2(p1,p8,p7,c1)
    trifill2(p7,p2,p1,c1)

    --draw right
    trifill2(p7,p6,p2,c3)


  elseif(block.i == 3)then
  -- i == 3
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

    -- draw top
    trifill2(p7,p6,p2,c3)
    trifill2(p2,p3,p7,c3)

    --draw left
    trifill2(p8,p7,p3,c2)

    --draw top
    trifill2(p8,p3,p2,c1)
    trifill2(p5,p8,p2,c1)
  elseif(block.i == 4)then
    -- i == 4
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .  ...     ...  .
    --  .     ..3--------
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..

    trifill2(p4,p8,p3,c2) 
    trifill2(p8,p7,p3,c2) -- l

    trifill2(p7,p6,p3,c3) -- r

    trifill2(p3,p6,p5,lg) --t
    trifill2(p5,p4,p3,lg) 
  elseif(block.i == 5)then
  -- i == 5
  --        ./1..
  --     ../  |  ...
  --  4../    |     ..2
  --  ./      |  ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

    trifill2(p1,p3,p2,c1) -- t

    trifill2(p1,p8,p3,lg) -- sw

    trifill2(p3,p8,p7,c2) -- l

    trifill2(p2,p3,p7,c3) -- r
    trifill2(p7,p6,p2,c3) 
  elseif(block.i == 6)then
  -- i == 6
  --          1 
  --     _____5_____
  --  4_______________2
  --  .  ...      ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..
    trifill2(p3,p2,p4,c1) -- t

    trifill2(p4,p2,p5,lg) -- NW

    trifill2(p4,p8,p3,c2) -- l
    trifill2(p8,p7,p3,c2) -- l

    trifill2(p7,p6,p3,c3) -- r
    trifill2(p2,p3,p6,c3) -- r
    
  elseif(block.i == 7)then
  -- i == 7
  --        ..1\
  --     ...  |  \
  --  4..     |   \    2
  --  .  ...  |    \   
  --  .     ..3__   \  
  --  8..     .  --- \ 6
  --     ...  .  ...
  --        ..7..  

    trifill2(p4,p3,p1,c1) -- t

    trifill2(p3,p6,p1,lg) -- NE

    trifill2(p4,p8,p3,c2) -- l
    trifill2(p8,p7,p3,c2) -- l

    trifill2(p7,p6,p3,c3) -- r
  elseif(block.i == 8)then
  -- i == 8
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  . \           / .
  --  .   \        /  .
  --  8..  \     /  ..6
  --     ... \ /  ...
  --        ..7..  
    trifill2(p1,p4,p2,c1) -- t

    trifill2(p4,p7,p2,c3) -- SE
    trifill2(p8,p7,p4,c2) -- l

    trifill2(p6,p2,p7,c3) -- r

  elseif(block.i == 9)then
  -- i == 9
  --        ..1..
  --     ...     ...
  --  4..     5-------2
  --  .       |      /|
  --  .       |    /  |
  --  8..     |  /  __6
  --     ...  |/ ___
  --        ..7__


    trifill2(p2,p5,p7,lg) -- sw

    trifill2(p2,p7,p6,c3) -- r
 
  elseif(block.i == 10)then
  -- i == 10
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .     / 3 \     .  
  --  .   /   |   \   . 
  --  8 /     |     \ 6
  --     ___  |   ___
  --        __7__

    trifill2(p8,p7,p3,c2) -- l

    trifill2(p3,p7,p6,c3) -- r
  elseif(block.i == 11)then
  -- i == 11
  --        ..1..
  --     ...     ...
  --  4-------5      ..2
  --  |  \    |   ..   .  
  --  |   \   |..      . 
  --  8    \  |       6
  --    ___  \|  ...
  --        __7..

    trifill2(p4,p8,p7,c2) -- l

    trifill2(p5,p4,p7,lg) -- NE
  elseif(block.i == 12)then
  -- i == 12
  --        ..1..
  --     ... / \ ...
  --  4..  /     \  ..2
  --  .  /         \  .  
  --  ./             \. 
  --  8---------------6
  --     ...  .  ...
  --        ..7..

    trifill2(p1,p8,p6,c3) -- SE
  end

 
  if(debug_quadrants)then


    if(block.x0 == ball.current_grid.x and block.y0 == ball.current_grid.y)then

      if(block.has_hole)then
        line(ball.x, ball.y - ball.z, hole.x, hole.y, 4)
      end

      print("block x:" .. pc.x .. "   y:" .. pc.y .. "   h:" .. z, 1, 1, 7)

      color(7)
      line(p1.x, p1.y, p2.x, p2.y)
      line(p2.x, p2.y, p3.x, p3.y)
      line(p3.x, p3.y, p4.x, p4.y)
      line(p4.x, p4.y, p1.x, p1.y)

      q = get_quadrant(ball.current_grid_float.x % flr(ball.current_grid_float.x),ball.current_grid_float.y % flr(ball.current_grid_float.y))
      print(q, ball.x, ball.y - ball.z + 30, 9)

      color(c4)
   
      if(q == "a")then
        line(p3.x,p3.y,pc.x,pc.y)
        line(pc.x,pc.y,p4.x,p4.y)
        line(p4.x,p4.y,p3.x,p3.y)
        
        -- trifill(p3,pc,p4,12) 
      elseif(q == "b")then

        line(p4.x,p4.y,pc.x,pc.y)
        line(pc.x,pc.y,p1.x,p1.y)
        line(p1.x,p1.y,p4.x,p4.y)
        
        --trifill(p4,pc,p1,12) 
      elseif(q == "c")then

        line(p1.x,p1.y,pc.x,pc.y)
        line(pc.x,pc.y,p2.x,p2.y)
        line(p2.x,p2.y,p1.x,p1.y)

        --trifill(p1,pc,p2,12) 
      elseif(q == "d")then

        line(p2.x,p2.y,pc.x,pc.y)
        line(pc.x,pc.y,p3.x,p3.y)
        line(p3.x,p3.y,p2.x,p2.y)

        --trifill(p2,pc,p3,12) 
      end
        
    end
  end

  
end

function draw_tile(x0,y0)
  local x = (x0-y0) * tw/2
  local y = (x0+y0) * th/2
  
  line(x,y,x+tw/2,y+th/2)
  line(x+tw/2,y+th/2,x,y+th)
  line(x,y+th,x-tw/2,y+th/2)
  line(x-tw/2,y+th/2,x,y)
end

function make_level_bowl()
  blocks = {}

  bsw= make_block(4,0,1,5,false) 
  bse= make_block(2,0,1,8,false) 
  bne= make_block(2,1,1,7,false) 
  bnw= make_block(4,1,1,6,false) 

  add(blocks, bse)
  add(blocks, bsw)
  add(blocks, bne)
  add(blocks, bnw)
end

function make_level_1()
  blocks = {}

  b1 = make_block(3,0,1,0,true)
  b2 = make_block(3,1,1,0,false)
  b3 = make_block(3,2,1,2,false) 

  add(blocks, b1)
  add(blocks, b2)
  add(blocks, b3)
end

function make_level_rampy()
  blocks = {}

  b1= make_block(4,1,1,9,false) 
  b2= make_block(4,2,1,10,false) 
  b3= make_block(3,2,1,11,false) 
  b4= make_block(3,1,1,12,false) 

  add(blocks, b2)
  add(blocks, b1)
  add(blocks, b3)
  add(blocks, b4)
end

function make_level_sides()
  blocks = {}

  b1= make_block(5,1,1,101,false) 
  b2= make_block(5,3,1,102,false) 
  b3= make_block(3,3,1,103,false) 
  b4= make_block(3,1,1,100,false) 

  add(blocks, b1)
  add(blocks, b2)
  add(blocks, b4)
  add(blocks, b3)
end

function _init()
  ball = make_ball(3,1,1)


  make_level_sides()
end

function get_current_block(x,y)
  for block in all(blocks) do
    if(block.x0 == x and block.y0 == y)then
      return block
    end
  end

  return nil
end

function raise(thing)
  thing.z += tz/2
end
function lower(thing)
  thing.z -= tz/2
end

level = 0
function next_level()
  if(level == 0)then
    make_level_bowl()
    level = 1 + level
  elseif(level == 1)then
    make_level_1()
    level = 1 + level
  elseif(level == 2)then
    make_level_rampy()
    level = 1 + level
  elseif(level >= 3)then
    make_level_sides()
    level = 0
  end
end


function move_direction(dir, force)
  
  if(dir == "s")then
   ball.oldx += 0.2 * force
   ball.oldy -= 0.1 * force
  end

  if(dir == "n")then
   ball.oldx -= 0.2 * force
   ball.oldy += 0.1 * force
  end

  if(dir == "w")then
   ball.oldx += 0.3 * force
   ball.oldy += 0.15 * force
  end

  if(dir == "e")then
   ball.oldx -= 0.3 * force
   ball.oldy -= 0.15 * force
  end

  -- todo dry this
  if(dir == "se")then
   move_direction("s", force * 0.5)
   move_direction("e", force * 0.5)
  end

  if(dir == "nw")then
   move_direction("n", force * 0.5)
   move_direction("w", force * 0.5)
  end

  if(dir == "ne")then
   move_direction("n", force * 0.5)
   move_direction("e", force * 0.5)
  end

  if(dir == "sw")then
   move_direction("s", force * 0.5)
   move_direction("w", force * 0.5)
  end
end

ditance_to_hole = 10000
function _update()

  triangles = 0
  move_ball(ball)

  if (btn(0)) then -- south
    move_direction("s", .4) 
  elseif (btn(1)) then -- north
    move_direction("n", .4)
  elseif (btn(2)) then -- west
    move_direction("w", .4)
  elseif (btn(3)) then  -- east
    move_direction("e", .4)
  end


  if(ball.may_be_stuck)then
    ball.stuck_frame_count += 1
  else
    ball.stuck_frame_count = 0
  end

  if(ball.stuck_frame_count > 5)then
    -- TODO
    -- OPTION 1 set this to the latest safe position, with a correct speed
    -- OPTION 2 set this to the calculated safe position, near the stucking block on the same quadrant
    -- OPTION 3 fix the math with rounding so that this 
    ball.z = 50
    ball.oldz = 50
  end

  if (btnp(4,0)) then raise(ball) end
  if (btnp(5,0)) then next_level() end

  -- no need to call this if move_ball is one
  ball.current_grid =       px_to_grid(ball.x, ball.y)
  ball.current_grid_float = px_to_grid_float(ball.x, ball.y)


  block = get_current_block(ball.current_grid.x, ball.current_grid.y)

  hole = {}
  hole.x = 0
  hole.y = 0

  local not_on_slope = false -- determina se, em um bloco misto, a bola não estã em um slope no momento

  if block == nil then
    ball.floor_height = 0
  -- plain block
  else 
    quadrant = get_quadrant(ball.current_grid_float.x % flr(ball.current_grid_float.x), ball.current_grid_float.y % flr(ball.current_grid_float.y))
    ball.quadrant = quadrant

    -- bloco reto é simples de calcular a altura
    if(block.i == 0)then
      
      if(block.has_hole)then
        hole = {}
        hole.x = block.x
        hole.y = block.y 

        ball_copy = {}
        ball_copy.x = ball.x
        ball_copy.y = ball.y - ball.z

        distance_to_hole = distance(ball_copy,block)
        if(distance_to_hole < 4)then
          ball.floor_height = 0
        else
          ball.floor_height = (block.z0  * tz * 2)
        end
      else
        ball.floor_height = (block.z0  * tz * 2)
      end  
    -- 45 degrees angles blocks
    elseif(block.i == 100 or block.i == 101 or block.i == 102 or block.i == 103)then
   
      if(ball.quadrant == block.top1 or ball.quadrant == block.top2)then
        ball.floor_height = (block.z0  * tz * 2)
      else
        ball.floor_height = 0
      end

    -- diagonal ramp blocks   z=(1-x/a-y/b)*c  
    elseif(block.i == 9 or block.i == 10 or block.i == 11 or block.i == 12)then
      local pns
      local pwe

      pns = ball.current_grid_float.y % flr(ball.current_grid_float.y)
      pwe = ball.current_grid_float.x % flr(ball.current_grid_float.x)

      -- z=(1-x/a-y/b)*c
      -- HEIGHT equals ( 1 - currentX / "fullX" - currentY / "fullY" ) * fullHeight
      
      if(ball.quadrant == nil)then
          -- do nothing
          not_on_slope = true

          ball.floor_height = block.z0
      elseif(ball.quadrant == block.slope1 or ball.quadrant == block.slope2)then
        if(block.i == 12)then
          ball.floor_height = (1- (pns*16)/16 - (pwe*16)/16)  * (block.z0  * tz * 2)
        elseif(block.i == 9)then
          ball.floor_height = (1- (pns *16)/16 - (abs(1-pwe) *16)/16)  * (block.z0  * tz*2)
        elseif(block.i == 11)then
          ball.floor_height = (1- (abs(1-pns)  *16)/16 - (pwe*16)/16)  * (block.z0  * tz*2)
        elseif(block.i == 10)then
          ball.floor_height = (1- ( abs(1-pns) *16)/16 - ( abs(1-pwe) *16)/16)  * (block.z0  * tz * 2)
        end
      else 
          -- do nothing
          not_on_slope = true
          ball.floor_height = block.z0 -1 
      end
    -- diagonal ramp blocks with plain top
    else 
      local pns
      local pwe

      pns = ball.current_grid_float.y % flr(ball.current_grid_float.y)
      pwe = ball.current_grid_float.x % flr(ball.current_grid_float.x)


      if(block.directionup == "n" or block.directionup == "s")then
        percent = pns
      elseif(block.directionup == "w" or block.directionup == "e")then
        percent = pwe
      end

      -- TODO this shit is confusing. i want it betterz
      -- TODO height modelling is imprecise my merging two ramps
      if(block.i == 5 or block.i == 6 or block.i == 7 or block.i == 8)then -- half block
    
        if(ball.quadrant == nil)then
          -- do nothing
          not_on_slope = true
        elseif(ball.quadrant == "b" and (block.slope1 == "b" or block.slope2 == "b"))then
          if(block.i == 6)then 
            percent = pns
          else
            percent = abs(pns - 1)
          end
          ball.floor_height = (block.z0  * tz * 2) * percent
        elseif(ball.quadrant == "a" and (block.slope1 == "a" or block.slope2 == "a"))then
          if(block.i == 8)then -- 4 is UP
            percent = abs(pwe - 1)
          else
            percent = pwe  -- 4 is DOWN
          end
          ball.floor_height = (block.z0  * tz * 2) * percent
        elseif(ball.quadrant == "c" and (block.slope1 == "c" or block.slope2 == "c"))then
          if(block.i == 7)then -- 4 is UP
            percent = abs(pwe-1)
          else
            percent = pwe
          end
          ball.floor_height = (block.z0  * tz * 2) * percent
        elseif(ball.quadrant == "d" and (block.slope1 == "d" or block.slope2 == "d"))then
          if(block.i == 7)then -- 4 is UP
            percent = pns
          else
            percent = abs(pns - 1) 
          end
         
          ball.floor_height = (block.z0  * tz * 2) * percent
        else
          not_on_slope = true
          ball.floor_height = (block.z0  * tz * 2)
        end
      end

      if(block.directionup == "w" or block.directionup == "n")then
        percent = abs(percent - 1)
        ball.floor_height = (block.z0  * tz * 2) * percent
      end

      if(block.directionup == "e" or block.directionup == "s")then
         ball.floor_height = (block.z0  * tz * 2) * percent
      end

    end


    -- slope exists and is in contact with floor
    if(ball.slope != 0 and is_on_floor(ball))then
      if(not_on_slope)then
        -- dont move
      else
        move_direction(block.directiondown, block.slope * block.friction)
      end
    end
  end
end

function distance(p0, p1)
 local dx = p0.x - p1.x
 local dy = p0.y - p1.y
 
 return sqrt(dx*dx+dy*dy)
end

function is_on_floor(ball)
  if(ball.z <= ball.floor_height)then
    return true
  elseif(abs(ball.floor_height - ball.floor_height - ball.z) < 0.1)then
    return true
  else
    return false
  end
end

function _draw()
	
  camera(-64+ball.x, -64+ ball.y)
  clip(-64+ball.x, -64+ ball.y)
  rectfill(-64+ball.x, -64+ ball.y, ball.x + 64, 64+ ball.y, c5)
  foreach(blocks, draw_block)


  draw_ball(ball)

  camera()
  clip()

  print("dist hole " .. distance_to_hole, 1, 110, 5)

  if block == nil then
    print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
  else 
    print(block.x0 .. ", " .. block.y0, 1, 120, 9)
  end

  print("b x:" .. ball.x .. " y:" .. ball.y .. " z:" .. ball.z, 1, 7, 6)
  print("ballg x:" .. ball.current_grid.x .. "   y:" .. ball.current_grid.y , 1, 14, 6)
  print("ballf x:" .. ball.current_grid_float.x .. "   y:" .. ball.current_grid_float.y , 1, 21, 6)
  print("floor z:" .. ball.floor_height , 1, 28, 6)
  print("cpu:" .. stat(1)*100 .. "%" , 1, 35, 2)
  print("triangles:" .. triangles , 1, 42, 2)

end
__gfx__
000b000000b0000000000000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000b000000b000000bb00000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b00b0b00000b0b00b00b0000b00b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b0000bbb0000b00b000bb000b0000bb00000000000000000005880000000000000000000000000000000000000000000000000000000000000000000000000
00b0b00b00b0b00b00b0000b00b0b00b000000000000000000005880000000000000000000000000000000000000000000000000000000000000000000000000
b0000b00b000b000000bb000b0000b00b00000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0b000b00b0000b00b0000b0b0b000b00b00000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0b0000000b0000000b0000000b000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00005000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eee00eee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ee0000ee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eee00eee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000eeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000001101013010030100000023020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

