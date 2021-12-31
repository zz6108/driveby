--[[
--
-- Accept hand of fate quest & hand in the quest with lightning speed!
--
--
-- Best regards,
-- Perjantai / Tiistai @ In-game
-- zz#6108
--]]
--
--
--
--
local driveby = {}

--
gossipData = {
	{ title="Hidden Cache" },
	{ title="Beast Nest" },
	{ title="Void Forge" },
	{ title="Volcanic Forge" },
	{ title="Jurassic Forge"},
--	{ title="Outlaw's Contract Board" } -- for debugging purposes..
}


--



function driveby:GOSSIP_SHOW(...)
	misc:debug("GOSSIP_SHOW fired")
	if misc:interactingWithCache() and misc:enabled() then
		local available = misc:gossipToTable({GetGossipAvailableQuests()})
		local active = misc:gossipToTable({GetGossipActiveQuests()})

	
		for i=0, 1 do 
			local destroy = nil

			if i > 0 then
				destroy = true

			end
			misc:debug("destroy toggle: %s", tostring(destroy))
			local availableToComplete = misc:getGossipValidQuest(available, destroy)
			if availableToComplete ~= nil then
				-- pick quest & complete
				local questIndex = misc:getQuestIndex(available, availableToComplete["quest"])
					if questIndex ~= nil then
						misc:chat("Doing quest %s, will consume %dx%s", availableToComplete["quest"],availableToComplete["count"], misc:getItemLink(availableToComplete["item"]))
						misc:consume(availableToComplete)
						SelectGossipAvailableQuest(questIndex[1])
						return;
					end
			else
				local activeToComplete = misc:getGossipValidQuest(active, destroy)
				if activeToComplete ~= nil then
					--pick quest & complete

					local questIndex = misc:getQuestIndex(active, activeToComplete["quest"])
					if questIndex ~= nil then
						misc:consume(activeToComplete)
						SelectGossipActiveQuest(questIndex[1])
						return;
					end
				end
			end
		end
		

	elseif misc:interactingWithCache() and misc:enabled() == false then
		misc:chat("pssst, enable driveby is currently %s, enable with '/driveby enable' for lightning speed cache busting!", misc:getStateHumanReadable())
	end
end


function driveby:QUEST_DETAIL(...)
	misc:debug("QUEST_DETAIL fired")
	if misc:interactingWithCache() and misc:enabled() then
		AcceptQuest()
	end
end

function driveby:QUEST_COMPLETE(...)
	misc:debug("QUEST_COMPLETE fired")
	if misc:interactingWithCache() and misc:enabled() then
		GetQuestReward()
		
	end
end


function driveby:QUEST_PROGRESS(...)
	misc:debug("QUEST_PROGRESS fired")
	if misc:interactingWithCache() and misc:enabled() then
		CompleteQuest()
	end
end

function driveby:PLAYER_LOGIN(...)
	misc:debug("PLAYER_LOGIN fired")
	if drivebyDebug == nil then
		drivebyDebug = false
	end

	if drivebyEnabled == nil then
		drivebyEnabled = true
	end


	cmd:help()
end


function driveby:ADDON_LOADED(...)
	misc:debug("ADDON_LOADED fired")
end

local drivebyFrame = CreateFrame("Frame")

drivebyFrame:SetScript(
	"OnEvent",
	function(self, event, ...)
		driveby[event](self, ...)
	end
)

for k, v in pairs(driveby) do
	drivebyFrame:RegisterEvent(k)
	misc:debug("Listening events on %s", k)
end

SLASH_DRIVEBY1 = "/driveby"
SLASH_DRIVEBY2 = "/db"
SlashCmdList["DRIVEBY"] = function(msg)
	cmd:input(msg)
end
