-- Generic Sound Precache function
local ph_precache_phe_core = CreateConVar("ph_precache_phe_core", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Precache Prop Hunt: Enhanced core sounds during player initial spawn.")
local ph_precache_taunts = CreateConVar("ph_precache_taunts", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Precache Prop Hunt: Enhanced core taunts during player's initial spawn.")

hook.Add("PlayerInitialSpawn", "PHE.PrecacheSoundCore", function()
	local function PrecacheThis(path)
		if file.Exists(path, "GAME") then
			local wav = file.Find(path .. "*.wav", "GAME")
			local mp3 = file.Find(path .. "*.mp3", "GAME")
			local ogg = file.Find(path .. "*.ogg", "GAME")

			printVerbose("[PH:E] Precaching Sound Core...")
			for _, snd in pairs(wav) do util.PrecacheSound(snd) end
			for _, snd in pairs(mp3) do util.PrecacheSound(snd) end
			for _, snd in pairs(ogg) do util.PrecacheSound(snd) end
		end
	end

	if ph_precache_phe_core:GetBool() then
		PrecacheThis("gamemode/prop_hunt/content/sound/misc")
		PrecacheThis("gamemode/prop_hunt/content/sound/prop_idbs")
	end

	if ph_precache_taunts:GetBool() then
		timer.Simple(3, function()
			for _, ptaunts in pairs(PHE.PROP_TAUNTS) do util.PrecacheSound(ptaunts) end
			for _, htaunts in pairs(PHE.HUNTER_TAUNTS) do util.PrecacheSound(htaunts) end
		end)
	end
end)