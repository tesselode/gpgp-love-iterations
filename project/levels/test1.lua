return {
  tileSize = 16,
  width = 15,
  height = 15,
  groups = {
    {
      name = 'Main',
      layers = {
        {
          name = 'Entities',
          type = 'entity'
        },
        {
          name = 'Geometry',
          type = 'geometry'
        },
        {
          name = 'Tiles',
          type = 'tile',
          tileset = 'Main'
        }
      }
    },
    {
      name = 'Secondary',
      layers = {
        {
          name = 'Entities',
          type = 'entity'
        },
        {
          name = 'Geometry',
          type = 'geometry'
        },
        {
          name = 'Tiles',
          type = 'tile',
          tileset = 'Main'
        }
      }
    },
  }
}
