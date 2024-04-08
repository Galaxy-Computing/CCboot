if ccboot then
    printError("This program does not run from the terminal")
    return
end
_G.ccboot = {}
_G.ccboot.bootcomplete = false
term.clearold = term.clear
function term.clear()
    term.clearold()
    term.setCursorPos(1,1)
end
term.clear()
os.pullEventOld = os.pullEvent
os.pullEvent = os.pullEventRaw
print("Loading CCboot")
if fs.exists("/boot/menu.lua") then
    menupresent = true
    os.loadAPI("/boot/menu.lua")
else
    menupresent = false
end
options = {"Default","CraftOS"}
bootinfo = {}
default = 2
if fs.exists("/boot/info") then
    for k,v in ipairs(fs.list("/boot/info")) do
        bootinfo[#bootinfo+1] = dofile("/boot/info/"..v)
    end
    for k,v in ipairs(bootinfo) do
        options[#options+1] = v[1]
    end
    default = 3
end
function ccboot.showbootmenu()
    selection = menu.doMenu("CCboot",options)
    if options[selection] == "Default" then
        selection = default
    end
    if options[selection] == "CraftOS" then
        os.pullEvent = os.pullEventOld
        term.setTextColor(colors.yellow)
        print(os.version())
        ccboot.bootcomplete = true
    else
        if fs.exists("/boot/"..bootinfo[selection-2][2]) then
            os.pullEvent = os.pullEventOld
            shell.run("/boot/"..bootinfo[selection-2][2])
        else
            print("File does not exist. Press ENTER to return to menu.")
            read(" ")
            ccboot.showbootmenu()
        end
    end
end
if menupresent then
    ccboot.showbootmenu()
else
    os.pullEvent = os.pullEventOld
    term.setTextColor(colors.yellow)
    print(os.version())
    ccboot.bootcomplete = true
end
if not ccboot.bootcomplete then
    print("Boot failed. Press ENTER to return to menu.")
    read(" ")
    ccboot.showbootmenu()
end
