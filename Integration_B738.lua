-- B737-800 Zibo Mod lua integration script
-- Started June 2018
-- re-written Sep 2018

if (PLANE_ICAO =="B738") then
--Field of view set for MD88
	FieldOfView = dataref_table("sim/graphics/view/field_of_view_deg")
	FieldOfView[0] = 87
	
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

-- HAT views
	set_button_assignment( (8*40) + 19, "sim/general/rot_up" )
	set_button_assignment( (8*40) + 20, "sim/general/hat_switch_up_right" )
	set_button_assignment( (8*40) + 21, "sim/general/rot_right" )
	set_button_assignment( (8*40) + 22, "sim/general/hat_switch_down_right" )
	set_button_assignment( (8*40) + 23, "sim/general/rot_down" )
	set_button_assignment( (8*40) + 24, "sim/general/hat_switch_down_left" )
	set_button_assignment( (8*40) + 25, "sim/general/rot_left" )
	set_button_assignment( (8*40) + 26, "sim/general/hat_switch_up_left" )	
	
-- Flap settings B738	
	dataref("FlapLeverPos", "linus/CFY/FlapLever","readonly",0)
	B738_FlapLeverPos = create_dataref_table("laminar/B738/axis/flap_lever","Float")
--	DataRef("B738_FlapLeverPos", "laminar/B738/axis/flap_lever","writeable")
	local ReqFlaps = 0
--	B738_FlapLeverPos[0] = 1
	function updateB738FlapLever()
		if FlapLeverPos ~= ReqFlaps then		--lever position changed	
			--first, command a new flaps position accordingly
			if FlapLeverPos == 0 then
				-- flaps retracted. CFY = 0
				command_once("laminar/B738/push_button/flaps_0")
			
			elseif FlapLeverPos == 2047 then
				-- flaps CFY = 1
				command_once("laminar/B738/push_button/flaps_1")
			
			elseif FlapLeverPos == 4095 then
				-- flaps CFY = 2
				command_once("laminar/B738/push_button/flaps_2")
			
			elseif FlapLeverPos == 6143 then
				-- flaps CFY = 5
				command_once("laminar/B738/push_button/flaps_5")

			elseif FlapLeverPos == 8191 then
				-- flaps CFY = 10
				command_once("laminar/B738/push_button/flaps_10")

			elseif FlapLeverPos == 10239 then
				-- flaps CFY = 15
				command_once("laminar/B738/push_button/flaps_15")

			elseif FlapLeverPos == 14335 then
				-- flaps CFY = 25
				command_once("laminar/B738/push_button/flaps_25")

			elseif FlapLeverPos == 16383 then
				-- flaps CFY = 30
				command_once("laminar/B738/push_button/flaps_40")
			end
--			elseif FlapLeverPos == 8191 then
--				command_once("laminar/B738/push_button/flaps_10")
--			end
			
			
			--second, equalize the req and the position
			ReqFlaps = FlapLeverPos
		end
--		print("FlapLeverPos: " .. FlapLeverPos .. ", calc: " .. ReqFlaps)
	end
	
	
	
	do_often("updateB738FlapLever()")
-- End FlapLeverPos

-- Start StartLever1
-- Checks the state of the CFY Start Lever 1 and adjusts the B737-800X Start Lever accordingly
	DataRef("StartLever1", "linus/CFY/StartLever1","writeable",0)
--	B738_StartLever1 = dataref_table("laminar/B738/engine/mixture_ratio1","Int")
	local ReqCutOff1
	--	DataRef("B738_StartLever1", "laminar/B738/engine/mixture_ratio1","writeable")

	function updateB738StartLever1()
--		print("StartLever1: " .. StartLever1 .. ", B738_StartLever1: " .. B738_StartLever1[0] )

		if StartLever1 ~= ReqCutOff1 then			--lever position changed
			--first, command the new position accordingly
			if StartLever1 == 0  then
				command_once("laminar/B738/engine/mixture1_cutoff")
			
			elseif StartLever1 > 0 then
				command_once("laminar/B738/engine/mixture1_idle")
			end

		end
		--second, equalize the req and the position
		ReqCutOff1 = StartLever1
		
	end
	do_often("updateB738StartLever1()")
-- End StartLever1

-- Start StartLever2
-- Checks the state of the CFY Start Lever 2 and adjusts the B737-800X Start Lever accordingly
	DataRef("StartLever2", "linus/CFY/StartLever2","writeable",0)
--	B738_StartLever2 = dataref_table("laminar/B738/engine/mixture_ratio2","Int")
	local ReqCutOff2
	--	DataRef("B738_StartLever2", "laminar/B738/engine/mixture_ratio2","writeable")

	function updateB738StartLever2()
--		print("StartLever2: " .. StartLever2 .. ", B738_StartLever2: " .. B738_StartLever2[0] )

		if StartLever2 ~= ReqCutOff2 then			--lever position changed
			--first, command the new position accordingly
			if StartLever2 == 0  then
				command_once("laminar/B738/engine/mixture2_cutoff")
			
			elseif StartLever2 > 0 then
				command_once("laminar/B738/engine/mixture2_idle")
			end

		end
		--second, equalize the req and the position
		ReqCutOff2 = StartLever2
		
	end
	do_often("updateB738StartLever2()")
-- End StartLever2

end


