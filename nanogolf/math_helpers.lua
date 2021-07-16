sqrt0 = sqrt
function sqrt(n)
  if (n <= 0) then return 0 end
  if (n >= 32761) then return 181.0 end
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
