//; Game: Splatoon 2
//; Game version: Global Testfire
//; Code: Display Dirty (D) Debug Mark


//; Hooks are placed in unused functions because there is no space left in .text
//; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


//; gsys::SystemTask::invokeDrawTV_ + 0x24
//; 0xE7BBA8 -> BL 0x1180820

//; The (D) text draw function (Cmn::DbgMenuUtl::Draw) is still in the game but it is never called. 
//; This code calls it every frame, however, the (D) mark will only show if the "dirty" flag is set
//; (Set when enabling debug features in the debug build, and in my retail reimplementations)

MOV X19, X0

STP X29, X30, [SP, #-0x10]!

MOV W0, #0x1E
BL 0x6F25C //; Cmn::DbgMenuUtl::Draw

LDP X29, X30, [SP], #0x10

MOV X0, X19
RET

//; Redirect call for stubbed debug text function to retail one (Not a hook)
//; Lp::Sys::DbgTextWriter::pilotDraw -> Lp::Sys::DbgTextWriter::productEntryF
//; 0x6F384 BL 0xFF9EC8
//; 0x6F3E0 BL 0xFF9EC8