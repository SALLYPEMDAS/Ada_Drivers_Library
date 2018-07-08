------------------------------------------------------------------------------
--                                                                          --
--                        Copyright (C) 2018, AdaCore                       --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with System;
with HAL;        use HAL;
with HAL.Bitmap; use HAL.Bitmap;

package Numworks.Display is

   Width  : constant := 320;
   Height : constant := 240;

   procedure Set_Drawing_Area (Area : Rect);

   procedure Start_Pixel_Write;

   procedure Push_Pixel (Pixel : HAL.UInt16);

   procedure Push_Pixels (Pixels       : HAL.UInt16_Array;
                          DMA_Theshold : Natural := 256);

   procedure Wait_End_Of_Push;
private

   type Command is (Nop,
                    Reset,
                    Sleep_In,
                    Sleep_Out,
                    Display_Off,
                    Display_On,
                    Column_Address_Set,
                    Page_Address_Set,
                    Memory_Write,
                    Memory_Read,
                    Tearing_Effect_Line_On,
                    Memory_Access_Control,
                    Pixel_Format_Set,
                    Frame_Rate_Control
                   ) with Size => 16, Volatile_Full_Access;

   for Command use (Nop                    => 16#00#,
                    Reset                  => 16#01#,
                    Sleep_In               => 16#10#,
                    Sleep_Out              => 16#11#,
                    Display_Off            => 16#28#,
                    Display_On             => 16#29#,
                    Column_Address_Set     => 16#2A#,
                    Page_Address_Set       => 16#2B#,
                    Memory_Write           => 16#2C#,
                    Memory_Read            => 16#2E#,
                    Tearing_Effect_Line_On => 16#35#,
                    Memory_Access_Control  => 16#36#,
                    Pixel_Format_Set       => 16#3A#,
                    Frame_Rate_Control     => 16#C6#);

   procedure Send_Command (Cmd  : Command;
                           Data : UInt8_Array := (1 .. 0 => 0))
     with Inline;
   procedure Send_Command (Cmd  : Command;
                           Data : UInt8)
     with Inline;

   procedure Start_DMA_Transfer (Addr  : System.Address;
                                 Count : UInt16);
   procedure Wait_DMA_Transfer;

end Numworks.Display;
