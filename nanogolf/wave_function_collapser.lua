debugfile = 'deb.txt'

function printf(str)

  printh(str, debugfile, true)
end

function wave_function_collapse(blocks, rounds_left)
  printf('-- starting wave fn collapse')

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

      for offset in all(offsets) do
        block_to_coord = get_block_at(block.x0 + offset.x, block.y0 + offset.y, block.height)

        local possible_connecting = connections[offset.coord]

        if #possible_connecting ~= 0 then
          chosen_block_type = rnd(possible_connecting)
          is_procedural = true
          local block_to_add = generators.block(block.x0 + offset.x, block.y0 + offset.y, 1, 1, chosen_block_type, false, is_procedural)
          add(blocks, block_to_add)
        end 
      end 
    end

    rounds_left -= 1
  end
end