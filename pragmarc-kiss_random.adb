-- History:
-- 2013 Aug 01     J. Carter     v1.0--Initial release

with Ada.Calendar;
with PragmARC.Date_Handler;

package body PragmARC.KISS_Random is
   use type Raw_Value;

   procedure Set_Seed (State : in out Generator;
                       New_W : in     Raw_Value    := Default_W;
                       New_X : in     Positive_Raw := Default_X;
                       New_Y : in     Positive_Raw := Default_Y;
                       New_Z : in     Positive_Raw := Default_Z)
   is
      -- null;
   begin -- Set_Seed
      State.W := New_W;
      State.X := New_X;
      State.Y := New_Y;
      State.Z := New_Z;
   end Set_Seed;

   procedure Randomize (State : in out Generator) is
      Year        : Ada.Calendar.Year_Number;
      Month       : Ada.Calendar.Month_Number;
      Day         : Ada.Calendar.Day_Number;
      Day_Seconds : Ada.Calendar.Day_Duration;
      Hour        : Natural;
      Minute      : Natural;
      Seconds     : Natural;
      Hundredths  : Natural;
   begin -- Randomize
      PragmARC.Date_Handler.Split (Date    => Ada.Calendar.Clock,
                                   Year    => Year,
                                   Month   => Month,
                                   Day     => Day,
                                   Hour    => Hour,
                                   Minute  => Minute,
                                   Seconds => Day_Seconds);

      Hour := Integer'Max (Hour, 1);
      Minute := Integer'Max (Minute, 1);
      Seconds := Integer (Day_Seconds);

      if Duration (Seconds) > Day_Seconds then
         Seconds := Seconds - 1;
      end if;

      Day_Seconds := Day_Seconds - Duration (Seconds);
      Seconds := Integer'Max (Seconds, 1);
      Hundredths := Integer'Max (Integer (100.0 * Day_Seconds), 1);

      Set_Seed (State => State,
                New_W => Raw_Value (Year * Hour),
                New_X => Raw_Value (Year * Minute),
                New_Y => Raw_Value (Year * Seconds),
                New_Z => Raw_Value (Year * Hundredths) );
   end Randomize;

   function Raw (State : in Generator) return Raw_Value is
      function ML (Value : in Raw_Value; Shift : in Natural) return Raw_Value;
      -- Returns Value xor Shift_Left (Value, Shift)

      function MR (Value : in Raw_Value; Shift : in Natural) return Raw_Value;
      -- Returns Value xor Shift_Right (Value, Shift)

      function ML (Value : in Raw_Value; Shift : in Natural) return Raw_Value is
         -- null;
      begin -- ML
         return Value xor Interfaces.Shift_Left (Value, Shift);
      end ML;

      function MR (Value : in Raw_Value; Shift : in Natural) return Raw_Value is
         -- null;
      begin -- MR
         return Value xor Interfaces.Shift_Right (Value, Shift);
      end MR;

      S : Generator renames State.Handle.State.all;
   begin -- Raw
      S.W := 30903 * (S.W and 65535) + Interfaces.Shift_Right (S.W, 16);
      S.X := 69069 * S.X + 1327217885;
      S.Y := ML (MR (ML (S.Y, 13), 17), 5);
      S.Z := 18000 * (S.Z and 65535) + Interfaces.Shift_Right (S.Z, 16);

      return S.X + S.Y + Interfaces.Shift_Left (S.Z, 16) + S.W;
   end Raw;

   function Random_Range (State : in Generator; Min : in Raw_Value; Max : in Raw_Value) return Raw_Value is
      Min_Work : constant Raw_Value := Raw_Value'Min (Min, Max);
      Max_Work : constant Raw_Value := Raw_Value'Max (Min, Max);

      Spread : constant Raw_Value := Max_Work - Min_Work + 1;
   begin -- Random_Range
      if Spread = 0 then
         return Raw (State);
      end if;

      return Min_Work + Raw (State) rem Spread;
   end Random_Range;

   package body Real_Values is
      function Random (State : in Generator) return Real is
         -- null;
      begin -- Random
         return Real (Raw (State) ) / Real (Raw_Value'Modulus);
      end Random;

      function Random_Range (State : in Generator; Min : in Real; Max : in Real) return Real is
         -- null;
      begin -- Random_Range
         return Random (State) * (Max - Min) + Min;
      end Random_Range;

      function Normal (State : in Generator; Mean : in Real; Sigma : in Real) return Real is
         Sum : Real := 0.0;
      begin -- Normal
         Add : for I in 1 .. 12 loop
            Sum := Sum + Random (State);
         end loop Add;

         return Sigma * (Sum - 6.0) + Mean;
      end Normal;
   end Real_Values;
end PragmARC.KISS_Random;
