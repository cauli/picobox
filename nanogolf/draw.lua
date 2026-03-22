
function draw_wireframe_block(x0,y0,z0, c)
  color(c)

  local x = (x0-y0) * TILE_WIDTH_HALF
  local y = (x0+y0) * TILE_HEIGHT_HALF
  local z = (x0+y0) * TILE_HEIGHT_HALF
  
  x += (64 - ball.x)
  y += (64 - ball.y)
  line(x,y,x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF) -- n to e
  line(x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x,y+TILE_HEIGHT) -- e to s
  line(x,y+TILE_HEIGHT,x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF) -- s to w
  line(x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x,y) -- w to n

  line(x,y,x,y-TILE_HEIGHT_HALF) -- pole on n
  line(x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x+TILE_WIDTH_HALF,y) -- pole on  e
  line(x,y+TILE_HEIGHT,x,y+TILE_HEIGHT-TILE_HEIGHT_HALF) -- pole on s
  line(x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x-TILE_WIDTH_HALF,y) -- pole on  w

  line(x,y-TILE_HEIGHT_HALF,x+TILE_WIDTH_HALF,y) -- n to e
  line(x+TILE_WIDTH_HALF,y,x,y+TILE_HEIGHT_HALF) -- e to s
  line(x,y+TILE_HEIGHT_HALF,x-TILE_WIDTH_HALF,y) -- s to w
  line(x-TILE_WIDTH_HALF,y,x,y-TILE_HEIGHT_HALF) -- w to n

  if is_edit_mode then
    if (x0 + y0) % 2 == 0 then
      line(x-6,y +16,x+6,y + 16, COLORS.LIGHT_GREY)
    end
  
    print(x0 .. "," .. y0, x - 5, y  +10, COLORS.LIGHT_GREY)
  end 
end

function draw_tile(x0,y0, c)
  color(c)

  local x = (x0-y0) * TILE_WIDTH_HALF
  local y = (x0+y0) * TILE_HEIGHT_HALF
  
  x += (64 - ball.x)
  y += (64 - ball.y)
  line(x,y,x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF)
  line(x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x,y+TILE_HEIGHT)
  line(x,y+TILE_HEIGHT,x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF)
  line(x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF,x,y)


  if is_edit_mode then
    if (x0 + y0) % 2 == 0 then
      line(x-6,y +16,x+6,y + 16, COLORS.LIGHT_GREY)
    end
  
    print(x0 .. "," .. y0, x - 5, y  +10, COLORS.LIGHT_GREY)
  end 
end

function draw_block_shadow(block)
  draw_block(block, true)
end 

function project_shadow_px(p, f)
  local offset_x = ox
  local offset_y = oy

  local p_grid = px_to_grid_float(p.x, p.y)
  p_grid.z = f
  local p_projected = project_point(p_grid, offset_x, offset_y)
  local p_to_px = grid_to_px(p_projected.x, p_projected.y, p_projected.z)

  return p_to_px
end

