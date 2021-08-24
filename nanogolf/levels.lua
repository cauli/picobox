globalSubSeeds = {}

levels = {   
     {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_HALF_E,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_E,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.REGULAR,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_SW,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_NW,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {3,1,1,BLOCKS.RAMP_W,false},
            },
        }
    },
    {
        metadata = {
            procedural = true
        },
        level = {
            {
                {2,1,1,BLOCKS.RAMP_N,false},
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
    --         },
    --     }
    -- },
    -- {
    --     metadata = {
    --         name = "multiple floors",
    --         theme = THEMES.LEAN,
    --         procedural = false
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
    -- diagonal ramps
}

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

    srand(subSeeds.baseLevelPickerSeed)
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

function get_sub_seeds()
    maxInt = 65534
    -- seed = "1364330648715260564240796008920406354802159042933974286750175206921467854849";
    -- seed = "1264370628715260564250796008920406354802159042933974286750175205821956227073";
    seed = "66418630152144138420887529467591841897902352589395023086471333752449146031912";

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

    globalSubSeeds = {
        baseLevelPickerSeed = subSeeds[1], 
        themeSeed = subSeeds[2], 
        darkPalette = subSeeds[3], 
        baseLevel = subSeeds[4], 
        waveFn1 = subSeeds[5], 
        waveFn2 = subSeeds[6], 
        shadowDir1 = subSeeds[7], 
        shadowDir2 = subSeeds[8],
        microscopic = subSeeds[9],
        floorWireframe = subSeeds[10],
        theCrowd = subSeeds[11],
        directionRemover = subSeeds[12],
    }
    
    return globalSubSeeds
end

function load_level(level_to_load, subSeeds)
    reset_map()

    teletransport_ball_to(ball, 3, 1, 10)
    srand(subSeeds.microscopic)
    if rnd() < 0.3 then
        TILE_WIDTH /= 2
        TILE_HEIGHT /= 2
        TILE_HEIGHT_HALF /= 2
        TILE_WIDTH_HALF /= 2
        DEFAULT_BLOCK_HEIGHT /= 2
        teletransport_ball_to(ball, 3, 1, 10)
    end

    local theme = getRandomTheme(subSeeds.themeSeed)

    -- dark palette
    srand(subSeeds.darkPalette)
    if rnd() < 0.30 then
        for i=0,15 do
            pal(i,i+128,1)
        end
        attr_is_night = true
    end

    -- crazy palette
    srand(subSeeds.darkPalette)
    if rnd() < 0.05 then
        crazyPaletteOffsets = { 666, 115, 108 }
        for i=0,15 do
            pal(i,i+rnd(crazyPaletteOffsets),1)
        end
        attr_is_night = true
    end

    c1 = theme.c1
    c2 = theme.c2
    c3 = theme.c3
    c4 = theme.c4
    c5 = theme.c5
    c6 = theme.c6
    c7 = theme.c7
    
    srand(subSeeds.theCrowd)
    chanceOfFlamingo = 0.01
    chanceOfFolliage = 0.1

    if rnd() <= 0.02 then
        chanceOfFolliage = 0
        chanceOfFlamingo = 0.65
    end 

    srand(subSeeds.baseLevel)
    randomLevel = rnd(level_to_load.level)
    
    for level_floor in all(level_to_load.level) do
        current_level_floor = current_level_floor + 1
        foreach(level_floor, create_block)
    end

    possibleSteps = { 0, 1, 3, 4, 5, 7, 8, 10, 20 }
    if level_to_load.metadata.procedural then
        wave_function_collapse(blocks, rnd(possibleSteps), subSeeds) 
    end

    for x = -8,8 do
        for y = -8,8 do
            block = get_block_at(x, y, 1)
            if block == nil then
                if rnd() < chanceOfFolliage then 
                    add(decorations, generate_decoration(x, y, 0, "folliage"))
                end
            end 
            
            if attr_is_night ~= true then
                block = get_block_at(x, y, 1)
                if block == nil then
                    if rnd() < chanceOfFlamingo then 
                        add(decorations, generate_decoration(x, y, 0, "flamingo"))
                    end
                end 
            end 
        end    
    end
    

    sortDepth(blocks)
end
