--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    self.consumable = def.consumable

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    self.onConsume = function() end
end

function GameObject:update(dt)

end

function GameObject:collides(target)
    if target.direction == 'left' or 'right' then
        return not (target.x - 2 > self.x + self.width or self.x > target.x + target.width + 3 or
                    target.y + 10 > self.y + self.height or self.y > target.y + target.height - 15)
    elseif target.direction == 'up' or 'down' then
        return not (target.x + 5 > self.x + self.width or self.x > target.x + target.width - 10 or
                    target.y + 4 > self.y + self.height or self.y > target.y + target.height)
    end
end

function  GameObject:fire(dt, player, dx, dy)
	if player.direction == 'left' then
        self.y = player.y
        self.x = self.x - dx * dt
    elseif player.direction == 'right' then
        self.y = player.y
        self.x = self.x + dx * dt
    elseif player.direction == 'up' then
        self.y = self.y - dy * dt
    elseif player.direction == 'down' then
        self.y = self.y + dy * dt
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)

    love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 255)
end