pico-8 cartridge // http://www.pico-8.com
version 5
__lua__

global_state = {
  change_level = {
    will_change_level = false,
    counter = 0,
    max_counter = 10
  }
}

block_height_regular = 1
block_height_small = 1
block_types = {
  -- a plateau
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..
  regular=0,

  -- nothing on one side
  -- a plateou on the specified direction
  --        ..2__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  
  half_south=100,
  half_west=101,
  half_north=102,
  half_east=103,

  -- a long ramp that raises to the specified direction
  -- RAMP NORTH WEST
  --        ..1.\
  --     ...     \..
  --  4.\         \ ..x
  --  .  \..     ..\  .
  --  .   \ ..x..   \ .
  --  8..  \  .     ..6
  --     ...\ .  ...
  --        ..7..
  ramp_north_west=1,
  ramp_north_east=2,
  ramp_south_west=3,
  ramp_south_east=4,
  
  -- ramps half of the block and the other half is 
  -- a plateau on the specified direction
  --        ./1..
  --     ../  |  ...
  --  4../    |     ..2
  --  ./      |  ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..
  ramp_half_east=5,
  ramp_half_south=6,
  ramp_half_west=7,
  ramp_half_north=8,
  
  -- a small diagonal ramp that raises to the specified direction
  -- RAMP NORTH
  --        ..1..
  --     ... / \ ...
  --  4..  /     \  ..2
  --  .  /         \  .  
  --  ./             \. 
  --  8---------------6
  --     ...  .  ...
  --        ..7..

  ramp_east=9,
  ramp_south=10,
  ramp_east=11,
  ramp_north=12,
}

spacing = 2

theme = {
  rosey = {
    c1 = 5, --   dark_grey
    c2 = 0, --   black
    c3 = 14, --  pink
    c4 = 3, --   dark_green
    c5 = 13, --  light_purple
    c6 = 2,
  },
  greeney = {
    c1 = 3,
    c2 = 9,
    c3 = 11,
    c4 = 12,
    c5 = 1,
    c6 = 2,
  },
  lean = {
    c1 = 6,
    c2 = 7,
    c3 = 5,
    c4 = 9,
    c5 = 15,
    c6 = 0,
  },
  squash = {
    c1 = 12,
    c2 = 1,
    c3 = 6,
    c4 = 5,
    c5 = 9,
    c6 = 13,
  },
  random = {
    c1 = flr(rnd()*16),
    c2 = flr(rnd()*16),
    c3 = flr(rnd()*16),
    c4 = flr(rnd()*16),
    c5 = flr(rnd()*16),
    c6 = flr(rnd()*16),
  }
}

levels = {
  -- multiple floors
  {
    metadata = {
      name = "multiple floors",
      theme = theme.lean
    },
    level = {
      {
        {3,-2,1,block_types.half_south,false},
        {3,-1,1,block_types.regular,false},
        {3,0,1,block_types.ramp_north_east,false},

        --{4,-1,1,block_types.ramp_south_east,false},

        {5,-4,1,block_types.ramp_south_east,false},
        {5,-3,1,block_types.regular,false},
        {5,-2,1,block_types.regular,false},
        
      },
      {
        {5,-3,1,block_types.ramp_south_east,false},
        {3,-2,1,block_types.half_south,false},
        {4,-2,1,block_types.regular,false},
        {5,-2,1,block_types.half_north,false},
        {3,-1,1,block_types.ramp_north_east,false},
        
        
      },
    }
  },
  {
    metadata = {
      name = "ramps with multiple heights",
      theme = theme.squash
    },
    level = {
      {
        {1,-2,0.2,block_types.ramp_south_east,false},
        {3,-2,1.0,block_types.ramp_south_east,false},
        {5,-2,3.0,block_types.ramp_south_east,false},

        {1,0,0.2,block_types.ramp_north_east,false},
        {3,0,1.0,block_types.ramp_north_east,false},
        {5,0,3.0,block_types.ramp_north_east,false},

        {1,2,0.2,block_types.ramp_south_west,false},
        {3,2,1.0,block_types.ramp_south_west,false},
        {5,2,3.0,block_types.ramp_south_west,false},
      },
    }
  },
  
  -- diagonal ramps
  {
    metadata = {
      name = "diagonals",
      theme = theme.rosey
    },
    level = {
      { 
        {1,1,1,block_types.ramp_east,false},
        {1,2,1,block_types.ramp_south,false},
        {0,2,1,block_types.ramp_west,false},
        {0,1,1,block_types.ramp_north,false},

        {0,4,1,block_types.ramp_south,false},
        {1,4,1,block_types.ramp_west,false},
        {1,5,1,block_types.ramp_north,false},
        {0,5,1,block_types.ramp_east,false},


        {3,1,1,block_types.ramp_half_north,false},
        {4,1,1,block_types.ramp_half_east,false},
        {3,2,1,block_types.ramp_half_west,false},
        {4,2,1,block_types.ramp_half_south,false},

        {3,4,1,block_types.ramp_half_south,false},
        {4,4,1,block_types.ramp_half_west,false},
        {3,5,1,block_types.ramp_half_east,false},
        {4,5,1,block_types.ramp_half_north,false},

        {8,1,1,block_types.half_west,false},
        {8,3,1,block_types.half_north,false},
        {6,3,1,block_types.half_east,false},
        {6,1,1,block_types.half_south,false},
      },
    }
  }
}


