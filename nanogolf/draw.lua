function draw_ball(b)
    pset(b.x, b.y - b.floor_height, 0) -- shadow
    pset(b.x, b.y - b.z, ball.color)
end

function draw_tile(x0,y0, c)
  color(c)

  local x = (x0-y0) * tw/2
  local y = (x0+y0) * th/2

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
    local x = block.x
    local y = block.y
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
      trifill(p3,p2,p1,c1)
      trifill(p1,p4,p3,c1)
  
      --draw left
      trifill(p8,p7,p3,c2)
      trifill(p3,p4,p8,c2)
     
      --draw right
      trifill(p7,p6,p2,c3)
      trifill(p2,p3,p7,c3)
  
      if(block.has_hole)then
        palt(14, true)
        palt(0,false)
        spr(21,pc.x-4,pc.y-4)
  
        palt() 
  
        spr(22,pc.x-4,pc.y-4)
        spr(6,pc.x-4,pc.y-4-8)
      end
    elseif(block.i == BLOCKS.half_south)then
  
        -- i == BLOCKS.half_south
        --        ..1..
        --     ...     ...
        --  4_______________2
        --  |  ---     ---  |
        --  |     --3--     |
        --  8--     |     --6
        --     ---  |  ---
        --        --7--
  
  
      --draw top
      trifill(p4,p3,p2,c1) --t
  
      trifill(p8,p7,p3,c2) -- l
      trifill(p4,p8,p3,c2) -- l
  
      trifill(p2,p3,p7,c3) -- r
      trifill(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.half_west)then
      -- i == BLOCKS.half_west
      --        __1..
      --     ___  |  ...
      --  4__     |     ..2
      --  |  ___  |  ...  .
      --  |     __3..     .
      --  8__     |     ..6
      --     ___  |  ...
      --        __7..
  
  
      --draw top
      trifill(p4,p3,p1,c1)
  
      trifill(p8,p7,p3,c2) -- l
      trifill(p4,p8,p3,c2) -- l
  
    elseif(block.i == BLOCKS.half_north)then
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
      trifill(p4,p2,p1,c1)
  
      --draw 'front' (se)
      color(c3)
      rectfill(p4.x,p4.y,p6.x,p6.y)
  
    elseif(block.i == BLOCKS.half_east)then
    -- i == BLOCKS.half_east
    --        ..1__
    --     ...  |  ___
    --  4..     |     __2
    --  .  ...  |  ___  |
    --  .     ..3__     |
    --  8..     |     __6
    --     ...  |  ___
    --        ..7__  
      --draw top
      trifill(p1,p3,p2,c1)
  
      trifill(p2,p3,p7,c3) -- r
      trifill(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.ramp_north_west)then
      --draw top
      trifill(p1,p4,p7,c1)
      trifill(p7,p6,p1,c1)
  
      --draw left
      trifill(p8,p7,p4,c2)
    elseif(block.i == BLOCKS.ramp_north_east)then
  
      -- draw top
      trifill(p1,p8,p7,c1)
      trifill(p7,p2,p1,c1)
  
      --draw right
      trifill(p7,p6,p2,c3)
  
  
    elseif(block.i == BLOCKS.ramp_south_west)then
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
      trifill(p7,p6,p2,c3)
      trifill(p2,p3,p7,c3)
  
      --draw left
      trifill(p8,p7,p3,c2)
  
      --draw top
      trifill(p8,p3,p2,c1)
      trifill(p5,p8,p2,c1)
    elseif(block.i == BLOCKS.ramp_south_east)then
      -- i == BLOCKS.ramp_south_east
      --        ..1..
      --     ...     ...
      --  4..           ..2
      --  .  ...     ...  .
      --  .     ..3--------
      --  8..     .     ..6
      --     ...  .  ...
      --        ..7..
  
      trifill(p4,p8,p3,c2) 
      trifill(p8,p7,p3,c2) -- l
  
      trifill(p7,p6,p3,c3) -- r
  
      trifill(p3,p6,p5,c6) --t
      trifill(p5,p4,p3,c6) 
    elseif(block.i == BLOCKS.ramp_half_east)then
    -- i == BLOCKS.ramp_half_east
    --        ./1..
    --     ../  |  ...
    --  4../    |     ..2
    --  ./      |  ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
  
      trifill(p1,p3,p2,c1) -- t
  
      trifill(p1,p8,p3,c6) -- sw
  
      trifill(p3,p8,p7,c2) -- l
  
      trifill(p2,p3,p7,c3) -- r
      trifill(p7,p6,p2,c3) 
    elseif(block.i == BLOCKS.ramp_half_south)then
    -- i == BLOCKS.ramp_half_south
    -- i == BLOCKS.ramp_half_south
    --          1 
    --     _____5_____
    --  4_______________2
    --  .  ...      ...  .
    --  .     ..3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
      trifill(p3,p2,p4,c1) -- t
  
      trifill(p4,p2,p5,c6) -- 𝘯𝘸
  
      trifill(p4,p8,p3,c2) -- l
      trifill(p8,p7,p3,c2) -- l
  
      trifill(p7,p6,p3,c3) -- r
      trifill(p2,p3,p6,c3) -- r
    
      
    elseif(block.i == BLOCKS.ramp_half_west)then
    -- i == BLOCKS.ramp_half_west
    -- i == BLOCKS.ramp_half_west
    --        ..1\
    --     ...  |  \
    --  4..     |   \    2
    --  .  ...  |    \   
    --  .     ..3__   \  
    --  8..     .  --- \ 6
    --     ...  .  ...
    --        ..7..  
  
      trifill(p4,p3,p1,c1) -- t
  
      trifill(p3,p6,p1,c6) -- 𝘯𝘦
  
      trifill(p4,p8,p3,c2) -- l
      trifill(p8,p7,p3,c2) -- l
  
      trifill(p7,p6,p3,c3) -- r
    elseif(block.i == BLOCKS.ramp_half_north)then
    -- i == BLOCKS.ramp_half_north
    --        ..1..
    --     ...     ...
    --  4_______________2
    --  . \           / .
    --  .   \        /  .
    --  8..  \     /  ..6
    --     ... \ /  ...
    --        ..7..  
      trifill(p1,p4,p2,c1) -- t
  
      trifill(p4,p7,p2,c3) -- 𝘴𝘦
      trifill(p8,p7,p4,c2) -- l
  
      trifill(p6,p2,p7,c3) -- r
  
    elseif(block.i == BLOCKS.ramp_east)then
    -- i == 9
    --        ..1..
    --     ...     ...
    --  4..     5-------2
    --  .       |      /|
    --  .       |    /  |
    --  8..     |  /  __6
    --     ...  |/ ___
    --        ..7__
  
  
      trifill(p2,p5,p7,c6) -- sw
  
      trifill(p2,p7,p6,c3) -- r
   
    elseif(block.i == BLOCKS.ramp_south)then
    -- i == 10
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .     / 3 \     .  
    --  .   /   |   \   . 
    --  8 /     |     \ 6
    --     ___  |   ___
    --        __7__
  
      trifill(p8,p7,p3,c2) -- l
  
      trifill(p3,p7,p6,c3) -- r
    elseif(block.i == BLOCKS.ramp_west)then
    --        ..1..
    --     ...     ...
    --  4-------5      ..2
    --  |  \    |   ..   .  
    --  |   \   |..      . 
    --  8    \  |       6
    --    ___  \|  ...
    --        __7..
  
      trifill(p4,p8,p7,c2) -- l
  
      trifill(p5,p4,p7,c6) -- 𝘯𝘦
    elseif(block.i == BLOCKS.ramp_north)then
    -- i == BLOCKS.ramp_north
    --        ..1..
    --     ... / \ ...
    --  4..  /     \  ..2
    --  .  /         \  .  
    --  ./             \. 
    --  8---------------6
    --     ...  .  ...
    --        ..7..
  
      trifill(p1,p8,p6,c3) -- 𝘴𝘦
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
  
  --draw blocks
  foreach(blocks, draw_block)

  -- draw ball
  draw_ball(ball)
