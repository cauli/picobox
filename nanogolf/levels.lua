levels = {   
     {
        metadata = {
            name = "wave function collapse",
            theme = THEMES.LEAN,
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_HALF_E,false},
            },
        }
    },
    -- {
    --     metadata = {
    --         name = "multiple heights",
    --         theme = THEMES.SQUASH,
    --         procedural = true
    --     },
    --     level = {
    --         {
<<<<<<< HEAD
    --             {3,-4,1.0,BLOCKS.RAMP_SE,false},
            
    --             {3,0,1.0,BLOCKS.RAMP_NE,false},

    --             {3,4,1.0,BLOCKS.RAMP_SW,false},

    --             {3,8,1.0,BLOCKS.RAMP_NW,false},

    --             {3,12,1.0,BLOCKS.REGULAR,false},

    --             {3,16,1.0,BLOCKS.RAMP_HALF_E,false},

    --             {3,20,1.0,BLOCKS.RAMP_HALF_N,false},

    --             {3,24,1.0,BLOCKS.RAMP_HALF_W,false},

    --             {3,28,1.0,BLOCKS.RAMP_HALF_S,false},

    --             {3,32,1.0,BLOCKS.HALF_E,false},

    --             {3,36,1.0,BLOCKS.HALF_N,false},

    --             {3,40,1.0,BLOCKS.HALF_W,false},

    --             {3,44,1.0,BLOCKS.HALF_S,false},

    --             {3,48,1.0,BLOCKS.RAMP_E,false},

    --             {3,52,1.0,BLOCKS.RAMP_N,false},

    --             {3,56,1.0,BLOCKS.RAMP_W,false},

    --             {3,60,1.0,BLOCKS.RAMP_S,false},
=======
    --             {1,-2,0.2,BLOCKS.RAMP_SE,false},
    --             {3,-2,1.0,BLOCKS.RAMP_SE,false},
    --             {5,-2,3.0,BLOCKS.RAMP_SE,false},

    --             {1,0,0.2,BLOCKS.RAMP_NE,false},
    --             {3,0,1.0,BLOCKS.RAMP_NE,false},
    --             {5,0,3.0,BLOCKS.RAMP_NE,false},

    --             {1,2,0.2,BLOCKS.RAMP_SW,false},
    --             {3,2,1.0,BLOCKS.RAMP_SW,false},
    --             {5,2,3.0,BLOCKS.RAMP_SW,false},

    --             {1,4,0.2,BLOCKS.RAMP_NW,false},
    --             {3,4,1.0,BLOCKS.RAMP_NW,false},
    --             {5,4,3.0,BLOCKS.RAMP_NW,false},

    --             {1,6,0.2,BLOCKS.REGULAR,false},
    --             {3,6,1.0,BLOCKS.REGULAR,false},
    --             {5,6,3.0,BLOCKS.REGULAR,false},

    --             {1,8,0.2,BLOCKS.RAMP_HALF_E,false},
    --             {3,8,1.0,BLOCKS.RAMP_HALF_E,false},
    --             {5,8,3.0,BLOCKS.RAMP_HALF_E,false},

    --             {1,10,0.2,BLOCKS.RAMP_HALF_N,false},
    --             {3,10,1.0,BLOCKS.RAMP_HALF_N,false},
    --             {5,10,3.0,BLOCKS.RAMP_HALF_N,false},

    --             {1,12,0.2,BLOCKS.RAMP_HALF_W,false},
    --             {3,12,1.0,BLOCKS.RAMP_HALF_W,false},
    --             {5,12,3.0,BLOCKS.RAMP_HALF_W,false},

    --             {1,14,0.2,BLOCKS.RAMP_HALF_S,false},
    --             {3,14,1.0,BLOCKS.RAMP_HALF_S,false},
    --             {5,14,3.0,BLOCKS.RAMP_HALF_S,false},

    --             {1,16,0.2,BLOCKS.HALF_E,false},
    --             {3,16,1.0,BLOCKS.HALF_E,false},
    --             {5,16,3.0,BLOCKS.HALF_E,false},

    --             {1,18,0.2,BLOCKS.HALF_N,false},
    --             {3,18,1.0,BLOCKS.HALF_N,false},
    --             {5,18,3.0,BLOCKS.HALF_N,false},

    --             {1,20,0.2,BLOCKS.HALF_W,false},
    --             {3,20,1.0,BLOCKS.HALF_W,false},
    --             {5,20,3.0,BLOCKS.HALF_W,false},

    --             {1,22,0.2,BLOCKS.HALF_S,false},
    --             {3,22,1.0,BLOCKS.HALF_S,false},
    --             {5,22,3.0,BLOCKS.HALF_S,false},

    --             {1,24,0.2,BLOCKS.RAMP_E,false},
    --             {3,24,1.0,BLOCKS.RAMP_E,false},
    --             {5,24,3.0,BLOCKS.RAMP_E,false},

    --             {1,26,0.2,BLOCKS.RAMP_N,false},
    --             {3,26,1.0,BLOCKS.RAMP_N,false},
    --             {5,26,3.0,BLOCKS.RAMP_N,false},

    --             {1,28,0.2,BLOCKS.RAMP_W,false},
    --             {3,28,1.0,BLOCKS.RAMP_W,false},
    --             {5,28,3.0,BLOCKS.RAMP_W,false},

    --             {1,30,0.2,BLOCKS.RAMP_S,false},
    --             {3,30,1.0,BLOCKS.RAMP_S,false},
    --             {5,30,3.0,BLOCKS.RAMP_S,false},
>>>>>>> 5d80ee3 (Add decorations)
    --         },
    --     }
    -- },
    -- {
    --     metadata = {
    --         name = "pyramids",
    --         theme = THEMES.SQUASH,
<<<<<<< HEAD
    --         procedural = false
=======
    --         procedural = true
>>>>>>> 5d80ee3 (Add decorations)
    --     },
    --     level = {
    --         {
    --             -- pyramid 1 base
    --             {0,-1,1,BLOCKS.RAMP_S,false},
    --             {1,-1,1,BLOCKS.RAMP_HALF_S,false},
    --             {1,-2,1,BLOCKS.RAMP_S,false},
    --             {2,-2,1,BLOCKS.RAMP_HALF_S,false},
    --             {2,-3,1,BLOCKS.RAMP_S,false},

    --             {0,0,1,BLOCKS.RAMP_E,false},
    --             {1,0,1,BLOCKS.RAMP_HALF_E,false},
    --             {1,1,1,BLOCKS.RAMP_E,false},
    --             {2,1,1,BLOCKS.RAMP_HALF_E,false},
    --             {2,2,1,BLOCKS.RAMP_E,false},
                
    --             {3,2,1,BLOCKS.RAMP_N,false},
    --             {3,1,1,BLOCKS.RAMP_HALF_N,false},
    --             {4,1,1,BLOCKS.RAMP_N,false},
    --             {4,0,1,BLOCKS.RAMP_HALF_N,false},
    --             {5,0,1,BLOCKS.RAMP_N,false},

    --             {5,-1,1,BLOCKS.RAMP_W,false},
    --             {3,-2,1,BLOCKS.RAMP_HALF_W,false},
    --             {4,-2,1,BLOCKS.RAMP_W,false},
    --             {4,-1,1,BLOCKS.RAMP_HALF_W,false},
    --             {3,-3,1,BLOCKS.RAMP_W,false},


    --             -- pyramid 2 base
    --             {1+5,-1 + -1,1,BLOCKS.RAMP_S,false},
    --             {2+5,-1 + -1,1,BLOCKS.RAMP_HALF_S,false},
    --             {2+5,-1 + -2,1,BLOCKS.RAMP_S,false},
                
    --             {1+5,-1 + 0,1,BLOCKS.RAMP_E,false},
    --             {2+5,-1 + 0,1,BLOCKS.RAMP_HALF_E,false},
    --             {2+5,-1 + 1,1,BLOCKS.RAMP_E,false},

    --             {3+5,-1 + 1,1,BLOCKS.RAMP_N,false},
    --             {3+5,-1 + 0,1,BLOCKS.RAMP_HALF_N,false},
    --             {4+5,-1 + 0,1,BLOCKS.RAMP_N,false},

    --             {3+5,-1 + -2,1,BLOCKS.RAMP_W,false},
    --             {3+5,-1 + -1,1,BLOCKS.RAMP_HALF_W,false},
    --             {4+5,-1 + -1,1,BLOCKS.RAMP_W,false},

                
    --             -- pyramid 3 base
    --             {8+2,-1,1,BLOCKS.RAMP_S,false},
    --             {8+2,0,1,BLOCKS.RAMP_E,false},
    --             {8+3,0,1,BLOCKS.RAMP_N,false},
    --             {8+3,-1,1,BLOCKS.RAMP_W,false},
                
    --         },
    --         {
    --             -- pyramid 1 mid
    --             {1,-1,1,BLOCKS.RAMP_S,false},
    --             {2,-1,1,BLOCKS.RAMP_HALF_S,false},
    --             {2,-2,1,BLOCKS.RAMP_S,false},
                
    --             {1,0,1,BLOCKS.RAMP_E,false},
    --             {2,0,1,BLOCKS.RAMP_HALF_E,false},
    --             {2,1,1,BLOCKS.RAMP_E,false},

    --             {3,1,1,BLOCKS.RAMP_N,false},
    --             {3,0,1,BLOCKS.RAMP_HALF_N,false},
    --             {4,0,1,BLOCKS.RAMP_N,false},

    --             {3,-2,1,BLOCKS.RAMP_W,false},
    --             {3,-1,1,BLOCKS.RAMP_HALF_W,false},
    --             {4,-1,1,BLOCKS.RAMP_W,false},

    --             -- pyramid 2
    --             {5+2,-1 + -1,1,BLOCKS.RAMP_S,false},
    --             {5+2,-1 + 0,1,BLOCKS.RAMP_E,false},
    --             {5+3,-1 + 0,1,BLOCKS.RAMP_N,false},
    --             {5+3,-1 + -1,1,BLOCKS.RAMP_W,false},
    --         },
    --         {
    --             -- pyramid 1 top
    --             {2,-1,1,BLOCKS.RAMP_S,false},
    --             {2,0,1,BLOCKS.RAMP_E,false},
    --             {3,0,1,BLOCKS.RAMP_N,false},
    --             {3,-1,1,BLOCKS.RAMP_W,false},
                
    --         },
    --     }
    -- },
    -- {
    --     metadata = {
    --         name = "multiple floors",
    --         theme = THEMES.LEAN,
<<<<<<< HEAD
    --         procedural = false
=======
    --         procedural = true
>>>>>>> 5d80ee3 (Add decorations)
    --     },
    --     level = {
    --         {
    --             {3,-2,1,BLOCKS.REGULAR,false},
    --             {3,-1,1,BLOCKS.REGULAR,false},
    --             {3,0,1,BLOCKS.RAMP_NE,false},

    --             --{4,-1,1,BLOCKS.RAMP_SE,false},

    --             {5,-4,1,BLOCKS.RAMP_SW,false},
    --             {5,-3,1,BLOCKS.REGULAR,false},
    --             {5,-2,1,BLOCKS.REGULAR,false},
    --         },
    --         {
    --             {5,-3,1,BLOCKS.RAMP_SW,false},
    --             {3,-2,1,BLOCKS.HALF_S,false},
    --             {4,-2,1,BLOCKS.REGULAR,false},
    --             {5,-2,1,BLOCKS.REGULAR,false},
    --             {3,-1,1,BLOCKS.RAMP_NE,false},
    --         },
    --     }
    -- },
    -- -- diagonal ramps
    -- {
    --     metadata = {
    --         name = "diagonals",
    --         theme = THEMES.ROSEY,
<<<<<<< HEAD
    --         procedural = false
=======
    --         procedural = true
>>>>>>> 5d80ee3 (Add decorations)
    --     },
    --     level = {
    --         { 
    --             {1,1,1,BLOCKS.RAMP_E,false},
    --             {1,2,1,BLOCKS.RAMP_S,false},
    --             {0,2,1,BLOCKS.RAMP_W,false},
    --             {0,1,1,BLOCKS.RAMP_N,false},

    --             {4,1,1,BLOCKS.RAMP_HALF_E,false},
    --             {3,1,1,BLOCKS.RAMP_HALF_N,false},
    --             {3,2,1,BLOCKS.RAMP_HALF_W,false},
    --             {4,2,1,BLOCKS.RAMP_HALF_S,false},

    --             {8,1,1,BLOCKS.HALF_W,false},
    --             {8,3,1,BLOCKS.HALF_N,false},
    --             {6,3,1,BLOCKS.HALF_E,false},
    --             {6,1,1,BLOCKS.HALF_S,false},
    --         },
    --     }
    -- }
}
<<<<<<< HEAD
=======

