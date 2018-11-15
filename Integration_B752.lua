-- X-Aviation B757-200 lua integration script
-- re-written Sep 2018


if (PLANE_ICAO =="B752") then

--Field of view set for MD88
	FieldOfView = dataref_table("sim/graphics/view/field_of_view_deg")
	FieldOfView[0] = 75
	
	-- Joystick Assignments - Jets
	clear_all_axis_assignments()
	set_axis_assignment( 50, "pitch", "normal" )
	set_axis_assignment( 51, "roll", "normal" )
	set_axis_assignment( 75, "right toe brake", "normal" )
	set_axis_assignment( 76, "left toe brake", "normal" )
	set_axis_assignment( 77, "yaw", "normal" )

	clear_all_button_assignments()
	
	set_button_assignment( (0*40) + 5, "sim/flight_controls/landing_gear_up" )
	set_button_assignment( (0*40) + 6, "sim/flight_controls/landing_gear_down" )

	set_button_assignment( (8*40) + 19, "sim/general/rot_up" )
	set_button_assignment( (8*40) + 20, "sim/general/hat_switch_up_right" )
	set_button_assignment( (8*40) + 21, "sim/general/rot_right" )
	set_button_assignment( (8*40) + 22, "sim/general/hat_switch_down_right" )
	set_button_assignment( (8*40) + 23, "sim/general/rot_down" )
	set_button_assignment( (8*40) + 24, "sim/general/hat_switch_down_left" )
	set_button_assignment( (8*40) + 25, "sim/general/rot_left" )
	set_button_assignment( (8*40) + 26, "sim/general/hat_switch_up_left" )

	-- setting nullzone, sensitivity and augment
	set( "sim/joystick/joystick_pitch_nullzone",      0.000 )
	set( "sim/joystick/joystick_roll_nullzone",       0.000 )
	set( "sim/joystick/joystick_heading_nullzone",    0.000 )
	set( "sim/joystick/joystick_pitch_sensitivity",   0.605 )
	set( "sim/joystick/joystick_roll_sensitivity",    0.608 )
	set( "sim/joystick/joystick_heading_sensitivity", 0.634 )
	set( "sim/joystick/joystick_pitch_augment",       0.626 )
	set( "sim/joystick/joystick_roll_augment",        0.620 )
	set( "sim/joystick/joystick_heading_augment",     0.634 )
	
-- Sound stuff
	knob1 = load_WAV_file(AIRCRAFT_PATH .. "sounds/cockpit/knob-1.wav")
	knob2 = load_WAV_file(AIRCRAFT_PATH .. "sounds/cockpit/knob-2.wav")
	
	
	--COMMENTED OUT 10/2/2018
-- Start Override Throttle off
-- Turns off the override of the throttles
--	Override_Throttle = dataref_table("sim/operation/override/override_throttles")
--	function FxOverrideThrottles ()
--		if Override_Throttle[0] ~= 0 then
--			Override_Throttle[0] = 0
--		end
	--print(Override_Throttle[0])
--	end
--	do_often("FxOverrideThrottles()")
-- End Override Throttle off
--COMMENTED OUT 10/2/2018

--Start MouseHandler always on
--	MouseHandler = dataref_table("mh/mouse_handler_on_window")
--	function MouseHandlerOn()
--		if MouseHandler[0] == 0 then
--			MouseHandler[0] = 1
--		end
--	end
--	do_every_frame("MouseHandlerOn()")

-- Start MCP integration
	-- Start HDG Selector
		DataRef("MCP_HDG","sim/cockpit/autopilot/heading_mag","writeable")			-- Dataref that the MCP works with
		B752_HDG = dataref_table("757Avionics/ap/hdg_act")							-- Dataref that the B752 works with
		DataRef("B752_AP_HDG", "757Avionics/mcp/hdg/label", "readonly")				-- Flag of the AP HDG display status (?), 1 = vis, 0 = not
		DataRef("B752_THR_Lamp", "1-sim/AP/lamp/1","readonly")						-- THR Lamp status, 0 = off, 0.8 = on
		DataRef("B752_LNAV_Lamp", "1-sim/AP/lamp/3","readonly")						-- LNAV Lamp status, 0 = off, 0.8 = on
		DataRef("B752_SPD_Lamp", "1-sim/AP/lamp/2","readonly")						-- SPD Lamp status, 0 = off, 0.8 = on
		DataRef("B752_HDG_Button","1-sim/AP/hdgConfButton","readonly")				-- HDG push button, 0 = , 1 = SEL
		DataRef("B752_HDG_Hold","1-sim/AP/hdgHoldButton","readonly")				-- HDG hold button, 0 = off, 1 = on
		
		-- On start, make the MCP = B752 HDG selector
		if MCP_HDG ~= B752_HDG[0] then
			-- equalizing MCP to B752. Runs only once, on startup
			MCP_HDG = B752_HDG[0]
		else
			-- nothing to do
		end
		
		-- set the prev hdg var and values
		MCP_prev_HDG = MCP_HDG
		B752_prev_HDG = B752_HDG[0]

		-- -- First function. HDG change by MCP to the B752
		-- function HDG_mod_MCP()
			-- --print("MCP: " .. MCP_HDG .. ", MCP_prev: " .. MCP_prev_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", B752_Prev: " .. B752_prev_HDG)
			-- -- checks if the MCP hdg has changed and if so updates the B752 HDG accordingly
			-- if MCP_HDG ~= MCP_prev_HDG then
				-- -- MCP change detected, update the B752
				-- B752_HDG[0] = MCP_HDG
				-- B752_prev_HDG = MCP_HDG
				-- MCP_prev_HDG = MCP_HDG
				-- play_sound(knob2)
				-- print("click by HDG")
			-- else
				-- -- no change, nothing to do
			-- end
		-- end
		-- do_every_draw("HDG_mod_MCP()")

		-- First function. HDG change by MCP to the B752 - ORIGINAL
		-- function HDG_mod_MCP()
			-- --print("MCP: " .. MCP_HDG .. ", MCP_prev: " .. MCP_prev_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", B752_Prev: " .. B752_prev_HDG)
-- --			-- checks if the MCP HDG has changed and if so updates the B752 HDG accordingly
			-- if MCP_HDG ~= MCP_prev_HDG then
-- --				-- MCP change detected, going down, up?, update the B752
				-- if MCP_HDG < MCP_prev_HDG then
					-- command_once("1-sim/comm/AP/hdgDN")
				-- elseif MCP_HDG > MCP_prev_HDG then
					-- command_once("1-sim/comm/AP/hdgUP")
				-- end
				-- MCP_prev_HDG = MCP_HDG	
				-- --play_sound(knob2)
				-- --print("click by HDG" .. "MCP_HDG: " .. MCP_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", MCP_prev_HDG: " .. MCP_prev_HDG .. ", B752_prev_HDG: " .. B752_prev_HDG )
			
			-- else
