/*
//=========================================\\
||    _______        __ _            __    ||
||   / /_   _|      / _| |           \ \   ||
||  / /  | |  _ __ | |_| |_   ___  __ \ \  ||
|| < <   | | | '_ \|  _| | | | \ \/ /  > > ||
||  \ \ _| |_| | | | | | | |_| |>  <  / /  ||
||   \_\_____|_| |_|_| |_|\__,_/_/\_\/_/   ||
|| 	     ____             __ _       	   ||
||	   / ____|           / _(_)      	   ||
||	  | |     ___  _ __ | |_ _  __ _ 	   ||
||	  | |    / _ \| '_ \|  _| |/ _` |	   ||
||	  | |___| (_) | | | | | | | (_| |	   ||
||	   \_____\___/|_| |_|_| |_|\__, |	   ||
||	                            __/ |	   ||
||	                           |___/	   ||
\\=========================================//
*/

-- *Don't touch these lines of code* 
influxtabconfig = influxtabconfig or {}
local cfg = influxtabconfig

-- Config start.

cfg.UseJobColor = false -- Replaces cfg.MainTabColor
cfg.ShowRankToAll = false 

-- Tab Color Customization
cfg.MainTabColor = Color( 25, 25, 25, 175 ) -- Base color of the scoreboard.

cfg.StaffRanks = {
	"owner",
	"superadmin",
	"admin"
}

-- Simple Input Panel for information
cfg.Input = function( text, func )

	configinput = vgui.Create("DFrame")
		configinput:SetSize( 250, 100 )
		configinput:Center()
		configinput:SetTitle("")
		configinput:ShowCloseButton(true)
		configinput:SetDraggable(true)
		configinput:MakePopup()
		configinput.Paint = function( self, w, h )
			influx.RoundedBox( 2, 0, 0, w, h, cfg.GetColor() )
			influx.Text( text, InfluxTabGetFont("CardInfo"), w/2, 25, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end

	configinput_text = vgui.Create( "DTextEntry", configinput )
		configinput_text:SetSize( 210, 25 )
		configinput_text:SetPos( 20, 60 )

	configinput_text.OnEnter = function( self )
		configinput:Close()
		func( self:GetValue() )
	end
end

-- Customize Player Card commands with this template
--[[

	{
		Name = "DisplayName",
		Func = function( ply )
			-- Commands function
		end,
		Privilage = false -- Privilage Boolean, If set to true only staff can use this function
	}

]]

-- Commands table to add commands
cfg.Commands = {
	{
		Name = "Copy SteamID",
		Func = function( ply )
			SetClipboardText( ply:SteamID() )
			chat.AddText( Color( 255, 255, 25 ), "Copied to clipboard" )
		end,
		Privilage = false
	},
	{
		Name = "View Profile",
		Func = function( ply )
			ply:ShowProfile()
		end,
		Privilage = false
	},
	{
		Name = "Copy Money",
		Func = function( ply )
			SetClipboardText( ply:getDarkRPVar("money") )
			chat.AddText( Color( 255, 255, 25 ), "Copied to clipboard" )
		end,
		Privilage = true
	},
	{
		Name = "Kick",
		Func = function( ply )
			cfg.Input( "Kick Reason", function(reason)
				RunConsoleCommand( "ULX", "Kick", ply:Nick(), reason )
			end )
		end,
		Privilage = true
	},
	{
		Name = "Ban",
		Func = function( ply )
			cfg.Input( "Ban Time (Seconds)", function(time)
				cfg.Input( "Ban Reason", function(reason)
					RunConsoleCommand( "ULX", "Ban", ply:Nick(), time, reason )
				end )
			end )
		end,
		Privilage = true
	},
	{
		Name = "Freeze",
		Func = function( ply )
			RunConsoleCommand( "ULX", "freeze", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Unfreeze",
		Func = function( ply )
			RunConsoleCommand( "ULX", "unfreeze", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Strip",
		Func = function( ply )
			RunConsoleCommand( "ULX", "strip", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Cloak",
		Func = function( ply )
			RunConsoleCommand( "ULX", "cloak", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Uncloak",
		Func = function( ply )
			RunConsoleCommand( "ULX", "uncloak", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Jail",
		Func = function( ply )
			RunConsoleCommand( "ULX", "jail", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Unjail",
		Func = function( ply )
			RunConsoleCommand( "ULX", "unjail", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "God",
		Func = function( ply )
			RunConsoleCommand( "ULX", "god", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Ungod",
		Func = function( ply )
			RunConsoleCommand( "ULX", "ungod", ply:Nick() )
		end,
		Privilage = true
	},
	{
		Name = "Unarrest",
		Func = function( ply )
			RunConsoleCommand( "darkrp", "unarrest", ply:Nick() )
		end,
		Privilage = true
	}
}