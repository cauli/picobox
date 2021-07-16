-- returns a point object
-- p.x
-- p.y
function generate_point(x,y,f)
    local p = {}
  p.x = x
  p.y = y - f
  return p
end

-- Generates "Ball" object
-- grid coordinates
function generate_ball(x0,y0,z0)
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

function generate_block(x0,y0,z0,floor,i,has_hole)
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

  -- 𝘳𝘢𝘮𝘱 𝘩𝘢𝘭𝘧 𝘸𝘦𝘴𝘵 i == BLOCKS.ramp_half_east
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
  block.x0 = x0
  block.y0 = y0
  block.z0 = z0
  block.floor = floor
  block.i =  i
  block.has_hole = has_hole
  block.friction = 0.99

  block.x = (block.x0-block.y0) * tw/2
  block.y = (block.x0+block.y0) * th/2
  block.z = tz + (block.z0 * tz)

  if(i == BLOCKS.regular)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
  elseif(i == BLOCKS.ramp_north_west) then
    block.slope = 0.25 * block.z0
    block.directionup = "w"
    block.directiondown = "e"
  elseif(i == BLOCKS.ramp_north_east) then
    block.slope = 0.25 * block.z0
    block.directionup = "n"
    block.directiondown = "s"
  elseif(i == BLOCKS.ramp_south_west) then
    block.slope = 0.25 * block.z0
    block.directionup = "e"
    block.directiondown = "w"
  elseif(i == BLOCKS.ramp_south_east) then
    block.slope = 0.25 * block.z0
    block.directionup = "s"
    block.directiondown = "n"
  elseif(i == BLOCKS.ramp_half_east) then
    block.slope = 0.5 * block.z0
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == BLOCKS.ramp_half_south) then
    block.slope = 0.5 * block.z0
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == BLOCKS.ramp_half_west) then
    block.slope = 0.5 * block.z0
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == BLOCKS.ramp_half_north) then
    block.slope = 0.5 * block.z0
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "d" 
    block.slope2 = "a"
  elseif(i == BLOCKS.ramp_east) then
    block.slope = 0.5 * block.z0
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == BLOCKS.ramp_south) then
    block.slope = 0.5 * block.z0
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "a" 
    block.slope2 = "d"
  elseif(i == BLOCKS.ramp_west) then
    block.slope = 0.5 * block.z0
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == BLOCKS.ramp_north) then
    block.slope = 0.5 * block.z0
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == BLOCKS.half_south)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "d"  
  elseif(i == BLOCKS.half_west)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "b"
  elseif(i == BLOCKS.half_north)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "b"
    block.top2 = "c"
  elseif(i == BLOCKS.half_east)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "c"
    block.top2 = "d"
  end

  return block
end

generators = {
  block= generate_block,
  point= generate_point,
  ball = generate_ball
}