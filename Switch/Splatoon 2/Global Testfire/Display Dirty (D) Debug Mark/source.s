//; Game: Splatoon 2
//; Game version: Global Testfire
//; Code: Display Dirty (D) Debug Mark


//; Hooks are written over unused functions (never executed).
//; There is a bit of free space in .text, but for some reason the emulator
//; crashes when executing code in that space. Writing over unused functions
//; doesn't cause a crash.


//; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x24
//; 0xE7BBA8 -> BL 0x1180820

//; The (D) text draw function (Cmn::DbgMenuUtl::Draw(agl::lyr::RenderInfo const&)) is still in the game but it is never called. 
//; This code calls it every frame, however, the (D) mark will only show if the "dirty" flag is set
//; (Set when enabling debug features in the debug build, and in my retail reimplementations)

MOV X19, X0

STP X29, X30, [SP, #-0x10]!

MOV W0, #0x1E
BL 0x6F25C //; Cmn::DbgMenuUtl::Draw(agl::lyr::RenderInfo const&)

LDP X29, X30, [SP], #0x10

MOV X0, X19
RET

//; Redirect call for stubbed debug text function to retail one (Not a hook)
//; Lp::Sys::DbgTextWriter::pilotDraw -> Lp::Sys::DbgTextWriter::productEntryF(int, sead::Vector2<float> const&, Lp::Sys::DbgTextWriter::ArgEx const*, char const*, ...)
//; 0x6F384 -> BL 0xFF9EC8
//; 0x6F3E0 -> BL 0xFF9EC8