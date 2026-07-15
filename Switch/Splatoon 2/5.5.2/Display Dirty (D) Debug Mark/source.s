; Game: Splatoon 2
; Game version: 5.5.2
; Code: Display Dirty (D) Debug Mark


; Hooks are placed in unused functions because there is no space left in .text
; Format is: *ADDRESS IT IS HOOKED AT* -> BL *ADDRESS OF HOOK*


; The (D) text draw function was removed after 3.1.0
; This code recreates the (D) mark draw when debug features are used at least once

; DbgTextWriter functions were removed after 3.1.0, but there is TextWriter debug text present in the game.
; In gsys::SystemTask::invokeDrawTV_(agl::DrawContext *), there is some debug text that prints the TV draw information, such as the 
; resolution width, scale, color etc. Trying to call TextWriter print is way complicated because it requires creating 
; and ; calling so many things for it to work, and I wasn't even able to do it because of how it is handled. 
; So, I decided to make my own system by enabling the debug TV draw info, removing the info draw, and making my own
; hooks there since everything I need to draw is already present there

; Starlight does the same thing to draw text (Enables TV draw, removes info draw etc) so I made some modifications in the
; function to make my text drawingcompatible with Starlight draws

; Enable debug TV draw info
; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) +0x284
; 0x185153C -> NOP


; Change one of the texts to nothing, to avoid printing it (Can't kill the text draw call because Starlight writes to that address)
; So doing this for compatibility
; 024AB808 -> 00 (Null terminator on first character)


; Skip drawing rest of debug text, at this point in the function, Starlight already hooked past all text, adding this if Starlight is 
; not being used
; 01851658 -> B 0x185190C


; Print (D) Debug Mark if Dirty
; gsys::SystemTask::invokeDrawTV_(agl::DrawContext *) + 0x2D8
; 0x1851590 -> BL 0x185173C

MOV X26, SP

STP X29, X30, [SP, #-0x10]!

MOV X8, #0x3FC000003FC00000
STR X8, [X26, #0x458]

ADRP X8, #0x29E7000
LDRB W8, [X8, #0x15]
CBZ W8, end // ; Custom "dirty" bool not set

ADRP X8, #0x2CFE000
LDR X8, [X8, #0x440]
LDP X8, X9, [X8]
STR X8, [X26, #0x460]
STR X9, [X26, #0x468]

LDR X8, posX
STR X8, [X26, #0x450]

ADD X0, X26, #0x428
ADR X1, string
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C // ; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

ADR X8, colorRed
LDP X8, X9, [X8]
STR X8, [X26, #0x460]
STR X9, [X26, #0x468]

ADR X8, posX

// ; Offset text
FMOV S0, #-1.0
FMOV S1, #1.0

LDP S2, S3, [X8]
FADD S2, S2, S0
FADD S3, S3, S1
ADD X0, X26, #0x450
STP S2, S3, [X0]

ADD X0, X26, #0x428
ADR X1, string
MOV W2, #0xFFFFFFFF
MOV W3, #1
MOV X4, XZR
BL 0x174A91C // ; sead::TextWriter::printImpl_(char const*,int,bool,sead::BoundBox2<float> *)

end:
LDP X29, X30, [SP], #0x10
MOV X8, #0x3F8000003F800000 // ; Original instruction
RET

posX: .float -579
posY: .float 319

colorRed:
.float 1
.float 0
.float 0
.float 1

string: .asciz "(D)"