tw = 50
th = 25
tz = 12.5/2


-- https://github.com/sulai/Lib-Pico8/blob/master/lang.lua
function enum(names, offset)
	offset=offset or 1
	local objects = {}
	local size=0
	for idr,name in pairs(names) do
		local id = idr + offset - 1
		local obj = {
			id=id,       -- id
			idr=idr,     -- 1-based relative id, without offset being added
			name=name    -- name of the object
		}
		objects[name] = obj
		objects[id] = obj
		size=size+1
	end
	objects.idstart = offset        -- start of the id range being used
	objects.idend = offset+size-1   -- end of the id range being used
	objects.size=size
	objects.all = function()
		local list = {}
		for _,name in pairs(names) do
			add(list,objects[name])
		end
		local i=0
		return function() i=i+1 if i<=#list then return list[i] end end
	end
	return objects
end


-- define global enums
-- colors = enum( {"black",  "dark_blue",     "purple",  "dark_green", 
--                 "brown",  "dark_grey",     "grey",    "white",
--                 "red",    "orange",        "yellow",  "green",
--                 "blue" ,  "light_purple",  "pink",    "washed_red"}, 0 )

-- height climbable
height_climbable = 5

-- physics parameters
gravity = 0.3
friction = 0.97
bounce = 1

blocks = {}

debug_quadrants = true
debug_count_triangles = 0

current_distance_to_hole = nil

sqrt0 = sqrt
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
function trifill( p1, p2, p3, c )
  debug_count_triangles += 1

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
function make_point(x,y,f)
  local p = {}
  p.x = x
  -- printh(f)
  p.y = y - f
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

  ball.color = 11

  -- We always set May Be Stuck to true when hitting a wall.
  -- Then we count the may_be_stuck frames and, if > than Threshold,
  -- We set the ball to the latest safe position
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
          hit_right_wall(b)
        elseif(ball.quadrant == "a" or ball.quadrant == "c")then
          hit_left_wall(b)
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


