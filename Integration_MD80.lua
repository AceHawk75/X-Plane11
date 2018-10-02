-- Rotate MD80 lua integration script
-- Started June 2018
-- re-written Sep 2018


if(PLANE_ICAO == "MD88") then
	--Field of view set for MD88
	FieldOfView = dataref_table("sim/graphics/view/field_of_view_deg")
	FieldOfView[0] = 69
	
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

-- code for MD88 landing lights
-- first define the three lights here
	dataref("L_LandingLight", "Rotate/md80/lights/wing_ldg_light_switch_l", "writeable")
	dataref("R_LandingLight", "Rotate/md80/lights/wing_ldg_light_switch_r", "writeable")
	define_shared_DataRef("linus/MD88/LandingLightsValue","Int")
	LL_value = dataref_table("linus/MD88/LandingLightsValue")
	-- at start all lights off
		LL_value[0] = -1
		L_LandingLight = 0
		R_LandingLight = 0
		
	-- command for button
	create_command("linus/MD88/ToggleLandingLights","Toggle MD88 Landing Lights",
		[[if LL_value[0] == -1 then
			L_LandingLight = 0
			R_LandingLight = 0
			
		else 	
			L_LandingLight = 2
			R_LandingLight = 2

		end
		LL_value[0] = LL_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 3, "linus/MD88/ToggleLandingLights" )
-- end MD88 Landing Lights code	
	
	
	
-- code for MD88 taxi lights
-- first define the three lights here
	dataref("MD88_taxi", "Rotate/md80/lights/nose_light_switch", "writeable")
	define_shared_DataRef("linus/MD88/TaxiLightsValue", "Int")
	TaxiL_value = dataref_table("linus/MD88/TaxiLightsValue")
	-- at start all lights off
		TaxiL_value[0] = -1
		MD88_taxi = 0

		
	-- command for button
	create_command("linus/MD88/ToggleTaxiLights","Toggle MD88 Taxi Lights",
		[[if TaxiL_value[0] == -1 then
			MD88_taxi = 0
			
			
		else 	
			MD88_taxi = 2
			
		end
		TaxiL_value[0] = TaxiL_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 2, "linus/MD88/ToggleTaxiLights" )
-- end MD88 Taxi Lights code


-- HAT views
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

-- Start StartLever1
-- Checks the state of the CFY Start Lever 1 and adjusts the MD88 Start Lever accordingly
	DataRef("StartLever1", "linus/CFY/StartLever1","writeable",0)
	MD88_StartLever1 = dataref_table("Rotate/md80/fuel/fuel_valve_ratio_l")
	StartLever1 = 0
	--	DataRef("MD88_StartLever1","Rotate/md80/fuel/fuel_valve_ratio_l","writeable",0)
-- 1 = on, 0 = off
--	EngRun = dataref_table("sim/flightmodel/engine/ENGN_running")
	function updateMD88StartLever1()
		--print("StartLever1: " .. StartLever1 .. ", MD88_StartLever1: " .. MD88_StartLever1[0] )
		if StartLever1 == 0 then
			MD88_StartLever1[0] = 0
		elseif StartLever1 > 0 then
			MD88_StartLever1[0] = 1
		end
	end
	do_often("updateMD88StartLever1()")
-- End StartLever1

-- Start StartLever2
-- Checks the state of the CFY Start Lever 2 and adjusts the MD88 Start Lever accordingly
	DataRef("StartLever2", "linus/CFY/StartLever2","writeable",0)
	MD88_StartLever2 = dataref_table("Rotate/md80/fuel/fuel_valve_ratio_r")
	StartLever2 = 0	
	--	EngRun = dataref_table("sim/flightmodel/engine/ENGN_running")
	function updateMD88StartLever2()
--		print("StartLever2: " .. StartLever2 .. ", MD88_StartLever2: " .. MD88_StartLever2[0] )
		if StartLever2 == 0 then
			MD88_StartLever2[1] = 0
		elseif StartLever2 > 0 then
			MD88_StartLever2[1] = 1
		end
	end
	do_often("updateMD88StartLever2()")
-- End StartLever2

-- Start FlapLeverPos
-- Checks the state of the CFY Flap Lever and adjusts the MD88 Flap Lever accordingly
--	DataRef("FlapLeverPos", "sim/multiplayer/controls/flap_request","readonly",0)
--	DataRef("FlapLeverPos", "sim/cockpit2/controls/flap_handle_deploy_ratio","readonly",0)
	DataRef("FlapLeverPos", "linus/CFY/FlapLever","readonly",0)
	MD88_FlapLeverPos = create_dataref_table("Rotate/md80/systems/flap_handle_drag_position_ratio", "Float")
	local FlapLever_MD88
--	FlapLever_MD88 = 0.0000608995 * FlapLeverPos + 0.000164376
--	FlapLever_MD88 = -2.81365e-9 * FlapLeverPos^2 + 0.000103263 * FlapLeverPos + 0.0579996
	function updateMD88FlapLever()
--		FlapLever_MD88 = 0.0000608995 * FlapLeverPos + 0.000164376
--		FlapLever_MD88 = -2.81365e-9 * FlapLeverPos^2 + 0.000103263 * FlapLeverPos + 0.0579996
		if FlapLever_MD88 ~= FlapLeverPos then
--			print("FlapLeverPos: " .. FlapLeverPos .. ", MD88_Flaps: " .. MD88_FlapLeverPos[0] .. ", FlapLever_MD88: " .. FlapLever_MD88)
--			MD88_FlapLeverPos[0] = FlapLever_MD88	
		
			--first, command a new flaps position accordingly
			if FlapLeverPos == 0 then
				-- flaps retracted. CFY = 0
				-- flaps MD88 = RET
				MD88_FlapLeverPos[0] = .1	
			
			elseif FlapLeverPos == 2047 then
				-- flaps CFY = 1
				-- flaps MD88 = T.O. 0
				MD88_FlapLeverPos[0] = .36	
			
			elseif FlapLeverPos == 4095 then
				-- flaps CFY = 2
				-- flaps MD88 = 11
				MD88_FlapLeverPos[0] = .54	
			
			elseif FlapLeverPos == 6143 then
				-- flaps CFY = 5
				-- flaps MD88 = 15
				MD88_FlapLeverPos[0] = .6	

			elseif FlapLeverPos == 8191 then
				-- flaps CFY = 10
				-- flaps MD88 = 28
				MD88_FlapLeverPos[0] = .75	

			elseif FlapLeverPos == 10239 then
				-- flaps CFY = 15
				-- flaps MD88 = 40
				MD88_FlapLeverPos[0] = .95	

			elseif FlapLeverPos == 14335 then
				-- flaps CFY = 25
				-- flaps MD88 = 40 (still)
				MD88_FlapLeverPos[0] = .95	

			elseif FlapLeverPos == 16383 then
				-- flaps CFY = 30
				-- flaps MD88 = 40 (still)
				MD88_FlapLeverPos[0] = .95	
			end
			
			--second, equalize the req and the position
			ReqFlaps = FlapLeverPos
			
		end
	end
	do_often("updateMD88FlapLever()")
-- End FlapLeverPos

-- Start Speed Brake lever
-- Checks the state of the CFY Speed Brake Lever and adjusts the MD88 Speed Brake Lever accordingly
	DataRef("SpeedBrakeLeverPos", "linus/CFY/SpoilerLever", "readonly", 0)
	MD88_SpeedBrakeLeverPos = create_dataref_table("Rotate/md80/systems/speedbrake_position","Int")
	function updateMD88SpeedBrakeLever()
--		print("SpeedBrakeLeverPos: " .. SpeedBrakeLeverPos .. ", MD88: " .. MD88_SpeedBrakeLeverPos[0] )
		MD88_SpeedBrakeLeverPos[0] = 0.0002442 * SpeedBrakeLeverPos
	end
	do_every_frame("updateMD88SpeedBrakeLever()")
-- End SpeedLeverPos

-- code for MD88 AutoThrottle switch
-- first define the switch
	dataref("AT_arm_sw", "Rotate/md80/autopilot/at_switch", "writeable")
-- define the other A/T stuff here
	XP_AT_Enabled = dataref_table("sim/cockpit2/autopilot/autothrottle_enabled")
--	AT_ThrottlePos1 = dataref_table("sim/cockpit2/engine/actuators/throttle_ratio")
--	IXEG_ThrottleLeverPos1 = dataref_table("ixeg/733/engine/eng1_thro_angle")
	
-- define the value state	
	define_shared_DataRef("linus/MD88/ATValue","Int")
	AT_value = dataref_table("linus/MD88/ATValue")
	-- at start, AT off
		AT_value[0] = -1
		AT_Disen_MD88 = 0
		
	-- command for button
	create_command("linus/MD88/ToggleAutoThrottle","Toggle MD88 AutoThrottle",
		[[if AT_value[0] == -1 then
			AT_arm_sw = 0
			XP_AT_Enabled[0] = 0
			
		else 	
			AT_arm_sw = 1
			-- insert the code to arm the AT here
			XP_AT_Enabled[0] = 1
			AT_Disen_MD88 = 1

		end
		AT_value[0] = AT_value[0] *-1]],
		"",
		"")
	-- button assignment
	set_button_assignment( (8*40) + 14, "linus/MD88/ToggleAutoThrottle" )
-- end MD88 Auto Throttle switch

-- code for MD88 AutoPilot switch
	-- button assignment
	set_button_assignment( (8*40) + 16, "Rotate/md80/autopilot/ap_toggle" )
-- end MD88 AutoPilot switch



-- Start AT_Disengage
-- Checks the state of the CFY AT Disengage and adjusts the MD88 A/T State accordingly
-- we should change this to a command instead
	dataref("AT_Disen_MD88","linus/CFY/ATDisen","writeable",0)
	dataref("MD88_ATDisc_light","Rotate/md80/autopilot/at_disc_active","writeable")

	function updateMD88ATDisen()
--		print("ATDisen: " .. ATDisen .. ", MD88_AT_Switch: " .. AT_Disen_MD88 )
		if AT_Disen_MD88 == 0 then

			--command_once("linus/MD88/ToggleAutoThrottle")
			command_once("Rotate/md80/autopilot/at_disc")
			AT_arm_sw = 0
--			command_once("linus/MD88/ToggleAutoThrottle")
			MD88_ATDisc_light = 1
--			AT_value[0] = -1
			AT_Disen_MD88 = 1

		end
	end
	do_often("updateMD88ATDisen()")

	-- End AT_Disengage

	
-- Start TOGA_Engage
-- Checks the state of the CFY TOGA Engage and commands TOGA accordingly
--	dataref("TOGA_MD88","linus/CFY/TOGASen","writeable",0)
--	dataref("MD88_ATDisc_light","Rotate/md80/autopilot/at_disc_active","writeable")
--	function updateMD88TOGASen()
--		print("TOGASen: " .. TOGA_MD88 .. ", MD88_AT_Switch: " .. AT_Disen_MD88 )
--		if TOGA_MD88 == 0 then

			--command_once("linus/MD88/ToggleAutoThrottle")
--			command_once("Rotate/md80/autopilot/to_ga_button")
--			AT_arm_sw = 0
--			command_once("linus/MD88/ToggleAutoThrottle")
--			MD88_ATDisc_light = 1
--			AT_value[0] = -1
--			TOGA_MD88 = 1
--
--		end
--	end
--	do_often("updateMD88TOGASen()")
-- End TOGA_Engage


--	set_button_assignment( (8*40) + 6, "sim/flight_controls/pitch_trim_down" )
--	set_button_assignment( (8*40) + 8, "sim/flight_controls/pitch_trim_up" )
	set_button_assignment( (8*40) + 8, "Rotate/md80/systems/v_trim_handle_up")
	set_button_assignment( (8*40) + 6, "Rotate/md80/systems/v_trim_handle_dn" )

--  mod 9/21/22 Giving up on the trim control. seems to be fine with just controling the handles with the button and the CFY
--  handling the rest via A/P control

--	DataRef("MD88_ElevatorTrim", "sim/flightmodel/controls/elv_trim")
--	DataRef("ElevatorTrimValue", "linus/CFY/ElevatorTrimValue", "writeable")
--	DataRef("TrimIndic", "linus/CFY/ElevatorTrimIndic","writeable")
--	DataRef("ElevatorTrimControl", "linus/CFY/ElevatorTrimControl", "writeable")
--	function MD88ElevatorTrim()
--		print("ElevatorTrimvalue: " .. ElevatorTrimValue .. ", TrimControl: " .. ElevatorTrimControl .. ", MD88Elevator: " .. MD88_ElevatorTrim)
--		local InterpretTrim
--		InterpretTrim = (MD88_ElevatorTrim * 26639) - 10256
--		InterpretTrim = (ElevatorTrimValue * 0.0000375389) + 0.385 
--		InterpretTrim = (ElevatorTrimValue * 0.0000282501) + 0.254232
--		ElevatorTrimValue = InterpretTrim
--		ElevatorTrimValue = (MD88_ElevatorTrim * 26639) - 10256
--		print("MD88_ElevatorTrim: " .. MD88_ElevatorTrim .. ", ElevatorTrimvalue: " .. ElevatorTrimValue .. ", interpreted: " .. InterpretTrim .. ", Indic: " .. TrimIndic)
--		print("MD88_ElevatorTrim: " .. MD88_ElevatorTrim .. ", ElevatorTrimvalue: " .. ElevatorTrimValue .. ", Indicator: " .. TrimIndic)

--	end
--	do_often ("MD88ElevatorTrim()")

-- Test a dataref / XPUIPC value
-- prints a dataref representing a test XPUIPC value continuously

	DataRef("XPUIPC_Value", "linus/CFY/ElevatorTrimValue", "writeable")
	function printXPUIPC()
--		print("XPUIPC_VALUE: " .. XPUIPC_Value)
	end
	do_often("printXPUIPC()")
-- End Test a dataref

--Start XpndrMode
-- sets the transponder based on the setting selected on the OpenCockpit module
	DataRef("XpndrMode_val", "linus/CFY/XpndrMode", "readonly")
	MD88_XpndrMode=dataref_table("Rotate/md80/instruments/transponder_mode_switch")
	function updateMD88Xpndr()
		-- MD88 xpndr has different detents than 737 - so we interpret the values for each stop and translate for MD88
		local XpndrMode
		if XpndrMode_val == 1 then
			XpndrMode = 1
		elseif XpndrMode_val == 2 then
			XpndrMode = 0
		elseif XpndrMode_val == 3 then
			XpndrMode = 4
		elseif XpndrMode_val == 4 then
			XpndrMode = 3
		elseif XpndrMode_val == 5 then
			XpndrMode = 2
		end
		
		--XpndrMode now has the interpreted value
		
		if MD88_XpndrMode[0] ~= XpndrMode  then
				MD88_XpndrMode[0]= XpndrMode 
		else
		
		end
		
	end
	do_sometimes("updateMD88Xpndr()")
--End XpndrMode

	--Start Parking Brake update
	--Updates the cockpit MD88 Parking Brake button when CFY PB latch is engaged
	DataRef("ParkingBrakeLatch", "sim/flightmodel/controls/parkbrake","readonly")
	MD88_ParkBrakeButton = dataref_table("Rotate/md80/systems/parking_brake_toggle_clicked")
	function updateMD88ParkBrakeButton()
		if ParkingBrakeLatch ~= MD88_ParkBrakeButton then
			MD88_ParkBrakeButton[0] = ParkingBrakeLatch
		end
	end
	do_sometimes("updateMD88ParkBrakeButton()")
end