-- --				-- no change, nothing to do
			-- end
		-- end
		-- do_every_frame("HDG_mod_MCP()")
		
		-- First function. HDG change by MCP to the B752
		function HDG_mod_MCP()
			--print("MCP: " .. MCP_HDG .. ", MCP_prev: " .. MCP_prev_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", B752_Prev: " .. B752_prev_HDG)
			--print("MCP: " .. MCP_HDG .. ", MCP_prev: " .. MCP_prev_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", B752_Prev: " .. B752_prev_HDG .. ", B752_AP_ALT: " .. B752_AP_ALT .. ", B752_LNAV_Lamp: " .. B752_LNAV_Lamp)
			--			-- checks if the MCP HDG has changed and if so updates the B752 HDG accordingly - ONLY IF LNAV IS NOT ON
			if MCP_HDG ~= MCP_prev_HDG then
				-- check if LNAV is on. if yes, then we just update the last value and do nothing
				if 	B752_AP_HDG == 1 and B752_LNAV_Lamp == 0 then		-- 1 = A/P LNAV not in charge
					-- MCP change detected and A/P not in charge. going down, up?, update the B752
					-- setting for HDG SEL on
					if B752_HDG_Button == 1 and B752_HDG_Hold == 0 then 						-- HDG SEL is on
						if MCP_HDG < MCP_prev_HDG then
							--command_once("1-sim/comm/AP/hdgDN")
							B752_HDG[0] = MCP_HDG
							MCP_prev_HDG = MCP_HDG
							B752_prev_HDG = MCP_HDG
							play_sound(knob2)
							--print("HDG dn due to MCP, HDG SEL")
						elseif MCP_HDG > MCP_prev_HDG then
							--command_once("1-sim/comm/AP/hdgUP")
							B752_HDG[0] = MCP_HDG
							MCP_prev_HDG = MCP_HDG
							B752_prev_HDG = MCP_HDG
							play_sound(knob2)
							print("HDG up due to MCP, HDG SEL")
						end
					elseif B752_HDG_Button == 0 and B752_HDG_Hold == 1 then						-- HDG ATT
							if MCP_HDG < MCP_prev_HDG then
								--command_once("1-sim/comm/AP/hdgDN")
								B752_HDG[0] = MCP_HDG
								MCP_prev_HDG = MCP_HDG
								B752_prev_HDG = MCP_HDG
								--play_sound(knob2)
								--print("HDG dn due to MCP, HDG ATT")
							
							elseif MCP_HDG > MCP_prev_HDG then
								B752_HDG[0] = MCP_HDG
								MCP_prev_HDG = MCP_HDG
								B752_prev_HDG = MCP_HDG
								--play_sound(knob2)
								--print("HDG up due to MCP, HDG ATT")
							end
					elseif B752_HDG_Button == 0 and B752_HDG_Hold == 0 then						-- HDG HOLD
							if MCP_HDG < MCP_prev_HDG then
								--command_once("1-sim/comm/AP/hdgDN")
								--MCP_prev_HDG = B752_HDG[0]
								--B752_HDG[0] = MCP_HDG
								--B752_prev_HDG = MCP_HDG
								--MCP_HDG = MCP_HDG + 1
								--print("B752 HDG dn due to MCP, MCP unchanged due to HDG HOLD")
								--print("B752 HDG: " .. B752_HDG[0] .. ", MCP_HDG: " .. MCP_HDG .. ", MCP_prev_HDG: " .. MCP_prev_HDG .. ", B752_prev_HDG: " .. B752_prev_HDG)
								B752_HDG[0] = MCP_HDG
								MCP_prev_HDG = MCP_HDG
								B752_prev_HDG = MCP_HDG
								--print("HDG dn due to MCP, HDG HOLD")
								play_sound(knob2)
							elseif MCP_HDG > MCP_prev_HDG then
								B752_HDG[0] = MCP_HDG
								MCP_prev_HDG = MCP_HDG
								B752_prev_HDG = MCP_HDG
								--print("HDG up due to MCP, HDG HOLD")
								play_sound(knob2)
							end
					
					
					end
				else
					-- A/P is in charge, so just equate prev val with curr val
					MCP_prev_HDG = MCP_HDG
					B752_HDG[0] = MCP_HDG
					B752_prev_HDG = MCP_HDG
					play_sound(knob2)
				end
				--MCP_prev_HDG = MCP_HDG
				--B752_prev_HDG = MCP_HDG
				--play_sound(knob2)
				--print("click by HDG" .. "MCP_HDG: " .. MCP_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", MCP_prev_HDG: " .. MCP_prev_HDG .. ", B752_prev_HDG: " .. B752_prev_HDG )
			
			else
--				-- no change, nothing to do
			end
		end
		do_every_draw("HDG_mod_MCP()")
		
		
		
		
		-- Second function. change by B752 to the MCP
		-- function HDG_mod_B752()
			-- --print("MCP: " .. MCP_HDG .. ", MCP_prev: " .. MCP_prev_HDG .. ", B752_HDG: " .. B752_HDG[0] .. ", B752_Prev: " .. B752_prev_HDG)
			-- -- checks if the B752 hdg has changed and if so updates the MCP HDG accordingly
			-- if B752_HDG[0] ~= B752_prev_HDG then
				-- -- B752 change detected, update the MCP
				-- MCP_HDG = B752_HDG[0]
				-- B752_prev_HDG = B752_HDG[0]
				-- MCP_prev_HDG = MCP_HDG
				
			-- else
				-- -- no change, nothing to do
			-- end
		-- end
		-- do_often("HDG_mod_B752()")
	-- END HDG Selector	
	
	-- Start ALT Selector
		DataRef("MCP_ALT","sim/cockpit/autopilot/altitude","writeable")				-- DataRef that the MCP works with
		DataRef("B752_AP_ALT", "757Avionics/mcp/alt/label", "readonly")				-- Flag of the AP ALT display status (?), 1 = vis, 0 = not
		DataRef("B752_VNAV_Lamp", "1-sim/AP/lamp/4","readonly")						-- VNAV Lamp status, 0 = off, 0.8 = on
		B752_ALT = dataref_table("757Avionics/ap/alt_act")							-- DataRef of the ALT window display

		-- On start, make the MCP = B752 ALT selector
		if MCP_ALT ~= B752_ALT[0] then
			-- equalizing MCP to B752
			MCP_ALT = B752_ALT[0]
		else
			-- nothing to do
		end
		
		-- set the prev hdg var and values
		MCP_prev_ALT = MCP_ALT
		B752_prev_ALT = B752_ALT[0]


		-- First function. ALT change by MCP to the B752
		-- if 757Avionics/mcp/vs/label is off (=0) then A/P is in charge - do nothing
		function ALT_mod_MCP()
			-- print("MCP: " .. MCP_ALT .. ", MCP_prev: " .. MCP_prev_ALT .. ", B752_ALT: " .. B752_ALT[0] .. ", B752_Prev: " .. B752_prev_ALT)
--			-- checks if the MCP ALT has changed and if so updates the B752 ALT accordingly
			if MCP_ALT ~= B752_prev_ALT then
				-- MCP change detected, check first if the A/P is in charge. then going down, up?, update the B752
				if B752_AP_ALT == 1 and B752_VNAV_Lamp == 0 then								-- 1 = A/P not in charge
					--still need to be able to set the mcp alt even if vnav is on. how??
					if MCP_ALT < MCP_prev_ALT then
						command_once("1-sim/comm/AP/altDN")
						play_sound(knob2)
						--print("click by ALT - dn" .. ", MCP_ALT: " .. MCP_ALT .. ", B752_ALT: " .. B752_ALT[0] .. ", MCP_prev_ALT: " .. MCP_prev_ALT .. ", B752_prev_ALT: " .. B752_prev_ALT )
					elseif MCP_ALT > MCP_prev_ALT then
						command_once("1-sim/comm/AP/altUP")
						play_sound(knob2)
						--print("click by ALT - up" .. ", MCP_ALT: " .. MCP_ALT .. ", B752_ALT: " .. B752_ALT[0] .. ", MCP_prev_ALT: " .. MCP_prev_ALT .. ", B752_prev_ALT: " .. B752_prev_ALT )
					end
				else
					-- A/P is in charge - do not touch the B752 MCP
					
					
				end
				
				MCP_prev_ALT = MCP_ALT	
				
				--play_sound(knob2)
				--print("click by ALT" .. ", MCP_ALT: " .. MCP_ALT .. ", B752_ALT: " .. B752_ALT[0] .. ", MCP_prev_ALT: " .. MCP_prev_ALT .. ", B752_prev_ALT: " .. B752_prev_ALT )
			
			else
