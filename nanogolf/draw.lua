function draw_tile(x0,y0, c)
  color(c)

  local x = (x0-y0) * tw/2
  local y = (x0+y0) * th/2
  
  x += (64 - ball.x)
  y += (64 - ball.y)
  line(x,y,x+tw/2,y+th/2)
  line(x+tw/2,y+th/2,x,y+th)
  line(x,y+th,x-tw/2,y+th/2)
  line(x-tw/2,y+th/2,x,y)

  if (x0 + y0) % 2 == 0 then
    line(x-6,y +16,x+6,y + 16, COLORS.LIGHT_GREY)
  end
  
  print(x0 .. "," .. y0, x - 5, y  +10, COLORS.LIGHT_GREY)
end

function draw_block(block)
    local x = block.x + (64 - ball.x)
    local y = block.y + (64 - ball.y)
    local z = block.z
    local f = ((block.floor-1) * (th/2))
    
    
    -- top 4
    local p1 = generators.point(x, y-z, f) -- ttc
    local p2 = generators.point(x+tw/2,y+th/2-z, f)   -- tcr
    local p3 = generators.point(x,y+th-z, f) -- tbc
    local p4 = generators.point(x-tw/2,y+th/2-z, f) -- tcl

    local pc = generators.point(x, y, f)

    -- bottom 4
    local p5 = generators.point(x, y, f)  -- btc
    local p6 = generators.point(x+tw/2, y+th/2, f) -- bcr
    local p7 = generators.point(x, y+th, f)  -- bbc
    local p8 = generators.point(x-tw/2, y+th/2, f)  -- bcl

    if(block.i == BLOCKS.REGULAR)then
      --draw top
      solid_trifill_v3(p3,p2,p1,c1)
      solid_trifill_v3(p1,p4,p3,c1)
  
      --draw left
      solid_trifill_v3(p8,p7,p3,c2)
      solid_trifill_v3(p3,p4,p8,c2)
     
      --draw right
      solid_trifill_v3(p7,p6,p2,c3)
      solid_trifill_v3(p2,p3,p7,c3)
  
      if(block.has_hole)then
        palt(14, true)
        palt(0,false)
        spr(21,pc.x-4,pc.y-4)
  
        palt() 
  
        spr(22,pc.x-4,pc.y-4)
        spr(6,pc.x-4,pc.y-4-8)
      end
    elseif(block.i == BLOCKS.HALF_S)then
  
        -- i == BLOCKS.HALF_S
        --        ..1..
        --     ...     ...
        --  4_______________2
        --  |  ---     ---  |
        --  |     --3--     |
        --  8--     |     --6
        --     ---  |  ---
        --        --7--
  
  
      --draw top
      solid_trifill_v3(p4,p3,p2,c1) --t
  
      solid_trifill_v3(p8,p7,p3,c2) -- l
      solid_trifill_v3(p4,p8,p3,c2) -- l
  
      solid_trifill_v3(p2,p3,p7,c3) -- r
      solid_trifill_v3(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.HALF_W)then
      -- i == BLOCKS.HALF_W
      --        __1..
      --     ___  |  ...
      --  4__     |     ..2
      --  |  ___  |  ...  .
      --  |     __3..     .
      --  8__     |     ..6
      --     ___  |  ...
      --        __7..
  
  
      --draw top
      solid_trifill_v3(p4,p3,p1,c1)
  
      solid_trifill_v3(p8,p7,p3,c2) -- l
      solid_trifill_v3(p4,p8,p3,c2) -- l
  
    elseif(block.i == BLOCKS.HALF_N)then
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
      solid_trifill_v3(p4,p2,p1,c1)
  
      --draw 'front' (se)
      color(c3)
      rectfill(p4.x,p4.y,p6.x,p6.y)
  
    elseif(block.i == BLOCKS.HALF_E)then
    -- i == BLOCKS.HALF_E
    --        ..1__
    --     ...  |  ___
    --  4..     |     __2
    --  .  ...  |  ___  |
    --  .     ..3__     |
    --  8..     |     __6
    --     ...  |  ___
    --        ..7__  
      --draw top
      solid_trifill_v3(p1,p3,p2,c1)
  
      solid_trifill_v3(p2,p3,p7,c3) -- r
      solid_trifill_v3(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.RAMP_NW)then
      --draw top
      solid_trifill_v3(p1,p4,p7,c1)
      solid_trifill_v3(p7,p6,p1,c1)
  
      --draw left
      solid_trifill_v3(p8,p7,p4,c2)
    elseif(block.i == BLOCKS.RAMP_NE)then
  
      -- draw top
      solid_trifill_v3(p1,p8,p7,c1)
      solid_trifill_v3(p7,p2,p1,c1)
  
      --draw right
      solid_trifill_v3(p7,p6,p2,c3)
  
  
    elseif(block.i == BLOCKS.RAMP_SE)then
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .  ...     ...  .
    --  .     ..3--------
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..

  
      -- draw top
      solid_trifill_v3(p7,p6,p2,c3)
      solid_trifill_v3(p2,p3,p7,c3)
  
      --draw left
      solid_trifill_v3(p8,p7,p3,c2)
  
      --draw top
      solid_trifill_v3(p8,p3,p2,c1)
      solid_trifill_v3(p5,p8,p2,c1)
    elseif(block.i == BLOCKS.RAMP_SW)then
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .  ...     ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
  
      solid_trifill_v3(p4,p8,p3,c2) 
      solid_trifill_v3(p8,p7,p3,c2) -- l
  
      solid_trifill_v3(p7,p6,p3,c3) -- r
  
      solid_trifill_v3(p3,p6,p5,c6) --t
      solid_trifill_v3(p5,p4,p3,c6) 
    elseif(block.i == BLOCKS.RAMP_HALF_E)then
    -- i == BLOCKS.RAMP_HALF_E
    --        ./1..
    --     ../  |  ...
    --  4../    |     ..2
    --  ./      |  ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
  
      solid_trifill_v3(p1,p3,p2,c1) -- t
  
      solid_trifill_v3(p1,p8,p3,c6) -- sw
  
      solid_trifill_v3(p3,p8,p7,c2) -- l
  
      solid_trifill_v3(p2,p3,p7,c3) -- r
      solid_trifill_v3(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.RAMP_HALF_S)then
    --          1 
    --     _____5_____
    --  4_______________2
    --  .  ...      ...  .
    --  .     ..3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
      solid_trifill_v3(p3,p2,p4,c1) -- t
  
      solid_trifill_v3(p4,p2,p5,c6) -- 𝘯𝘸
  
      solid_trifill_v3(p4,p8,p3,c2) -- l
      solid_trifill_v3(p8,p7,p3,c2) -- l
  
      solid_trifill_v3(p7,p6,p3,c3) -- r
      solid_trifill_v3(p2,p3,p6,c3) -- r
    
      
    elseif(block.i == BLOCKS.RAMP_HALF_W)then
    --        ..1\
    --     ...  |  \
    --  4..     |   \    2
    --  .  ...  |    \   
    --  .     ..3__   \  
    --  8..     .  --- \ 6
    --     ...  .  ...
    --        ..7..  
  
      solid_trifill_v3(p4,p3,p1,c1) -- t
  
      solid_trifill_v3(p3,p6,p1,c6) -- 𝘯𝘦
  
      solid_trifill_v3(p4,p8,p3,c2) -- l
      solid_trifill_v3(p8,p7,p3,c2) -- l
  
      solid_trifill_v3(p7,p6,p3,c3) -- r
    elseif(block.i == BLOCKS.RAMP_HALF_N)then
    -- i == BLOCKS.RAMP_HALF_N
    --        ..1..
    --     ...     ...
    --  4_______________2
    --  . \           / .
    --  .   \        /  .
    --  8..  \     /  ..6
    --     ... \ /  ...
    --        ..7..  
      solid_trifill_v3(p1,p4,p2,c1) -- t
  
      solid_trifill_v3(p4,p7,p2,c3) -- 𝘴𝘦
      solid_trifill_v3(p8,p7,p4,c2) -- l
  
      solid_trifill_v3(p6,p2,p7,c3) -- r
  
    elseif(block.i == BLOCKS.RAMP_E)then
    --        ..1..
    --     ...     ...
    --  4..     5-------2
    --  .       |      /|
    --  .       |    /  |
    --  8..     |  /  __6
    --     ...  |/ ___
    --        ..7__
  
  
      solid_trifill_v3(p2,p5,p7,c6) -- sw
  
      solid_trifill_v3(p2,p7,p6,c3) -- r
   
    elseif(block.i == BLOCKS.RAMP_S)then
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .     / 3 \     .  
    --  .   /   |   \   . 
    --  8 /     |     \ 6
    --     ___  |   ___
    --        __7__
  
      solid_trifill_v3(p8,p7,p3,c2) -- l
  
      solid_trifill_v3(p3,p7,p6,c3) -- r
    elseif(block.i == BLOCKS.RAMP_W)then
    --        ..1..
    --     ...     ...
    --  4-------5      ..2
    --  |  \    |   ..   .  
    --  |   \   |..      . 
    --  8    \  |       6
    --    ___  \|  ...
    --        __7..
  
      solid_trifill_v3(p4,p8,p7,c2) -- l
  
      solid_trifill_v3(p5,p4,p7,c6) -- 𝘯𝘦
    elseif(block.i == BLOCKS.RAMP_N)then
    -- i == BLOCKS.RAMP_N
    --        ..1..
    --     ... / \ ...
    --  4..  /     \  ..2
    --  .  /         \  .  
    --  ./             \. 
    --  8---------------6
    --     ...  .  ...
    --        ..7..
  
      solid_trifill_v3(p1,p8,p6,c3) -- 𝘴𝘦
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

        color(c4)
     
        if(q == "a")then
          line(p3.x,p3.y,pc.x,pc.y)
          line(pc.x,pc.y,p4.x,p4.y)
          line(p4.x,p4.y,p3.x,p3.y)
          
          print(q, pc.x + 2, pc.y - 5, COLORS.ORANGE)
        elseif(q == "b")then
  
          line(p4.x,p4.y,pc.x,pc.y)
          line(pc.x,pc.y,p1.x,p1.y)
          line(p1.x,p1.y,p4.x,p4.y)
          
          print(q, pc.x + 2, pc.y - 5, COLORS.ORANGE)
        elseif(q == "c")then
  
          line(p1.x,p1.y,pc.x,pc.y)
          line(pc.x,pc.y,p2.x,p2.y)
          line(p2.x,p2.y,p1.x,p1.y)

          print(q, pc.x - 5, pc.y - 5, COLORS.ORANGE)
        elseif(q == "d")then
  
          line(p2.x,p2.y,pc.x,pc.y)
          line(pc.x,pc.y,p3.x,p3.y)
          line(p3.x,p3.y,p2.x,p2.y)

          print(q, pc.x - 5, pc.y - 5, COLORS.ORANGE)
        end
          
      end
    end
