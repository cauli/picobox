DIRECTIONS = { N, S, E, W, NW, SW, NE, SE }

BLOCKS = {
    -- a plateau
    REGULAR = 0,

    -- nothing on one side
    -- a plateau on the specified direction
    --
    -- HALF_E
    --        ..2__
    --     ...  |  ___
    --  4..     |     __2
    --  .  ...  |  ___  |
    --  .     ..3__     |
    --  8..     |     __6
    --     ...  |  ___
    --        ..7__
    HALF_S=1,
    HALF_W=2,
    HALF_N=3,
    HALF_E=4, 

    -- a long ramp that raises to the specified direction

    --        ..1.\
    --     ...     \..
    --  4.\         \ ..x
    --  .  \..     ..\  .
    --  .   \ ..x..   \ .
    --  8..  \  .     ..6
    --     ...\ .  ...
    --        ..7..
    RAMP_NW=5,

    --        ..1_
    --     ... /   - _
    --  4..  /         -x
    --  .  /..     ..  /.
    --  ./    ..x..  /  .
    --  8__     .  /  ..6
    --     ___  . /...
    --        __7..
    RAMP_NE=6,

    --        ..1..
    --     ...      ..
    --  4..    ----------2
    --  .  -        ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
    RAMP_SW=7,
    RAMP_SE=8,

    -- RAMP_HALF_(E|S|W|N)
    --
    -- ramps half of the block and the other half is
    -- a plateau on the specified direction

    --        ./1..
    --     ../  |  ...
    --  4../    |     ..2
    --  ./      |  ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
    RAMP_HALF_E=9,

    --          1 
    --     _____5_____
    --  4_______________2
    --  .  ...      ...  .
    --  .     ..3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
    RAMP_HALF_S=10,

    --        ..1\
    --     ...  |  \
    --  4..     |   \    2
    --  .  ...  |    \   
    --  .     ..3__   \  
    --  8..     .  --- \ 6
    --     ...  .  ...
    --        ..7..  
    RAMP_HALF_W=11,

    --        ..1..
    --     ...     ...
    --  4_______________2
    --  . \           / .
    --  .   \        /  .
    --  8..  \     /  ..6
    --     ... \ /  ...
    --        ..7..  
    RAMP_HALF_N=12,

    -- RAMP_(E|S|N|W)
    -- a small diagonal ramp that raises to the specified direction
    --        ..1..
    --     ...     ...
    --  4..     5-------2
    --  .       |      /|
    --  .       |    /  |
    --  8..     |  /  __6
    --     ...  |/ ___
    --        ..7__
    RAMP_E=13,
        
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .     / 3 ⟍    .  
    --  .   /   |   ⟍   . 
    --  8 /     |     ⟍ 6
    --     ___  |   ___
    --        __7__
    RAMP_S=14,

    --        ..1..
    --     ...     ...
    --  4-------5      ..2
    --  |  \    |   ..   .  
    --  |   \   |..      . 
    --  8    \  |       6
    --    ___  \|  ...
    --        __7..
    RAMP_W=15,

    --        ..1..
    --     ... / \ ...
    --  4..  /     \  ..2
    --  .  /         \  .
    --  ./             \.
    --  8---------------6
    --     ...  .  ...
    --        ..7..
    RAMP_N=16,
}

-- groups of blocks used for the wave function collapser
BLOCK_GROUPS = {
    EMPTY = {
        nil,
    },
    ELEVATED_AT = {
        SW = {
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.HALF_E, 
            BLOCKS.HALF_N, 
            BLOCKS.RAMP_NE, 
            BLOCKS.RAMP_HALF_E, 
            BLOCKS.RAMP_HALF_N
        },
        NW = {
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.RAMP_SE,
            BLOCKS.HALF_E, 
            BLOCKS.HALF_S,
            BLOCKS.RAMP_HALF_E, 
            BLOCKS.RAMP_HALF_S  
        },
        SE = {
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.HALF_N, 
            BLOCKS.HALF_W, 
            BLOCKS.RAMP_NW, 
            BLOCKS.RAMP_HALF_W, 
            BLOCKS.RAMP_HALF_N
        },
        NE = {
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR, 
            BLOCKS.REGULAR,
            BLOCKS.HALF_W,
            BLOCKS.HALF_S,
            BLOCKS.RAMP_SW,
            BLOCKS.RAMP_HALF_W,
            BLOCKS.RAMP_HALF_S
        }
    },
    ELEVATING_TOWARDS = {
        SW = {
            BLOCKS.RAMP_SW,
        },
        NW = {
            BLOCKS.RAMP_NW,
        },
        SE = {
            BLOCKS.RAMP_SE,
        },
        NE = {
            BLOCKS.RAMP_NE,
        },
        N = {
            BLOCKS.RAMP_N,
        },
        W = {
            BLOCKS.RAMP_W,
        },
        S = {
            BLOCKS.RAMP_S,
        },
        E = {
            BLOCKS.RAMP_E,
        }
    },
    SUNKEN_AT = {
        SW = {
            nil,
            nil,
            nil,
            BLOCKS.HALF_W, BLOCKS.HALF_S,
            BLOCKS.RAMP_SW
        },
        NW = {
            nil,
            nil,
            nil,
            BLOCKS.HALF_S, BLOCKS.HALF_E
        },
        SE = {
            nil,
            nil,
            nil,
            BLOCKS.HALF_W, BLOCKS.HALF_N
        },
        NE = {
            nil,
            nil,
            BLOCKS.HALF_E, BLOCKS.HALF_N
        }
    }
}