--				-- no change, nothing to do
			end
		end
		do_every_draw("ALT_mod_MCP()")
		
		
		-- Second function. change by B752 to the MCP
		function ALT_mod_B752()
			--print("MCP: " .. MCP_ALT .. ", MCP_prev: " .. MCP_prev_ALT .. ", B752_ALT: " .. B752_ALT[0] .. ", B752_Prev: " .. B752_prev_ALT)
			-- checks if the B752 ALT has changed and if so updates the MCP ALT accordingly
			if B752_ALT[0] ~= B752_prev_ALT and B752_VNAV_Lamp ==0 then
				-- B752 change detected, update the MCP			
				MCP_ALT = B752_ALT[0]
				B752_prev_ALT = B752_ALT[0]
				MCP_prev_ALT = MCP_ALT
				
			else
				-- no change, nothing to do
			end
		end
		do_every_frame("ALT_mod_B752()")
	-- END ALT Selector	

	-- Start VSI Selector
		DataRef("MCP_VSI","sim/cockpit/autopilot/vertical_velocity","writeable")				-- MCP Value
		--DataRef("B752_AP_VSI", "1-sim/AP/vviSettingSign", "readonly")
		DataRef("B752_AP_VSI", "757Avionics/mcp/vs/label", "readonly")							-- VS control by the A/P. 0 = A/P, 1 = Not A/P
		--	DataRef("B752_VSI","757Avionics/ap/VSI_act","writeble")
		B752_VSI = dataref_table("757Avionics/ap/vs_act")										-- VS value on B752 MCP

		-- On start, make the MCP = B752 VSI selector
		if MCP_VSI ~= B752_VSI[0] then
			-- equalizing MCP to B752
			MCP_VSI = B752_VSI[0]
		else
			-- nothing to do
		end
		
		-- set the prev VSI var and values
		MCP_prev_VSI = MCP_VSI
		B752_prev_VSI = B752_VSI[0]
	-- mod 10/9/2018
	
	DataRef("XP_VSI_Status","sim/cockpit2/autopilot/vvi_status","readonly")		-- 0 = OFF, 2 = ON
	
	-- Start VSI Reset
	function VSI_reset()
		-- checks for the reset of the VSI mode and sets MCP VSI to 0 accordingly
		if XP_VSI_Status == 0 then
			-- VSI mode has ended and thus MCP should go back to 0
			MCP_VSI = 0
			MCP_prev_VSI = 0
		else
			-- VSI mode is on - nothing to do
		end
	end
	do_often("VSI_reset()")
	-- End VSI reset
	
	-- via command instead of dataref
	-- First function. change by MCP to the B752
		-- what if it wasn't the MCP who changed the var?
		-- if 1-sim/AP/vviSettingSign is on (=1) then A/P is in charge - do nothing
		-- if 757Avionics/mcp/vs/label is off (=0) then A/P is in charge - do nothing
		function VSI_mod_MCP()
			-- print("MCP: " .. MCP_VSI .. ", MCP_prev: " .. MCP_prev_VSI .. ", B752_VSI: " .. B752_VSI[0] .. ", B752_Prev: " .. B752_prev_VSI)
--			-- checks if the MCP VSI has changed and if so updates the B752 VSI accordingly
			if MCP_VSI ~= MCP_prev_VSI then
				-- MCP change detected, check first if the A/P is in charge. then going down, up?, update the B752
				if B752_AP_VSI == 1 then
					if MCP_VSI < MCP_prev_VSI then
						command_once("1-sim/comm/AP/vviDN")
						play_sound(knob2)
						--print("click by VSI" .. "MCP_VSI: " .. MCP_VSI .. ", B752_VSI: " .. B752_VSI[0] .. ", MCP_prev_VSI: " .. MCP_prev_VSI .. ", B752_prev_VSI: " .. B752_prev_VSI )
					elseif MCP_VSI > MCP_prev_VSI then
						command_once("1-sim/comm/AP/vviUP")
						play_sound(knob2)
						--print("click by VSI" .. "MCP_VSI: " .. MCP_VSI .. ", B752_VSI: " .. B752_VSI[0] .. ", MCP_prev_VSI: " .. MCP_prev_VSI .. ", B752_prev_VSI: " .. B752_prev_VSI )
					end
				else
					-- A/P is in charge - do not touch the B752 MCP
					MCP_VSI = 0
					MCP_prev_VSI = 0
				end
				--update prev val with curr val
				MCP_prev_VSI = MCP_VSI	
				
				
			
			else
--				-- no change, nothing to do
			end
		end
		do_every_draw("VSI_mod_MCP()")
	

		-- Second function. change by B752 to the MCP
		function VSI_mod_B752()
			--print("MCP: " .. MCP_VSI .. ", MCP_prev: " .. MCP_prev_VSI .. ", B752_VSI: " .. B752_VSI[0] .. ", B752_Prev: " .. B752_prev_VSI)
			-- checks if the B752 VSI has changed and if so updates the MCP VSI accordingly
			if B752_VSI[0] ~= B752_prev_VSI then
				-- B752 change detected, update the MCP
				MCP_VSI = B752_VSI[0]
				B752_prev_VSI = B752_VSI[0]
				MCP_prev_VSI = MCP_VSI
				
			else
				-- no change, nothing to do
			end
		end
		do_every_frame("VSI_mod_B752()")
	-- END VSI Selector	

	-- Start Capt Course Selector  												** uses same dataref - only need to play sound when changed
		DataRef("MCP_N1_OBS","sim/cockpit/radios/nav1_obs_degm","writeable")
		-- DataRef("B752_VSI","757Avionics/ap/VSI_act","writeble")
		-- B752_VSI = dataref_table("757Avionics/ap/vs_act")
		-- On start, make the MCP = B752 VSI selector
		-- removed - always the same
		
		-- set the prev VSI var and values
		MCP_prev_N1_OBS = MCP_N1_OBS
		

		-- First function. change by MCP to the B752
		function N1_OBS_mod_MCP()
			
			-- checks if the MCP N1 OBS has changed and if so plays sound
			if MCP_N1_OBS ~= MCP_prev_N1_OBS then
				-- MCP change detected, play sound - nothing else
				MCP_prev_N1_OBS = MCP_N1_OBS
				play_sound(knob2)
				--print("click by OBS")
			else
				-- no change, nothing to do
			end
		end
		do_every_frame("N1_OBS_mod_MCP()")	
	-- End Capt Course Selector
	
	-- Start IAS Selector
		DataRef("MCP_IAS","sim/cockpit/autopilot/airspeed","writeable")
		B752_IAS = dataref_table("757Avionics/ap/spd_act")
		
		-- On start, make the MCP = B752 IAS selector
		if MCP_IAS ~= B752_IAS[0] then
			-- equalizing MCP to B752
			MCP_IAS = B752_IAS[0]
		else
			-- nothing to do
		end
		
		-- set the prev IAS var and values
		MCP_prev_IAS = MCP_IAS
		B752_prev_IAS = B752_IAS[0]

		-- First function. change by MCP to the B752
		function IAS_mod_MCP()
			--print("MCP: " .. MCP_IAS .. ", MCP_prev: " .. MCP_prev_IAS .. ", B752_IAS: " .. B752_IAS[0] .. ", B752_Prev: " .. B752_prev_IAS)
			-- checks if the MCP IAS has changed and if so updates the B752 IAS accordingly
			if B752_AT_arm_sw == 0 and B752_SPD_Lamp > 0 then				-- A/T is on and on SPD mode
				if MCP_IAS ~= MCP_prev_IAS then
					-- MCP change detected, update the B752
					B752_IAS[0] = MCP_IAS
					B752_prev_IAS = MCP_IAS
					MCP_prev_IAS = MCP_IAS
					play_sound(knob2)
					--print("click by MCP IAS - SPD is on")
				else
					-- no change, nothing to do
				end
			elseif B752_AT_arm_sw == 0 and B752_FLCH_Lamp > 0 then			-- A/T is on and in FLCH mode
				if MCP_IAS ~= B752_IAS[0] then
					-- MCP change detected, update the B752
					B752_IAS[0] = MCP_IAS
					--B752_prev_IAS = MCP_IAS
					MCP_prev_IAS = MCP_IAS
					play_sound(knob2)
					--print("click by MCP IAS - FLCH is on. MCP_IAS: " .. MCP_IAS .. ", B752_IAS: " .. B752_IAS[0])
				else
					-- no change, nothing to do
				end
			
			else															-- A/T is off
				if MCP_IAS ~= MCP_prev_IAS then
					B752_IAS[0] = MCP_IAS
					MCP_prev_IAS = MCP_IAS
					play_sound(knob2)
					--print("click by MCP IAS - A/T is off. MCP_IAS: " .. MCP_IAS .. ", B752_IAS: " .. B752_IAS[0])
				end
			
			end
		end
		do_every_draw("IAS_mod_MCP()")

		-- Works for SPD mode
		-- -- First function. change by MCP to the B752
		-- function IAS_mod_MCP()
			-- --print("MCP: " .. MCP_IAS .. ", MCP_prev: " .. MCP_prev_IAS .. ", B752_IAS: " .. B752_IAS[0] .. ", B752_Prev: " .. B752_prev_IAS)
			-- -- checks if the MCP IAS has changed and if so updates the B752 IAS accordingly
			-- if MCP_IAS ~= MCP_prev_IAS then
				-- -- MCP change detected, update the B752
				-- B752_IAS[0] = MCP_IAS
				-- B752_prev_IAS = MCP_IAS
				-- MCP_prev_IAS = MCP_IAS
				-- play_sound(knob2)
				-- print("click by MCP IAS")
			-- else
				-- -- no change, nothing to do
			-- end
		-- end
		-- do_every_draw("IAS_mod_MCP()")		

		
		-- -- Second function. change by B752 to the MCP
		-- function IAS_mod_B752()
			-- --print("MCP: " .. MCP_IAS .. ", MCP_prev: " .. MCP_prev_IAS .. ", B752_IAS: " .. B752_IAS[0] .. ", B752_Prev: " .. B752_prev_IAS)
			-- -- checks if the B752 IAS has changed and if so updates the MCP IAS accordingly
			-- if B752_IAS[0] ~= B752_prev_IAS then
				-- -- B752 change detected, update the MCP
				-- MCP_IAS = B752_IAS[0]
				-- B752_prev_IAS = B752_IAS[0]
				-- MCP_prev_IAS = MCP_IAS
				
			-- else
				-- -- no change, nothing to do
			-- end
		-- end
		-- do_often("IAS_mod_B752()")
	-- END IAS Selector	
	

