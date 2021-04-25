-- PragmAda Reusable Component (PragmARC)
-- Copyright (C) 2021 by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- History:
-- 2021 May 01     J. Carter          V2.2--Adhere to coding standard
-- 2021 Jan 01     J. Carter          V2.1--Removed Assign
-- 2020 Nov 01     J. Carter          V2.0--Initial Ada-12 version
----------------------------------------------------------------------------
-- 2018 Aug 01     J. Carter          V1.2--Cleanup compiler warnings
-- 2016 Jun 01     J. Carter          V1.1--Changed comment for empty declarative part
-- 2013 Mar 01     J. Carter          V1.0--Initial Ada-07 version
---------------------------------------------------------------------------------------------------
-- 2002 Oct 01     J. Carter          V2.1--Added Context to Iterate; use mode out to allow scalars
-- 2002 May 01     J. Carter          V2.0--Added Assign; implemented using PragmARC.List_Bounded_Unprotected
-- 2001 Jun 01     J. Carter          V1.1--Added Peek
-- 2000 May 01     J. Carter          V1.0--Initial release
--
package body PragmARC.Data_Structures.Queues.Bounded.Unprotected is
   procedure Clear (Queue : in out Handle) is
      -- Empty
   begin -- Clear
      Queue.List.Clear;
   end Clear;

   procedure Put (Into : in out Handle; Item : in Element) is
      -- Empty
   begin -- Put
      Into.List.Append (New_Item => Item);
   end Put;

   procedure Get (From : in out Handle; Item : out Element) is
      -- Empty
   begin -- Get
      Item := From.List.First_Element;
      From.List.Delete_First;
   end Get;

   use type Ada.Containers.Count_Type;

   function Is_Full (Queue : in Handle) return Boolean is
      (Queue.List.Length = Queue.List.Capacity);

   function Is_Empty (Queue : in Handle) return Boolean is
      (Queue.List.Is_Empty);

   function Length (Queue : in Handle) return Natural is
      (Integer (Queue.List.Length) );

   function Peek (Queue : in Handle) return Element is
      (Queue.List.First_Element);

   procedure Iterate (Over : in out Handle) is
      procedure Action (Pos : in Implementation.Cursor) is
         -- Empty
      begin -- Action
         Action (Item => Implementation.Element (Pos) );
      end Action;
   begin -- Interate
      Over.List.Iterate (Process => Action'Access);
   end Iterate;
end PragmARC.Data_Structures.Queues.Bounded.Unprotected;
