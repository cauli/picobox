local COLORS = {
  BLACK = 0,
  DARK_BLUE = 1,
  DARK_PURPLE = 2,
  DARK_GREEN = 3,
  BROWN = 4,
  DARK_GREY = 5,
  LIGHT_GREY = 6,
  WHITE = 7,
  RED = 8,
  ORANGE = 9,
  YELLOW = 10,
  GREEN = 11,
  BLUE = 12,
  LAVENDER = 13,
  PINK = 14,
  LIGHT_PEACH = 15
}

local THEMES = {
    {
      c1 = COLORS.DARK_GREY,
      c2 = COLORS.BLACK,
      c3 = COLORS.PINK,
      c4 = COLORS.DARK_GREEN,
      c5 = COLORS.LAVENDER,
      c6 = COLORS.DARK_PURPLE,
    },
    {
      c1 = COLORS.LIGHT_GREY,
      c2 = COLORS.WHITE,
      c3 = COLORS.DARK_GREY,
      c4 = COLORS.ORANGE,
      c5 = COLORS.LIGHT_PEACH,
      c6 = COLORS.BLACK,
    },
    {
      c1 = COLORS.BLUE,
      c2 = COLORS.DARK_BLUE,
      c3 = COLORS.LIGHT_GREY,
      c4 = COLORS.DARK_GREY,
      c5 = COLORS.ORANGE,
      c6 = COLORS.LAVENDER,
    }
  }

function getRandomTheme(themeSeed) 
  srand(themeSeed)
  local t = rnd(THEMES)

  printf(t)
  return t
end