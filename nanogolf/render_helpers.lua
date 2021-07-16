-- written by nusan
-- taken from 𝘱ico8 3d renderer http://www.lexaloffle.com/bbs/?tid=2731&autoplay=1#pp
-- by orange451
function trifill( p1, p2, p3, c )
  debug_count_triangles = debug_count_triangles + 1

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

  y1 = y1 + 0.001 -- offset to avoid divide per 0

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