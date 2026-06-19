//; Game: Splatoon 2
//; Game version: 3.1.0
//; Code: Display Dirty (D) Debug Mark


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; gsys::SystemTask::invokeDrawTV_ + 0x30
//; 0x17BC7BC -> BL 0x1B610E0

//; The (D) text draw function (Cmn::DbgMenuUtl::Draw) is still in the game but it is never called. 
//; This code calls it every frame, however, the (D) mark will only show if the "dirty" flag is set
//; (Set when enabling debug features in the debug build, and in my retail reimplementations)

MOV X19, X0

STP X29, X30, [SP, #-0x10]!

MOV W0, #0x1E
BL 0x9C208 //; Cmn::DbgMenuUtl::Draw

LDP X29, X30, [SP], #0x10

MOV X0, X19
RET

//; Redirect call for stubbed debug text function to retail one (Not a hook)
//; Lp::Sys::DbgTextWriter::pilotDraw -> Lp::Sys::DbgTextWriter::productEntryF
//; 0009C330 -> BL 0x19BC22C
//; 0009C38C -> BL 0x19BC22C