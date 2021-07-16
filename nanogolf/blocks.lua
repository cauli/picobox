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
    --        ..2__
    --     ...  |  ___
    --  4..     |     __2
    --  .  ...  |  ___  |
    --  .     ..3__     |
    --  8..     |     __6
    --     ...  |  ___
    --        ..7__
    half_south=100,
    half_west=101,
    half_north=102,
    half_east=103,

    -- a long ramp that raises to the specified direction
    -- 𝘳𝘢𝘮𝘱 𝘯𝘰𝘳𝘵𝘩 𝘸𝘦𝘴𝘵
    --        ..1.\
    --     ...     \..
    --  4.\         \ ..x
    --  .  \..     ..\  .
    --  .   \ ..x..   \ .
    --  8..  \  .     ..6
    --     ...\ .  ...
    --        ..7..
    ramp_north_west=1,
    ramp_north_east=2,
    ramp_south_west=3,
    ramp_south_east=4,

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
    ramp_half_east=5,
    ramp_half_south=6,
    ramp_half_west=7,
    ramp_half_north=8,

    -- a small diagonal ramp that raises to the specified direction
    -- 𝘳𝘢𝘮𝘱 𝘯𝘰𝘳𝘵𝘩
    --        ..1..
    --     ... / \ ...
    --  4..  /     \  ..2
    --  .  /         \  .
    --  ./             \.
    --  8---------------6
    --     ...  .  ...
    --        ..7..

    ramp_east=9,
    ramp_south=10,
    ramp_west=11,
    ramp_north=12,
}