-- triangle definitions per block type
-- each entry: {point_index_a, point_index_b, point_index_c, color_index}
-- points: 1=top-n 2=top-e 3=top-s 4=top-w 5=bot-n 6=bot-e 7=bot-s 8=bot-w
-- colors: 1=c1(top) 2=c2(left) 3=c3(right) 4=c4 5=c5 6=c6(slope)
--
--        ..1..          point layout (top view):
--     ...     ...
--  4..           ..2        1
--  .  ...     ...  .      4   2
--  .     ..3..     .        3
--  8..     .     ..6
--     ...  .  ...       (mirrored below: 5-8)
--        ..7..
BLOCK_TRIS = {
  -- REGULAR: full flat top + left + right faces
  [0]  = {{3,2,1,1},{1,4,3,1},{8,7,3,2},{3,4,8,2},{7,6,2,3},{2,3,7,3}},
  -- HALF_S: plateau on south half (4-2 edge cuts across middle)
  [1]  = {{4,3,2,1},{8,7,3,2},{4,8,3,2},{2,3,7,3},{7,6,2,3}},
  -- HALF_W: plateau on west half (1-3 edge cuts across middle)
  [2]  = {{4,3,1,1},{8,7,3,2},{4,8,3,2}},
  -- HALF_N: plateau on north half, rectfill for front face
  [3]  = {{4,2,1,1},{4,2,6,3},{4,6,8,3}},
  -- HALF_E: plateau on east half
  [4]  = {{1,3,2,1},{2,3,7,3},{7,6,2,3}},
  -- RAMP_NW: diagonal ramp rising to NW
  [5]  = {{1,4,7,1},{7,6,1,1},{8,7,4,2}},
  -- RAMP_NE: diagonal ramp rising to NE
  [6]  = {{1,8,7,1},{7,2,1,1},{7,6,2,3}},
  -- RAMP_SW: diagonal ramp rising to SW
  [7]  = {{4,8,3,2},{8,7,3,2},{7,6,3,3},{3,6,5,6},{5,4,3,6}},
  -- RAMP_SE: diagonal ramp rising to SE
  [8]  = {{7,6,2,3},{2,3,7,3},{8,7,3,2},{8,3,2,1},{5,8,2,1}},
  -- RAMP_HALF_E: half ramp rising to NE, plateau on SE
  [9]  = {{1,3,2,1},{1,8,3,6},{3,8,7,2},{2,3,7,3},{7,6,2,3}},
  -- RAMP_HALF_S: half ramp rising to SE, plateau on NE
  [10] = {{3,2,4,1},{4,2,5,6},{4,8,3,2},{8,7,3,2},{7,6,3,3},{2,3,6,3}},
  -- RAMP_HALF_W: half ramp rising to SW, plateau on NW
  [11] = {{4,3,1,1},{3,6,1,6},{4,8,3,2},{8,7,3,2},{7,6,3,3}},
  -- RAMP_HALF_N: half ramp rising to NW, plateau on NE
  [12] = {{1,4,2,1},{4,7,2,3},{8,7,4,2},{6,2,7,3}},
  -- RAMP_E: small corner ramp, rises from 7 to 2 (east corner)
  [13] = {{2,5,7,6},{2,7,6,3}},
  -- RAMP_S: small corner ramp, rises from 8+2 to 3 (south corner)
  [14] = {{8,7,3,2},{3,7,6,3}},
  -- RAMP_W: small corner ramp, rises from 7 to 4 (west corner)
  [15] = {{4,8,7,2},{5,4,7,6}},
  -- RAMP_N: small corner ramp, rises from 8+6 to 1 (north corner)
  [16] = {{1,8,6,3}},
}

function draw_block(block, is_shadow)
    local x = block.x + (64 - ball.x)
    local y = block.y + (64 - ball.y)
    local z = block.z
    local f = ((block.floor-1) * (TILE_HEIGHT_HALF))
    
    local is_procedural = block.is_procedural
    local is_user = block.is_user

    -- top 4
    local p1 = generators.point(x, y-z, f)
    local p2 = generators.point(x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF-z, f)
    local p3 = generators.point(x,y+TILE_HEIGHT-z, f)
    local p4 = generators.point(x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF-z, f)

    local pc = generators.point(x, y, f)

    -- bottom 4
    local p5 = generators.point(x, y, f)
    local p6 = generators.point(x+TILE_WIDTH_HALF, y+TILE_HEIGHT_HALF, f)
    local p7 = generators.point(x, y+TILE_HEIGHT, f)
    local p8 = generators.point(x-TILE_WIDTH_HALF, y+TILE_HEIGHT_HALF, f)

    local c1 = c1 
    local c2 = c2
    local c3 = c3    
    local c4 = c4 
    local c5 = c5
    local c6 = c6

    if is_shadow == true then
      if is_shadow_debug == true then
        c1 = COLORS.GREEN
        c2 = COLORS.RED
        c3 = COLORS.BLUE
        c4 = COLORS.BLACK
        c5 = COLORS.DARK_GREEN
        c6 = COLORS.DARK_BLUE
      else 
        c1 = COLORS.DARK_PURPLE
        c2 = COLORS.DARK_PURPLE
        c3 = COLORS.DARK_PURPLE
        c4 = COLORS.DARK_PURPLE
        c5 = COLORS.DARK_PURPLE
        c6 = COLORS.DARK_PURPLE
      end

      p1 = project_shadow_px(p1, block.z)
      p2 = project_shadow_px(p2, block.z)
      p3 = project_shadow_px(p3, block.z)
      p4 = project_shadow_px(p4, block.z)
    end 

    local pts = {p1,p2,p3,p4,p5,p6,p7,p8}
    local cols = {c1,c2,c3,c4,c5,c6}
    local tris = BLOCK_TRIS[block.i]
    if tris then
      for t in all(tris) do
        solid_trifill_v3(pts[t[1]],pts[t[2]],pts[t[3]],cols[t[4]])
      end
    end

    if block.i == BLOCKS.REGULAR and block.has_hole then
      palt(14, true)
      palt(0,false)
      spr(21,pc.x-4,pc.y-4)
      palt() 
      spr(22,pc.x-4,pc.y-4)
      spr(6,pc.x-4,pc.y-4-8)
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
  
        local q = get_quadrant(ball.current_grid_float.x % flr(ball.current_grid_float.x),ball.current_grid_float.y % flr(ball.current_grid_float.y))

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

    if is_edit_mode then 
      if is_procedural then
        spr(16,pc.x-4,pc.y-4)
      end

      if is_user then
        spr(17,pc.x-4,pc.y-4)
      end
    end
