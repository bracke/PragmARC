-- PragmAda Reusable Component (PragmARC)
-- Copyright (C) 2024 by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Parse a String into fields based on a separator Character
--
-- History:
-- 2024 Aug 15     J. Carter          V1.1--Eliminated Raw
-- 2022 Aug 01     J. Carter          V1.0--Initial version
--
pragma Assertion_Policy (Check);
pragma Unsuppress (All_Checks);

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package PragmARC.Line_Fields is
   package Field_Lists is new Ada.Containers.Vectors
      (Index_Type => Positive, Element_Type => Ada.Strings.Unbounded.Unbounded_String, "=" => Ada.Strings.Unbounded."=");

   subtype Field_List is Field_Lists.Vector;

   function Parsed (Line : String; Separator : Character := ' ') return Field_List;
   -- Presumes that Line consists of fields speparated by Separator
   -- If Separator = ' ', then fields are separated by 1 or more spaces; otherwise, they are separated by exactly 1 Separator
   -- Handles quoted field surrounded by quotation marks (") that may contain Separator. The surrounding quotation marks are
   -- removed and any doubled quotation marks ("") are converted to single quotation marks. Any field containing quotation marks
   -- must have an even number of quotation marks or Constraint_Error will be raised
   -- The result contains the fields parsed out of Line
end PragmARC.Line_Fields;
