--[[
The MIT License (MIT)
Copyright (c) 2016 Isaac Trimble-Pederson "cyanisaac", "ProjectB"
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
 
barColor = colors.white
-- Dependencies
function center(text, height, color)
    local x,y=term.getSize()
    if height ~= nil then
        term.setCursorPos((x-string.len(text))/2, height)
    else
        term.setCursorPos((x-string.len(text))/2, y/2)
    end
    if color ~= nil then
        term.setTextColor(color)
    end
    term.write(text)
end
 
-- Main code
local function drawTop(text)
    local oldTC = term.getTextColor()
    local oldBC = term.getBackgroundColor()
 
    term.setCursorPos(1,1)
    term.setBackgroundColor(barColor)
    term.setTextColor(colors.black)
    term.clearLine()
    center(text, 1, colors.black)
 
    term.setTextColor(oldTC)
    term.setBackgroundColor(oldBC)
end
 
local function drawBottom(text)
    local w,h = term.getSize()
    local oldTC = term.getTextColor()
    local oldBC = term.getBackgroundColor()
 
    term.setCursorPos(1,h)
    term.setBackgroundColor(barColor)
    term.setTextColor(colors.black)
    term.clearLine()
    center(text, h, colors.black)
 
    term.setTextColor(oldTC)
    term.setBackgroundColor(oldBC)
end
 
local function renderOptions(options, selectedOption)
    local w,h = term.getSize()
    if #options > h-2 then
        error("Too many options to display. Page support will come in the future.")
    end
 
    for i=1, #options do
        local oBG = term.getBackgroundColor()
        local oTC = term.getTextColor()
 
        term.setCursorPos(1,i+2)
        if selectedOption == i then
            term.setBackgroundColor(colors.gray)
        else
            term.setBackgroundColor(colors.black)
        end
        term.clearLine()
        center(options[i], i+2, colors.white)
 
        term.setBackgroundColor(oBG)
        term.setTextColor(oTC)
    end
end
 
function doMenu(topText, options)
    local w,h = term.getSize()
    local selectedOption = 1
    local function render(sOption)
        term.clear()
        term.setCursorPos(1,1)
        drawTop(topText)
        renderOptions(options, sOption)
    end
    local function changeSelectedOption(a)
        if selectedOption+a > 0 and selectedOption+a < #options+1 then
            selectedOption = selectedOption+a
        end
        render(selectedOption)
    end
 
    local oldBG = term.getBackgroundColor()
    local oldTX = term.getTextColor()
 
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
 
    render(selectedOption)
 
    while true do
        local event, param1, param2, param3 = os.pullEvent()
        if event == "key" then
            if param1 == keys.enter then
                break
            elseif param1 == keys.up then
                changeSelectedOption(-1)
            elseif param1 == keys.down then
                changeSelectedOption(1)
            end
        end
    end
    term.setBackgroundColor(oldBG)
    term.setTextColor(oldTX)
    term.clear()
    term.setCursorPos(1,1)
    return selectedOption
end
 
function doInfoScreen(title, info)
    local w,h = term.getSize()
    local oldBG = term.getBackgroundColor()
    local oldTX = term.getTextColor()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1,2)
    print(info)
    term.setCursorPos(1,1)
    drawTop(title)
    drawBottom("Press ENTER to return...")
    while true do
        local event, param1 = os.pullEvent()
        if event == "key" and param1 == keys.enter then
            break
        end
    end
    term.setBackgroundColor(oldBG)
    term.setTextColor(oldTX)
    term.clear()
    term.setCursorPos(1,1)
    return selectedOption
end
