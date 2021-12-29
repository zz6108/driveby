

misc = {}

gossipQuests = {
    ---- hidden cache
	{quest="Hidden Cache: Epic Gnomish Masterkey", item="Precision Gnomish Masterkey", count=1},
	{quest="Hidden Cache: Epic Homicite Key", item="Master Homicite Key", count=1},
	{quest="Hidden Cache: Rare Gnomish Masterkey", item="Practical Gnomish Masterkey", count=1},
	{quest="Hidden Cache: Rare Homicite Key", item="Exceptional Homicite Key", count=1},
	{quest="Hidden Cache: Uncommon Gnomish Masterkey", item="Potent Gnomish Masterkey", count=1},
	{quest="Hidden Cache: Uncommon Homicite Key", item="Solid Homicite Key", count=1},
    {quest="Smash the Chest", item=nil, count=0},
    ---- beast nest
    {quest="Place Tempting Bait", item="Tempting Bait", count=1},
    {quest="Place Irresistible Bait", item="Irresistible Bait", count=1},
    {quest="Place Alluring Bait", item="Alluring Bait", count=1},
    {quest="Destroy Nest", item=nil, count=0},
}

function misc:chat(format, ...)
	print(misc:sprintf("|cff00ff00driveby:|r %s", string.format(format, ...)))
end

function misc:sprintf(format, ...)
	return string.format(format, ...)
end

function misc:debug(format, ...)
	if (drivebyDebug ~= nil and drivebyDebug == true) then
		misc:chat("debug - %s", misc:sprintf(format, ...))
	end
end

function misc:consume(quest)
    if quest["item"] ~= nil then
        local itemlink = misc:getItemLink(quest["item"])
        if itemlink == nil then
            itemlink = misc:sprintf("[%s]", quest["item"])
        end
        misc:chat("Completing quest: '%s', will consume %dx %s", quest["quest"], quest["count"], itemlink)
    else
        misc:chat("Completing quest: '%s'!", quest["quest"])
    end
end

function misc:enabled()
    return drivebyEnabled
end

function misc:getStateHumanReadable()
	misc:debug("state: %s", tostring(drivebyEnabled))
	if (drivebyEnabled) then
		return "enabled"
	else
		return "disabled"
	end
end

function misc:interactingWithCache()
    local title = tostring(misc:getNpcTitle()):lower()
    for k, v in pairs(gossipData) do
        if title:lower() == v["title"]:lower() then
            return true
        end
    end 
    return false
end

function misc:gossipToTable(gossip)
	local available = {}
    for k, v in pairs(gossip) do
       -- misc:debug("gossip: %s %s", tostring(k), tostring(v))
		if k == 1 or ((k - 1) % 4 == 0) then
            table.insert(available, v)
            misc:debug("insert: %s", tostring(v))
		end
	end
	return available
end

function misc:getQuestByName(name)
    for k, v in ipairs(gossipQuests) do
        if v["quest"]:lower() == tostring(name):lower() then
            return v
        end
    end

    return nil
end

function misc:getNpcTitle()
	misc:debug("returning gossip text: %s", tostring(GossipFrameNpcNameText:GetText()))
	return GossipFrameNpcNameText:GetText()
end


function misc:isQuestName(quest)
	if string.find(GetTitleText(), quest) then
		return true
	else
		return false
	end
end

function misc:getQuestIndex(gossip, quest)
	for k, v in pairs(gossip) do
		if string.find(v, quest) then
			return {k, v}
		end
	end

	return nil --no quest id?
end

function misc:getItemCount(item)
   -- if item == "Practical Gnomish Masterkey" then return 2 end
    return GetItemCount(item, false, false)
end

function misc:getItemLink(item)
	_, link = GetItemInfo(item)
	return link;
end

function misc:hasQuestItem(quest, destroy)

	-- empty cache
    if quest["item"] == nil then
        if destroy ~= nil then
            return true
        else
            return false
        end
	end


	if misc:getItemCount(quest["item"]) >= quest["count"] then
		return true
	else
		return false
	end
end

function misc:getGossipValidQuest(gossip, destroy)
    for _, quest in pairs(gossip) do
        local quest = misc:getQuestByName(quest)
        if quest ~= nil and misc:hasQuestItem(quest, destroy) then
            misc:debug("doing quest: %s (%s), got quest item!", tostring(quest["quest"]), tostring(quest["item"]))
            return quest
        end
    end

    return nil
end


function misc:getValidQuest()
	for k, v in ipairs(gossipQuests) do
		if misc:hasQuestItem(v) then
			return v
		end
	end
	return nil
end
