levels = {
    {
        metadata = {
            name = "shadow",
            theme = THEMES.SQUASH,
            procedural = false
        },
        level = {
            {
                {3,0,1.0,BLOCKS.REGULAR,false},
                -- {3,3,1.0,BLOCKS.REGULAR,false},
            },
            {
                -- {3,3,1.0,BLOCKS.REGULAR,false},

                -- {3,6,1.0,BLOCKS.REGULAR,false},
            },
        }
    },
    {
        metadata = {
            name = "multiple heights",
            theme = THEMES.SQUASH,
            procedural = true
        },
        level = {
            {
                {3,-4,1.0,BLOCKS.RAMP_SE,false},
            
                {3,0,1.0,BLOCKS.RAMP_NE,false},

                {3,4,1.0,BLOCKS.RAMP_SW,false},

                {3,8,1.0,BLOCKS.RAMP_NW,false},

                {3,12,1.0,BLOCKS.REGULAR,false},

                {3,16,1.0,BLOCKS.RAMP_HALF_E,false},

                {3,20,1.0,BLOCKS.RAMP_HALF_N,false},

                {3,24,1.0,BLOCKS.RAMP_HALF_W,false},

                {3,28,1.0,BLOCKS.RAMP_HALF_S,false},

                {3,32,1.0,BLOCKS.HALF_E,false},

                {3,36,1.0,BLOCKS.HALF_N,false},

                {3,40,1.0,BLOCKS.HALF_W,false},

                {3,44,1.0,BLOCKS.HALF_S,false},

                {3,48,1.0,BLOCKS.RAMP_E,false},

                {3,52,1.0,BLOCKS.RAMP_N,false},

                {3,56,1.0,BLOCKS.RAMP_W,false},

                {3,60,1.0,BLOCKS.RAMP_S,false},
            },
        }
    },
    {
        metadata = {
            name = "wave function collapse",
            theme = THEMES.LEAN,
            procedural = true
        },
        level = {
            {
                {2,1,1,BLOCKS.RAMP_NE,false},

                {5,1,1,BLOCKS.REGULAR,false},
            },
        }
    },
    {
        metadata = {
            name = "pyramids",
            theme = THEMES.SQUASH,
            procedural = false
        },
        level = {
            {
                -- pyramid 1 base
                {0,-1,1,BLOCKS.RAMP_S,false},
                {1,-1,1,BLOCKS.RAMP_HALF_S,false},
                {1,-2,1,BLOCKS.RAMP_S,false},
                {2,-2,1,BLOCKS.RAMP_HALF_S,false},
                {2,-3,1,BLOCKS.RAMP_S,false},

                {0,0,1,BLOCKS.RAMP_E,false},
                {1,0,1,BLOCKS.RAMP_HALF_E,false},
                {1,1,1,BLOCKS.RAMP_E,false},
                {2,1,1,BLOCKS.RAMP_HALF_E,false},
                {2,2,1,BLOCKS.RAMP_E,false},
                
                {3,2,1,BLOCKS.RAMP_N,false},
                {3,1,1,BLOCKS.RAMP_HALF_N,false},
                {4,1,1,BLOCKS.RAMP_N,false},
                {4,0,1,BLOCKS.RAMP_HALF_N,false},
                {5,0,1,BLOCKS.RAMP_N,false},

                {5,-1,1,BLOCKS.RAMP_W,false},
                {3,-2,1,BLOCKS.RAMP_HALF_W,false},
                {4,-2,1,BLOCKS.RAMP_W,false},
                {4,-1,1,BLOCKS.RAMP_HALF_W,false},
                {3,-3,1,BLOCKS.RAMP_W,false},


                -- pyramid 2 base
                {1+5,-1 + -1,1,BLOCKS.RAMP_S,false},
                {2+5,-1 + -1,1,BLOCKS.RAMP_HALF_S,false},
                {2+5,-1 + -2,1,BLOCKS.RAMP_S,false},
                
                {1+5,-1 + 0,1,BLOCKS.RAMP_E,false},
                {2+5,-1 + 0,1,BLOCKS.RAMP_HALF_E,false},
                {2+5,-1 + 1,1,BLOCKS.RAMP_E,false},

                {3+5,-1 + 1,1,BLOCKS.RAMP_N,false},
                {3+5,-1 + 0,1,BLOCKS.RAMP_HALF_N,false},
                {4+5,-1 + 0,1,BLOCKS.RAMP_N,false},

                {3+5,-1 + -2,1,BLOCKS.RAMP_W,false},
                {3+5,-1 + -1,1,BLOCKS.RAMP_HALF_W,false},
                {4+5,-1 + -1,1,BLOCKS.RAMP_W,false},

                
                -- pyramid 3 base
                {8+2,-1,1,BLOCKS.RAMP_S,false},
                {8+2,0,1,BLOCKS.RAMP_E,false},
                {8+3,0,1,BLOCKS.RAMP_N,false},
                {8+3,-1,1,BLOCKS.RAMP_W,false},
                
            },
            {
                -- pyramid 1 mid
                {1,-1,1,BLOCKS.RAMP_S,false},
                {2,-1,1,BLOCKS.RAMP_HALF_S,false},
                {2,-2,1,BLOCKS.RAMP_S,false},
                
                {1,0,1,BLOCKS.RAMP_E,false},
                {2,0,1,BLOCKS.RAMP_HALF_E,false},
                {2,1,1,BLOCKS.RAMP_E,false},

                {3,1,1,BLOCKS.RAMP_N,false},
                {3,0,1,BLOCKS.RAMP_HALF_N,false},
                {4,0,1,BLOCKS.RAMP_N,false},

                {3,-2,1,BLOCKS.RAMP_W,false},
                {3,-1,1,BLOCKS.RAMP_HALF_W,false},
                {4,-1,1,BLOCKS.RAMP_W,false},

                -- pyramid 2
                {5+2,-1 + -1,1,BLOCKS.RAMP_S,false},
                {5+2,-1 + 0,1,BLOCKS.RAMP_E,false},
                {5+3,-1 + 0,1,BLOCKS.RAMP_N,false},
                {5+3,-1 + -1,1,BLOCKS.RAMP_W,false},
            },
            {
                -- pyramid 1 top
                {2,-1,1,BLOCKS.RAMP_S,false},
                {2,0,1,BLOCKS.RAMP_E,false},
                {3,0,1,BLOCKS.RAMP_N,false},
                {3,-1,1,BLOCKS.RAMP_W,false},
                
            },
        }
    },
    {
        metadata = {
            name = "multiple floors",
            theme = THEMES.LEAN,
            procedural = false
        },
        level = {
            {
                {3,-2,1,BLOCKS.REGULAR,false},
                {3,-1,1,BLOCKS.REGULAR,false},
                {3,0,1,BLOCKS.RAMP_NE,false},

                --{4,-1,1,BLOCKS.RAMP_SE,false},

                {5,-4,1,BLOCKS.RAMP_SW,false},
                {5,-3,1,BLOCKS.REGULAR,false},
                {5,-2,1,BLOCKS.REGULAR,false},
            },
            {
                {5,-3,1,BLOCKS.RAMP_SW,false},
                {3,-2,1,BLOCKS.HALF_S,false},
                {4,-2,1,BLOCKS.REGULAR,false},
                {5,-2,1,BLOCKS.REGULAR,false},
                {3,-1,1,BLOCKS.RAMP_NE,false},
            },
        }
    },
    -- diagonal ramps
    {
        metadata = {
            name = "diagonals",
            theme = THEMES.ROSEY,
            procedural = false
        },
        level = {
            { 
                {1,1,1,BLOCKS.RAMP_E,false},
                {1,2,1,BLOCKS.RAMP_S,false},
                {0,2,1,BLOCKS.RAMP_W,false},
                {0,1,1,BLOCKS.RAMP_N,false},

                {4,1,1,BLOCKS.RAMP_HALF_E,false},
                {3,1,1,BLOCKS.RAMP_HALF_N,false},
                {3,2,1,BLOCKS.RAMP_HALF_W,false},
                {4,2,1,BLOCKS.RAMP_HALF_S,false},

                {8,1,1,BLOCKS.HALF_W,false},
                {8,3,1,BLOCKS.HALF_N,false},
                {6,3,1,BLOCKS.HALF_E,false},
                {6,1,1,BLOCKS.HALF_S,false},
            },
        }
    }
}

current_level = 0
function next_level()
  local total_levels = #levels
  
  if current_level == total_levels then
    current_level = 1
  else 
    current_level = current_level + 1
  end
  
  load_level(levels[current_level])
end

function reset_map()
    blocks = {}
    current_level_floor = 0
    global_state.change_level.will_change_level = false
    global_state.change_level.counter = 0
end

current_level_floor = 0

local function create_block(b, is_user) 
    is_procedural = false
    local block_to_add = generators.block(b[1], b[2], b[3], current_level_floor, b[4], b[5], is_procedural, is_user)
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

    if level_to_load.metadata.procedural then
        wave_function_collapse(blocks, #blocks)
    end

    sortDepth(blocks)
end
