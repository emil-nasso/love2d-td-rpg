LootDialog = Class {
    init = function(self, items)
        local row = 0
        local col = 0
        self.items = {}

        for _, item in pairs(items) do
            table.insert(self.items, {
                item = item,
                row = row,
                col = col,
            })

            col = col + 1
            if (col > 7) then
                col = 0
                row = row + 1
            end
        end
    end,
    position = Vector(200, 100),
    w = 400,
    h = 300,
    items = {},
    buttons = {
        { text = "Close [esc]",  x = 160, y = 250, w = 110, h = 40, action = function(self) self:close() end },
        { text = "Loot all [e]", x = 280, y = 250, w = 110, h = 40, action = function(self) self:lootAll() end },
    }
}

function LootDialog:atX(x)
    return x + self.position.x
end

function LootDialog:atY(y)
    return y + self.position.y
end

function LootDialog:gridCoord(col, row)
    local x1 = self:atX(12 + (col * 48))
    local y1 = self:atY(50 + (row * 48))
    return x1, y1, x1 + 40, y1 + 40
end

function LootDialog:keyPressed(key)
    if key == 'escape' then
        self:close()
    elseif key == 'e' then
        self:lootAll()
    end
end

function LootDialog:lootAll()
    for _, item in pairs(self.items) do
        item.item:pickup()
    end
    self:close()
end

function LootDialog:close()
    OpenDialog = nil
end

function LootDialog:mousePressed(x, y, button)
    local mouseX, mouseY = love.mouse.getPosition()
    for index, item in pairs(self.items) do
        local x1, y1, x2, y2 = self:gridCoord(item.col, item.row)
        if mouseX > x1 and mouseX < x2 and mouseY > y1 and mouseY < y2 then
            item.item:pickup()
            table.remove(self.items, index)
            break
        end
    end

    for index, button in pairs(self.buttons) do
        if self:buttonIsHoovered(button) then
            button.action(self)
            break;
        end
    end
end

function LootDialog:buttonIsHoovered(button)
    local x1, y1 = self:atX(button.x), self:atY(button.y)
    local x2, y2 = x1 + button.w, y1 + button.h

    local mouseX, mouseY = love.mouse.getPosition()

    return mouseX > x1 and mouseX < x2 and mouseY > y1 and mouseY < y2
end

function LootDialog:draw()
    local mouseX, mouseY = love.mouse.getPosition()
    -- Border
    Ui:setColor(Colors.lightGray)
    love.graphics.rectangle('fill', self:atX(-4), self:atY(-4), self.w + 8, self.h + 8, 6, 6)
    love.graphics.setLineWidth(1)

    -- Background
    Ui:setColor(Colors.gray)
    love.graphics.rectangle('fill', self:atX(0), self:atY(0), self.w, self.h)

    -- Title
    Ui:setColor(Colors.white)
    love.graphics.print("Loot", self:atX(10), self:atY(10))

    -- Grid
    Ui:setColor(Colors.white)
    for col = 0, 7, 1 do
        for row = 0, 3, 1 do
            local x1, y1, x2, y2 = self:gridCoord(col, row)
            if mouseX > x1 and mouseX < x2 and mouseY > y1 and mouseY < y2 then
                Cursors:setPointerCursor()
                Ui:setColor(Colors.lightGray)
                love.graphics.rectangle('fill', x1, y1, x2 - x1, y2 - y1)
                Ui:setColor(Colors.white)
            end
            love.graphics.rectangle('line', x1, y1, x2 - x1, y2 - y1)
        end
    end

    Ui:setColor(nil)

    -- Items
    for _, item in pairs(self.items) do
        local x, y = self:gridCoord(item.col, item.row)
        item.item:draw(Vector(x + 20, y + 20))
    end

    -- Buttons
    for _, button in pairs(self.buttons) do
        self:drawButton(button)
    end
end

function LootDialog:drawButton(button)
    Ui:setColor(Colors.white)
    Ui:setFont(Ui.fontSize.l)

    local x, y = self:atX(button.x), self:atY(button.y)

    if self:buttonIsHoovered(button) then
        Ui:setColor(Colors.lightGray)
        love.graphics.rectangle('fill', x, y, button.w, button.h, 6)
        Ui:setColor(Colors.white)
    end

    love.graphics.rectangle('line', x, y, button.w, button.h, 6)
    love.graphics.print(button.text, x + 10, y + 10)
end

return LootDialog
