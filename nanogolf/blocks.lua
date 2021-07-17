BLOCKS = {
    -- a plateau
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .  ...     ...  .
    --  .     ..3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
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
    HALF_S=100,
    HALF_W=101,
    HALF_N=102,
    HALF_E=103,

    -- a long ramp that raises to the specified direction

    --        ..1.\
    --     ...     \..
    --  4.\         \ ..x
    --  .  \..     ..\  .
    --  .   \ ..x..   \ .
    --  8..  \  .     ..6
    --     ...\ .  ...
    --        ..7..
    RAMP_NW=1,

    --        ..1_
    --     ... /   - _
    --  4..  /         -x
    --  .  /..     ..  /.
    --  ./    ..x..  /  .
    --  8__     .  /  ..6
    --     ___  . /...
    --        __7..
    RAMP_NE=2,

    --        ..1..
    --     ...      ..
    --  4..    ----------2
    --  .  -        ...  .
    --  --------.3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
    RAMP_SW=3,
    RAMP_SE=4,

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
    RAMP_HALF_E=5,

    --          1 
    --     _____5_____
    --  4_______________2
    --  .  ...      ...  .
    --  .     ..3..     .
    --  8..     .     ..6
    --     ...  .  ...
    --        ..7..
    RAMP_HALF_S=6,

    --        ..1\
    --     ...  |  \
    --  4..     |   \    2
    --  .  ...  |    \   
    --  .     ..3__   \  
    --  8..     .  --- \ 6
    --     ...  .  ...
    --        ..7..  
    RAMP_HALF_W=7,

    --        ..1..
    --     ...     ...
    --  4_______________2
    --  . \           / .
    --  .   \        /  .
    --  8..  \     /  ..6
    --     ... \ /  ...
    --        ..7..  
    RAMP_HALF_N=8,

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
    RAMP_E=9,
        
    --        ..1..
    --     ...     ...
    --  4..           ..2
    --  .     / 3 \     .  
    --  .   /   |   \   . 
    --  8 /     |     \ 6
    --     ___  |   ___
    --        __7__
    RAMP_S=10,

    --        ..1..
    --     ...     ...
    --  4-------5      ..2
    --  |  \    |   ..   .  
    --  |   \   |..      . 
    --  8    \  |       6
    --    ___  \|  ...
    --        __7..
    RAMP_W=11,

    --        ..1..
    --     ... / \ ...
    --  4..  /     \  ..2
    --  .  /         \  .
    --  ./             \.
    --  8---------------6
    --     ...  .  ...
    --        ..7..
    RAMP_N=12,
}

-- for each block type, we determine which are the possible
-- connection blocks for each coordinate set, in the following 
-- clockwise order, starting from SW
--
-- [<<SW>>, <<NW>, <<NE>>, <<SE>>]
-- 
--            N
--          ..1..
--      ...      ...
-- W  4..           ..2 E
--    .  ...     ...  .
--    .     ..3..     .
--    8..     S     ..6
--       ...  .  ...
--          ..7..
-- 
BLOCK_CONNECTIONS = {
    REGULAR = {
        -- possible connections to SW
        SW = {BLOCKS.REGULAR, BLOCKS.HALF_E, BLOCKS.HALF_N, BLOCKS.RAMP_NE, BLOCKS.RAMP_HALF_E, BLOCKS.RAMP_HALF_N},
    
        -- TODO possible connections to NW
        NW = {BLOCKS.REGULAR},
    
        -- TODO possible connections to NE
        NE = {BLOCKS.REGULAR},
    
        -- TODO possible connections to SE
        SE = {BLOCKS.REGULAR, BLOCKS.HALF_W, BLOCKS.HALF_N, BLOCKS.RAMP_NW, BLOCKS.RAMP_HALF_W, BLOCKS.RAMP_HALF_N}
    }
}

 -- TODO
    --   HALF_E
    --   HALF_S
    --   HALF_W
    --   HALF_N
    --   HALF_E
    --   RAMP_NW
    --   RAMP_NE
    --   RAMP_SW
    --   RAMP_SE
    --   RAMP_HALF_E
    --   RAMP_HALF_S
    --   RAMP_HALF_W
    --   RAMP_HALF_N
    --   RAMP_E
    --   RAMP_S
    --   RAMP_W
    --   RAMP_N
