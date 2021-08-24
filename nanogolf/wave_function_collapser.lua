debugfile = 'debe.txt'


function printf(str)
  printh(str, debugfile, true)
end


function wave_function_collapse(blocks, rounds_left, subSeeds)
  
  possibleHeights = {  1, 1, 1 }

  srand(subSeeds.waveFn2)
  if rnd() < 0.35 then
    possibleHeights = { 1, 1, 3 }
  elseif rnd() < 0.15 then
    possibleHeights = { 1, 1, 1, 5 }
  end

  srand(subSeeds.waveFn1)
  -- dont know why, but this makes repeating patterns that are cool
  inside_srand = false
  if rnd() < 0.25 then
    inside_srand = true
  end


  for block in all(blocks) do 
    if rounds_left == 0 then
      return 
    end 

    connections = BLOCK_CONNECTIONS[block.name]

    if connections ~= nil then  
      offsets = {
        {x=0, y=1, coord="SW"},
        {x=1, y=0, coord="SE"},
        {x=0, y=-1, coord="NE"},
        {x=-1, y=0, coord="NW"}
      }

      srand(subSeeds.directionScrambler)
      if rnd() < 0.13 then
        
        offsets = {
          {x=rnd({-1, 0, 1}), y=rnd({-1, 0, 1}), coord="SW"},
          {x=rnd({-1, 0, 1}), y=rnd({-1, 0, 1}), coord="SE"},
          {x=rnd({-1, 0, 1}), y=rnd({-1, 0, 1}), coord="NE"},
          {x=rnd({-1, 0, 1}), y=rnd({-1, 0, 1}), coord="NW"}
        }  
      end

      for offset in all(offsets) do
        block_in_position_to_add = get_block_at(block.x0 + offset.x, block.y0 + offset.y, block.height)
        
        if block_in_position_to_add == nil then
          local possible_connecting = connections[offset.coord]

          if #possible_connecting ~= 0 then
            -- dont know why, but this makes repeating patterns that are cool
            if inside_srand then srand(subSeeds.waveFn1) end
            chosen_block_type = rnd(possible_connecting)

            is_procedural = true
            local block_to_add = generators.block(block.x0 + offset.x, block.y0 + offset.y, rnd(possibleHeights), 1, chosen_block_type, false, is_procedural)
            add(blocks, block_to_add)
          end 
        end
      end 
    end

    rounds_left -= 1
  end
end