function get_sub_seeds() 
    maxInt = 65534
    seed = "2364370628715260564250796008920406354802159042933974286750175206921467854849";
    
    randomSeed = true

    pointer = 1
    seedLength = 4
    seedCount = flr(#seed / 4)
    subSeeds = {}

    for s=1,#seed,seedLength do

        if randomSeed then
            add(subSeeds, tostring(flr(1000 + rnd(9000))))
        else 
            add(subSeeds, tonum(sub(seed, s, s+seedLength-1)))
        end
    end

    local themeSeed = subSeeds[1] -- theme
    local baseLevel = subSeeds[2] -- base level

    return { 
        themeSeed = subSeeds[1], 
        baseLeverPickerSeed = subSeeds[2], 
        waveFn1 = subSeeds[3], 
        folliage = subSeeds[4],
        darkPalette = subSeeds[5] 
    }
end
>>>>>>> 5d80ee3 (Add decorations)

current_level = 0
function next_level()
  subSeeds = get_sub_seeds()

  local total_levels = #levels
  
  if current_level == total_levels then
    current_level = 1
  else 
    current_level = current_level + 1
  end
  
  load_level(levels[current_level], subSeeds)
end

function random_level()
    subSeeds = get_sub_seeds()

    srand(subSeeds.baseLeverPickerSeed)
    rnd(levels)

    load_level(rnd(levels), subSeeds)
end

  
function reset_map()
    blocks = {}
    decorations = {}
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

function rnd32()
    return rnd() << 16 | rnd()
end

function load_level(level_to_load, subSeeds)
    reset_map()

<<<<<<< HEAD
    maxInt = 65534
    seed = "2364370628715260564250796008920406354802159042933974286750175206921467854849";
    
    randomSeed = true
    pointer = 1
    seedLength = 4
    seedCount = flr(#seed / 4)
    subSeeds = {}

    for s=1,#seed,seedLength do

        if randomSeed then
            add(subSeeds, tostring(flr(1000 + rnd(9000))))
        else 
            add(subSeeds, tonum(sub(seed, s, s+seedLength-1)))
        end
    end

    local themeSeed = subSeeds[1] -- theme
    printf(subSeeds[19])
      
    printf(tostr(seed, true))

    -- srand("1264370628715260564250796008920406354802159042933974286750175206921467854849")

    local theme = getRandomTheme(themeSeed)
=======
    local theme = getRandomTheme(subSeeds.themeSeed)
>>>>>>> 5d80ee3 (Add decorations)

    srand(subSeeds.darkPalette)
    if rnd() < 0.15 then
        for i=0,15 do
            pal(i,i+128,1)
        end
        attr_is_night = true
    end

    c1 = theme.c1
    c2 = theme.c2
    c3 = theme.c3
    c4 = theme.c4
    c5 = theme.c5
    c6 = theme.c6
    
    srand(subSeeds.baseLevel)
    randomLevel = rnd(level_to_load.level)
    
    for level_floor in all(level_to_load.level) do
        current_level_floor = current_level_floor + 1
        foreach(level_floor, create_block)
    end

    if level_to_load.metadata.procedural then
        srand(subSeeds.waveFn1)
        wave_function_collapse(blocks, 100)
    end

    for x = -5,5 do
        for y = -5,5 do
            block = get_block_at(x, y, 1)
            if block == nil then
                if rnd() < 0.10 then 
                    add(decorations, generate_decoration(x, y, 0, "folliage"))
                end
            end 
            
            if attr_is_night ~= true then
                block = get_block_at(x, y, 1)
                if block == nil then
                    if rnd() < 0.01 then 
                        add(decorations, generate_decoration(x, y, 0, "flamingo"))
                    end
                end 
            end 
        
        end    
    end
    

    sortDepth(blocks)
end
