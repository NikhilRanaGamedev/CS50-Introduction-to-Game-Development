--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

local balls = 1
local counter = 0

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
    self.ballPowerup = Powerup(1)
    self.keyPowerup = Powerup(2)
    self.recoverPoints = 5000

    -- give ball random starting velocity
    for i = 1, 3 do
        if i == 1 then
            self.ball[i].dx = math.random(-200, 200)
            self.ball[i].dy = math.random(-50, -60)
        else
            self.ball[i].dx = math.random(-800, 1000)
            self.ball[i].dy = math.random(-800, -1000)
        end
    end

    -- give powerup balls random spawn points
    for i = 1, 2 do
        self.ball[i + 1].active = false
        self.ball[i + 1].x = math.random(0, VIRTUAL_WIDTH - 16)
        self.ball[i + 1].y = math.random(30, VIRTUAL_WIDTH / 2)
    end

    -- give powerup down acceleration
    self.ballPowerup.dy = math.random(80, 100)
    self.keyPowerup.dy = math.random(120, 160)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)

    for i = 1, 3 do
        if self.ball[i].active then
            self.ball[i]:update(dt)

            if self.ball[i]:collides(self.paddle) then
                -- raise ball[i] above paddle in case it goes below it, then reverse dy
                self.ball[i].y = self.paddle.y - 8
                self.ball[i].dy = -self.ball[i].dy

                --
                -- tweak angle of bounce based on where it hits the paddle
                --

                -- if we hit the paddle on its left side while moving left...
                if self.ball[i].x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                    self.ball[i].dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball[i].x))
        
                -- else if we hit the paddle on its right side while moving right...
                elseif self.ball[i].x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                    self.ball[i].dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball[i].x))
                end

            gSounds['paddle-hit']:play()
            end
        end
    end

    self.ballPowerup:update(dt)
    self.keyPowerup:update(dt)

    -- check if powerup collides with paddle
    if self.ballPowerup:collides(self.paddle) then
        self.ballPowerup.powerupCollected = true
        self.ballPowerup.powerupActive = false
        self.ballPowerup.hitCounter = 0
        self.ballPowerup.x = math.random(0, VIRTUAL_WIDTH - 16)
        self.ballPowerup.y = math.random(0, VIRTUAL_HEIGHT / 2 - 30)

        balls = 3
        for i = 1, balls do
            if self.ball[i].active == false then
                self.ball[i].active = true

                self.ball[i].dx = math.random(-200, 200)
                self.ball[i].dy = math.random(-50, -60)
            end
        end
    elseif self.ballPowerup.y > VIRTUAL_HEIGHT then
        self.ballPowerup.powerupActive = false
        self.ballPowerup.hitCounter = 0
        self.ballPowerup.y = math.random(0, VIRTUAL_HEIGHT / 2)
    end

    if self.keyPowerup:collides(self.paddle) then
        self.keyPowerup.powerupCollected = true
        self.keyPowerup.powerupActive = false
        lockedBrickInfo.tier = 1

        self.keyPowerup.x = math.random(0, VIRTUAL_WIDTH - 16)
        self.keyPowerup.y = math.random(0, VIRTUAL_HEIGHT / 2 - 30)
    elseif self.keyPowerup.y > VIRTUAL_HEIGHT then
        self.keyPowerup.powerupActive = false
        self.keyPowerup.seconds = 22
        self.keyPowerup.y = math.random(0, VIRTUAL_HEIGHT / 2)
    end

    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
        
        for i = 1, 3 do
            if self.ball[i].active then
                -- only check collision if we're in play
                if brick.inPlay and self.ball[i]:collides(brick) then

                    -- add to score
                    if brick.color == 6 and brick.tier == 1 then
                        self.score = self.score + 5000
                    elseif brick.color == 6 and brick.tier == 0 then
                        self.score = self.score + 0
                    else
                        self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    end

                    -- trigger the brick's hit function, which removes it from play
                    brick:hit(self.ballPowerup, self.keyPowerup)

                    -- if we have enough points, recover a point of health
                    if self.score > self.recoverPoints then
                        -- can't go above 3 health
                        self.health = math.min(3, self.health + 1)

                        -- multiply recover points by 2
                        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                        -- increase size
                        self.paddle.size = math.min(self.paddle.size + 1, 4)
                        self.paddle.width = math.min(self.paddle.width + 32, 128)

                        -- play recover sound effect
                        gSounds['recover']:play()
                    end

                    -- go to our victory screen if there are no more bricks left
                    if self:checkVictory() then
                        gSounds['victory']:play()

                        gStateMachine:change('victory', {
                            level = self.level,
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            highScores = self.highScores,
                            ball = self.ball,
                            recoverPoints = self.recoverPoints
                        })
                    end

                    --
                    -- collision code for bricks
                    --
                    -- we check to see if the opposite side of our velocity is outside of the brick;
                    -- if it is, we trigger a collision on that side. else we're within the X + width of
                    -- the brick and should check to see if the top or bottom edge is outside of the brick,
                    -- colliding on the top or bottom accordingly 
                    --

                    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    if self.ball[i].x + 2 < brick.x and self.ball[i].dx > 0 then
                
                        -- flip x velocity and reset position outside of brick
                        self.ball[i].dx = -self.ball[i].dx
                        self.ball[i].x = brick.x - 8
            
                    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                    -- so that flush corner hits register as Y flips, not X flips
                    elseif self.ball[i].x + 6 > brick.x + brick.width and self.ball[i].dx < 0 then
                
                        -- flip x velocity and reset position outside of brick
                        self.ball[i].dx = -self.ball[i].dx
                        self.ball[i].x = brick.x + 32
            
                    -- top edge if no X collisions, always check
                    elseif self.ball[i].y < brick.y then
                
                        -- flip y velocity and reset position outside of brick
                        self.ball[i].dy = -self.ball[i].dy
                        self.ball[i].y = brick.y - 8
            
                    -- bottom edge if no X collisions or top collision, last possibility
                    else
                
                        -- flip y velocity and reset position outside of brick
                        self.ball[i].dy = -self.ball[i].dy
                        self.ball[i].y = brick.y + 16
                    end

                    -- slightly scale the y velocity to speed up the game, capping at +- 150
                    if math.abs(self.ball[i].dy) < 150 then
                        self.ball[i].dy = self.ball[i].dy * 1.02
                    end

                    -- only allow colliding with one brick, for corners
                    break
                end
            end
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    for i = 1, 3 do
        if self.ball[i].y >= VIRTUAL_HEIGHT and self.ball[i].active == true and balls ~= 1 then
                self.ball[i].active = false
                counter = counter + 1

                self.ball[i].x = math.random(0, VIRTUAL_WIDTH - 16)
                self.ball[i].y = math.random(30, VIRTUAL_WIDTH / 2)

                self.ball[i].dx = 0
                self.ball[i].dy = 0

                if counter == 2 then
                    self.ballPowerup.powerupCollected = false
                    balls = 1
                    counter = 0
                end
        elseif self.ball[i].y >= VIRTUAL_HEIGHT and self.ball[i].active == true and balls == 1 then
            self.health = self.health - 1

            self.paddle.size = math.max(self.paddle.size - 1, 1)
            self.paddle.width = math.max(self.paddle.width - 32, 32)

            gSounds['hurt']:play()

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    level = self.level,
                    recoverPoints = self.recoverPoints
                })
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for i = 1, 3 do
        if self.ball[i].active then
            self.ball[i]:render()
        end
    end

    renderScore(self.score)
    renderHealth(self.health)

    self.ballPowerup:render()
    self.keyPowerup:render()

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end