-- Start FlapLeverPos
-- Checks the state of the CFY Flap Lever and adjusts the B752 Flap Lever accordingly
	DataRef("FlapLeverPos", "linus/CFY/FlapLever","readonly",0)
	DataRef("B752_FlapLeverPos","sim/flightmodel/controls/flaprqst", "writeable")
	local FlapLever_B752
	FlapLever_B752 = 0

	function updateB752FlapLever()


		if FlapLever_B752 ~= FlapLeverPos then
--			print("FlapLeverPos: " .. FlapLeverPos .. ", B752_Flaps: " .. B752_FlapLeverPos .. ", FlapLever_B752: " .. FlapLever_B752)
		
			--first, command a new flaps position accordingly
			if FlapLeverPos == 0 then
				-- flaps retracted. CFY = 0
				-- flaps B752 = 0 (UP)
				B752_FlapLeverPos = 0	
			
			elseif FlapLeverPos == 2047 then
				-- flaps CFY = 1
				-- flaps B752 = 1
				B752_FlapLeverPos = .16667
			
			elseif FlapLeverPos == 4095 then
				-- flaps CFY = 2
				-- flaps B752 = 5
				B752_FlapLeverPos = .3333
			
			elseif FlapLeverPos == 6143 then
				-- flaps CFY = 5
				-- flaps B752 = 15
				B752_FlapLeverPos = .5	

			elseif FlapLeverPos == 8191 then
				-- flaps CFY = 10
				-- flaps B752 = 20
				B752_FlapLeverPos = .66667	

			elseif FlapLeverPos == 10239 then
				-- flaps CFY = 15
				-- flaps B752 = 25
				B752_FlapLeverPos = .833333

			elseif FlapLeverPos == 14335 then
				-- flaps CFY = 25
				-- flaps B752 = 30
				B752_FlapLeverPos = 1

			elseif FlapLeverPos == 16383 then
				-- flaps CFY = 30
				-- flaps B752 = 30 (still)
				MD88_FlapLeverPos = 1
			end
			
			--second, equalize the req and the position
			FlapLever_B752 = FlapLeverPos
			
		end
	end
	do_often("updateB752FlapLever()")
-- End FlapLeverPos



-- Start StartLever1
-- Checks the state of the CFY Start Lever 1 and adjusts the 757 Start Lever accordingly
	DataRef("StartLever1", "linus/CFY/StartLever1","writeable",0)
	B752_StartLever1 = dataref_table("1-sim/fuel/fuelCutOffLeft")
	EngRun = dataref_table("sim/flightmodel/engine/ENGN_running")
	function updateB752StartLever1()
--		print("StartLever1: " .. StartLever1 .. ", B752_StartLever1: " .. B752_StartLever1[0] )
		if StartLever1 == 0 then
			B752_StartLever1[0] = 0
		elseif StartLever1 > 16383 then
			-- weird start value, setting to 0
			B752_StartLever1[0] = 0
		elseif StartLever1 > 0 then
			B752_StartLever1[0] = 2
			
--			if EngRun[0] == 1 then
--				B752_StartLever1[0] = 1
--			else
--				B752_StartLever1[0] = 2
--			end

		end
	end
	do_often("updateB752StartLever1()")
-- End StartLever1

-- Start StartLever2
-- Checks the state of the CFY Start Lever 2 and adjusts the 757 Start Lever accordingly
	DataRef("StartLever2", "linus/CFY/StartLever2","writeable",0)
	B752_StartLever2 = dataref_table("1-sim/fuel/fuelCutOffRight")
	EngRun = dataref_table("sim/flightmodel/engine/ENGN_running")
	function updateB752StartLever2()
--		print("StartLever2: " .. StartLever2 .. ", B752_StartLever2: " .. B752_StartLever2[0] )
		if StartLever2 == 0 then
			B752_StartLever2[1] = 0
		elseif StartLever2 > 0 then
			B752_StartLever2[1] = 2
--			if EngRun[1] == 1 then
--				B752_StartLever2[0] = 1
--			else
--				B752_StartLever2[0] = 2
--			end

		end
	end
	do_often("updateB752StartLever2()")
-- End StartLever1

-- THROTTLE STUFF STARTS HERE
	Override_Throttle = dataref_table("sim/operation/override/override_throttles")
	dataref("B752_AT_arm_sw", "1-sim/AP/atSwitcher", "writeable")  					-- 0 = ON, 1 = OFF
	define_shared_DataRef("linus/B752/ATValue","Int")
	B752_AT_VALUE = dataref_table("linus/B752/ATValue")								-- 0 = ON, 1 = OFF
	XP_AT_Enabled = dataref_table("sim/cockpit2/autopilot/autothrottle_enabled") 	-- 0 = OFF, 1 = ON
	
	--New A/T logic OCT 2018
	
	AT_SPD = dataref_table("1-sim/AP/spdButton")
	AT_VNAV = dataref_table("1-sim/AP/vnavButton")
	AT_EPR = dataref_table("1-sim/AP/eprButton")

	-- ojo: must monitor ->> 757Avionics/ap/at_servos_is_active 0 = no, 1 = yes
	
	--local B752_AT_VALUE
	B752_AT_VALUE[0] = -1
	
	
	-- Start AT_Disengage
	-- First: command to disengage A/T
		-- create_command("linus/B752/AutoThrottle_Disengage","B752 AutoThrottle Disengage",
				-- -- OFF = 1
				-- -- ON = 0
				-- [[
					-- -- set AutoThrottle = OFF
					-- B752_AT_arm_sw = 1								-- B752 AT Switch goes off
					-- command_once("sim/autopilot/autothrottle_off")	-- Xplane AT command
					-- B752_AT_VALUE[0] = 1							-- Linus Dataref value - Lets us know where we left off
				-- ]],
				-- "",
				-- "")

-- DISABLED ON 10/29/2018
		-- create_command("linus/B752/AutoThrottle_Disengage","B752 AutoThrottle Disengage",
			-- -- OFF = 1
			-- -- ON = 0
			-- [[
				-- -- set AutoThrottle = OFF
				-- B752_AT_arm_sw = 1								-- B752 AT Switch goes off
				-- XP_AT_Enabled[0] = 0
				-- Override_Throttle[0] = 0
			-- ]],
			-- "",
			-- "")

