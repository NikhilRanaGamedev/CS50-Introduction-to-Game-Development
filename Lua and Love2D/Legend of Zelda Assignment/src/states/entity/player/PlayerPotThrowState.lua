--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotThrowState = Class{__includes = BaseState}

local potDx = 150
local potDy = 150

local potX = 0
local potY = 0
local index = 1

function PlayerPotThrowState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity:changeAnimation('pot-throw-' .. self.entity.direction)

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.pot = self.dungeon.currentRoom.pickedPot

    potX = self.pot.x
    potY = self.pot.y

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object == self.pot then
            index = k
        end
    end
end

function PlayerPotThrowState:update(dt)
    self.pot:fire(dt, self.entity, potDx, potDy)

    for k, entity in pairs(self.dungeon.currentRoom.entities) do
        if self.pot:collides(entity) then
            gSounds['pot_hit']:play()
            entity:damage(1)
        end
    end

    if self.entity.direction == 'left' then
        if self.pot.x < potX - self.pot.width - 48 or self.pot.x < MAP_RENDER_OFFSET_X then
            table.remove(self.dungeon.currentRoom.objects, index)
            gSounds['pot_hit']:play()
            self.entity:changeState('idle')
        end
    elseif self.entity.direction == 'right' then
        if self.pot.x > potX + self.pot.width + 48 or self.pot.x > VIRTUAL_WIDTH - (TILE_SIZE * 2) then
            table.remove(self.dungeon.currentRoom.objects, index)
            gSounds['pot_hit']:play()
            self.entity:changeState('idle')
        end
    elseif self.entity.direction == 'up' then
        if self.pot.y < potY - self.pot.height - 48 or self.pot.y < MAP_RENDER_OFFSET_Y then
            table.remove(self.dungeon.currentRoom.objects, index)
            gSounds['pot_hit']:play()
            self.entity:changeState('idle')
        end
    elseif self.entity.direction == 'down' then
        if self.pot.y > potY + self.pot.height + 48 or self.pot.y > VIRTUAL_HEIGHT - (TILE_SIZE * 2) then
            table.remove(self.dungeon.currentRoom.objects, index)
            gSounds['pot_hit']:play()
            self.entity:changeState('idle')
        end
    end

    --[[if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('idle')
    end]]
end

function PlayerPotThrowState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end