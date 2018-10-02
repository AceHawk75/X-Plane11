-- X-Aviation B757-200 lua integration script
-- re-written Sep 2018


if (PLANE_ICAO =="B752") then
--Field of view set for MD88
	FieldOfView = dataref_table("sim/graphics/view/field_of_view_deg")
	FieldOfView[0] = 75

-- Start Override Throttle off
-- Turns off the override of the throttles
	Override_Throttle = dataref_table("sim/operation/override/override_throttles")
	function FxOverrideThrottles ()
		if Override_Throttle[0] ~= 0 then
			Override_Throttle[0] = 0
		end
	--print(Override_Throttle[0])
	end
	do_often("FxOverrideThrottles()")
-- End Override Throttle off

--Start MouseHandler always on
--	MouseHandler = dataref_table("mh/mouse_handler_on_window")
--	function MouseHandlerOn()
--		if MouseHandler[0] == 0 then
--			MouseHandler[0] = 1
--		end
--	end
--	do_every_frame("MouseHandlerOn()")


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


-- Start AT_Disengage
-- Checks the state of the CFY AT Disengage and adjusts the B757-200 A/T State accordingly
	dataref("AT_Disen_752","linus/CFY/ATDisen","writeable",0)
	
	function updateB752ATDisen()
--		print("ATDisen: " .. ATDisen .. ", B752_AT_Switch: " .. AT_Disen_752 )
		if AT_Disen_752 == 0 then
	--		AT_arm_sw = 0
	--		XP_AT_Enabled[0] = 0
	--		AT_Value[0] = -1
	--		AT_arm_sw = 0
	--		XP_AT_Enabled[0] = 0
			command_once("linus/B752/ToggleAutoThrottle")
			AT_Disen_752 = 1
		end
	end
	do_often("updateB752ATDisen()")
-- End AT_Disengage

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

	set_button_assignment( (8*40) + 6, "sim/flight_controls/pitch_trim_down" )
	set_button_assignment( (8*40) + 8, "sim/flight_controls/pitch_trim_up" )


-- code for B752 AutoThrottle switch
-- first define the switch
	dataref("AT_arm_sw", "1-sim/AP/atSwitcher", "writeable")  -- 0 = on, 1 = OFF
-- define the other A/T stuff here
	XP_AT_Enabled = dataref_table("sim/cockpit2/autopilot/autothrottle_enabled")
	AT_SPD = dataref_table("1-sim/AP/spdButton")
	
-- define the value state	
	define_shared_DataRef("linus/B752/ATValue","Int")
	AT_value = dataref_table("linus/B752/ATValue")
	-- at start, AT off
		AT_value[0] = -1
		AT_arm_sw = 1
		XP_AT_Enabled[0] = 0
		AT_Disen_752 = 1
	
	-- command for button
	create_command("linus/B752/ToggleAutoThrottle","Toggle B752 AutoThrottle",
		[[if AT_value[0] == -1 then		
			-- set AutoThrottle = off
			--AT_arm_sw = 1
			XP_AT_Enabled[0] = 0
			-- turn off the A/T buttons before the A/T switch!
			AT_FLCH[0] = 0
			AT_SPD[0] = 0
			AT_VNAV[0] = 0
			AT_arm_sw = 1
			AT_Disen_752 = 1
		else 	
			-- set AutoThrottle = on
			AT_arm_sw = 0
			-- insert the code to arm the AT here
			if AT_FLCH[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
			if AT_SPD[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
			if AT_VNAV[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
			AT_Disen_752 = 1
		end
		AT_value[0] = AT_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 14, "linus/B752/ToggleAutoThrottle" )
-- end B752 Auto Throttle switch

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


	-- B752 A/T FLCH switch and CFY
	--IF A/T is on then 
		--If FLCH is turned on, we want AT to remain on (AND CFY to continue working)
	--ELSE
	--	We want FLCH to turn off 
	--dataref("AT_FLCH","1-sim/AP/flchButton","readonly")
	AT_FLCH = dataref_table("1-sim/AP/flchButton")
	function CheckFLCH()
		if AT_arm_sw == 0 then
			if	AT_FLCH[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
		else
			AT_FLCH[0] = 0
		end
	end
	do_often ("CheckFLCH()")
	-- end FLCH

	-- B752 A/T VNAV switch and CFY
	-- If VNAV is turned on, we want AT to remain on (AND CFY to continue working)
	--dataref("AT_VNAV","1-sim/AP/vnavButton","readonly")
	AT_VNAV = dataref_table("1-sim/AP/vnavButton")
	function CheckVNAV()
		if AT_arm_sw == 0 then
			if	AT_VNAV[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
		end
	end
	do_often ("CheckVNAV()")
	-- end VNAV check

	-- B752 A/T SPD switch and CFY
	-- If SPD is turned on, we want AT to remain on (AND CFY to continue working)
	--dataref("AT_VNAV","1-sim/AP/vnavButton","readonly")
	function CheckSPD()
		if AT_arm_sw == 0 then
			if	AT_SPD[0] == 1 then
				XP_AT_Enabled[0] = 1
			end
		else	
			AT_SPD[0] = 0
		end
	end
	do_often ("CheckSPD()")
	-- end VNAV check


--set_button_assignment( (8*40) + 14, "sim/autopilot/autothrottle_toggle" )

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

end