-- START New AT Disengage switch			
-- We are leaving the offset alone. now we need to detect the button press by monitoring the states of XP_AT_Enabled and Override_Throttle.
-- If they disagree, the button was pressed.
	-- First, the command
		create_command("linus/B752/AutoThrottle_Disengage","B752 AutoThrottle Disengage",
			-- OFF = 1
			-- ON = 0
			[[
				-- -- set AutoThrottle = OFF
				B752_AT_arm_sw = 1								-- B752 AT Switch goes off
				XP_AT_Enabled[0] = 0
				Override_Throttle[0] = 0
			]],
			"",
			"")

	-- Second, the monitor function
	function NewB752ATDisen()
		-- monitors the disagreement between XP_AT_Enabled and Override_Throttle. when disagree, then fire AT Disengage command
		if TOGA_latch ~= 1 then
			if XP_AT_Enabled[0] == 0 and XP_AT_Enabled[0] ~= Override_Throttle[0] then
				-- disagreement detected, we now fire AT Disengage command
				print("AT Disengage Fired! XP_AT_Enabled=" .. XP_AT_Enabled[0] .. ", Override_Throttle=" .. Override_Throttle[0])
				command_once("linus/B752/AutoThrottle_Disengage")		-- execs command to turn off B752 MCP switch
			else
				-- they agree, nothing to do
			end
		else
			-- Disagreement ok because of TOGA
			print("Override ATDisen due to TOGA")
		end
	end
	do_often("NewB752ATDisen()")

-- END New AT Disengage switch
			
-- START AT Disengage switch
-- Checks the state of the CFY AT Disengage and adjusts the B757-200 A/T State accordingly
	dataref("AT_Disen_752","linus/CFY/ATDisen","writeable")
	
	-- function updateB752ATDisen()
-- --		print("ATDisen: " .. ATDisen .. ", B752_AT_Switch: " .. AT_Disen_752 )
		-- if AT_Disen_752 == 0 then							-- CFY AT Disen button was pressed
	-- --		AT_arm_sw = 0
	-- --		XP_AT_Enabled[0] = 0
	-- --		AT_Value[0] = -1
	-- --		AT_arm_sw = 0
	-- --		XP_AT_Enabled[0] = 0
	-- --		command_once("linus/B752/ToggleAutoThrottle")
			-- command_once("linus/B752/AutoThrottle_Disengage")		-- execs command to turn off B752 MCP switch, Xplane A/T and Linus DataRef (Why?)
			-- AT_Disen_752 = 1
		-- end
	-- end
	-- do_often("updateB752ATDisen()")
-- End AT_Disengage




-- START FLCH logic 
-- if FLCH is pressed / engaged and the A/T is on then sim/cockpit2/autopilot/autothrottle_enabled should be on 
	AT_FLCH = dataref_table("1-sim/AP/flchButton")
	DataRef("B752_FLCH_Lamp","1-sim/AP/lamp/5","readonly")
	DataRef("XP_Cabin_Altitude","757Avionics/adc/alt_cpt","readonly")
	DataRef("XP_Throttle_state","sim/cockpit2/engine/actuators/throttle_beta_rev_ratio_all","readonly")
	XP_Throttle_req = dataref_table("sim/multiplayer/controls/engine_throttle_request")
	function B752_AT_on_FLCH()
--		-- checks if FLCH is pressed and A/T is on then sim/cockpit2/autopilot/autothrottle_enabled should be on
		if B752_FLCH_Lamp > 0 then
			-- button is pressed and lamp is on - FLCH is active (?)
			if XP_Cabin_Altitude < B752_ALT[0] then
				-- we want to Climb
				-- AutoThrottle enable (1) and override on (1)
				XP_AT_Enabled[0] = 1
				Override_Throttle[0] = 1
				
				
				
			elseif XP_Cabin_Altitude > B752_ALT[0] then
				-- we want to descend
				-- AutoThrottle disable AFTER idle!
				
				if XP_Throttle_state > 0.024696 then
					XP_AT_Enabled[0] = 1
					Override_Throttle[0] = 1
					XP_Throttle_req[0] = 0.024696
					--print("FLCH Descend mode")
				else					
					--print("FLCH Descend IDLE reached")
					--XP_AT_Enabled[0] = 0	--Commented out - to avoid tripping the AT Disen 
					Override_Throttle[0] = 0
					
				end
				
			end
		else
			--print("FLCH not active!")
		end
	--print("XP_Cabin_Altitude: " .. XP_Cabin_Altitude .. ", XP_AT_Enabled: " .. XP_AT_Enabled[0] .. ", B752_ALT[0]: " .. B752_ALT[0] .. ", XP_Throttle_state: " .. XP_Throttle_state)
	end
	do_every_frame("B752_AT_on_FLCH()")
-- END FLCH

-- START SPD logic 
-- if SPD is pressed / engaged and the A/T is on then sim/cockpit2/autopilot/autothrottle_enabled should be on 
	B752_SPD_prev = B752_SPD_Lamp
	
	function B752_AT_on_SPD()
--		-- checks if SPD is pressed and A/T is on then sim/cockpit2/autopilot/autothrottle_enabled should be on
		if B752_SPD_Lamp ~= B752_SPD_prev then
			if B752_SPD_Lamp > 0 then
				-- button is pressed and lamp is on - SPD is active 
				-- AutoThrottle enable (1) and override on (1)
				XP_AT_Enabled[0] = 1
				Override_Throttle[0] = 1
				AT_EPR[0] = 0
				--print("SPD mode is now active!")
			
			else
				--print("SPD mode not active!")
			end
			B752_SPD_prev = B752_SPD_Lamp
		end
	end
	do_often("B752_AT_on_SPD()")
-- END SPD logic

DataRef("XP_OnGround","sim/flightmodel/failures/onground_any","readonly")		-- To know if on ground. 1 = yes, 0 = no
--DataRef("B752_EPR_Limit","1-sim/fms/thrust_limit_value","readonly")				-- B752 EPR Limit, set by FMC	
--B752_E1_EPR = dataref_table("sim/cockpit2/engine/indicators/EPR_ratio")
DataRef("B752_EPR_Limit","1-sim/eicas/EPR_target/L","readonly")					-- B752 Eng1 EPR Limit, set by FMC, converted	
B752_E1_EPR = dataref_table("1-sim/eicas/EPR_deltaL/L","readonly")				-- B752 Eng1 EPR developed, converted
--B752_E1_EPR = dataref_table("1-sim/eicas/EPR_deltaU/L","readonly")					-- B752 Eng1 EPR Requested, converted

-- START THR logic 
-- if THR is pressed / engaged and the A/T is on AND we are on the ground then sim/cockpit2/autopilot/autothrottle_enabled should be on 
--	B752_THR_prev = B752_THR_Lamp

TOGA_latch = 0				

	function B752_AT_on_THR()
--		-- checks if THR is pressed and A/T is on AND we are on the Ground then sim/cockpit2/autopilot/autothrottle_enabled should be on
		-- until reaching TO EPR set value
		-- then sim/cockpit2/autopilot/autothrottle_enabled should be off to allow manual adj of the A/T
		
