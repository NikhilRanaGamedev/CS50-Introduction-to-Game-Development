Powerup = Class{__includes = BaseState}

local timer = 0
local COUNTDOWN = 0.75

function Powerup:init(power)
	self.x = math.random(0, VIRTUAL_WIDTH - 16)
	self.y = math.random(0, VIRTUAL_HEIGHT / 2 - 30)

	self.dy = 0

	self.width = 16
	self.height = 16

	self.hitCounter = 0
	self.seconds = 22

	self.powerupActive = false
	self.powerupCollected = false

	self.power = power
end

function Powerup:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Powerup:update(dt)
	if self.hitCounter == 10 and self.power == 1 then
		self.powerupActive = true
		self.y = self.y + self.dy * dt
	end
	
	if self.powerupActive == false and self.powerupCollected == false and lockedBrick then
		timer = timer + dt

		if timer > COUNTDOWN and self.power == 2 then
			timer = timer % COUNTDOWN
			self.seconds = math.max(0, self.seconds - 1)
		end
	end

	if self.seconds == 0 then
		self.powerupActive = true
		self.y = self.y + self.dy * dt
	end
end

function Powerup:render()
	if self.powerupActive and self.powerupCollected == false then
		love.graphics.draw(gTextures['main'], gFrames['powerup'][self.power], self.x, self.y)
	end
end