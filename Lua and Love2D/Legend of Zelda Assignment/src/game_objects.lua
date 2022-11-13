--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        consumable = false,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 110,
        width = 16,
        height = 16,
        consumable = false,
        solid = true,
        defaultState = 'unpicked',
        states = {
            ['unpicked'] = {
                frame = 110
            },
            ['picked'] = {
                frame = 110
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        consumable = true,
        solid = false,
        defaultState = 'unconsumed',
        states = {
            ['unconsumed'] = {
                frame = 5
            },
            ['consumed'] = {
                frame = 1
            }
        }
	}
}