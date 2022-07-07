-- Props will autotaunt at specified intervals (put this crap on the server because the old way was all on the client and that's silly)
local function TauntTimeLeft(ply)
	-- Always return 1 when the conditions are not met
	if !IsValid(ply) or !ply:Alive() or ply:Team() != TEAM_PROPS then 
		return 1 
	end

	local lastTauntTime = ply:GetNWFloat("LastTauntTime")
	local nextTauntTime = lastTauntTime + GetConVar("ph_autotaunt_delay"):GetInt()
	return nextTauntTime - CurTime()
end

local function AutoTauntThink()
	if GetConVar("ph_autotaunt_enabled"):GetBool() then
		local WHOLE_TAUNTS = PHE:GetAllTeamTaunt(TEAM_PROPS)
		for _, ply in ipairs(team.GetPlayers(TEAM_PROPS)) do
			local timeLeft = TauntTimeLeft(ply)

			if IsValid(ply) and ply:Alive() and ply:Team() == TEAM_PROPS and timeLeft <= 0 then
				local rand_taunt = tostring(table.Random(WHOLE_TAUNTS))
				ply:EmitSound(rand_taunt, 100, math.Rand(75, 135))
				ply:SetNWFloat("LastTauntTime", CurTime())
			end
		end
	end
end
timer.Create("AutoTauntThinkTimer", 1, 0, AutoTauntThink)
