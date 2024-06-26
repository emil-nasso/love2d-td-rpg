ManaOrb = Class {
    init = function(self, amount, pos)
        self.amount = amount
        self.pos = pos
        Items:addOnGround(self)
    end,
    autoPickup = true,
}

function ManaOrb:pickup()
    Ui:addDebugMessage("Picking up mana orb")

    Player.mana:regenerateAmount(self.amount)
    Items:removeFromGround(self)
end

function ManaOrb:draw(positionOverride)
    local pos = positionOverride or self.pos

    Ui:setColor(Colors.blue)
    love.graphics.circle("fill", pos.x, pos.y, self.amount)
    Ui:setColor(Colors.black)
    love.graphics.circle("line", pos.x, pos.y, self.amount)
end

return ManaOrb
