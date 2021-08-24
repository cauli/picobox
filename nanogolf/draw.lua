
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
  -- in order to keep the triangles drawn for the blocks, 
  -- the shadow can only project "up"
  -- in the screen (towards NORTH)
  -- if we wish to draw shadows to other directions, we need to choose other triangles to draw
  -- depending on the base block type

  
  srand(globalSubSeeds.waveFn1)
  shadowInverter1 = 1
  if rnd() < 0.3 then shadowInverter1 = -1 end
  srand(globalSubSeeds.waveFn2)
  shadowInverter2 = 1
  if rnd() < 0.3 then shadowInverter2 = -1 end

  srand(globalSubSeeds.shadowDir1)
  local offset_x = rnd() * -0.20 * shadowInverter1
  srand(globalSubSeeds.shadowDir2)
  local offset_y = rnd() * -0.20 * shadowInverter2


  local p_grid = px_to_grid_float(p.x, p.y)
  p_grid.z = f
  p_projected = project_point(p_grid, offset_x, offset_y)
  p_to_px = grid_to_px(p_projected.x, p_projected.y, p_projected.z)

  return p_to_px
end

function draw_decoration(decoration)

  pos = grid_to_px(decoration.x0, decoration.y0, decoration.z0)

  local x = pos.x + (64 - ball.x) - 4
  local y = pos.y + (64 - ball.y) + 5 + decoration.offsetY
  local z = pos.z
  
  if (decoration.sprites[decoration.frame] ~= nil) then
    spr(decoration.sprites[decoration.frame], x, y, decoration.w, decoration.h)
  end
end

