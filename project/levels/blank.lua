return {
  tileSize = 16,
  width    = 32,
  height   = 18,
  groups   = {
    {
      name = 'Foreground',
      layers = {
        {
          name    = 'Tiles 2',
          type    = 'tile',
          tileset = 'Main',
        },
        {
          name    = 'Tiles 1',
          type    = 'tile',
          tileset = 'Main',
        },
      }
    },
    {
      name = 'Main',
      layers = {
        {
          name = 'Entities',
          type = 'entity',
        },
        {
          name = 'Geometry',
          type = 'geometry',
        },
        {
          name    = 'Tiles 2',
          type    = 'tile',
          tileset = 'Main',
        },
        {
          name    = 'Tiles 1',
          type    = 'tile',
          tileset = 'Main',
        },
      },
    },
    {
      name = 'Background',
      layers = {
        {
          name    = 'Tiles 2',
          type    = 'tile',
          tileset = 'Main',
        },
        {
          name    = 'Tiles 1',
          type    = 'tile',
          tileset = 'Main',
        },
      }
    },
  }
}
