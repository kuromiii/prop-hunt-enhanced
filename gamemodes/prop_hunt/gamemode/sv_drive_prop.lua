hook.Add("Move", "moveProp", function(ply,move)
	if IsValid(ply) && ply:Alive() && ply:Team() == TEAM_PROPS then
		local ent = ply.ph_prop
		if IsValid(ent) then
			-- Set position
			if (ent:GetModel() == "models/player/kleiner.mdl" || ent:GetModel() == player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel"))) then
				ent:SetPos(move:GetOrigin())
			else
				ent:SetPos(move:GetOrigin() - Vector(0, 0, ent:OBBMins().z))
			end

			-- Set angles
			if !ply:GetPlayerLockedRot() then
				local ang = move:GetAngles()
				ent:SetAngles(Angle(0, ang.y, 0))
			end
		end
	end
end)