end

-- common comparators
function  ascending(a,b) return a<b end
function descending(a,b) return a>b end

-- a: array to be sorted in-place
-- c: comparator (optional, defaults to ascending)
-- l: first index to be sorted (optional, defaults to 1)
-- r: last index to be sorted (optional, defaults to #a)
function qsort(a,c,l,r)
    c,l,r=c or ascending,l or 1,r or #a
    if l<r then
        if c(a[r],a[l]) then
            a[l],a[r]=a[r],a[l]
        end
        local lp,rp,k,p,q=l+1,r-1,l+1,a[l],a[r]
        while k<=rp do
            if c(a[k],p) then
                a[k],a[lp]=a[lp],a[k]
                lp+=1
            elseif not c(a[k],q) then
                while c(q,a[rp]) and k<rp do
                    rp-=1
                end
                a[k],a[rp]=a[rp],a[k]
                rp-=1
                if c(a[k],p) then
                    a[k],a[lp]=a[lp],a[k]
                    lp+=1
                end
            end
            k+=1
        end
        lp-=1
        rp+=1
        a[l],a[lp]=a[lp],a[l]
        a[r],a[rp]=a[rp],a[r]
        qsort(a,c,l,lp-1       )
        qsort(a,c,  lp+1,rp-1  )
        qsort(a,c,       rp+1,r)
    end
end

function sortDepth(elem)
  qsort(elem, function(a,b) 
    return a.x0 + a.y0 + a.z0 - (a.zIndex/5) < b.x0 + b.y0 + b.z0 - (b.zIndex/5)
  end)
end

function render_scene(blocks, ball)
  -- NOTE a ball moving it's Z coordinate currently isn't
  -- followed by the camera. This might need to be tweaked
  -- if that's the case in the future
  local renderable_min_x = ball.current_grid.x - 2
  local renderable_max_x = ball.current_grid.x + 2
  local renderable_min_y = ball.current_grid.y - 2
  local renderable_max_y = ball.current_grid.y + 2
  
  for i = renderable_min_x,renderable_max_x do
    for j = renderable_min_y,renderable_max_y do
      draw_tile(i, j, COLORS.DARK_GREY)
    end    
  end

  drawn_ball = false
  drawn_ball_shadow = false

  renderables = {}
  for key, value in pairs(blocks) do
    renderables[key] = value
  end

  printf(ball.z)
  add(renderables, {zIndex=1,x0=ball.current_grid.x, y0=ball.current_grid.y, z0=ball.floor_height, class="ball_shadow"})
  add(renderables, {zIndex=-1,x0=ball.current_grid.x, y0=ball.current_grid.y, z0=ball.current_floor, class="ball"})

  sortDepth(renderables)

  printf('>>>>>> will render')
  for renderable in all(renderables) do

    printf(renderable.zIndex)

    if (renderable.class == 'block') then
      draw_block(renderable)
    end

    if (renderable.class == 'ball_shadow') then
      pset(64, 64 - ball.floor_height, 0) -- shadow      
    end 
    
    if (renderable.class == 'ball') then    
      pset(64, 64 - ball.z, ball.color)
    end 
  end
end

function _draw()
    -- camera and bg

    -- in this setup, camera follows ball around
    -- camera(-64+ball.x, -64 + ball.y)
    -- clip(-64+ball.x, -64+ ball.y)
    -- rectfill(-64+ball.x, -64+ ball.y, ball.x + 64, 64+ ball.y, c5)
    clip(-64, -64, 64, 64)
    rectfill(0, 0, 128, 128, c5)
    
    render_scene(blocks, ball)

    -- this will bring debug stuff to fixed position
    -- camera()
    -- clip()

    if current_distance_to_hole ~= nil then 
        print("dist hole " .. current_distance_to_hole, 1, 110, 5)
    end

    if block == nil then
        print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
    else 
        print(block.x0 .. ", " .. block.y0, 1, 120, 9)
    end

    -- print("b x:" .. ball.x .. " y:" .. ball.y .. " z:" .. ball.z, 1, 7, COLORS.BLACK)
    print("floor" .. ball.current_floor, 1, 7, COLORS.BLACK)
    -- print("ballg x:" .. ball.current_grid.x .. "   y:" .. ball.current_grid.y , 1, 14, COLORS.BLACK)
    -- print("ballf x:" .. ball.current_grid_float.x .. "   y:" .. ball.current_grid_float.y , 1, 21, COLORS.BLACK)
    -- print("floor z:" .. ball.floor_height , 1, 28, COLORS.BLACK)
    -- print("cpu:" .. stat(1)*100 .. "%" , 1, 35, COLORS.DARK_PURPLE)
    -- print("triangles:" .. debug_count_triangles , 1, 42, COLORS.DARK_PURPLE)
end
  