--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local gold = love.graphics.newImage('gold.png')
local silver = love.graphics.newImage('silver.png')
local bronze = love.graphics.newImage('bronze.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
        currentState = 'countdown'
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen

    if self.score >= 7 and self.score < 13 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Congratulation! You earned the Bronze medal!', 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(bronze, VIRTUAL_WIDTH / 2 - bronze:getWidth() / 2, 50)
    elseif self.score >= 13 and self.score < 20 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Congratulation! You earned the Silver medal!', 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(silver, VIRTUAL_WIDTH / 2 - silver:getWidth() / 2, 50)
    elseif self.score >= 20 then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Congratulation! You earned the Gold medal!', 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.draw(gold, VIRTUAL_WIDTH / 2 - gold:getWidth() / 2, 50)
    else 
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 160, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 200, VIRTUAL_WIDTH, 'center')
end