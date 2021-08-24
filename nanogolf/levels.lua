globalSubSeeds = {}

current_level = 0


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
    -- seed = "66418630152144138420887529467591841897902352589395023086471333752449146031912";

    randomSeed = false
    
    if seed == "0000000000000000000000000000000000000000000000000000000000000000000000000000" then
        randomSeed = true
    end 
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
        directionScrambler = subSeeds[12],
        moonGravity = subSeeds[13],
        wireframeBoundaries = subSeeds[14],
    }
    
    return globalSubSeeds
end

function load_level(level_to_load, subSeeds)
    reset_map()

    srand(subSeeds.moonGravity)
    if rnd() < 0.1 then
        gravity = 0.05
    end
    
    TILE_WIDTH = 50
    TILE_HEIGHT = 25
    TILE_HEIGHT_HALF = TILE_HEIGHT/2
    TILE_WIDTH_HALF = TILE_WIDTH/2
    DEFAULT_BLOCK_HEIGHT = 12.5/2

    teletransport_ball_to(ball, 3, 1, 10)
    srand(subSeeds.microscopic)
    if rnd() < 0.35 then
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
    if rnd() < 0.5 then
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
    chanceOfWindy = 0.01


    if rnd() <= 0.05 then
        chanceOfFolliage = 0
        chanceOfFlamingo = 0.65
    end 

    srand(subSeeds.baseLevel)
    -- randomLevel = rnd(level_to_load.level)

    current_level_floor = current_level_floor + 1
    create_block({rnd({1,2,3}),rnd({-1,1}),1,rnd({BLOCKS.RAMP_HALF_E,
    BLOCKS.RAMP_E,
    BLOCKS.REGULAR,
    BLOCKS.RAMP_SW,
    BLOCKS.RAMP_NW,
    BLOCKS.RAMP_W,
    BLOCKS.RAMP_N}),false}, false)

    possibleSteps = { 1, 3, 5, 7, 8, 10, 20 }
    -- if level_to_load.metadata.procedural then
        wave_function_collapse(blocks, rnd(possibleSteps), subSeeds) 
    -- end

    for x = -8,8 do
        for y = -8,8 do
            block = get_block_at(x, y, 1)
            if block == nil then
                if rnd() < chanceOfFolliage then 
                    add(decorations, generate_decoration(x, y, 0, "folliage"))
                end
            end 
            
            block = get_block_at(x, y, 1)
            if block == nil then
                if rnd() < chanceOfWindy then 
                    chanceOfWindy *= 0.2 -- there shouldnt be two windys at the same level... most likely!
                    add(decorations, generate_decoration(x, y, 0, "windy"))
                end
            end 

            if attr_is_night ~= true then
                block = get_block_at(x, y, 1)
                if block == nil then
                    if rnd() < chanceOfFlamingo then 
                        chanceOfFlamingo -= 0.003
                        add(decorations, generate_decoration(x, y, 0, "flamingo"))
                    end
                end 
            end 
        end    
    end
    

    sortDepth(blocks)
end
