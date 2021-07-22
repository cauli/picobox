
global_state = {
  change_level = {
    will_change_level = false,
    counter = 0,
    max_counter = 10
  }
}

tw = 50
th = 25
tz = 12.5/2

-- height climbable
height_climbable = 5

-- physics parameters
gravity = 0.3
friction = 0.97
bounce = 1

blocks = {}

debug_quadrants = false
debug_count_triangles = 0

current_distance_to_hole = nil

cursor_position = {x=0, y=0, z=0}
is_edit_mode = false
function toggle_edit_mode()
  -- TODO how to invert boolean on lua?
  if is_edit_mode then 
    is_edit_mode = false
  else 
    is_edit_mode = true

    cursor_position.x = ball.current_grid.x
    cursor_position.y = ball.current_grid.y

    teletransport_ball_to(ball, cursor_position.x, cursor_position.y, 5)
  end
end
menuitem(1, "edit level", toggle_edit_mode )


--        ..1..
--     ...     ...
--  4..           ..2
--  .  ...     xxxxxx
--  .     ..3xxxxxxxx
--  8..     xxxxxxxx6
--     .    xxxxxxx
--        ..7xx  
function hit_right_wall(b)
  local tempy = b.vy
  b.vy = b.vx
  b.vx = tempy

  b.vx = -b.vx
  b.vy = -b.vy

  ball.color = COLORS.WHITE

  -- 𝘸e always set 𝘮ay 𝘣e 𝘴tuck to true when hitting a wall.
  -- 𝘵hen we count the may_be_stuck frames and, if > than 𝘵hreshold,
  -- 𝘸e set the ball to the latest safe position
  ball.may_be_stuck = true
end

--        ..1..
--     ...     ...
--  4xx           ..2
--  xxxxxx     ...  .
--  xxxxxxxx3..     .
--  8xxxxxxxx     ..6
--     xxxxxx  ...
--        xx7..  zx
function hit_left_wall(b)
  local tempy = -b.vy
  b.vy = -b.vx
  b.vx = tempy

  b.vx = -b.vx
  b.vy = -b.vy

  ball.color = COLORS.WHITE

  -- 𝘸e always set 𝘮ay 𝘣e 𝘴tuck to true when hitting a wall.
  -- 𝘵hen we count the may_be_stuck frames and, if > than 𝘵hreshold,
  -- 𝘸e set the ball to the latest safe position
  ball.may_be_stuck = true
end

function update_movement_ball(b)

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
          ball.vz = -1 * ball.vz

          if (abs(ball.vz) >= 1) then
            sfx(0)
          else 
            sfx(3)
          end 
        end

        if(debug_quadrants)then
          ball.color = COLORS.WHITE
        end
      -- (unclimbable)
      else
        b.x = b.oldx
        b.y = b.oldy
        b.z = b.oldz

        if(ball.quadrant == "b" or ball.quadrant == "d")then
          hit_right_wall(b)
        elseif(ball.quadrant == "a" or ball.quadrant == "c")then
          hit_left_wall(b)
        end

        if(abs(ball.vz) < 0.5)then
          ball.vz = 0
        else
          ball.vz = -1 * ball.vz
          sfx(0)
        end

      end
  else
     ball.may_be_stuck = false
     ball.color = COLORS.WHITE
  end

  if(ball.z < 0)then
    ball.z = 0.5
  end

  b.oldx = b.x
  b.oldy = b.y
  b.oldz = b.z
  
  b.x = b.x + b.vx
  b.y = b.y + b.vy
  b.z = b.z + b.vz

  b.z = b.z - gravity

  ball.last_floor_height = ball.floor_height
  
  b.current_grid =       px_to_grid(b.x, b.y)
  b.current_grid_float = px_to_grid_float(ball.x, ball.y + ball.z)

end

