local function CreateReplConVar(cvarname, cvarvalue, description, ...)
	return CreateConVar(cvarname, cvarvalue, CLIENT and {FCVAR_REPLICATED} or {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, description, ...)
end -- replicated only on clients, archive/notify on server

if GetConVar("ph_use_custom_plmodel_for_prop") == nil then
	CreateReplConVar("ph_use_custom_plmodel_for_prop", "0", "Should use a custom playermodel for props when the round begins?")
end

if GetConVar("ph_use_custom_plmodel") == nil then
	CreateReplConVar("ph_use_custom_plmodel", "0", "Make custom player model available for hunters?")
end

if GetConVar("ph_use_playermodeltype") == nil then
	CreateReplConVar("ph_use_playermodeltype", "0", "Which model list that should deliver from? 0 = All Playermodels availale, 1 = Use Legacy method: list.Get('PlayerOptionsModel') (Recommended if you want to custom your model list)")
end

if GetConVar("ph_prop_camera_collisions") == nil then
	CreateReplConVar("ph_prop_camera_collisions", "0", "Attempts to stop props from viewing inside walls.")
end

if GetConVar("ph_freezecam") == nil then
	CreateReplConVar("ph_freezecam", "1", "Enable freeze camera.")
end

if GetConVar("ph_prop_collision") == nil then
	CreateReplConVar("ph_prop_collision", "0", "Should props collide with each other?")
end

if GetConVar("ph_customtaunts_delay") == nil then
	CreateReplConVar("ph_customtaunts_delay", "6", "Delay (in secondes) for props to play custom taunt again.")
end

if GetConVar("ph_enable_custom_taunts") == nil then
	CreateReplConVar("ph_enable_custom_taunts", "1", "Enable custom taunts for prop teams by pressing C?\n  You must have a list of custom taunts to enable this.")
end

if GetConVar("ph_normal_taunt_delay") == nil then
	CreateReplConVar("ph_normal_taunt_delay", "2", "How many in seconds delay for props to play normal [F3] taunt again?")
end

if GetConVar("ph_prop_jumppower") == nil then
	CreateReplConVar("ph_prop_jumppower", "1.4", "Multipliers for Prop Jump Power (Do not confused with Prop's Gravity!). Min. 1.")
end

if GetConVar("ph_notice_prop_rotation") == nil then
	CreateReplConVar("ph_notice_prop_rotation", "1", "Enable Prop Rotation notification on every time Prop Spawns.")
end

if GetConVar("ph_enable_lucky_balls") == nil then
	CreateReplConVar("ph_enable_lucky_balls", "1", "Spawn lucky balls when props break?")
end

if GetConVar("ph_enable_devil_balls") == nil then
	CreateReplConVar("ph_enable_devil_balls", "1", "Spawn devil balls when hunters die?")
end

if GetConVar("ph_enable_plnames") == nil then
	CreateReplConVar("ph_enable_plnames", "0", "Serverside control for if a clients see client\'s team player names through walls.")
end

if GetConVar("ph_hunter_fire_penalty") == nil then
	CreateReplConVar("ph_hunter_fire_penalty", "5", "Health points removed from hunters when they shoot.")
end

if GetConVar("ph_hunter_kill_bonus") == nil then
	CreateReplConVar("ph_hunter_kill_bonus", "100", "How much health to give back to the Hunter after killing a prop.")
end

if GetConVar("ph_hunter_smg_grenades") == nil then
	CreateReplConVar("ph_hunter_smg_grenades", "1", "How many grenades do hunters get. Zero means none.")
end

if GetConVar("ph_swap_teams_every_round") == nil then
	CreateReplConVar("ph_swap_teams_every_round", "1", "Should teams swapped on every round?")
end

if GetConVar("ph_game_time") == nil then
	CreateReplConVar("ph_game_time", "30", "Maximum Time Left (in minutes) - Default is 30 minutes.")
end

if GetConVar("ph_hunter_blindlock_time") == nil then
	CreateReplConVar("ph_hunter_blindlock_time", "30", "How long hunters are blinded (in seconds)")
end

if GetConVar("ph_round_time") == nil then
	CreateReplConVar("ph_round_time", "300", "Time (in seconds) for each rounds.")
end

if GetConVar("ph_rounds_per_map") == nil then
	CreateReplConVar("ph_rounds_per_map", "10", "Numbers played on a map (Default: 10)")
end

if GetConVar("ph_waitforplayers") == nil then
	CreateReplConVar("ph_waitforplayers", "1", "Should we wait for players for proper round?")
end

if GetConVar("ph_min_waitforplayers") == nil then
	CreateReplConVar("ph_min_waitforplayers", "1", "Numbers of mininum players that we should wait for round start. Value must not contain less than 1.")
end

-- Verbose mode & Function
local verbose = CreateConVar("ph_print_verbose", "0", { FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Developer Verbose. Some printed messages will only appear if this is enabled.")
function printVerbose(text)
	if GetConVar("ph_print_verbose"):GetBool() and text then
		print(tostring(text))
	end
end

if GetConVar("ph_min_waitforplayers") == nil then
	CreateReplConVar("ph_autotaunt_delay", "45", "The delay for the auto taunt")
end

if GetConVar("ph_min_waitforplayers") == nil then
	CreateReplConVar("ph_autotaunt_enabled", "1", "Should auto taunting be enabled")
end

if GetConVar("ph_sv_enable_obb_modifier") == nil then
	CreateConVar("ph_sv_enable_obb_modifier", "1", "Developer: Enable OBB Model Data Modifier")
end

if GetConVar("ph_reload_obb_setting_everyround") == nil then
	CreateConVar("ph_reload_obb_setting_everyround", "1", "Developer: Reload OBB Model Data Modifier Every round Restarts")
end

if GetConVar("phe_check_props_boundaries") == nil then
	CreateReplConVar("phe_check_props_boundaries", "0", "[EXPERIMENTAL] Enable prop boundaries Check? This will prevent you to stuck with other objects/Wall.")
end

if GetConVar("ph_language") == nil then
	CreateReplConVar("ph_language", "en", "Language of the server, requires map change.")
end

if GetConVar("ph_allow_prop_pickup") == nil then
	CreateReplConVar("ph_allow_prop_pickup", "1", "Allow players to pick up small props")
end

local ph_forcejoinbalancedteams = GetConVar("ph_forcejoinbalancedteams")
if ph_forcejoinbalancedteams == nil then
	ph_forcejoinbalancedteams = CreateReplConVar("ph_forcejoinbalancedteams", "1", "Force players to even out teams upon joining")
end

GM.ForceJoinBalancedTeams = ph_forcejoinbalancedteams:GetBool()

cvars.AddChangeCallback("ph_forcejoinbalancedteams", function()
	GAMEMODE.ForceJoinBalancedTeams = GetConVar("ph_forcejoinbalancedteams"):GetBool()
end)

local ph_autoteambalance = GetConVar("ph_autoteambalance")
if ph_autoteambalance == nil then
	ph_autoteambalance = CreateReplConVar("ph_autoteambalance", "1", "Automatically even out teams at the start of a round")
end

GM.AutomaticTeamBalance = ph_autoteambalance:GetBool()

cvars.AddChangeCallback("ph_autoteambalance", function()
	GAMEMODE.AutomaticTeamBalance = GetConVar("ph_autoteambalance"):GetBool()
end)