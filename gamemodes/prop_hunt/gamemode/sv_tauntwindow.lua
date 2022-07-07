-- Validity check to prevent some sort of spam
local function IsDelayed(ply)
	local lastTauntTime = ply:GetNWFloat("LastTauntTime")
	local delayedTauntTime = lastTauntTime + GetConVar("ph_customtaunts_delay"):GetInt()
	return delayedTauntTime > CurTime()
end

net.Receive("CL2SV_PlayThisTaunt", function(len, ply)
	local snd = net.ReadString()
	local volume = net.ReadUInt(9)
	local pitch = net.ReadUInt(8)

	if IsValid(ply) and !IsDelayed(ply) then
		if file.Exists("sound/" .. snd, "GAME") then
			ply:EmitSound(snd, volume, pitch)
			ply:SetNWFloat("LastTauntTime", CurTime())
		else
			ply:ChatPrint("[PH: Enhanced] - Warning: That taunt you selected does not exists on server!")
		end
	else
		ply:ChatPrint("[PH: Enhanced] - Please wait in few seconds...!")
	end
end)
