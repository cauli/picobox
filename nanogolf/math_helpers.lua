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

function px_to_grid(x,y)
    local current_grid = {}
    current_grid.x = flr((x / (TILE_WIDTH_HALF) + y / (TILE_HEIGHT_HALF)) /2);
    current_grid.y = flr((y / (TILE_HEIGHT_HALF) -(x/ (TILE_WIDTH_HALF))) /2);
    return current_grid
end

function px_to_grid_float(x,y)
    local current_grid = {}
    current_grid.x = (x / (TILE_WIDTH_HALF) + y / (TILE_HEIGHT_HALF)) /2;
    current_grid.y = (y / (TILE_HEIGHT_HALF) - (x / (TILE_WIDTH_HALF))) /2;
    return current_grid
end

function grid_to_px(x0,y0,z0) 
    local pos_px = {}
    pos_px.x = (x0-y0) * TILE_WIDTH_HALF
    pos_px.y = (x0+y0) * TILE_HEIGHT_HALF
    pos_px.z = DEFAULT_BLOCK_HEIGHT + (z0 * DEFAULT_BLOCK_HEIGHT)
    return pos_px
end

function project_point(p, offset_x, offset_y)
    local x = p.x
    local y = p.y
    local z = p.z
    
    -- 1 = midday = applies offsets once
    -- 0.1 = "sunset-like" long shadow
    sunset_factor = 0.4
    
    while z > 0 do 
        z = 0
        x += offset_x
        y += offset_y
    end
    printf('-----')

    return {z=z, x=x, y=y}
end

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
