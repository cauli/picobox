-- written by electricgryphon
function solid_trifill_v3(p1, p2, p3, c)

  local x1 = p1.x
  local x2 = p2.x
  local x3 = p3.x

  local y1 = p1.y
  local y2 = p2.y
  local y3 = p3.y
  
  local min_x = min(x1, min(x2, x3))
  if (min_x > 127) then
      return
  end
  local max_x = max(x1, max(x2, x3))
  if (max_x < 0) then
      return
  end
  local min_y = min(y1, min(y2, y3))
  if (min_y > 127) then
      return
  end
  local max_y = max(y1, max(y2, y3))
  if (max_y < 0) then
      return
  end

  debug_count_triangles += 1

  local x1 = band(x1, 0xffff)
  local x2 = band(x2, 0xffff)
  local y1 = band(y1, 0xffff)
  local y2 = band(y2, 0xffff)
  local x3 = band(x3, 0xffff)
  local y3 = band(y3, 0xffff)

  local width = min(127, max_x) - max(0, min_x)
  local height = min(127, max_y) - max(0, min_y)

  if (width > height) then --wide triangle
      local nsx, nex
      --sort y1,y2,y3
      if (y1 > y2) then
          y1, y2 = y2, y1
          x1, x2 = x2, x1
      end

      if (y1 > y3) then
          y1, y3 = y3, y1
          x1, x3 = x3, x1
      end

      if (y2 > y3) then
          y2, y3 = y3, y2
          x2, x3 = x3, x2
      end

      if (y1 ~= y2) then
          local delta_sx = (x3 - x1) / (y3 - y1)
          local delta_ex = (x2 - x1) / (y2 - y1)

          if (y1 > 0) then
              nsx = x1
              nex = x1
              min_y = y1
          else --top edge clip
              nsx = x1 - delta_sx * y1
              nex = x1 - delta_ex * y1
              min_y = 0
          end

          max_y = min(y2, 128)

          for y = min_y, max_y - 1 do
              rectfill(nsx, y, nex, y, c)
              nsx = nsx + delta_sx
              nex = nex + delta_ex
          end
      else --where top edge is horizontal
          nsx = x1
          nex = x2
      end

      if (y3 ~= y2) then
          local delta_sx = (x3 - x1) / (y3 - y1)
          local delta_ex = (x3 - x2) / (y3 - y2)

          min_y = y2
          max_y = min(y3, 128)
          if (y2 < 0) then
              nex = x2 - delta_ex * y2
              nsx = x1 - delta_sx * y1
              min_y = 0
          end

          for y = min_y, max_y do
              rectfill(nsx, y, nex, y, c)
              nex = nex + delta_ex
              nsx = nsx + delta_sx
          end
      else --where bottom edge is horizontal
          rectfill(nsx, y3, nex, y3, c)
      end
  else --tall triangle -----------------------------------<><>----------------
      local nsy, ney

      --sort x1,x2,x3
      if (x1 > x2) then
          x1, x2 = x2, x1
          y1, y2 = y2, y1
      end

      if (x1 > x3) then
          x1, x3 = x3, x1
          y1, y3 = y3, y1
      end

      if (x2 > x3) then
          x2, x3 = x3, x2
          y2, y3 = y3, y2
      end

      if (x1 ~= x2) then
          local delta_sy = (y3 - y1) / (x3 - x1)
          local delta_ey = (y2 - y1) / (x2 - x1)

          if (x1 > 0) then
              nsy = y1
              ney = y1
              min_x = x1
          else --top edge clip
              nsy = y1 - delta_sy * x1
              ney = y1 - delta_ey * x1
              min_x = 0
          end

          max_x = min(x2, 128)

          for x = min_x, max_x - 1 do
              rectfill(x, nsy, x, ney, c)
              nsy = nsy + delta_sy
              ney = ney + delta_ey
          end
      else --where top edge is horizontal
          nsy = y1
          ney = y2
      end

      if (x3 ~= x2) then
          local delta_sy = (y3 - y1) / (x3 - x1)
          local delta_ey = (y3 - y2) / (x3 - x2)

          min_x = x2
          max_x = min(x3, 128)
          if (x2 < 0) then
              ney = y2 - delta_ey * x2
              nsy = y1 - delta_sy * x1
              min_x = 0
          end

          for x = min_x, max_x do
              rectfill(x, nsy, x, ney, c)
              ney = ney + delta_ey
              nsy = nsy + delta_sy
          end
      else --where bottom edge is horizontal
          rectfill(x3, nsy, x3, ney, c)
      end
  end
end
