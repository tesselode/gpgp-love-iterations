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
      name = 'Stupid',
      layers = {
        {
          name = 'Butts',
          type = 'entity'
        },
        {
          name = 'Poop',
          type = 'entity'
        },
        {
          name = 'Farts',
          type = 'entity',
        },
        {
          name = 'Entities',
          type = 'entity',
        }
      }
    },
  }
}
