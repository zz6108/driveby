
cmd = {}
local cmdCommands, cmdPatterns, cmdHelp = {}, {}, {}

function cmd:input(data)
	self.original = data
	self.cmd = data

	if cmd:call() == false then
        cmd:help()
        misc:debug("no cmd found, printing help")
	end
end

function cmd:patterns()
    local patterns = {}
    for k, v in pairs(cmdPatterns) do
        patterns[k] = cmdPatterns[k]()
        misc:debug("inserted pattern: patterns[%s] = %s", tostring(k), patterns[k])
    end

    return patterns
end

function cmd:help()
    for k, v in pairs(cmdHelp) do
        cmdHelp[k]()
    end
end

function cmd:call()
	local patterns = cmd:patterns()

	for command, v in pairs(patterns) do
		if (self.cmd:match(v)) then
			if (self.cmd:match("^%w*", 1) == command) then
				local callArgs = {}
				for str in self.cmd:gmatch("(%w+)") do
					table.insert(callArgs, str)
				end

				return cmdCommands[command](unpack(callArgs))
			end
		end
	end
	return false
end

function cmdCommands:state()
    misc:chat("driveby is currently: %s", misc:getStateHumanReadable())
    return true
end

function cmdPatterns:state()
    return "^%w-$"
end

function cmdHelp:state()
    return cmdCommands:state()
end

function cmdCommands:enable()
   drivebyEnabled = true
   misc:chat("Enabled!")
   return true;
end

function cmdPatterns:enable()
    return "^%w-$"
end

function cmdHelp:enable()
    misc:chat("/driveby enable")
    misc:chat("        Enables driveby")
end

function cmdCommands:disable()
    drivebyEnabled = false
    misc:chat("Disabled!")
    return true;
end

function cmdPatterns:disable()
    return "^%w-$"
end

function cmdHelp:disable()
    misc:chat("/driveby disable")
    misc:chat("        Disables driveby")
end


function cmdCommands:toggle()
    if drivebyEnabled then
        cmdCommands:disable()
    else
        cmdCommands:enable()
    end
    return true;
end

function cmdPatterns:toggle()
    return "^%w-$"
end

function cmdHelp:toggle()
    misc:chat("/driveby toggle")
    misc:chat("        enables/disables driveby")
end


function cmdCommands:debug()
    if drivebyDebug then
        drivebyDebug = false
        misc:chat("debug disabled.")
    else
        drivebyDebug = true
        misc:chat("debug enabled")
    end
    return true;
end

function cmdPatterns:debug()
    return "^%w-$"
end

function cmdHelp:debug()
    misc:chat("/driveby debug")
    misc:chat("        enables/disables debugging")
end