function teletransport_ball_to(b, x0,y0,z0)
  pos_px = grid_to_px(x0,y0,z0+1)

  b.x = pos_px.x
  b.y = pos_px.y
  b.z = pos_px.z

  b.oldx = b.x
  b.oldy = b.y
  b.oldz = b.z

  b.current_grid =       px_to_grid(b.x, b.y)
  b.current_grid_float = px_to_grid_float(b.x, b.y + b.z)
end

function _init()
  ball = generators.ball(3,1,1)
  next_level()
end

-- given X, Y, Z coordinates, will
-- return the "Block" object existing in that position
function get_block_at(x,y,z)
  local possible_blocks = {}
  
  if z < 0 then 
    z = 0
  end 
  for block in all(blocks) do
    if(block.x0 == x and block.y0 == y and (block.floor-1)*(tz*2) <= z+2)then
      add(possible_blocks, block)
    end
  end

  if #possible_blocks == 0 then 
    return nil
  end 

  if #possible_blocks == 1 then
    return possible_blocks[1]
  end 

  selected_block = possible_blocks[0]
  for b in all(possible_blocks) do 
    if selected_block == nil then 
      selected_block = b
    else 
      if b.floor > selected_block.floor then
        selected_block = b
      end 
    end 
  end
  return selected_block
end

function raise(thing)
  thing.z += tz/2
end

function lower(thing)
  thing.z -= tz/2
end

-- TODO refactor force
function add_force(obj, dir, force)
  if(dir == "s")then
   obj.oldx += 0.3 * force
   obj.oldy -= 0.1 * force
  end

  if(dir == "n")then
   obj.oldx -= 0.3 * force
   obj.oldy += 0.1 * force
  end

  if(dir == "w")then
   obj.oldx += 0.3 * force
   obj.oldy += 0.1 * force
  end

  if(dir == "e")then
   obj.oldx -= 0.3 * force
   obj.oldy -= 0.1 * force
  end

  if(dir == "se")then
   add_force(obj, "s", force * 0.5)
   add_force(obj, "e", force * 0.5)
  end

  if(dir == "nw")then
   add_force(obj, "n", force * 0.5)
   add_force(obj, "w", force * 0.5)
  end

  if(dir == "ne")then
   add_force(obj, "n", force * 0.5)
   add_force(obj, "e", force * 0.5)
  end

  if(dir == "sw")then
   add_force(obj, "s", force * 0.5)
   add_force(obj, "w", force   * 0.5)
  end
end

function get_ball_vertical_speed_multiplier()
  local dz = ball.oldz - ball.z
  return min(max(dz*5,1),17)
 end

function tablesize(t)
  local c=0
  for k,v in pairs(t) do
    c+=1
  end
  return c
end

latest_block_type_created = BLOCKS.REGULAR
function update_edit_mode()
  if (btnp(0)) then
    cursor_position.y = cursor_position.y + 1
  elseif (btnp(1)) then
    cursor_position.y = cursor_position.y - 1
  elseif (btnp(2)) then
    cursor_position.x = cursor_position.x - 1
  elseif (btnp(3)) then
    cursor_position.x = cursor_position.x + 1
  end

  teletransport_ball_to(ball, cursor_position.x, cursor_position.y, 5)

  local current_block = get_block_at(cursor_position.x, cursor_position.y, cursor_position.z)

  if (btnp(5,0)) then 
    if current_block != nil then
      del(blocks, current_block)
      sfx(1)
    end
  end  

  if (btnp(4,0)) then 
    sfx(2)

    if current_block != nil then
      if current_block.i ~= nil then 
        local next_i = current_block.i + 1
      
        if next_i >= tablesize(BLOCKS) then
          next_i = 0
        end 
  
        del(blocks, current_block)
        latest_block_type_created = next_i
        create_block({cursor_position.x,cursor_position.y,1,next_i,false}, true)
      else 
        del(blocks, current_block)
        create_block({cursor_position.x,cursor_position.y,1,latest_block_type_created,false}, true)
      end

    else
      create_block({cursor_position.x,cursor_position.y,1,latest_block_type_created,false}, true)
    end
  end
