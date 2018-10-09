# X-Plane11
General X-Plane 11 hardware scripts integration
====================================================
The integration of Cockpit For You throttle quadrant and Xplane11 for each aircraft depends on the close
operation of XPUIPC mapping of Offsets to Datarefs. Any changes to said datarefs is then interpreted via FlywithLua code
to then actuate systems/instruments/controls/buttons on each aircraft.
So for each integration task we will find a corresponding XPUIPC.CFG section and a .lua code section. Both need to be implemented for 
the solution to work.

October 2018 adding the integration of Virtual Avionics MCP and EFIS modules to the project.

Acronyms used: 
Hardware
CFY:    Cockpit for You. Used when referring to the Throttle Quadrant (TQ) hardware.(www.cockpitforyou.com)
MCP:
EFIS:

Software
XPUIPC: FSUIPC "emulator" for Xplane.
B752
B738
B737IXEG
MD88


Often times the work is a cat and mouse game.
We have to decide who to follow when a change is made. Hardware, Xplane or the aircraft.
- Sometimes the aircraft is the driver
- Sometimes CFY updates Xplane datarefs and then we have to update aircraft datarefs
- Sometimes we have to capture the offset change and update an aircraft dataref
