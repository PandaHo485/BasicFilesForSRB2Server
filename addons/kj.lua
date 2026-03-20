local lastJoiner = nil

addHook("PlayerJoin", function(n)
	lastJoiner = n
end)

local function kickLastJoiner(p, ...)
	if lastJoiner == nil return end

	local reason = ""
	for i, word in pairs({...})
		if i ~= 1
			reason = $1.." "..word
		else
			reason = $1..word
		end
	end
	if reason == "" reason = "please rejoin" end

	COM_BufInsertText(p, "kick "..lastJoiner.." "..reason)
end

COM_AddCommand("kickjoiner", kickLastJoiner, 1)
COM_AddCommand("kj", kickLastJoiner, 1)