--		if B752_THR_Lamp ~= B752_THR_prev then
			if XP_OnGround == 1 then
				-- we are on the ground
				
				if B752_THR_Lamp > 0 then
					if TOGA_latch == 1 then
						-- button is pressed and lamp is on - THR is active 
						-- TOGA latch is on
						-- if we have not reached tgt EPR then 
						-- AutoThrottle enable (1) and override on (1)
						
						if B752_E1_EPR[0] <= B752_EPR_Limit * 0.88  then		-- not there yet
							TOGA_latch = 1
							--XP_AT_Enabled[0] = 1
							--Override_Throttle[0] = 1
							XP_Throttle_req[0] = 1.1						--Increase Throttle fwd till we reach tgt EPR
							print("Not yet at 88% EPR - increasing Throttle. E1_EPR: " .. B752_E1_EPR[0] / B752_EPR_Limit .. "%, " .. B752_E1_EPR[0] .. ", EPR_Lim: " .. B752_EPR_Limit)
						
						--elseif B752_E1_EPR[0] <= B752_EPR_Limit * 0.95 then --or TOGA_latch == 0 then
						--	TOGA_latch = 1
						--	XP_AT_Enabled[0] = 1
						--	Override_Throttle[0] = 0
						--	XP_Throttle_req[0] = 1.1						--Increase Throttle fwd till we reach tgt EPR
							
						--	print("reaching 95% limit EPR - increasing Throttle")
						--	print("THR/EPR mode is now active! - TO mode" .. B752_E1_EPR[0] .. ", " .. B752_EPR_Limit)
						else
							-- We reached EPR target - back to manual control
							-- consider a timer here?
							XP_Throttle_req[0] = 1.1
							XP_AT_Enabled[0] = 0								--Frees the Throttle Handles
							--Override_Throttle[0] = 0							--Prevents Throttle from coming down
							TOGA_latch = 0
							print("THR/EPR mode is now inactive! - TO mode - EPR reached")
						end
					else
						-- TOGA latch is off, so we are not doing TOGA anymore
						-- nothing to do
					end
				else
					--print("THR mode not active!")
				end
			else
				-- aircraft is not on ground
				if B752_THR_Lamp > 0 then
					XP_AT_Enabled[0] = 0
					Override_Throttle[0] = 0
					TOGA_latch = 0
					--print("THR mode - air - is now active!")
				else
					-- in the air, THR lamp is off
				end
			end
			--B752_THR_prev = B752_THR_Lamp
			
--		end
	end
	do_every_frame("B752_AT_on_THR()")
-- END THR logic

-- Start TOGA logic
	--When TOGA button is pressed, goes to 1. If F/D on and AT is on then we should do TOGA (press EPR/THR)
	DataRef("B752_TOGA","linus/CFY/TOGASen","writeable")		-- 0 = OFF, 1 = ON
	DataRef("B752_FD_sw1","1-sim/AP/fd1Switcher","readonly")	-- 1 = OFF, 0 = ON
	DataRef("B752_FD_sw2","1-sim/AP/fd2Switcher","readonly")	-- 1 = OFF, 0 = ON
	function B752_TOGA_button()
		-- senses the TOGA button press then executes TOGA if: on the ground and FD on and AT on
		
		if B752_TOGA == 1 then
			-- Button is pressed
			print("TOGA pressed")
			if XP_OnGround == 1 then
				-- Aircraft on Ground
				print("Aircraft on Ground")
				if B752_FD_sw1 == 0 or B752_FD_sw2 == 0 then
					-- FD is on
					print("FD is on")
					if B752_AT_arm_sw == 0 then
						-- AT is on
						-- We engage TOGA
						print("AT is on. We Engage TOGA")
						TOGA_latch = 1
						XP_AT_Enabled[0] = 1
						Override_Throttle[0] = 1						-- Otherwise will limit Throttle to 1.3 EPR
						XP_Throttle_req[0] = 1.1	
						AT_EPR[0] = 1	
						--Override_Throttle[0] = 0						-- Otherwise will limit Throttle to 1.3 EPR
						--XP_Throttle_req[0] = 1.1						--Increase Throttle fwd till we reach tgt EPR
						--print("increasing Throttle")
						B752_TOGA = 0		-- Reset TOGA	
					else
						-- AT is not on
						print("AT is not on")
						B752_TOGA = 0
						TOGA_latch = 0
					end
				else
					-- FD is not on
					print("FD is not on")
					B752_TOGA = 0
					TOGA_latch = 0
				end
			else
				-- Aircraft in the Air -- further development needed here
				print("Aircraft in the Air")
				B752_TOGA = 0
				TOGA_latch = 0
			end
		else
			-- TOGA button is not pressed
		end
	end
	
	do_often("B752_TOGA_button()")
	
-- END TOGA logic

-- code for B752 AutoThrottle switch
-- first define the switch
--	dataref("AT_arm_sw", "1-sim/AP/atSwitcher", "writeable")  -- 0 = on, 1 = OFF
-- define the other A/T stuff here
--	XP_AT_Enabled = dataref_table("sim/cockpit2/autopilot/autothrottle_enabled")
--	AT_SPD = dataref_table("1-sim/AP/spdButton")
	
-- define the value state	
--	define_shared_DataRef("linus/B752/ATValue","Int")
--	AT_value = dataref_table("linus/B752/ATValue")
	-- at start, AT off
--		AT_value[0] = -1
--		AT_arm_sw = 1
--		XP_AT_Enabled[0] = 0
--		AT_Disen_752 = 1
	
	-- command for button
--	create_command("linus/B752/ToggleAutoThrottle","Toggle B752 AutoThrottle",
		-- [[if AT_value[0] == -1 then		
			-- -- set AutoThrottle = off
			-- --AT_arm_sw = 1
			-- XP_AT_Enabled[0] = 0
			-- -- turn off the A/T buttons before the A/T switch!
			-- --AT_FLCH[0] = 0
			-- --AT_SPD[0] = 0
			-- --AT_VNAV[0] = 0
			-- AT_arm_sw = 1
			-- AT_Disen_752 = 1
		-- else 	
			-- -- set AutoThrottle = on
			-- AT_arm_sw = 0
			-- -- insert the code to arm the AT here
			-- --if AT_FLCH[0] == 1 then
			-- --	XP_AT_Enabled[0] = 1
			-- end
			-- --if AT_SPD[0] == 1 then
			-- --	XP_AT_Enabled[0] = 1
			-- end
			-- --if AT_VNAV[0] == 1 then
			-- --	XP_AT_Enabled[0] = 1
			-- end
			-- AT_Disen_752 = 1
		-- end
		-- AT_value[0] = AT_value[0] *-1]],
		-- "",
		-- "")
	-- button assignment
--	set_button_assignment( (8*40) + 14, "linus/B752/ToggleAutoThrottle" )

--to inspect values of the AT MCP button states
--function AT_MCP_Buttons()
--	print("AT_EPR: " .. AT_EPR[0] .. ", AT_FLCH: " .. AT_FLCH[0] .. ", AT_SPD: " .. AT_SPD[0] .. ", AT_VNAV: " .. AT_VNAV[0] .. ", AT_EPR: " .. AT_EPR)
--	print("B752_AT_VALUE: " .. B752_AT_VALUE[0] .. ", B752_AT_arm_sw: " .. B752_AT_arm_sw)
--end
--do_often("AT_MCP_Buttons()")

	-- create_command("linus/B752/ToggleAutoThrottle","Toggle B752 AutoThrottle",
			-- -- OFF = 1
			-- -- ON = 0
			-- [[
			
			-- if B752_AT_VALUE[0] == 0 then		
				-- -- set AutoThrottle = OFF
				-- B752_AT_arm_sw = 1
				-- command_once("sim/autopilot/autothrottle_off")
				-- B752_AT_VALUE[0] = 1
			-- else 	
				-- -- set AutoThrottle = ON
				-- B752_AT_arm_sw = 0
				-- command_once("sim/autopilot/autothrottle_on")
				-- B752_AT_VALUE[0] = 0
			-- end
			-- ]],
		 -- "",
		 -- "")
		 
		create_command("linus/B752/ToggleAutoThrottle","Toggle B752 AutoThrottle",
			-- OFF = 1
			-- ON = 0
			[[
			
			if B752_AT_arm_sw == 0 then					-- MCP AT switch is ON - we then turn it OFF (0 to 1)
				-- set AutoThrottle = OFF
				B752_AT_arm_sw = 1
				-- consider the override here
				Override_Throttle[0] = 0					-- If we flick the AT switch down, no more override should happen
				-- also the XP A/T dataref to OFF
				XP_AT_Enabled[0] = 0					-- 0 = OFF, 1 = ON
				
			else 	
				-- set AutoThrottle = ON				-- MCP AT switch is OFF - we then turn it ON (1 to 0)
				B752_AT_arm_sw = 0
				
				--if no AT modes are armed, then we don't enable the XP_AT_Enabled
				if B752_VNAV_Lamp > 0 or B752_FLCH_Lamp > 0 or B752_SPD_Lamp > 0 then --not THR
					XP_AT_Enabled[0] = 1
					Override_Throttle[0] = 1
				else
					-- no A/T modes are on so we do not let the ap control the throttle
				end
				-- consider the override here
				-- override yes if AT modes are on
				
			end
			]],
		 "",
		 "")
		 