function make_block(x0,y0,z0,floor,i,has_hole)
  -- REGULAR
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  --  HALF SOUTH
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  |  ---     ---  |
  --  |     --3--     |
  --  8--     |     --6
  --     ---  |  ---
  --        --7--

  -- HALF WEST
  --        __1..
  --     ___  |  ...
  --  4__     |     ..2
  --  |  ___  |  ...  .
  --  |     __3..     .
  --  8__     |     ..6
  --     ___  |  ...
  --        __7..

  -- HALF NORTH
  --        __1__
  --    ___       ___
  --  4_______________2
  --  |  ...     ...  |
  --  |     ..3..     |
  --  8_______________6
  --     ...  .  ...
  --        ..7..  

  -- HALF WEST
  --        ..2__
  --     ...  |  ___
  --  4..     |     __2
  --  .  ...  |  ___  |
  --  .     ..3__     |
  --  8..     |     __6
  --     ...  |  ___
  --        ..7__  

  -- RAMP NORTH WEST
  --        ..1.\
  --     ...     \..
  --  4.\         \ ..x
  --  .  \..     ..\  .
  --  .   \ ..x..   \ .
  --  8..  \  .     ..6
  --     ...\ .  ...
  --        ..7..

  -- RAMP NORTH EAST
  --        ..1..
  --     ... /   ...
  --  x..  /        ..2
  --  .  ./.     .../ .
  --  . /   ..x..  /  .
  --  8..     .  /  ..6
  --     ...  . /...
  --        ..7..

  -- RAMP SOUTH EAST
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- RAMP SOUTH WEST
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .  ...     ...  .
  --  .     ..3--------
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..


  -- RAMP HALF WEST i == block_types.ramp_half_east
  --        ./1..
  --     ../  |  ...
  --  4../    |     ..2
  --  ./      |  ...  .
  --  --------.3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..

  -- RAMP WEST
  --        ..1..
  --     ...     ...
  --  4..     5-------2
  --  .       |      /|
  --  .       |    /  |
  --  8..     |  /  __6
  --     ...  |/ ___
  --        ..7__

  -- RAMP SOUTH
  --        ..1..
  --     ...     ...
  --  4..           ..2
  --  .     / 3 \     .  
  --  .   /   |   \   . 
  --  8 /     |     \ 6
  --     ___  |   ___
  --        __7__

  -- RAMP WEST
  --        ..1..
  --     ...     ...
  --  4_______5      ..2
  --  |\      |   ..   .  
  --  |  \    |..      . 
  --  8    \  |       6
  --    ___  \|  ...
  --        __7..

  -- RAMP NORTH
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

  if(i == block_types.regular)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
  elseif(i == block_types.ramp_north_west) then
    block.slope = 0.25 * block.z0
    block.directionup = "w"
    block.directiondown = "e"
  elseif(i == block_types.ramp_north_east) then
    block.slope = 0.25 * block.z0
    block.directionup = "n"
    block.directiondown = "s"
  elseif(i == block_types.ramp_south_west) then
    block.slope = 0.25 * block.z0
    block.directionup = "e"
    block.directiondown = "w"
  elseif(i == block_types.ramp_south_east) then
    block.slope = 0.25 * block.z0
    block.directionup = "s"
    block.directiondown = "n"
  elseif(i == block_types.ramp_half_east) then
    block.slope = 0.5 * block.z0
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == block_types.ramp_half_south) then
    block.slope = 0.5 * block.z0
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == block_types.ramp_half_west) then
    block.slope = 0.5 * block.z0
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == block_types.ramp_half_north) then
    block.slope = 0.5 * block.z0
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "d" 
    block.slope2 = "a"
  elseif(i == block_types.ramp_east) then
    block.slope = 0.5 * block.z0
    block.directionup = "ne"
    block.directiondown = "sw"
    block.slope1 = "c" 
    block.slope2 = "d"
  elseif(i == block_types.ramp_south) then
    block.slope = 0.5 * block.z0
    block.directionup = "se"
    block.directiondown = "nw"
    block.slope1 = "a" 
    block.slope2 = "d"
  elseif(i ==block_types.ramp_west) then
    block.slope = 0.5 * block.z0
    block.directionup = "sw"
    block.directiondown = "ne"
    block.slope1 = "a" 
    block.slope2 = "b"
  elseif(i == block_types.ramp_north) then
    block.slope = 0.5 * block.z0
    block.directionup = "nw"
    block.directiondown = "se"
    block.slope1 = "b" 
    block.slope2 = "c"
  elseif(i == block_types.half_south)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "d"  
  elseif(i == block_types.half_west)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "a"
    block.top2 = "b"
  elseif(i == block_types.half_north)then
    block.slope = 0 * block.z0
    block.directionup = nil
    block.directiondown = nil
    block.top1 = "b"
    block.top2 = "c"
  elseif(i == block_types.half_east)then
    block.slope = 0 * block.z0
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
  local f = ((block.floor-1) * (block.z))

  -- top 4
  local p1 = make_point(x, y-z, f) -- ttc
  local p2 = make_point(x+tw/2,y+th/2-z, f)   -- tcr
  local p3 = make_point(x,y+th-z, f) -- tbc
  local p4 = make_point(x-tw/2,y+th/2-z, f) -- tcl

  local pc = make_point(x, y, f)

  -- bottom 4
  local p5 = make_point(x, y, f)  -- btc
  local p6 = make_point(x+tw/2, y+th/2, f) -- bcr
  local p7 = make_point(x, y+th, f)  -- bbc
  local p8 = make_point(x-tw/2, y+th/2, f)  -- bcl
  
  if(block.i == block_types.regular)then
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
  elseif(block.i == block_types.half_south)then

      -- i == block_types.half_south
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
  elseif(block.i == block_types.half_west)then
    -- i == block_types.half_west
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

  elseif(block.i == block_types.half_north)then
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

  elseif(block.i == block_types.half_east)then
  -- i == block_types.half_east
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
  elseif(block.i == block_types.ramp_north_west)then
    --draw top
    trifill(p1,p4,p7,c1)
    trifill(p7,p6,p1,c1)

    --draw left
    trifill(p8,p7,p4,c2)
  elseif(block.i == block_types.ramp_north_east)then

    -- draw top
    trifill(p1,p8,p7,c1)
    trifill(p7,p2,p1,c1)

    --draw right
    trifill(p7,p6,p2,c3)


  elseif(block.i == block_types.ramp_south_west)then
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
  elseif(block.i == block_types.ramp_south_east)then
    -- i == block_types.ramp_south_east
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
  elseif(block.i == block_types.ramp_half_east)then
  -- i == block_types.ramp_half_east
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
  elseif(block.i == block_types.ramp_half_south)then
  -- i == block_types.ramp_half_south
  -- i == block_types.ramp_half_south
  --          1 
  --     _____5_____
  --  4_______________2
  --  .  ...      ...  .
  --  .     ..3..     .
  --  8..     .     ..6
  --     ...  .  ...
  --        ..7..
    trifill(p3,p2,p4,c1) -- t

    trifill(p4,p2,p5,c6) -- NW

    trifill(p4,p8,p3,c2) -- l
    trifill(p8,p7,p3,c2) -- l

    trifill(p7,p6,p3,c3) -- r
    trifill(p2,p3,p6,c3) -- r
  
    
  elseif(block.i == block_types.ramp_half_west)then
  -- i == block_types.ramp_half_west
  -- i == block_types.ramp_half_west
  --        ..1\
  --     ...  |  \
  --  4..     |   \    2
  --  .  ...  |    \   
  --  .     ..3__   \  
  --  8..     .  --- \ 6
  --     ...  .  ...
  --        ..7..  

    trifill(p4,p3,p1,c1) -- t

    trifill(p3,p6,p1,c6) -- NE

    trifill(p4,p8,p3,c2) -- l
    trifill(p8,p7,p3,c2) -- l

    trifill(p7,p6,p3,c3) -- r
  elseif(block.i == block_types.ramp_half_north)then
  -- i == block_types.ramp_half_north
  --        ..1..
  --     ...     ...
  --  4_______________2
  --  . \           / .
  --  .   \        /  .
  --  8..  \     /  ..6
  --     ... \ /  ...
  --        ..7..  
    trifill(p1,p4,p2,c1) -- t

    trifill(p4,p7,p2,c3) -- SE
    trifill(p8,p7,p4,c2) -- l

    trifill(p6,p2,p7,c3) -- r

  elseif(block.i == block_types.ramp_east)then
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
 
  elseif(block.i == block_types.ramp_south)then
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
  elseif(block.i == block_types.ramp_west)then
  --        ..1..
  --     ...     ...
  --  4-------5      ..2
  --  |  \    |   ..   .  
  --  |   \   |..      . 
  --  8    \  |       6
  --    ___  \|  ...
  --        __7..

    trifill(p4,p8,p7,c2) -- l

    trifill(p5,p4,p7,c6) -- NE
  elseif(block.i == block_types.ramp_north)then
  -- i == block_types.ramp_north
  --        ..1..
  --     ... / \ ...
  --  4..  /     \  ..2
  --  .  /         \  .  
  --  ./             \. 
  --  8---------------6
  --     ...  .  ...
  --        ..7..

    trifill(p1,p8,p6,c3) -- SE
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