function draw_block(block, is_shadow)
    local x = block.x + (64 - ball.x)
    local y = block.y + (64 - ball.y)
    local z = block.z
    local f = ((block.floor-1) * (TILE_HEIGHT_HALF))

    local is_procedural = block.is_procedural
    local is_user = block.is_user

    -- top 4
    local pc = generators.point(x, y, f)
    
    -- skip rendering blocks that are too distant
    if distance(ball, block) > 128 then 
      return 
    end    

    local p1 = generators.point(x, y-z, f) -- ttc
    local p2 = generators.point(x+TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF-z, f)   -- tcr
    local p3 = generators.point(x,y+TILE_HEIGHT-z, f) -- tbc
    local p4 = generators.point(x-TILE_WIDTH_HALF,y+TILE_HEIGHT_HALF-z, f) -- tcl

    -- bottom 4
    local p5 = generators.point(x, y, f)  -- btc
    local p6 = generators.point(x+TILE_WIDTH_HALF, y+TILE_HEIGHT_HALF, f) -- bcr
    local p7 = generators.point(x, y+TILE_HEIGHT, f)  -- bbc
    local p8 = generators.point(x-TILE_WIDTH_HALF, y+TILE_HEIGHT_HALF, f)  -- bcl

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
        c1 = c7
        c2 = c7
        c3 = c7
        c4 = c7
        c5 = c7
        c6 = c7
      end

      -- top
      p1 = project_shadow_px(p1, block.z)
      p2 = project_shadow_px(p2, block.z)
      p3 = project_shadow_px(p3, block.z)
      p4 = project_shadow_px(p4, block.z)

      -- bottom
      -- p5 = project_shadow_px(p5, f)
      -- p6 = project_shadow_px(p6, f)
      -- p7 = project_shadow_px(p7, f)
      -- p8 = project_shadow_px(p8, f)

    end 
   
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
      --draw top
      solid_trifill_v3(p4,p3,p2,c1) --t
  
      solid_trifill_v3(p8,p7,p3,c2) -- l
      solid_trifill_v3(p4,p8,p3,c2) -- l
  
      solid_trifill_v3(p2,p3,p7,c3) -- r
      solid_trifill_v3(p7,p6,p2,c3) 

      
    elseif(block.i == BLOCKS.RAMP_HALF_W)then
      solid_trifill_v3(p4,p3,p1,c1) -- t
  
      solid_trifill_v3(p3,p6,p1,c6) -- 𝘯𝘦
  
      solid_trifill_v3(p4,p8,p3,c2) -- l
      solid_trifill_v3(p8,p7,p3,c2) -- l
  
      solid_trifill_v3(p7,p6,p3,c3) -- r
    elseif(block.i == BLOCKS.RAMP_HALF_N)then
      solid_trifill_v3(p1,p4,p2,c1) -- t
  
      solid_trifill_v3(p4,p7,p2,c3) -- 𝘴𝘦
      solid_trifill_v3(p8,p7,p4,c2) -- l
  
      solid_trifill_v3(p6,p2,p7,c3) -- r
     elseif(block.i == BLOCKS.HALF_W)then
         solid_trifill_v3(p4,p3,p1,c1)

         solid_trifill_v3(p8,p7,p3,c2) -- l
         solid_trifill_v3(p4,p8,p3,c2) -- l

     elseif(block.i == BLOCKS.HALF_N)then
      solid_trifill_v3(p4,p2,p1,c1)

      color(c3)
      rectfill(p4.x,p4.y,p6.x,p6.y)

    elseif(block.i == BLOCKS.HALF_E)then
      solid_trifill_v3(p1,p3,p2,c1)

      solid_trifill_v3(p2,p3,p7,c3) -- r
      solid_trifill_v3(p7,p6,p2,c3)
    elseif(block.i == BLOCKS.RAMP_NW)then
      solid_trifill_v3(p1,p4,p7,c1)
      solid_trifill_v3(p7,p6,p1,c1)

      solid_trifill_v3(p8,p7,p4,c2)
    elseif(block.i == BLOCKS.RAMP_NE)then
      solid_trifill_v3(p1,p8,p7,c1)
      solid_trifill_v3(p7,p2,p1,c1)
      solid_trifill_v3(p7,p6,p2,c3)
    elseif(block.i == BLOCKS.RAMP_SE)then
      solid_trifill_v3(p7,p6,p2,c3)
      solid_trifill_v3(p2,p3,p7,c3)

      solid_trifill_v3(p8,p7,p3,c2)

      solid_trifill_v3(p8,p3,p2,c1)
      solid_trifill_v3(p5,p8,p2,c1)
    elseif(block.i == BLOCKS.RAMP_SW)then
      solid_trifill_v3(p4,p8,p3,c2)
      solid_trifill_v3(p8,p7,p3,c2)

      solid_trifill_v3(p7,p6,p3,c3)

      solid_trifill_v3(p3,p6,p5,c6)
      solid_trifill_v3(p5,p4,p3,c6)
    elseif(block.i == BLOCKS.RAMP_HALF_E)then

      solid_trifill_v3(p1,p3,p2,c1)

      solid_trifill_v3(p1,p8,p3,c6)

      solid_trifill_v3(p3,p8,p7,c2)

      solid_trifill_v3(p2,p3,p7,c3)
      solid_trifill_v3(p7,p6,p2,c3)
    elseif(block.i == BLOCKS.RAMP_HALF_S)then
      solid_trifill_v3(p3,p2,p4,c1)

      solid_trifill_v3(p4,p2,p5,c6)

      solid_trifill_v3(p4,p8,p3,c2)
      solid_trifill_v3(p8,p7,p3,c2)

      solid_trifill_v3(p7,p6,p3,c3)
      solid_trifill_v3(p2,p3,p6,c3)
    elseif(block.i == BLOCKS.RAMP_E)then
      solid_trifill_v3(p2,p5,p7,c6)
      solid_trifill_v3(p2,p7,p6,c3)
    elseif(block.i == BLOCKS.RAMP_S)then
      solid_trifill_v3(p8,p7,p3,c2)
      solid_trifill_v3(p3,p7,p6,c3)
    elseif(block.i == BLOCKS.RAMP_W)then
      solid_trifill_v3(p4,p8,p7,c2)
      solid_trifill_v3(p5,p4,p7,c6)
    elseif(block.i == BLOCKS.RAMP_N)then  
      solid_trifill_v3(p1,p8,p6,c3)
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

  renderables = TableConcat(renderables, decorations)

  add(renderables, {zIndex=1,x0=ball.current_grid.x, y0=ball.current_grid.y, z0=ball.floor_height, class="ball_shadow"})
  add(renderables, {zIndex=-1,x0=ball.current_grid.x, y0=ball.current_grid.y, z0=ball.current_floor, class="ball"})

  sortDepth(renderables)


  srand(globalSubSeeds.wireframeBoundaries)
  draw_wireframe = false
  wireframe_color = c1
  if rnd() <= 0.02 then
    draw_wireframe = true
    wireframe_color = rnd({c1,c2,c3,c4,c5,c6,c7})
  end

  srand(globalSubSeeds.waveFn1)
  if rnd() < 0.4 then
    for renderable in all(renderables) do
      if (renderable.class == 'block') then
        draw_block_shadow(renderable)
      end
    end
  end

  for renderable in all(renderables) do
    if (renderable.class == 'block') then
      draw_block(renderable, false)

      if (draw_wireframe) then draw_wireframe_block(renderable.x0, renderable.y0, renderable.z0, wireframe_color) end 
      
    end

    if (renderable.class == 'decoration') then
      draw_decoration(renderable)
    end

    if (renderable.class == 'ball_shadow') then
      pset(64, 64 - ball.floor_height, 0) -- shadow      
    end 
    
    if (renderable.class == 'ball') then    
      pset(64, 64 - ball.z, ball.color)
    end 
  end

  if is_edit_mode == true then
    -- edit mode current tile
    draw_wireframe_block(cursor_position.x, cursor_position.y, cursor_position.z, COLORS.PINK)
  end 
end

function _draw()
    -- camera and bg
    clip(-64, -64, 64, 64)
    rectfill(0, 0, 128, 128, c5)
    
    render_scene(blocks, ball)
        
    -- if block == nil then
    --     print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
    -- else 
    --     print(block.x0 .. ", " .. block.y0, 1, 120, 9)
    -- end

end
  