-- key: sim/cockpit2/autopilot/autothrottle_enabled
--	set_button_assignment( (8*40) + 14, "sim/autopilot/autothrottle_toggle" )
	set_button_assignment( (8*40) + 14, "linus/B752/ToggleAutoThrottle" )	
	-- end B752 Auto Throttle switch

-- Start Override Throttle off
-- Ensures Auto Throttle stays on if switch is on the on state
	-- dataref("B752_Override_Throttle", "sim/cockpit2/autopilot/autothrottle_enabled", "writeable")
	-- -- to start, the override should be off
	-- B752_Override_Throttle = 0
	-- function B752_FxOverrideThrottles ()
		-- --first check if the AT_switch is on
		-- if B752_AT_arm_sw == 0 then
			-- --switch is on - so override should be on
			-- if B752_Override_Throttle == 0 then
				-- --command_once("sim/autopilot/autothrottle_on")
				-- B752_Override_Throttle = 1
			-- end
		-- else
		-- end
-- --			print("B752_Override_Throttle: " .. B752_Override_Throttle .. ", B752_AT_arm_sw: " .. B752_AT_arm_sw)
	-- end
	-- do_often("B752_FxOverrideThrottles()")
-- End Override Throttle off


--COMMENTED OUT 10/2/2018
	-- B752 A/T FLCH switch and CFY
	--IF A/T is on then 
		--If FLCH is turned on, we want AT to remain on (AND CFY to continue working)
	--ELSE
	--	We want FLCH to turn off 
	--dataref("AT_FLCH","1-sim/AP/flchButton","readonly")
--	AT_FLCH = dataref_table("1-sim/AP/flchButton")
--	function CheckFLCH()
--		if AT_arm_sw == 0 then
--			if	AT_FLCH[0] == 1 then
--				XP_AT_Enabled[0] = 1
--			end
--		else
--			AT_FLCH[0] = 0
--		end
--	end
--	do_often ("CheckFLCH()")
	-- end FLCH

	-- B752 A/T VNAV switch and CFY
	-- If VNAV is turned on, we want AT to remain on (AND CFY to continue working)
	--dataref("AT_VNAV","1-sim/AP/vnavButton","readonly")
--	AT_VNAV = dataref_table("1-sim/AP/vnavButton")
--	function CheckVNAV()
--		if AT_arm_sw == 0 then
--			if	AT_VNAV[0] == 1 then
--				XP_AT_Enabled[0] = 1
--			end
--		--added 10/2/2018
--		else	
--			AT_VNAV[0] = 0
--		end
--	end
--	do_often ("CheckVNAV()")
	-- end VNAV check

	-- B752 A/T SPD switch and CFY
	-- If SPD is turned on, we want AT to remain on (AND CFY to continue working)
	--dataref("AT_VNAV","1-sim/AP/vnavButton","readonly")
--	function CheckSPD()
--		if AT_arm_sw == 0 then
--			if	AT_SPD[0] == 1 then
--				XP_AT_Enabled[0] = 1
--			end
--		else	
--			AT_SPD[0] = 0
--		end
--	end
--	do_often ("CheckSPD()")
	-- end SPD check

--COMMENTED OUT 10/2/2018

--set_button_assignment( (8*40) + 14, "sim/autopilot/autothrottle_toggle" )




-- END OF THROTTLE STUFF HERE




-- Start A/P Disengage button
-- Disengages the A/P (via the MCP lever)
	dataref("B752_AP_Disengage_Lever", "1-sim/AP/desengageLever", "writeable")
	--B752_AT_State = 0
	create_command("linus/B752/AP_Disengage_bar","Disengage AutoPilot - Bar",
			-- OFF = 1
			-- ON = 0
			[[
				
				
				-- set AutoPilot = OFF
				-- B752_AT_State = B752_AT_State + 1
				B752_AP_Disengage_Lever = 1
				--sets off alarm - on second press we return bar to on (turns off alarm)
				sleep(3)
				B752_AP_Disengage_Lever = 0
				--if B752_AT_State >=2 then 
				--	B752_AT_State = 0
				--	B752_AP_Disengage_Lever = 0
				--else
				
				--end 
			]],
		 "",
		 "")
	-- Disengages the A/P (via the yoke button)
	dataref("B752_AP_Disengage_Button", "1-sim/AP/desengageButton", "writeable")
	--B752_AT_State = 0
	create_command("linus/B752/AP_Disengage_button","Disengage AutoPilot - Button",
			-- OFF = 1
			-- ON = 0
			 [[								
				-- set AutoPilot = OFF
				
				B752_AP_Disengage_Button = B752_AP_Disengage_Button + 1
				if B752_AP_Disengage_Button >= 2 then 		-- we have pressed more than once
					B752_AP_Disengage_Button = 0
				else
				
				end
			-- ]],
			"",
			"")

		 

	
-- Sets the button for the A/P disengage
	set_button_assignment( (8*40) + 4, "linus/B752/AP_Disengage_button" )
--	set_button_assignment( (8*40) + 4, "1-sim/AP/comm/ap_disc" )




-- Start Speed Brake lever
-- Checks the state of the CFY Speed Brake Lever and adjusts the B752 Speed Brake Lever accordingly
	DataRef("SpeedBrakeLeverPos", "linus/CFY/SpoilerLever", "writeable", 0)
	B752_SpeedBrakeLeverPos = dataref_table("sim/flightmodel/controls/sbrkrqst")
	SpeedBrakeLeverPos = 0
	
	function updateB752SpeedBrakeLever()
--		print("SpeedBrakeLeverPos: " .. SpeedBrakeLeverPos .. ", B752: " .. B752_SpeedBrakeLeverPos[0] )

		B752_SpeedBrakeLeverPos[0] = (-0.000000000000454830629473323 * (SpeedBrakeLeverPos ^ 2))  + (0.0000610463332578886 * SpeedBrakeLeverPos)
	end
	do_every_frame("updateB752SpeedBrakeLever()")
-- End SpeedLeverPos

--Start XpndrMode
-- sets the transponder based on the setting selected on the OpenCockpit module
	DataRef("XpndrMode", "linus/CFY/XpndrMode", "readonly")
	B752_XpndrMode=dataref_table("1-sim/transponder/systemMode")
	function updateB752Xpndr()
		if B752_XpndrMode[0] ~= XpndrMode then
				B752_XpndrMode[0]= XpndrMode
		else
		
		end
		
	end
	do_often("updateB752Xpndr()")
--End XpndrMode




-- code for B752 taxi lights
-- first define the three lights here
	dataref("L_Rwy_turnoff", "1-sim/lights/runwayL/switch", "writeable")
	dataref("R_Rwy_turnoff", "1-sim/lights/runwayR/switch", "writeable")	
	define_shared_DataRef("linus/B752/TaxiLightsValue", "Int")
	TaxiL_value = dataref_table("linus/B752/TaxiLightsValue")
	-- at start all lights off
		TaxiL_value[0] = -1
		L_Rwy_turnoff = 0
		R_Rwy_turnoff = 0

