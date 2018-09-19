# X-Plane11
General X-Plane 11 hardware scripts integration
====================================================
The integration of Cockpit For You throttle quadrant and Xplane11 for each aircraft depends on the close
operation of XPUIPC mapping of Offsets to Datarefs. Any changes to said datarefs is then interpreted via FlywithLua code
to then actuate systems/instruments/controls/buttons on each aircraft.
So for each integration task we will find a corresponding XPUIPC.CFG section and a .lua code section. Both need to be implemented for 
the solution to work.
