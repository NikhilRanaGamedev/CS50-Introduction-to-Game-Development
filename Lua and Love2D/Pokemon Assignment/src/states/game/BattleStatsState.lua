--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleStatsState = Class{__includes = BaseState}

function BattleStatsState:init(battleState, HPIncrease, attackIncrease, defenseIncrease, speedIncrease)
    self.battleState = battleState
    
    self.statsMenu = Menu {
        x = VIRTUAL_WIDTH - 100,
        y = VIRTUAL_HEIGHT - 64 - 115,
        width = 100,
        height = 110,
        cursor = false,
        items = {
            {
                text = 'HP: ' .. 
                tostring(self.battleState.playerPokemon.HP - HPIncrease) .. ' + ' .. 
                tostring(HPIncrease) .. ' = ' .. 
                tostring(self.battleState.playerPokemon.HP)
            },
            {
                text = 'Attack: ' .. 
                tostring(self.battleState.playerPokemon.attack - attackIncrease) .. ' + ' .. 
                tostring(attackIncrease) .. ' = ' .. 
                tostring(self.battleState.playerPokemon.attack)
            },
            {
                text = 'Defense: ' .. 
                tostring(self.battleState.playerPokemon.defense - defenseIncrease) .. ' + ' .. 
                tostring(defenseIncrease) .. ' = ' .. 
                tostring(self.battleState.playerPokemon.defense)
            },
            {
                text = 'Speed: ' .. 
                tostring(self.battleState.playerPokemon.speed - speedIncrease) .. ' + ' .. 
                tostring(speedIncrease) .. ' = ' .. 
                tostring(self.battleState.playerPokemon.speed)
            }
        }
    }
end

function BattleStatsState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        self:fadeOutWhite()
    end
end

function BattleStatsState:render()
    love.graphics.setFont(gFonts['small'])
    self.statsMenu:render()
end

function BattleStatsState:fadeOutWhite()
    gStateStack:pop()

    -- fade in
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1, 
    function()

        -- resume field music
        gSounds['victory-music']:stop()
        gSounds['field-music']:play()
        
        -- pop off the battle state and stats state
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 255, g = 255, b = 255
        }, 1, function() end))
    end))
end