function TableConcat(t1,t2)
    t1c = {}
    t2c = {}

    for key, value in pairs(t1) do
        t1c[key] = value
    end
      
    for key, value in pairs(t2) do
        t2c[key] = value
    end

    for i=1,#t2c do
        t1c[#t1c+1] = t2c[i]
    end
    
    return t1c
end

BLOCK_CONNECTIONS = {
    REGULAR = {
        NE =  TableConcat(BLOCK_GROUPS.EMPTY, BLOCK_GROUPS.ELEVATED_AT.NE),
        NW =  TableConcat(BLOCK_GROUPS.EMPTY, BLOCK_GROUPS.ELEVATED_AT.NW),
        SW =  TableConcat(BLOCK_GROUPS.EMPTY, BLOCK_GROUPS.ELEVATED_AT.SW),
        SE =  TableConcat(BLOCK_GROUPS.EMPTY, BLOCK_GROUPS.ELEVATED_AT.SE)
    },
    RAMP_NE = {
        NE = BLOCK_GROUPS.ELEVATED_AT.NE,
        NW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NE, BLOCK_GROUPS.ELEVATING_TOWARDS.E),
        SE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NE, BLOCK_GROUPS.ELEVATING_TOWARDS.N),
        SW = BLOCK_GROUPS.SUNKEN_AT.SW
    },
    RAMP_NW = {
        NE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NW, BLOCK_GROUPS.ELEVATING_TOWARDS.W),
        NW = BLOCK_GROUPS.ELEVATED_AT.NW,
        SE = BLOCK_GROUPS.SUNKEN_AT.NW,
        SW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NW, BLOCK_GROUPS.ELEVATING_TOWARDS.N),
    },
    RAMP_SE = {
        NE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SE, BLOCK_GROUPS.ELEVATING_TOWARDS.S),
        NW = BLOCK_GROUPS.SUNKEN_AT.SE, 
        SE = BLOCK_GROUPS.ELEVATED_AT.SE,
        SW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SE, BLOCK_GROUPS.ELEVATING_TOWARDS.E),
    },
    RAMP_SW = {
        NE = BLOCK_GROUPS.SUNKEN_AT.NE,
        NW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SW, BLOCK_GROUPS.ELEVATING_TOWARDS.S),
        SE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SW, BLOCK_GROUPS.ELEVATING_TOWARDS.W),
        SW = BLOCK_GROUPS.ELEVATED_AT.SW
    }, 
    HALF_S = {
        NE = BLOCK_GROUPS.EMPTY,
        NW = BLOCK_GROUPS.EMPTY,
        SE = BLOCK_GROUPS.ELEVATED_AT.SE,
        SW = BLOCK_GROUPS.ELEVATED_AT.SW
    },
    HALF_N = {
        NE = BLOCK_GROUPS.ELEVATED_AT.NE,
        NW = BLOCK_GROUPS.ELEVATED_AT.NW,
        SE = BLOCK_GROUPS.EMPTY,
        SW = BLOCK_GROUPS.EMPTY,
    },
    HALF_E = {
        NE = BLOCK_GROUPS.ELEVATED_AT.NE,
        NW = BLOCK_GROUPS.EMPTY,
        SE = BLOCK_GROUPS.ELEVATED_AT.SE,
        SW = BLOCK_GROUPS.EMPTY,
    },   
    HALF_W = {
        NE = BLOCK_GROUPS.EMPTY,
        NW = BLOCK_GROUPS.ELEVATED_AT.NW,
        SE = BLOCK_GROUPS.EMPTY,
        SW = BLOCK_GROUPS.ELEVATED_AT.SW,
    },
    RAMP_W = {
        NE = BLOCK_GROUPS.EMPTY,
        NW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SW, BLOCK_GROUPS.ELEVATING_TOWARDS.S),
        SE = BLOCK_GROUPS.EMPTY, 
        SW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NW, BLOCK_GROUPS.ELEVATING_TOWARDS.N),
    },
    RAMP_E = {
        NE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SE, BLOCK_GROUPS.ELEVATING_TOWARDS.S),
        NW = BLOCK_GROUPS.EMPTY,
        SE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NE, BLOCK_GROUPS.ELEVATING_TOWARDS.N),
        SW = BLOCK_GROUPS.EMPTY,
    },
    RAMP_N = {
        NE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NW, BLOCK_GROUPS.ELEVATING_TOWARDS.W),
        NW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.NE, BLOCK_GROUPS.ELEVATING_TOWARDS.E),
        SE = BLOCK_GROUPS.EMPTY,
        SW = BLOCK_GROUPS.EMPTY,
    },
    RAMP_S = {
        NE = BLOCK_GROUPS.EMPTY, 
        NW = BLOCK_GROUPS.EMPTY, 
        SE = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SW, BLOCK_GROUPS.ELEVATING_TOWARDS.W),
        SW = TableConcat(BLOCK_GROUPS.ELEVATING_TOWARDS.SE, BLOCK_GROUPS.ELEVATING_TOWARDS.E),
    }
}

BLOCK_CONNECTIONS['RAMP_HALF_E'] = {
    NE = BLOCK_CONNECTIONS.REGULAR.NE, 
    NW = BLOCK_CONNECTIONS.RAMP_NE.NW, 
    SE = BLOCK_CONNECTIONS.REGULAR.SE,
    SW = BLOCK_CONNECTIONS.RAMP_SE.SW, 
}




-- TODO
    --   RAMP_HALF_S
    --   RAMP_HALF_W
    --   RAMP_HALF_N