end

-- common comparators
function  ascending(a,b) return a<b end
function descending(a,b) return a>b end

function sortDepth(elem)
  qsort(elem, function(a,b) 
    return a.x0 + a.y0 + a.z0 - (a.zIndex/5) < b.x0 + b.y0 + b.z0 - (b.zIndex/5)
  end)
end

function render_scene(blocks, ball)
  local renderable_min_x = ball.current_grid.x - 2
  local renderable_max_x = ball.current_grid.x + 2
  local renderable_min_y = ball.current_grid.y - 2
  local renderable_max_y = ball.current_grid.y + 2
  
  for i = renderable_min_x,renderable_max_x do
    for j = renderable_min_y,renderable_max_y do
      draw_tile(i, j, COLORS.DARK_GREY)
    end    
  end

  for b in all(blocks) do
    if b.class == 'block' then
      draw_block_shadow(b)
    end
  end

  local ball_draw_z = max(ball.z, ball.floor_height)
  local ball_screen_y = 64 - ball_draw_z
  local shadow_screen_y = 64 - ball.floor_height
  local ball_depth = ball.current_grid.x + ball.current_grid.y + ball.current_floor

  -- draw blocks behind the ball
  for b in all(blocks) do
    if b.class == 'block' then
      local block_depth = b.x0 + b.y0 + b.z0
      if block_depth < ball_depth then
        draw_block(b)
      end
    end
  end

  -- draw ball marker, then blocks in front
  pset(64, shadow_screen_y, 0)
  pset(64, ball_screen_y, COLORS.PINK)

  for b in all(blocks) do
    if b.class == 'block' then
      local block_depth = b.x0 + b.y0 + b.z0
      if block_depth >= ball_depth then
        draw_block(b)
      end
    end
  end

  -- if the marker was overwritten, the ball is occluded
  if pget(64, ball_screen_y) ~= COLORS.PINK then
    pset(64, ball_screen_y, COLORS.DARK_GREY)
  else
    pset(64, ball_screen_y, ball.color)
  end

  if is_edit_mode == true then
    draw_wireframe_block(cursor_position.x, cursor_position.y, cursor_position.z, COLORS.PINK)
  end 
end

function _draw()
    clip(-64, -64, 64, 64)
    rectfill(0, 0, 128, 128, c5)
    
    render_scene(blocks, ball)

    if current_distance_to_hole ~= nil then 
        print("dist hole " .. current_distance_to_hole, 1, 110, 5)
    end

    if ball.current_block == nil then
        print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
    else 
        print(ball.current_block.x0 .. ", " .. ball.current_block.y0, 1, 120, 9)
    end
end
