-- Loading Tab Menu
local modules = file.Find( "influxtab/*.lua", "LUA" )
influxtab = influxtab or {}
influxtabconfig = influxtabconfig or {}
local cfg = influxtabconfig
	-- Loading Modules
	if SERVER then
		for _, svfile in ipairs( modules ) do
			AddCSLuaFile( "influxtab/" .. svfile )
		end
	end

	if CLIENT then
		for _, clfile in ipairs( modules ) do
			include( "influxtab/" .. clfile )
		end
	end
	-- End of module loading

	-- Loading Config
	if SERVER then
		AddCSLuaFile( "influxtabconfig.lua" )
	end

	if CLIENT then
		include( "influxtabconfig.lua" )
	end
	-- End of config loading

-- End of loading

-- Resource Start

resource.AddFile( "resource/fonts/GeosansLight.ttf" )
resource.AddFile( "resource/fonts/SeganLight.ttf" )

-- Resource End

-- Tab Menu Functions
if CLIENT then
	timer.Simple( 1.5, function()

		surface.CreateFont( "InfluxTitleDisplay", {
			font = "Segan",
			size = 45,
			weight = 50,
			antialias = true
		} )
		surface.CreateFont( "InfluxTitle2Display", {
			font = "Segan",
			size = 25,
			weight = 50,
			antialias = true
		} )
		surface.CreateFont( "Geosans", {
			font = "Geosanslight",
			size = 25,
			weight = 50,
			antialias = true
		} )
		hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
		hook.Remove("ScoreboardShow", "FAdmin_scoreboard")

		GAMEMODE.ScoreboardShow = function()
			InfluxShowScore()
		end
		GAMEMODE.ScoreboardHide = function()
			InfluxHideScore()
		end

		function InfluxTabThink()
			if InfluxApiLoaded == true then
				InfluxAPIFailed = false
				localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
			else
				InfluxAPIFailed = true
			end
		end
		hook.Add( "Think", "InfluxTabThink", InfluxTabThink )

		function InfluxTabGetFont(font)
			fontlist = {
				Title = "InfluxTitleDisplay",
				ServerInfo = "InfluxTitle2Display",
				CardInfo = "Geosans"
			}

			for k, v in pairs( fontlist ) do
				if k == font then
					return v
				end
			end
		end

		function InfluxTabUppercase(text)
		    return (text:gsub("^%l", string.upper))
		end

		function cfg.GetColor()
			if cfg.UseJobColor then
				return team.GetColor( LocalPlayer():Team() )
			else
				return cfg.MainTabColor
			end
		end
	end)
end
-- End of Functions

InfluxTabLoaded = true

if CLIENT then
	timer.Simple( 7, function()
		if InfluxAPIFailed then
			chat.AddText( Color( 255, 25, 25 ), "[WARNING]", Color( 255, 255, 255 ), ": Influx API not present!" )
		end
	end )
end