current_level_floor = 0
function reset_map() 
  blocks = {}
  current_level_floor = 0
  global_state.change_level.will_change_level = false
  global_state.change_level.counter = 0
end

function create_block(b) 
  local block_to_add = make_block(b[1], b[2], b[3], current_level_floor, b[4], b[5])
  add(blocks, block_to_add)
end


function load_level(level_to_load)
  reset_map()
  
  c1 = level_to_load.metadata.theme.c1
  c2 = level_to_load.metadata.theme.c2
  c3 = level_to_load.metadata.theme.c3
  c4 = level_to_load.metadata.theme.c4
  c5 = level_to_load.metadata.theme.c5
  c6 = level_to_load.metadata.theme.c6

  for level_floor in all(level_to_load.level) do
    current_level_floor = current_level_floor + 1
    foreach(level_floor, create_block)
  end 
end

function _init()
  ball = make_ball(3,1,1)
  next_level()
end

function get_current_blocks(x,y,z)
  local possible_blocks = {}
  
  if z < 0 then 
    z = 0
  end 
  for block in all(blocks) do
    if(block.x0 == x and block.y0 == y and (block.floor-1)*(tz*2) <= z+2)then
      add(possible_blocks, block)
    end
  end

  --printh(#possible_blocks..": possible blocks")
  if #possible_blocks == 0 then 
    return nil
  end 

  if #possible_blocks == 1 then
    return possible_blocks
  end 

  for i=1,#possible_blocks do
      local j = i
      while j > 1 and possible_blocks[j-1].floor > possible_blocks[j].floor do
          possible_blocks[j].floor,possible_blocks[j-1].floor = possible_blocks[j-1].floor,possible_blocks[j].floor
          j = j - 1
      end
  end

  return possible_blocks
  -- selected_block = possible_blocks[0]
  -- for b in all(possible_blocks) do 
  --   if selected_block == nil then 
  --     selected_block = b
  --   else 
  --     if b.floor > selected_block.floor then
  --       selected_block = b
  --     end 
  --   end 
  -- end
  
end

function raise(thing)
  thing.z += tz/2
end
function lower(thing)
  thing.z -= tz/2
end

current_level = 0
function next_level()
  local total_levels = #levels
  
  if current_level == total_levels then
    current_level = 1
  else 
    current_level = current_level + 1
  end
  
  printh("\nLoading level...")
  printh("total_levels: "..total_levels)
  printh("current_level: "..current_level)
  printh("current_level_name: "..levels[current_level].metadata.name)
  load_level(levels[current_level])
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

function get_ball_vertical_speed_multiplier()
  local dz = ball.oldz - ball.z
  return min(max(dz*6,1),17)
 end

function check_floor_height(stack_blocks, index) 
  local block = stack_blocks[index]
  printh(index)
  block_floor_offset = ((block.floor-1) * tz * 2)
  quadrant = get_quadrant(ball.current_grid_float.x % flr(ball.current_grid_float.x), ball.current_grid_float.y % flr(ball.current_grid_float.y))
  ball.quadrant = quadrant

  -- bloco reto é simples de calcular a altura
  if(block.i == 0)then
    
    if(block.has_hole)then
      hole = {}
      hole.x = block.x
      hole.y = block.y - block_floor_offset

      ball_copy = {}
      ball_copy.x = ball.x
      ball_copy.y = ball.y - ball.z

      current_distance_to_hole = distance(ball_copy,block)
      -- printh(current_distance_to_hole)
      if(current_distance_to_hole < (tz*2))then
        ball.floor_height = 0 + block_floor_offset

        global_state.change_level.will_change_level = true
      else
        ball.floor_height = (block.z0  * tz * 2) + block_floor_offset
      end
    else
      ball.floor_height = (block.z0  * tz * 2) + block_floor_offset
    end  
  -- 45 degrees angles blocks
  elseif(block.i == block_types.half_south or block.i == block_types.half_west or block.i == block_types.half_north or block.i == block_types.half_east)then
  
    if(ball.quadrant == block.top1 or ball.quadrant == block.top2)then
      ball.floor_height = (block.z0  * tz * 2) + block_floor_offset
    else
      local cur_block_floor_check  = index-1
      if cur_block_floor_check > 1 then
        check_floor_height(stack_blocks, index-1)
      else 
        ball.floor_height = 0 -- TODO actually we do now know
      end 
    end

  -- diagonal ramp blocks z=(1-x/a-y/b)*c
  elseif(block.i == block_types.ramp_east or block.i == block_types.ramp_south or block.i ==block_types.ramp_west or block.i == block_types.ramp_north)then
    local pns
    local pwe

    pns = ball.current_grid_float.y % flr(ball.current_grid_float.y)
    pwe = ball.current_grid_float.x % flr(ball.current_grid_float.x)

    -- z=(1-x/a-y/b)*c
    -- HEIGHT equals ( 1 - currentX / "fullX" - currentY / "fullY" ) * fullHeight
    
    if(ball.quadrant == nil)then
        -- do nothing
        not_on_slope = true

        ball.floor_height = block.z0 + block_floor_offset
    elseif(ball.quadrant == block.slope1 or ball.quadrant == block.slope2)then
      if(block.i == block_types.ramp_north)then
        ball.floor_height = (1- (pns*16)/16 - (pwe*16)/16)  * (block.z0  * tz * 2) + block_floor_offset
      elseif(block.i == block_types.ramp_east)then
        ball.floor_height = (1- (pns *16)/16 - (abs(1-pwe) *16)/16)  * (block.z0  * tz*2)+ block_floor_offset
      elseif(block.i ==block_types.ramp_west)then
        ball.floor_height = (1- (abs(1-pns)  *16)/16 - (pwe*16)/16)  * (block.z0  * tz*2)+ block_floor_offset
      elseif(block.i == block_types.ramp_south)then
        ball.floor_height = (1- ( abs(1-pns) *16)/16 - ( abs(1-pwe) *16)/16)  * (block.z0  * tz * 2)+ block_floor_offset
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
    if(block.i == block_types.ramp_half_east or block.i == block_types.ramp_half_south or block.i == block_types.ramp_half_west or block.i == block_types.ramp_half_north)then -- half block
  
      if(ball.quadrant == nil)then
        -- do nothing
        not_on_slope = true
      elseif(ball.quadrant == "b" and (block.slope1 == "b" or block.slope2 == "b"))then
        if(block.i == block_types.ramp_half_south)then 
          percent = pns
        else
          percent = abs(pns - 1)
        end
        ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
      elseif(ball.quadrant == "a" and (block.slope1 == "a" or block.slope2 == "a"))then
        if(block.i == block_types.ramp_half_north)then -- 4 is UP
          percent = abs(pwe - 1)
        else
          percent = pwe  -- 4 is DOWN
        end
        ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
      elseif(ball.quadrant == "c" and (block.slope1 == "c" or block.slope2 == "c"))then
        if(block.i == block_types.ramp_half_west)then -- 4 is UP
          percent = abs(pwe-1)
        else
          percent = pwe
        end
        ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
      elseif(ball.quadrant == "d" and (block.slope1 == "d" or block.slope2 == "d"))then
        if(block.i == block_types.ramp_half_west)then -- 4 is UP
          percent = pns
        else
          percent = abs(pns - 1) 
        end
        
        ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
      else
        not_on_slope = true
        ball.floor_height = ((block.z0  * tz * 2)) + block_floor_offset
      end
    end

    if(block.directionup == "w" or block.directionup == "n")then
      percent = abs(percent - 1)
      ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
    end

    if(block.directionup == "e" or block.directionup == "s")then
        ball.floor_height = ((block.z0  * tz * 2) * percent) + block_floor_offset
    end

  end
end 

function _update()

  if (global_state.change_level.will_change_level) then
    global_state.change_level.counter = global_state.change_level.counter + 1

    -- printh(global_state.change_level.max_counter)
    -- printh(global_state.change_level.max_counter)
    if (global_state.change_level.counter > global_state.change_level.max_counter) then 
      next_level()
    end 
  end 

  debug_count_triangles = 0
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

  local stack_blocks = get_current_blocks(ball.current_grid.x, ball.current_grid.y, ball.z)
  printh("eita")
  printh(stack_zzbzlocks)
  hole = {}
  hole.x = 0
  hole.y = 0
  
  local not_on_slope = false -- determina se, em um bloco misto, a bola não estã em um slope no momento

  if stack_blocks == nil or #stack_blocks == 0 then
    ball.floor_height = 0
  -- plain block
  else 
    local block = stack_blocks[#stack_blocks]
    check_floor_height(stack_blocks, #stack_blocks)


    -- slope exists and is in contact with floor
    if(ball.slope != 0 and is_on_floor(ball))then
      if(not_on_slope)then
        -- dont move
      else
        move_direction(block.directiondown, block.slope * block.friction * get_ball_vertical_speed_multiplier())
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

  -- this will bring debug stuff to fixed position
  camera()
  clip()

  if current_distance_to_hole != nil then 
    print("dist hole " .. current_distance_to_hole, 1, 110, 5)
  end

  if block == nil then
    print(ball.current_grid.x .. ", " .. ball.current_grid.y, 1, 120, 5)
  else 
    print(block.x0 .. ", " .. block.y0, 1, 120, 9)
  end

  print("b x:" .. ball.x .. " y:" .. ball.y .. " z:" .. ball.z, 1, 7, 9)
  print("ballg x:" .. ball.current_grid.x .. "   y:" .. ball.current_grid.y , 1, 14, 9)
  print("ballf x:" .. ball.current_grid_float.x .. "   y:" .. ball.current_grid_float.y , 1, 21, 9)
  print("floor z:" .. ball.floor_height , 1, 28, 9)
  -- print("cpu:" .. stat(1)*100 .. "%" , 1, 35, 2)
  -- print("triangles:" .. debug_count_triangles , 1, 42, 2)

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

