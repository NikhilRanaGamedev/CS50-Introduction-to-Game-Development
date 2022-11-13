--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.entity) and object.solid and love.keyboard.wasPressed('c') then
            self.dungeon.currentRoom.pickedPot = object
            self.entity:changeState('pot-lift')
        end
    end
end

function PlayerIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end