--[[
    TitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

local bronze = love.graphics.newImage('mini bronze.png')
local silver = love.graphics.newImage('mini silver.png')
local gold = love.graphics.newImage('mini gold.png')

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
        currentState = 'countdown'
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gold, VIRTUAL_WIDTH / 2 - gold:getWidth() / 2 - 45, 130)
    love.graphics.printf('- 20 Points', VIRTUAL_WIDTH / 2 - gold:getWidth() / 2 - 10, 140, VIRTUAL_WIDTH)

    love.graphics.draw(silver, VIRTUAL_WIDTH / 2 - silver:getWidth() / 2 - 45, 135 + silver:getHeight())
    love.graphics.printf('- 13 Points', VIRTUAL_WIDTH / 2 - silver:getWidth() / 2 - 10, 145 + silver:getHeight(), VIRTUAL_WIDTH)

    love.graphics.draw(bronze, VIRTUAL_WIDTH / 2 - bronze:getWidth() / 2 - 45, 135 + silver:getHeight() + bronze:getHeight())
    love.graphics.printf('- 7 Points', VIRTUAL_WIDTH / 2 - bronze:getWidth() / 2 - 10, 145 + silver:getHeight() + bronze:getHeight(), VIRTUAL_WIDTH)
end