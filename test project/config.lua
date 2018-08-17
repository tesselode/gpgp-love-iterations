return {
	tileSize = 16,
	entities = {
		{
			name = 'Fish',
			image = 'images/fish.png',
		},
		{
			name = 'Jellyfish',
			image = 'images/jellyfish.png',
		},
		{
			name = 'Smol fish',
			image = 'images/smol fish.png',
		},
	},
	defaultSettings = {
		width = 16,
		height = 9,
		layers = {
			{
				name = 'Entities',
				type = 'Entity',
			},
			{
				name = 'Terrain',
				type = 'Geometry',
			},
		},
	},
}
