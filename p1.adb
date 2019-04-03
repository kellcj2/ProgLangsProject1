-- Author:        Christopher J. Kelly
-- Creation Date: 2/6/2019
-- Due Date:      2/13/2019
-- Course:        CSC 310
-- Professor:     Spiegel
-- Assignment:    #1
-- Filename:      p1.adb
-- Purpose:       Prompts user with menu, which gives options for handling
--                an integer array. Keeps array in sorted order.
WITH Text_IO;
WITH Ada.Characters.Handling;
USE Text_IO;
USE Ada.Characters.Handling;

PROCEDURE p1 IS

   PACKAGE Num IS NEW Integer_IO(Integer);
   PACKAGE Real IS NEW Float_IO(Float);
   USE Num;
   USE Real;

   Min                       : CONSTANT Integer := 1;
   Max                       : CONSTANT Integer := 10;
   TYPE IntList IS ARRAY (Min .. Max) OF Integer;

   List                      : IntList := (OTHERS => 0); -- initialize all to 0
   Count                     : Integer := 0;             -- num Elements in list


   -- Procedure Name: PrintList
   -- Description:    Prints the integer list to the screen
   -- Parameters:     IList IN IntList - list to be printed
   --                 Num IN Integer   - number of elements in list
   -- Return:         N/A
   PROCEDURE PrintList(IList: IN IntList; Num: IN Integer) IS
   BEGIN
      Put("Index: ");
      FOR I IN Integer RANGE IList'First .. (Num + IList'First - 1) LOOP
         Put(I, 8);
      END LOOP;
      Text_IO.New_Line;

      Put("Value: ");
      FOR I IN Integer RANGE IList'First .. (Num + IList'First - 1) LOOP
         Put(IList(I), 8);
      END LOOP;
      Text_IO.New_Line;
   END PrintList;


   -- Procedure Name: SwapElements
   -- Description:    Swaps the position of 2 elements in a list
   -- Parameters:     IList IN OUT IntList - list to be modified
   --                 Num IN Integer       - number of elements in list
   --                 Index1 IN Integer    - first index to be swapped
   --                 Index2 IN Integer    - seconds index to be swapped
   -- Return:         N/A
   PROCEDURE SwapElements(IList: IN OUT IntList;
                          Num, Index1, Index2: IN Integer) IS
      Temp                   : Integer;
   BEGIN
      Temp := IList(Index1);
      IList(Index1) := IList(Index2);
      IList(Index2) := Temp;
   END SwapElements;


   -- Procedure Name: SortList
   -- Description:    Puts the list in ascending numerical order
   -- Parameters:     IList IN OUT IntList - list to be sorted
   --                 Num IN Integer       - number of elements in list
   -- Return:         N/A
   PROCEDURE SortList(IList: IN OUT IntList; Num: IN Integer) IS
   BEGIN
      FOR I IN Integer RANGE IList'First .. IList'First+Num-1 LOOP
         FOR J IN Integer RANGE I+1 .. IList'First+Num-1 LOOP
            IF IList(I) > IList(J) THEN
               SwapElements(IList, Num, I, J);
            END IF;
         END LOOP;
      END LOOP;
   END SortList;


   -- Function Name: CheckOrder
   -- Description:   Checks if num is in order relative to immediate neighbors
   -- Parameters:    IList IN IntList - The list to be checked
   --                Num IN Integer   - number of elements in the list
   --                Index IN Integer - the index of the element to be checked
   -- Return:        Integer: 0 if NOT in order, 1 if IN order
   FUNCTION CheckOrder(IList: IN IntList;
                       Num, Index: IN Integer) RETURN Integer IS
   BEGIN
      IF Num = 1 THEN
         RETURN 1;

      ELSIF Index = (IList'First + Num - 1) THEN -- last in list
         IF IList(Index - 1) > IList(Index) THEN
            RETURN 0;
         END IF;

      ELSIF Index = IList'First THEN -- first in list
         IF IList(Index) > IList(Index + 1) THEN
            RETURN 0;
         END IF;

      ELSE -- check value before and after index
         IF IList(Index) > IList(Index + 1)
           OR IList(Index) < IList(Index - 1) THEN
            RETURN 0;
         END IF;
      END IF;

      RETURN 1;
   END CheckOrder;


   -- Function Name: Search
   -- Description:   Uses binary search to find element in the list
   -- Parameters:    IList IN IntList   - List to be searched
   --                Num IN Integer     - Number of elements in list
   --                Element IN Integer - Element to look for
   -- Return:        Integer: 0 if element NOT found, else the index
   FUNCTION Search(IList: IN IntList; 
		   Num, Element: IN Integer) RETURN Integer IS
      Middle, First, Last    : Integer;
   BEGIN
      IF Num = 1 THEN -- array length is 1
         IF IList(IList'First) = Element THEN
            RETURN IList'First;
         ELSE
            RETURN 0;
         END IF;
      END IF;

      Middle := (IList'First + Num-1) / 2;
      First  := IList'First;
      Last   := IList'First + Num - 1;

      WHILE First <= Last LOOP -- binary search through array
         IF IList(Middle) = Element THEN
            RETURN Middle;

         ELSIF IList(Middle) < Element THEN -- search latter half
            First := Middle + 1;

         ELSE -- search first half
            Last := Middle - 1;

         END IF;

         Middle := (First + Last) / 2;
      END LOOP;

      RETURN 0; -- element not found
   END Search;


   -- Procedure Name: ChangeElement
   -- Description:    Changes an element in list when given an index, then sorts
   -- Parameters:     IList IN OUT IntList - list to be modified
   --                 Num IN Integer       - number of elements in list
   --                 Index IN Integer     - index to modify
   --                 NewVal IN Integer    - new value for the index
   -- Return:         N/A
   PROCEDURE ChangeElement(IList: IN OUT IntList;
                           Num, Index, NewVal: IN Integer) IS
   BEGIN
      IList(Index) := NewVal;
      IF CheckOrder(IList, Num, Index) = 0 THEN
         SortList(IList, Num);
      END IF;
   END ChangeElement;


   -- Function Name: IsFull
   -- Description:   Checks if the list is full
   -- Parameters:    IList IN IntList - list to be checked
   --                Num IN Integer   - number of elements in list
   -- Return:        Integer: 0 if NOT full, 1 if full
   FUNCTION IsFull(IList: IN IntList; Num: IN Integer) RETURN Integer IS
   BEGIN
      IF Num = (IList'Last - IList'First + 1) THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   END IsFull;


   -- Procedure Name: Insert
   -- Description:    Inserts a new element in the list
   -- Parameters:     IList IN OUT IntList - list to be inserted upon
   --                 Num IN OUT Integer   - number of elements in list
   --                 NewVal IN Integer    - new element to be inserted
   -- Return:         N/A
   PROCEDURE Insert(IList: IN OUT IntList;
                    Num: IN OUT Integer; NewVal: IN Integer) IS
   BEGIN
      IList(IList'First + Num) := NewVal; -- insert at end of list
      Num := Num + 1;

      IF CheckOrder(IList, Num, IList'First + Num - 1) = 0 THEN -- out of order
         SortList(IList, Num);
      END IF;

   END Insert;


   -- Function Name: Sum
   -- Description:   Sums up all elements in the list
   -- Parameters:    IList: IN IntList - list to be calculated
   --                Num: IN Integer   - number of elements in list
   -- Return:        Integer: the sum
   FUNCTION Sum(IList: IN IntList; Num: IN Integer) RETURN Integer IS
      Sum                    : Integer := 0;
   BEGIN
      FOR I IN Integer RANGE IList'First .. (Num + IList'First - 1) LOOP
         Sum := Sum + IList(I);
      END LOOP;

      RETURN Sum;
   END Sum;


   -------------- User Input Functions --------------

   -- Procedure Name: GetChangeElement
   -- Description:    Prompts user for input and changes the index given
   -- Parameters:     IList IN OUT IntList - list to be modified
   --                 Num IN Integer       - number of elements in list
   -- Return:         N/A
   PROCEDURE GetChangeElement(IList: IN OUT IntList; Num: IN Integer) IS
      Index, Value           : Integer;
   BEGIN
      BEGIN
         Put("Enter an index to change: ");
         Index := Integer'Value(Get_Line); -- casts input to integer

         IF (Index >= (IntList'First + Num)) OR (Index < IntList'First) THEN
            Put_Line("Error: Invalid Index");
            RETURN;
         END IF;

         Put("Enter a new value: ");
         Value := Integer'Value(Get_Line);

      EXCEPTION
         WHEN Constraint_Error => -- error when casting to integer
            Put_Line("Error: Please only enter integers");
            RETURN;
      END;

      ChangeElement(IList, Num, Index, Value); -- modifies the element
   END GetChangeElement;


   -- Procedure Name: GetAverage
   -- Description:    Outputs results of the average calculation
   -- Parameters:     IList: IN IntList - list to find average of
   --                 Num: IN Integer   - number of elements in list
   -- Return:         N/A
   PROCEDURE GetAverage(IList: IN IntList; Num: IN Integer) IS
      Avg                    : Float;
   BEGIN
      IF Num = 0 THEN
         Put_Line("Cannot find average of empty list");
         RETURN;
      END IF;
      
      Avg := Float(Sum(IList, Num)) / Float(Num);
      Put("Average: ");
      Put(Item=>Avg, Fore=>0, Aft=>2, Exp=>0);
      Text_IO.New_Line;
   END GetAverage;


   -- Function Name: GetSearch
   -- Description:   Prompts user for element to look for and outputs results
   -- Parameters:    IList IN IntList - List to be searched
   --                Num IN Integer   - Number of elements in list
   -- Return:        N/A
   PROCEDURE GetSearch(IList: IN IntList; Num: IN Integer) IS
      Element, Index         : Integer;
   BEGIN
      BEGIN -- get element to search for
         Put("Enter the element to look for: ");
         Element := Integer'Value(Get_Line);
      EXCEPTION
         WHEN Constraint_Error =>
            Put_Line("Error: Please only enter integers");
            RETURN;
      END;
      
      Index := Search(IList, Num, Element);
      IF Index /= 0 THEN
         Put("Element found at index ");
         Put(Index, 0);
         Text_IO.New_Line;
      ELSE
         Put_Line("Element not found");
      END IF;
   END GetSearch;


   -- Procedure Name: GetInsert
   -- Description:    Gets input in order to enter new element in list
   -- Parameters:     IList IN OUT IntList - list to be inserted upon
   --                 Num IN OUT Integer   - number of elements in list
   -- Return:         N/A
   PROCEDURE GetInsert(IList: IN OUT IntList; Num: IN OUT INteger) IS
      NewVal                 : Integer;
   BEGIN
      IF IsFull(IList, Num) = 1 THEN -- if list is full
         Put_Line("Error: List is already full");
         RETURN;
      END IF;

      Put("Enter an integer value to be inserted: ");
      BEGIN
         NewVal := Integer'Value(Get_Line); -- casts input to integer
      EXCEPTION
         WHEN Constraint_Error =>
            Put_Line("Error: Please only enter integers");
            RETURN;
      END;

      Insert(IList, Num, NewVal);
   END GetInsert;


   -- Function Name: GetInput
   -- Description:   Prompts user for menu input
   -- Parameters:    N/A
   -- Return:        Character: First character of input entered
   FUNCTION GetInput RETURN Character IS
      Input                  : String(1 .. 50);
      Last                   : Natural;
   BEGIN
      Put_Line("Select:");
      Put_Line("P)rint Array");
      Put_Line("L)ook for Element");
      Put_Line("C)hange an Element");
      Put_Line("I)nsert New Element");
      Put_Line("F)ind Average");
      Put_Line("Q)uit");
      Put("> ");

      Text_IO.Get_Line(Input, Last);
      RETURN To_Upper(Character(Input(1))); -- 1st char in string to upper
   END GetInput;


BEGIN -- main procedure
   LOOP
      CASE GetInput IS
         WHEN 'P' =>
            PrintList(List, Count);

         WHEN 'L' =>
            GetSearch(List, Count);

         WHEN 'C' =>
            GetChangeElement(List, Count);

         WHEN 'I' =>
            GetInsert(List, Count);

         WHEN 'F' =>
            GetAverage(List, Count);

         WHEN 'Q' =>
            RETURN;

         WHEN OTHERS =>
            Put_Line("Invalid Selection");

      END CASE;
      Text_IO.New_Line;
      Text_IO.New_Line;
   END LOOP;
END p1;