--		rnoff = 0               **************************
		
	-- command for button
	create_command("linus/B752/ToggleTaxiLights","Toggle B752 Taxi Lights",
		[[if TaxiL_value[0] == -1 then
			L_Rwy_turnoff = 0
			R_Rwy_turnoff = 0
			
		else 	
			L_Rwy_turnoff = 1
			R_Rwy_turnoff = 1
		end
		TaxiL_value[0] = TaxiL_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 2, "linus/B752/ToggleTaxiLights" )
-- end B752 Taxi Lights code

-- code for B752 landing lights
-- first define the three lights here
	dataref("L_LandingLight", "1-sim/lights/landingL/switch", "writeable")
	dataref("N_LandingLight", "1-sim/lights/landingN/switch", "writeable")
	dataref("R_LandingLight", "1-sim/lights/landingR/switch", "writeable")
	define_shared_DataRef("linus/B752/LandingLightsValue","Int")
	LL_value = dataref_table("linus/B752/LandingLightsValue")
	-- at start all lights off
		LL_value[0] = -1
		L_LandingLight = 0
		N_LandingLight = 0
		R_LandingLight = 0
		
	-- command for button
	create_command("linus/B752/ToggleLandingLights","Toggle B752 Landing Lights",
		[[if LL_value[0] == -1 then
			L_LandingLight = 0
			N_LandingLight = 0
			R_LandingLight = 0
			
		else 	
			L_LandingLight = 1
			N_LandingLight = 1
			R_LandingLight = 1

		end
		LL_value[0] = LL_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 3, "linus/B752/ToggleLandingLights" )
-- end B752 Landing Lights code

--COMMENTED OUT 10/2/2018
--	set_button_assignment( (8*40) + 6, "sim/flight_controls/pitch_trim_down" )
--	set_button_assignment( (8*40) + 8, "sim/flight_controls/pitch_trim_up" )
--COMMENTED OUT 10/2/2018








-- code for B752 Altimeter Barometer Setting UP
-- first define the dataref
	dataref("BaroRotaryLeft", "1-sim/gauges/baroRotary_left", "writeable")
--		
--	-- command for button
--	create_command("linus/B752/BarometerUp","Increase Altimeter Barometer Setting",
--		[[
--		BaroRotaryLeft=BaroRotaryLeft + 0.001692
--		]],
--		"",
--		"")
--	-- button assignment
--	set_button_assignment( (0*40) + 29, "linus/B752/BarometerUp" )
-- end B752 Altimeter Barometer Setting Up code

-- code for B752 Altimeter Barometer Setting DOWN
-- first define the dataref
--	dataref("BaroRotaryRight", "1-sim/gauges/baroRotary_right", "writeable")
-- no need to define DataRef, using same as the up one
		
--	-- command for button
--	create_command("linus/B752/BarometerDown","Decrease Altimeter Barometer Setting",
--		[[
--		BaroRotaryLeft=BaroRotaryLeft - 0.001692
--		]],
--		"",
--		"")
--	-- button assignment
--	set_button_assignment( (0*40) + 30, "linus/B752/BarometerDown" )
-- end B752 Altimeter Barometer Setting Down code

-- code for B752 Altimeter Barometer Setting Match - Pilot and CoPilot
-- first define the dataref
	dataref("BaroRotaryRight", "1-sim/gauges/baroRotary_right", "writeable")

		
	-- command for button
	create_command("linus/B752/BarometerSync","Synchronize Altimeter Barometer Setting",
		[[
		BaroRotaryRight=BaroRotaryLeft
		]],
		"",
		"")
--	-- button assignment
	set_button_assignment( (0*40) + 2, "linus/B752/BarometerSync" )
-- end B752 Sync Altimeter Barometer Setting code



--BEGIN EFIS Integration
--EFIS has: Radio Altimeter, Baro/Radio selector, Baro altimeter setting, IN/HPA selector, Map mode, map range, VOR1/ADF1 switch, VOR2/ADF2 switch
--WXR, STA, WPT, ARPT, DATA, POS, TERR, FPV, METERS

-- EFIS Radio Altimeter
DataRef("EFIS_RALT","sim/cockpit/misc/radio_altimeter_minimum","readonly")
--DataRef("B752_RALT","1-sim/inst/HD/L","writeable")
DataRef("B752_RALT","1-sim/ndpanel/1/dhRotary","writeable")
EFIS_RALT_prev = EFIS_RALT

function CheckRALT()
	--if EFIST RALT changes then changes B757 RALT accordingly
	if EFIS_RALT ~= EFIS_RALT_prev then
		if EFIS_RALT == 0 then									--The RALT has been reset - so we reset as well
			B752_RALT = 0
			EFIS_RALT_prev = 0
		else													--Not a RALT reset so we continue
			B752_RALT = EFIS_RALT/1000
			EFIS_RALT_prev = EFIS_RALT
			
		end
	else
		-- no change - nothing to do
	end 
end
do_often("CheckRALT()")

-- EFIS Map Range knob
DataRef("B752_HSI_rng" ,"1-sim/ndpanel/1/hsiRangeRotary","writeable")		-- B752 HSI rng has 7 positions. 
DataRef("EFIS_HSI_rng","sim/cockpit2/EFIS/map_range","writeable")			-- EFIS rng has 8 positions

-- On start, make the B752 map range = EFIS map range
-- print("Start values: EFIS_HSI: " .. EFIS_HSI_rng .. ", B752_HSI: " .. B752_HSI_rng)
-- B752_HSI_rng = EFIS_HSI_rng
-- print("AfterStart values: EFIS_HSI: " .. EFIS_HSI_rng .. ", B752_HSI: " .. B752_HSI_rng)
function CheckEFIS_rng()
	--if EFIST RALT changes then changes B757 RALT accordingly
	if EFIS_HSI_rng ~= B752_HSI_rng then
		
		B752_HSI_rng = EFIS_HSI_rng
		print("EFIS_HSI: " .. EFIS_HSI_rng .. ", B752_HSI: " .. B752_HSI_rng)
			
	else
		-- no change - nothing to do
	end 
end
do_often ("CheckEFIS_rng()")


-- EFIS Map Mode knob
DataRef("B752_HSI_mode" ,"1-sim/ndpanel/1/hsiModeRotary","writeable")			-- B752 HSI mode has 6 positions. 0 = FULL ILS, 1 = FULL VOR, 2 = EXP ILS, 3 = EXP VOR, 4 = MAP, 5 = PLN
DataRef("EFIS_HSI_mode","sim/cockpit/switches/EFIS_map_submode","readonly")		-- EFIS HSI mode has 4 positions. 0 = APP, 1 = VOR, 2 = MAP, 4 = PLN

-- On start, make the B752 HSI mode = EFIS HSI mode
--B752_HSI_mode = EFIS_HSI_mode
EFIS_HSI_prev_mode = EFIS_HSI_mode

function CheckEFIS_mode()
	--if EFIS HSI mode changes then changes B757 HSI Mode accordingly
	if EFIS_HSI_mode ~= EFIS_HSI_prev_mode then
		-- there was a change. so now we interpret current value and adjust B752 accordingly
		if EFIS_HSI_mode == 0 then		-- APP mode
			B752_HSI_mode = 2
		
		elseif EFIS_HSI_mode == 1 then	-- VOR mode
			B752_HSI_mode = 3
		
		elseif EFIS_HSI_mode == 2 then	-- MAP mode
			B752_HSI_mode = 4
		
		elseif EFIS_HSI_mode == 4 then	-- PLN mode
			B752_HSI_mode = 5	
		
		end
		
		EFIS_HSI_prev_mode = EFIS_HSI_mode
		print("EFIS_HSI: " .. EFIS_HSI_mode .. ", EFIS_HSI_prev: " .. EFIS_HSI_prev_mode .. ", B752_HSI: " .. B752_HSI_mode)
			
	else
		-- no change - nothing to do
	end 
end
do_often ("CheckEFIS_mode()")

-- require "arcaze"	
	-- -- HID stuff here
	-- EFIS = hid_open(1240,62630)
	-- if EFIS == nil then
		-- print("Device not open :(")
	-- else
		-- print("YAY! Device DID open ")
	-- end
	
	-- local numvars
	-- local var1
	-- local var2
	-- local var3
	-- local var4
	-- --numvars,var1,var2,var3,var4=hid_read_timeout(EFIS,4,100)
	-- --print(var1 .. ", " .. var2 .. ", " .. var3 .. ", ")
	

end