end

function _update()

  if (global_state.change_level.will_change_level) then
    global_state.change_level.counter = global_state.change_level.counter + 1

    if (global_state.change_level.counter > global_state.change_level.max_counter) then 
      next_level()
    end 
  end 

  debug_count_triangles = 0

  if is_edit_mode == false then 
    update_movement_ball(ball)

    if (btn(0)) then -- south
      add_force(ball, "s", .4) 
    elseif (btn(1)) then -- north
      add_force(ball, "n", .4)
    elseif (btn(2)) then -- west
      add_force(ball, "w", .4)
    elseif (btn(3)) then  -- east
      add_force(ball, "e", .4)
    end

    if(ball.may_be_stuck)then
      ball.stuck_frame_count += 1
    else
      ball.stuck_frame_count = 0
    end
  
    if(ball.stuck_frame_count > 5)then
      -- 𝘵𝘰𝘥𝘰
      -- 𝘰𝘱𝘵𝘪𝘰𝘯 1 set this to the latest safe position, with a correct speed
      -- 𝘰𝘱𝘵𝘪𝘰𝘯 2 set this to the calculated safe position, near the stucking block on the same quadrant
      -- 𝘰𝘱𝘵𝘪𝘰𝘯 3 fix the math with rounding so that this 
      ball.z = 50
      ball.oldz = 50
    end
  
    if (btnp(4,0)) then raise(ball) end
    if (btnp(5,0)) then next_level() end
  
    -- no need to call this if update_movement_ball is one
    ball.current_grid =       px_to_grid(ball.x, ball.y)
    ball.current_grid_float = px_to_grid_float(ball.x, ball.y)
    ball.current_floor = 1 + (ball.z / (th/2))
  
    block = get_block_at(ball.current_grid.x, ball.current_grid.y, ball.z)
  
    hole = {}
    hole.x = 0
    hole.y = 0
    
    local not_on_slope = false
  
    if block == nil then
      ball.floor_height = 0
    -- plain block
    else 
      block_floor_offset = ((block.floor-1) * tz * 2)
      quadrant = get_quadrant(ball.current_grid_float.x % flr(ball.current_grid_float.x), ball.current_grid_float.y % flr(ball.current_grid_float.y))
      ball.quadrant = quadrant
  
      -- it's simple to calculate this type of block's height
      if(block.i == 0)then
        
        if(block.has_hole)then
          hole = {}
          hole.x = block.x
          hole.y = block.y - block_floor_offset
  
          ball_copy = {}
          ball_copy.x = ball.x
          ball_copy.y = ball.y - ball.z
  
          current_distance_to_hole = distance(ball_copy,block)
          if(current_distance_to_hole < (tz*2))then
            ball.floor_height = 0 + block_floor_offset
  
            global_state.change_level.will_change_level = true
          else
            ball.floor_height = (block.height  * tz * 2) + block_floor_offset
          end
        else
          ball.floor_height = (block.height  * tz * 2) + block_floor_offset
        end  
      -- 45 degrees angles blocks
      elseif(block.i == BLOCKS.HALF_S or block.i == BLOCKS.HALF_W or block.i == BLOCKS.HALF_N or block.i == BLOCKS.HALF_E)then
     
        if(ball.quadrant == block.top1 or ball.quadrant == block.top2)then
          ball.floor_height = (block.height  * tz * 2) + block_floor_offset
        else
          ball.floor_height = 0 + block_floor_offset
        end
  
      -- diagonal ramp blocks z=(1-x/a-y/b)*c
      elseif(block.i == BLOCKS.RAMP_E or block.i == BLOCKS.RAMP_S or block.i ==BLOCKS.RAMP_W or block.i == BLOCKS.RAMP_N)then
        local pns
        local pwe
  
        pns = ball.current_grid_float.y % flr(ball.current_grid_float.y)
        pwe = ball.current_grid_float.x % flr(ball.current_grid_float.x)
  
        -- z=(1-x/a-y/b)*c
        -- 𝘩𝘦𝘪𝘨𝘩𝘵 equals ( 1 - current𝘹 / "full𝘹" - current𝘺 / "full𝘺" ) * full𝘩eight
        
        if(ball.quadrant == nil)then
            -- do nothing
            not_on_slope = true
  
            ball.floor_height = block.height + block_floor_offset
        elseif(ball.quadrant == block.slope1 or ball.quadrant == block.slope2)then
          if(block.i == BLOCKS.RAMP_N)then
            ball.floor_height = (1- (pns*16)/16 - (pwe*16)/16)  * (block.height  * tz * 2) + block_floor_offset
          elseif(block.i == BLOCKS.RAMP_E)then
            ball.floor_height = (1- (pns *16)/16 - (abs(1-pwe) *16)/16)  * (block.height  * tz*2)+ block_floor_offset
          elseif(block.i ==BLOCKS.RAMP_W)then
            ball.floor_height = (1- (abs(1-pns)  *16)/16 - (pwe*16)/16)  * (block.height  * tz*2)+ block_floor_offset
          elseif(block.i == BLOCKS.RAMP_S)then
            ball.floor_height = (1- ( abs(1-pns) *16)/16 - ( abs(1-pwe) *16)/16)  * (block.height  * tz * 2)+ block_floor_offset
          end
        else 
            -- do nothing
            not_on_slope = true
            ball.floor_height = block.height -1 
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
        if(block.i == BLOCKS.RAMP_HALF_E or block.i == BLOCKS.RAMP_HALF_S or block.i == BLOCKS.RAMP_HALF_W or block.i == BLOCKS.RAMP_HALF_N)then -- half block
      
          if(ball.quadrant == nil)then
            -- do nothing
            not_on_slope = true
          elseif(ball.quadrant == "b" and (block.slope1 == "b" or block.slope2 == "b"))then
            if(block.i == BLOCKS.RAMP_HALF_S)then 
              percent = pns
            else
              percent = abs(pns - 1)
            end
            ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
          elseif(ball.quadrant == "a" and (block.slope1 == "a" or block.slope2 == "a"))then
            if(block.i == BLOCKS.RAMP_HALF_N)then -- 4 is 𝘶𝘱
              percent = abs(pwe - 1)
            else
              percent = pwe  -- 4 is 𝘥𝘰𝘸𝘯
            end
            ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
          elseif(ball.quadrant == "c" and (block.slope1 == "c" or block.slope2 == "c"))then
            if(block.i == BLOCKS.RAMP_HALF_W)then -- 4 is 𝘶𝘱
              percent = abs(pwe-1)
            else
              percent = pwe
            end
            ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
          elseif(ball.quadrant == "d" and (block.slope1 == "d" or block.slope2 == "d"))then
            if(block.i == BLOCKS.RAMP_HALF_W)then -- 4 is 𝘶𝘱
              percent = pns
            else
              percent = abs(pns - 1) 
            end
           
            ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
          else
            not_on_slope = true
            ball.floor_height = ((block.height  * tz * 2)) + block_floor_offset
          end
        end
  
        if(block.directionup == "w" or block.directionup == "n")then
          percent = abs(percent - 1)
          ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
        end
  
        if(block.directionup == "e" or block.directionup == "s")then
           ball.floor_height = ((block.height  * tz * 2) * percent) + block_floor_offset
        end
  
      end
  
  
      -- slope exists and is in contact with floor
      if(block ~= nil and block.slope ~= nil and ball.slope != 0 and is_on_floor(ball))then
        if(not_on_slope)then
          -- dont move
        else
          add_force(ball, block.directiondown, block.slope * block.friction * get_ball_vertical_speed_multiplier())
        end
      end
    end
  else 
    update_edit_mode()
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