end

function _draw()
    -- camera and bg
    camera(-64+ball.x, -64+ ball.y)
    clip(-64+ball.x, -64+ ball.y)
    rectfill(-64+ball.x, -64+ ball.y, ball.x + 64, 64+ ball.y, c5)
    
    render_scene(blocks, ball)

    -- draw blocks
    --foreach(blocks, draw_block)

    -- draw ball
    --draw_ball(ball)

    -- this will bring debug stuff to fixed position
    camera()
    clip()

    if current_distance_to_hole ~= nil then 
        print("dist hole " .. current_distance_to_hole, 1, 110, 5)
    end

    if block == nil then
        print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
    else 
        print(block.x0 .. ", " .. block.y0, 1, 120, 9)
    end

    print("b x:" .. ball.x .. " y:" .. ball.y .. " z:" .. ball.z, 1, 7, COLORS.BLACK)
    -- print("ballg x:" .. ball.current_grid.x .. "   y:" .. ball.current_grid.y , 1, 14, COLORS.BLACK)
    -- print("ballf x:" .. ball.current_grid_float.x .. "   y:" .. ball.current_grid_float.y , 1, 21, COLORS.BLACK)
    print("floor z:" .. ball.floor_height , 1, 28, COLORS.BLACK)
    print("cpu:" .. stat(1)*100 .. "%" , 1, 35, COLORS.DARK_PURPLE)
    print("triangles:" .. debug_count_triangles , 1, 42, COLORS.DARK_PURPLE)
end
  