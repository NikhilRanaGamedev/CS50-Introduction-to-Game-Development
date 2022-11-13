--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('pot-lift-' .. self.entity.direction)

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.pot = self.dungeon.currentRoom.pickedPot

    if self.entity.direction == 'left' then
        Timer.tween(1.5, {
            [self.pot] = {x = self.entity.x + 2, y = self.entity.y - 13}
        })
    elseif self.entity.direction == 'right' then
        Timer.tween(1.5, {
            [self.pot] = {x = self.entity.x - 2, y = self.entity.y - 13}
        })
    elseif self.entity.direction == 'up' or 'down' then
        Timer.tween(1.5, {
            [self.pot] = {y = self.entity.y - 13}
        })
    end
end

function PlayerPotLiftState:update(dt)
    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('pot-idle')
    end
end

function PlayerPotLiftState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end