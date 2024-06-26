DialogueDialog = Class {
    init = function(self, npcName, dialogue)
        self.npcName = npcName
        self.dialogue = dialogue
        self:updateOptions()
    end,
    x = 200,
    y = 100,
    w = 400,
    h = 300,
    text = '',
    choices = {},
    items = {},
    dialogue = {},
    npcName = ''
}

function DialogueDialog:updateOptions(selection)
    if (selection) then
        table.insert(self.choices, selection)
    end

    local current = self.dialogue
    for _, choice in ipairs(self.choices) do
        current = current.options[choice]
    end

    self.text = current.text

    self.options = current.options or {}
end

function DialogueDialog:atX(x)
    return x + self.x
end

function DialogueDialog:atY(y)
    return y + self.y
end

function DialogueDialog:keyPressed(key)
    local number = tonumber(key)
    local option = self.options[number]

    if (option ~= nil) then
        self:updateOptions(number)
    elseif key == 'space' and #self.options == 0 then
        self.choices = {}
        self:updateOptions()
    elseif key == 'escape' then
        self:close()
    end
end

function DialogueDialog:close()
    OpenDialog = nil
end

function DialogueDialog:mousePressed(x, y, button)
end

function DialogueDialog:draw()
    -- Border
    Ui:setColor(Colors.lightGray)
    love.graphics.rectangle('fill', self:atX(-4), self:atY(-4), self.w + 8, self.h + 8, 6, 6)
    love.graphics.setLineWidth(1)

    -- Background
    Ui:setColor(Colors.gray)
    love.graphics.rectangle('fill', self:atX(0), self:atY(0), self.w, self.h)

    -- Title
    Ui:setColor(Colors.white)
    Ui:setBoldFont(Ui.fontSize.l)
    love.graphics.print(self.npcName, self:atX(10), self:atY(10))

    Ui:setColor(Colors.white)
    Ui:setFont(Ui.fontSize.l)
    love.graphics.print(self.text, self:atX(10), self:atY(35))

    Ui:setColor(nil)

    -- Options

    Ui:setColor(Colors.white)
    Ui:setBoldFont(Ui.fontSize.l)

    for number, option in pairs(self.options) do
        self:drawOption(self:atX(10), self:atY(number * 20 + 50), number, "center", option)
    end

    if (#self.options == 0) then
        self:drawOption(self:atX(10), self:atY(165), "space", "center", { option = "Continue..." })
    end

    self:drawOption(self:atX(10), self:atY(265), "esc", "right", { option = "Close" })
end

function DialogueDialog:drawOption(x, y, label, align, option)
    love.graphics.printf("[ " .. label .. " ] - " .. option.option, x, y, 380, align)
end

return DialogueDialog
