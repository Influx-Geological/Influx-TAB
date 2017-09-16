-- influx Tab
influxtabconfig = influxtabconfig or {}
local InfluxCardInfo = InfluxCardInfo or {}
local cfg = influxtabconfig
local InfluxInfoCount = 0
local InfluxCardInfo = localplayer
local InfluxPlayerCard_Opened = false
local InfluxTabCurrentRank = localplayer:GetUserGroup()

function InfluxAddCardInfo(ply, func, number, color)
	InfluxInfoCount = number
	local TextFunc = func or "ERROR"
	surface.SetFont( InfluxTabGetFont("CardInfo") )
	local TextW, TextH = surface.GetTextSize( TextFunc )
	influx.Text( func, InfluxTabGetFont("CardInfo"), 150, 35 + ( 25 * ( InfluxInfoCount - 1 ) ), Color( color.r, color.g, color.b, color.a ), TEXT_ALIGN_LEFT )
end

if !InfluxAPIFailed then
	function DrawInfluxTab()
		InfluxCardInfo = localplayer
		local InfluxCommandprevsize = 0
		local InfluxCommandprevpos = 0
		local InfluxCommandrow = 0

		InfluxTab_scoreboard = vgui.Create("DFrame")
			InfluxTab_scoreboard:SetSize( ScrW()/1.25, ScrH()/1.25 )
			InfluxTab_scoreboard:Center()
			InfluxTab_scoreboard:SetTitle("")
			InfluxTab_scoreboard:ShowCloseButton(false)
			InfluxTab_scoreboard:SetDraggable(false)
			InfluxTab_scoreboard.Paint = function( self, w, h )
				influx.RoundedBox( 5, 0, 0, w, h, cfg.GetColor() )
				influx.RoundedBox( 2, 0, ((ScrH()/1.25)/6), (ScrW()/1.25), (ScrH()/1.25 - (ScrH()/1.25)/6), Color( 45, 45, 45, 225 ) )
					if InfluxPlayerCard_Opened then
						influx.Text( "Nickname", InfluxTabGetFont("CardInfo"), 10 + 12, (h/6) - 20, Color( 255, 255, 255, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						influx.Text( "Job", InfluxTabGetFont("CardInfo"), 5 + w/2 - 60, (h/6) - 20, Color( 255, 255, 255, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						influx.Text( "Ping", InfluxTabGetFont("CardInfo"), 10 + w/2 - 40, (h/6) - 20, Color( 255, 255, 25, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						influx.Text( "Nickname", InfluxTabGetFont("CardInfo"), 10 + 12, (h/6) - 20, Color( 255, 255, 255, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						influx.Text( "Job", InfluxTabGetFont("CardInfo"), 5 + w - 60, (h/6) - 20, Color( 255, 255, 255, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						influx.Text( "Ping", InfluxTabGetFont("CardInfo"), 10 + w - 40, (h/6) - 20, Color( 255, 255, 25, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
					end
				influx.Text( GetHostName(), InfluxTabGetFont("Title"), 10, 10, Color( 255, 255, 255, 255 ) )
				influx.Text( gmod.GetGamemode().Name.." | Players: "..#player.GetAll().."/"..game.MaxPlayers(), InfluxTabGetFont("ServerInfo"), 25, 55, Color( 255, 255, 255, 255 ) )
			end
			InfluxTab_scoreboard:Show()
			InfluxTab_scoreboard:MakePopup()

		local InfluxTab_playercard = vgui.Create( "DPanel", InfluxTab_scoreboard )
			InfluxTab_playercard:SetSize( (ScrW()/1.25)/2, (ScrH()/1.25 - (ScrH()/1.25)/6) )
			InfluxTab_playercard:SetPos( (ScrW()/1.25)/2, ((ScrH()/1.25)/6) )
			InfluxTab_playercard:SetVisible( false )


		local InfluxTab_playercard_close = vgui.Create( "DButton", InfluxTab_playercard )
			InfluxTab_playercard_close:SetSize( ((ScrW()/1.25)/2)/8, 45 )
			InfluxTab_playercard_close:SetPos( (((ScrW()/1.25)/2)/2) - (((ScrW()/1.25)/2)/8)/2, (ScrH()/1.25 - (ScrH()/1.25)/6) - 55 )
			InfluxTab_playercard_close:SetText( "" )

		InfluxTab_playercard_close.Paint = function(self, w, h )
			if InfluxTab_playercard_close:IsHovered() then
				influx.RoundedBox( 2, 0, 0, w, h, Color( 75, 75, 75, 255 ) )
			else
				influx.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50, 255 ) )
			end
			influx.Text( "Close", InfluxTabGetFont(CardInfo), w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		InfluxTab_playercard_close.DoClick = function()
			InfluxPlayerCard_Close()
			InfluxTab_scoreboard.Update()
		end

		local InfluxTab_avatar = vgui.Create( "AvatarImage", InfluxTab_playercard )
			InfluxTab_avatar:SetSize( 126, 126 )
			InfluxTab_avatar:SetPos( 17, 32 )

		InfluxTab_avatar.Update = function()
			InfluxTab_avatar:SetPlayer( InfluxCardInfo, 126 )
		end

		local InfluxTab_commands = vgui.Create( "DPanel", InfluxTab_playercard )
			InfluxTab_commands:SetSize( ((ScrW()/1.25)/2) - 10, (ScrH()/1.25 - (ScrH()/1.25)/6)/4 )
			InfluxTab_commands:SetPos( 5, 175 )

		InfluxTab_commands.Paint = function(self, w, h)
			influx.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50, 255 ) )
		end

		for o, m in pairs(cfg.Commands) do
			local function Influx_DrawNewCommand()
				local font = InfluxTabGetFont("CardInfo")
				surface.SetFont( font )
				local namew, _ = surface.GetTextSize( m.Name )
				local sizew = namew + 10

				local prevsize = InfluxCommandprevsize
				local prevpos = InfluxCommandprevpos

				local posx = (5 + (prevsize + prevpos))
				local posy = (5 + ( 35 * InfluxCommandrow ))

				if (posx + sizew) >= (((ScrW()/1.25)/2) - 10) then
					InfluxCommandrow = InfluxCommandrow + 1
					posx = (5)
					posy = (5 + ( 35 * InfluxCommandrow ))
				end

				if (posy + 30) >= (ScrH()/1.25 - (ScrH()/1.25)/6)/4 then return end

				local InfluxTab_commandbutton = vgui.Create( "DButton", InfluxTab_commands )
					InfluxTab_commandbutton:SetText( "" )
					InfluxTab_commandbutton:SetSize(sizew, 30 )
					InfluxTab_commandbutton:SetPos( posx, posy )

				InfluxTab_commandbutton.Paint = function(self, w, h)
					if InfluxTab_commandbutton:IsHovered() then
						influx.RoundedBox( 2, 0, 0, w, h, Color(100, 100, 100, 255) )
					else
						influx.RoundedBox( 2, 0, 0, w, h, Color(75, 75, 75, 255) )
					end
					influx.Text( m.Name, font, w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end


				InfluxTab_commandbutton.DoClick = function()
					m.Func(InfluxCardInfo)
				end
				InfluxCommandprevsize = sizew
				InfluxCommandprevpos = posx
			end

			if m.Privilage then
				if table.HasValue( cfg.StaffRanks, localplayer:GetUserGroup() ) then
					Influx_DrawNewCommand()
				else
					o = o - 1
				end
			else
				Influx_DrawNewCommand()
			end
		end

		function InfluxPlayerCard_Open()
			InfluxTab_playercard:SetVisible( true )
			InfluxPlayerCard_Opened = true
		end

		function InfluxPlayerCard_Close()
			InfluxTab_playercard:SetVisible( false )
			InfluxPlayerCard_Opened = false
			InfluxCardInfo = localplayer
		end

		local InfluxTab_playerlist = vgui.Create( "DScrollPanel", InfluxTab_scoreboard )
			InfluxTab_playerlist:SetSize( (ScrW()/1.25), (ScrH()/1.25 - (ScrH()/1.25)/6) - 5 )
			InfluxTab_playerlist:SetPos( 0, ((ScrH()/1.25)/6) )
			InfluxTab_playerlist.Paint = function( self, w, h)
				-- Paint Function
			end

			InfluxTab_playerlist.VBar.Paint = function(self, w, h)
				influx.RoundedBox( 2, 0, 0, w, h, Color( 25, 25, 25, 175 ) )
			end
			InfluxTab_playerlist.VBar.btnGrip.Paint = function(self, w, h)
				if InfluxTab_playerlist.VBar.btnGrip:IsHovered() then
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 200 ) )
				else
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 175 ) )
				end
			end
			InfluxTab_playerlist.VBar.btnUp.Paint = function(self, w, h)
				if InfluxTab_playerlist.VBar.btnUp:IsHovered() then
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 125 ) )
				else
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 100 ) )
				end
			end
			InfluxTab_playerlist.VBar.btnDown.Paint = function(self, w, h)
				if InfluxTab_playerlist.VBar.btnDown:IsHovered() then
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 125 ) )
				else
					influx.RoundedBox( 2, 0, 0, w, h, Color( 100, 100, 100, 100 ) )
				end
			end

		InfluxTab_scoreboard.Update = function()
			InfluxTab_playerlist:Clear()

			if not table.HasValue( player.GetAll(), InfluxCardInfo ) then
				InfluxCardInfo = localplayer
				if InfluxPlayerCard_Opened then
					InfluxPlayerCard_Close()
				end
			end

			if InfluxPlayerCard_Opened != false then
				InfluxTab_playerlist:SetSize( (ScrW()/1.25)/2, (ScrH()/1.25 - (ScrH()/1.25)/6) - 5 )
			else
				InfluxTab_playerlist:SetSize( (ScrW()/1.25), (ScrH()/1.25 - (ScrH()/1.25)/6) - 5 )
			end
			local a = 0
			for k, v in pairs(team.GetAllTeams()) do
				for i, j in pairs(team.GetPlayers(k)) do
					a = a + 1
					j.linenum = 0

					local InfluxTab_playerview = vgui.Create( "DButton", InfluxTab_playerlist )
						InfluxTab_playerview:SetText( "" )
						InfluxTab_playerview:SetSize(InfluxTab_playerlist:GetWide() - 20, 30 )
						InfluxTab_playerview:SetPos( 10, 10 + a * 37 - 37 )

					local clr = team.GetColor(k)

					InfluxTab_playerview.Paint = function( self, w, h )

						if InfluxTab_playerview:IsHovered() then
							if j:Alive() then
								influx.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50, 255 ) )
								influx.RoundedBox( 2, 0, 0, 5, h, Color( clr.r, clr.g, clr.b, 255 ) )
							else
								influx.RoundedBox( 2, 0, 0, w, h, Color( 50, 50, 50, 195 ) )
								influx.RoundedBox( 2, 0, 0, 5, h, Color( clr.r, clr.g, clr.b, 195 ) )				
							end
						else
							if j:Alive() then
								influx.RoundedBox( 2, 0, 0, w, h, Color( 25, 25, 25, 255 ) )
								influx.RoundedBox( 2, 0, 0, 5, h, Color( clr.r, clr.g, clr.b, 255 ) )
							else
								influx.RoundedBox( 2, 0, 0, w, h, Color( 25, 25, 25, 190 ) )
								influx.RoundedBox( 2, 0, 0, 5, h, Color( clr.r, clr.g, clr.b, 190 ) )				
							end
						end

						if j:GetFriendStatus() == "friend" or j == localplayer then
							if j.linenum == w then j.linenum = 0 end
							j.linenum = j.linenum + 1
							j.linenum2 = j.linenum - 1
							j.linenum3 = j.linenum - 2
							j.linenum4 = j.linenum - 3
							j.linenum5 = j.linenum - 4
							influx.RoundedBox( 1, 0 + j.linenum, 0, 1, h, Color( 255, 255, 255, 100 ) )
							influx.RoundedBox( 1, 0 + j.linenum2, 0, 1, h, Color( 255, 255, 255, 75 ) )
							influx.RoundedBox( 1, 0 + j.linenum3, 0, 1, h, Color( 255, 255, 255, 50 ) )
							influx.RoundedBox( 1, 0 + j.linenum4, 0, 1, h, Color( 255, 255, 255, 25 ) )
							influx.RoundedBox( 1, 0 + j.linenum5, 0, 1, h, Color( 255, 255, 255, 10 ) )
						end

						if not j:IsValid() then
							InfluxTab_scoreboard.Update()
							return
						end

						influx.Text( j:Nick(), InfluxTabGetFont("CardInfo"), 12, h - 15, Color( 255, 255, 255, 250 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						influx.Text( j:getDarkRPVar("job"), InfluxTabGetFont("CardInfo"), InfluxTab_playerlist:GetWide() - 60, h - 15, Color( 255, 255, 255, 250 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						influx.Text( j:Ping(), InfluxTabGetFont("CardInfo"), InfluxTab_playerlist:GetWide() - 40, h - 15, Color( 255, 255, 25, 250 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					InfluxTab_playerview.DoClick = function()
						if InfluxPlayerCard_Opened == true then
							if InfluxCardInfo != j then
								InfluxCardInfo = j
								InfluxPlayerCard_Open()
								InfluxTab_scoreboard.Update()
							else
								InfluxPlayerCard_Close()
								InfluxTab_scoreboard.Update()
							end
						else
							InfluxCardInfo = j
							InfluxPlayerCard_Open()
							InfluxTab_scoreboard.Update()
						end
					end
				end
			end
				local cardclr = team.GetColor(InfluxCardInfo:Team())
				InfluxTab_avatar.Update()
				InfluxTab_playercard.Paint = function( self, w, h)
				InfluxInfoCount = 0
				influx.RoundedBox( 2, 0, 0, w, h, Color( 25, 25, 25, 225 ) )
				influx.RoundedBox( 2, 5, 5, w - 10, 25, Color( cardclr.r, cardclr.g, cardclr.b, 255 ) )
				influx.RoundedBoxEx( 2, 15, 30, 130, 130, Color( cardclr.r, cardclr.g, cardclr.b, 255 ), false, false, true, true )
				influx.RoundedBoxEx( 2, 17, 32, 126, 126, Color( 25, 25, 25, 255 ) )

				InfluxAddCardInfo(InfluxCardInfo, "Name: "..InfluxCardInfo:Name(), InfluxInfoCount + 1, Color( 255, 255, 255 ) )
				InfluxAddCardInfo(InfluxCardInfo, "SteamID: "..InfluxCardInfo:SteamID(), InfluxInfoCount + 1, Color( 255, 255, 255 ), true )
				InfluxAddCardInfo(InfluxCardInfo, "Job: "..InfluxCardInfo:getDarkRPVar("job"), InfluxInfoCount + 1, Color( 255, 255, 255 ) )
				if cfg.ShowRankToAll then
					InfluxAddCardInfo(InfluxCardInfo, "Rank: "..InfluxTabUppercase(InfluxCardInfo:GetUserGroup()), InfluxInfoCount + 1, Color( 255, 255, 255 ) )
				else
					if table.HasValue( cfg.StaffRanks, localplayer:GetUserGroup() ) then
						InfluxAddCardInfo(InfluxCardInfo, "Rank: "..InfluxTabUppercase(InfluxCardInfo:GetUserGroup()), InfluxInfoCount + 1, Color( 255, 255, 255 ) )
						InfluxAddCardInfo(InfluxCardInfo, "Wallet: "..DarkRP.formatMoney(InfluxCardInfo:getDarkRPVar("money")), InfluxInfoCount + 1, Color( 255, 255, 255 ) )
					end
				end
			end
		end
	end

	function InfluxShowScore()
		if InfluxTab_scoreboard == nil then DrawInfluxTab() end
		if InfluxTabCurrentRank != localplayer:GetUserGroup() then
			InfluxTab_scoreboard:Close()
			InfluxTab_scoreboard = nil
			InfluxTabCurrentRank = localplayer:GetUserGroup()
			DrawInfluxTab()
			InfluxTab_scoreboard.Update()
		else
			InfluxTab_scoreboard.Update()
			InfluxTab_scoreboard:SetVisible(true)
		end
	end

	function InfluxHideScore()
		if InfluxTab_scoreboard != nil then InfluxTab_scoreboard:SetVisible(false) end
		InfluxPlayerCard_Close()
	end

	concommand.Add( "Influx_Tab_Close", function()
		if InfluxTab_scoreboard != nil then
			InfluxTab_scoreboard:Close()
			InfluxTab_scoreboard = nil
		end
	end )
end