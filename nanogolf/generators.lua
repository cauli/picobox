--[[
  generators.lua

  Contains "generate_{{type}}" functions, used
  to instantiate objects of a certain {{type}}
  ]]

-- returns a point object
-- p.x
-- p.y
function generate_point(x,y,f)
  local p = {}
  p.x = x
  p.y = y - f
  p.z = f
  return p
end

-- Generates "Ball" object
-- grid coordinates
function generate_ball(x0,y0,z0)
  local b = {}

  -- convert to global
  local x = (x0-y0) * TILE_WIDTH_HALF
  local y = (x0+y0) * TILE_HEIGHT_HALF
  local z = (z0 * DEFAULT_BLOCK_HEIGHT) - DEFAULT_BLOCK_HEIGHT

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


function generate_decoration(x0,y0,z0,type)
  local decoration = {}
  decoration.class="decoration"
  decoration.type=type
  decoration.x0 = x0
  decoration.y0 = y0
  decoration.z0 = z0
  decoration.zIndex = 0

  if decoration.type == 'folliage' then
    decoration.sprites = {0,0,0,0,1,1,1,1,2,2,2,2,2,3,3,3,3,3,2,2,2,2,2,2,1,1,1,1,1,0,0,0,0,0}
    decoration.currentSprite = flr(rnd() * #decoration.sprites)
  end 

  return decoration
end


function generate_block(x0,y0,z0,floor,i,has_hole,is_procedural,is_user)
  -- 𝘳𝘦𝘨𝘶𝘭𝘢𝘳
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  --  𝘩𝘢𝘭𝘧 𝘴𝘰𝘶𝘵𝘩
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  |  ---     ---  |
  --  |     --3--     |
  --  8--     |     --6
  --     ---  |  ---
  --        --7--

  -- 𝘩𝘢𝘭𝘧 𝘸𝘦𝘴𝘵
  --        __1..
  --     ___  |  ...
  --  4__     |     ..2
  --  |  ___  |  ...  .
  --  |     __3..     .
  --  8__     |     ..6
  --     ___  |  ...
  --        __7..

  -- 𝘩𝘢𝘭𝘧 𝘯𝘰𝘳𝘵𝘩
  --        __1__
  --    ___       ___
  --  4_______________2
  --  |  ...     ...  |
  --  |     ..3..     |
  --  8_______________6
  --     ...  .  ...
  --        ..7..  

  -- 𝘩𝘢𝘭𝘧 𝘸𝘦𝘴𝘵
  --        ..2__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  

  -- 𝘳𝘢𝘮𝘱 𝘯𝘰𝘳𝘵𝘩 𝘸𝘦𝘴𝘵
  --        ..1.\
  --     ...     \..
  --  4.\         \ ..x
  --  .  \..     ..\  .
  --  .   \ ..x..   \ .
  --  8..  \  .     ..6
  --     ...\ .  ...
  --        ..7..

  -- 𝘳𝘢𝘮𝘱 𝘯𝘰𝘳𝘵𝘩 𝘦𝘢𝘴𝘵
  --        ..1..
  --     ... /   ...
  --  x..  /        ..2
  --  .  ./.     .../ .
  --  . /   ..x..  /  .
  --  8..     .  /  ..6
  --     ...  . /...
  --        ..7..

  -- 𝘳𝘢𝘮𝘱 𝘴𝘰𝘶𝘵𝘩 𝘦𝘢𝘴𝘵
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- 𝘳𝘢𝘮𝘱 𝘴𝘰𝘶𝘵𝘩 𝘸𝘦𝘴𝘵
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3--------
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- 𝘳𝘢𝘮𝘱 𝘩𝘢𝘭𝘧 𝘸𝘦𝘴𝘵 i == BLOCKS.RAMP_HALF_E
  --        ./1..
  --     ../  |  ...
  --  4../    |     ..2
  --  ./      |  ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- 𝘳𝘢𝘮𝘱 𝘸𝘦𝘴𝘵
  --        ..1..
  --     ...     ...
  --  4..     5-------2
  --  .       |      /|
  --  .       |    /  |
  --  8..     |  /  __6
  --     ...  |/ ___
  --        ..7__

  -- 𝘳𝘢𝘮𝘱 𝘴𝘰𝘶𝘵𝘩
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .     / 3 \     .  
  --  .   /   |   \   . 
  --  8 /     |     \ 6
  --     ___  |   ___
  --        __7__

  -- 𝘳𝘢𝘮𝘱 𝘸𝘦𝘴𝘵
  --        ..1..
  --     ...     ...
  --  4_______5      ..2
  --  |\      |   ..   .  
  --  |  \    |..      . 
  --  8    \  |       6
  --    ___  \|  ...
  --        __7..

  -- 𝘳𝘢𝘮𝘱 𝘯𝘰𝘳𝘵𝘩
  --        ..1..
  --     ... / \ ...
  --  4..  /     \  ..2
  --  .  /         \  .  
  --  ./             \. 
  --  8---------------6
  --     ...  .  ...
  --        ..7..
  local block = {}
  block.class="block"
  block.x0 = x0
  block.y0 = y0
  block.height = z0
  block.z0 = floor
  block.floor = floor
  block.i = i
  block.has_hole = has_hole
  block.friction = 0.99
  block.zIndex = 0 -- just to tie-break depth sorting
  block.is_procedural = is_procedural
  block.is_user = is_user
  
  block.x = (block.x0-block.y0) * TILE_WIDTH_HALF
  block.y = (block.x0+block.y0) * TILE_HEIGHT_HALF
  block.z = DEFAULT_BLOCK_HEIGHT + (block.height * DEFAULT_BLOCK_HEIGHT)

  if(i == BLOCKS.REGULAR)then
    block.name = "REGULAR"
    block.slope = 0 * block.height
    block.directionup = nil
    block.directiondown = nil
  elseif(i == BLOCKS.RAMP_NW) then
    block.name = "RAMP_NW"
    block.slope = 0.25 * block.height
    block.directionup = "w"
    block.directiondown = "e"
  elseif(i == BLOCKS.RAMP_NE) then
    block.name = "RAMP_NE"
    block.slope = 0.25 * block.height
    block.directionup = "n"
    block.directiondown = "s"
  elseif(i == BLOCKS.RAMP_SE) then
    block.name = "RAMP_SE"
    block.slope = 0.25 * block.height
    block.directionup = "e"
    block.directiondown = "w"
  elseif(i == BLOCKS.RAMP_SW) then
    block.name = "RAMP_SW"
    block.slope = 0.25 * block.height
    block.directionup = "s"
    block.directiondown = "n"
  elseif(i == BLOCKS.RAMP_HALF_E) then
    block.name = "RAMP_HALF_E"
    block.slope = 0.5 * block.height
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == BLOCKS.RAMP_HALF_S) then
    block.name = "RAMP_HALF_S"
    block.slope = 0.5 * block.height
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == BLOCKS.RAMP_HALF_W) then
    block.name = "RAMP_HALF_W"
    block.slope = 0.5 * block.height
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == BLOCKS.RAMP_HALF_N) then
    block.name = "RAMP_HALF_N"
    block.slope = 0.5 * block.height
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "d" 
    block.slope2 = "a"
  elseif(i == BLOCKS.RAMP_E) then
    block.name = "RAMP_E"
    block.slope = 0.5 * block.height
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == BLOCKS.RAMP_S) then
    block.name = "RAMP_S"
    block.slope = 0.5 * block.height
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "a" 
    block.slope2 = "d"
  elseif(i == BLOCKS.RAMP_W) then
    block.name = "RAMP_W"
    block.slope = 0.5 * block.height
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == BLOCKS.RAMP_N) then
    block.name = "RAMP_N"
    block.slope = 0.5 * block.height
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == BLOCKS.HALF_S)then
    block.name = "HALF_S"
    block.slope = 0 * block.height
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "d"  
  elseif(i == BLOCKS.HALF_W)then
    block.name = "HALF_W"
    block.slope = 0 * block.height
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "b"
  elseif(i == BLOCKS.HALF_N)then
    block.name = "HALF_N"
    block.slope = 0 * block.height
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "b"
    block.top2 = "c"
  elseif(i == BLOCKS.HALF_E)then
    block.name = "HALF_E"
    block.slope = 0 * block.height
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "c"
    block.top2 = "d"
  end

  return block
end

generators = {
  block = generate_block,
  decoration = generate_decoration,
  point= generate_point,
  ball = generate_ball
}