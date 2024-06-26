Mobs = Class {
    mobs = {},
    spawners = {},
    graphics = {
        spawner = {
            sprite = Sprites.spawner,
            grid = Anim8.newGrid(32, 32, 224, 32),
        }
    }
}

function Mobs:remove(mob)
    mob.fixture:destroy()
    for i, value in ipairs(self.mobs) do
        if value == mob then
            table.remove(self.mobs, i)
            break
        end
    end
end

function Mobs:addSpiderSpawner(pos, radius, count)
    local spawner = SpiderSpawner(pos, radius, count)
    table.insert(self.spawners, spawner)
    spawner:initialSpawn()
end

function Mobs:add(mob)
    table.insert(self.mobs, mob)
end

function Mobs:move(dt)
    for _, mob in pairs(self.mobs) do
        mob:move(dt)
    end
end

function Mobs:update(dt)
    for index, spawner in pairs(self.spawners) do
        spawner.animation:update(dt)
    end
end

function Mobs:closestTo(x, y, maxRange)
    local closestMob = nil
    local closestDistance = 9999999
    for _, mob in pairs(self.mobs) do
        local mobV = Vector(mob.body:getX(), mob.body:getY())
        local distance = mobV:dist(Vector(x, y))
        if (distance < closestDistance and distance < maxRange) then
            closestDistance = distance
            closestMob = mob
        end
    end

    return closestMob
end

function Mobs:applyShockwave(x, y)
    local originV = Vector(x, y)
    for _, mob in pairs(self.mobs) do
        local mobV = Vector(mob.body:getX(), mob.body:getY())
        local distanceToOrigin = mobV:dist(originV)

        if (distanceToOrigin < 200) then
            local forceV = -1 * (originV - mobV)
            forceV:normalizeInplace()

            local multiplier = ((200 - distanceToOrigin) / 200) * 500
            mob.body:applyLinearImpulse(forceV.x * multiplier, forceV.y * multiplier)
        end
    end
end

function Mobs:drawMobs()
    -- Draw mobs
    for _, mob in pairs(self.mobs) do
        Ui:setColor(nil)
        mob.animation:draw(mob.spriteSheet, mob.body:getX(), mob.body:getY(), nil, 1, nil, 32, 32)

        if (mob.health < mob.maxHealth) then
            Ui:setColor(Colors.black)
            love.graphics.rectangle("fill", mob.body:getX() - 20, mob.body:getY() - 25, 40, 6)
            Ui:setColor(Colors.red)
            love.graphics.rectangle(
                "fill",
                mob.body:getX() - 19, mob.body:getY() - 24,
                38 * (mob.health / mob.maxHealth), 4
            )
        end
    end
end

function Mobs:drawSpawners()
    Ui:setColor(nil)
    -- Draw spawner animations
    for _, spawner in pairs(self.spawners) do
        spawner.animation:draw(self.graphics.spawner.sprite, spawner.pos.x, spawner.pos.y, nil, 1, nil, 32, 32)
    end
end

return Mobs
