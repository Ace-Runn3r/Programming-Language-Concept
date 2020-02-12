--  Author: Cole Clements, cclements2016@my.fit.edu
--  Course: CSE 4250, Spring 2019
--  Project: Proj3, Panther Party
--  'gnat --version':  (GCC) 7.3.1 20180524 (for GNAT Community 2018 (20180523-73))

with Ada.Text_IO;               use Ada.Text_IO; 
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO; 
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;

with Dijkstra;
procedure panther is 

    Input : File_Type;
    N, X, A, B, M, T : Integer;

begin
    -- change file name from input file // used for testing
    --Open(File => Input,  Mode => In_File,  Name => "input.txt"); 
    -- open File and take in start information
    Get(Item => N);    
    Get(Item => M); 
    Get(Item => X);

    declare 
        subtype DijTypeTO is Integer range 1..N; -- define Dijkstra generic
        package DijtoParty is new Dijkstra (node => DijTypeTo);
        
        subtype DijTypeFrom is Integer range 1..N; -- define 2nd Dijkstra generic
        package DijfromParty is new Dijkstra (node => DijTypeFrom);
        
        lairsTo : DijtoParty.EdgeList(0..M-1);
        lairsFrom : DijfromParty.EdgeList(0..M-1);
    begin
        for I in 0..M-1 Loop -- create array of edge/node info
            Get(Item => A);   
            Get(Item => B);
            Get(Item => T);
            
            lairsTo(I).Start_Node := A;
            lairsTo(I).End_Node := B;
            lairsTo(I).Time := T;
            
            lairsFrom(I).Start_Node := A;
            lairsFrom(I).End_Node := B;
            lairsFrom(I).Time := T;
        end loop;
        declare
            -- create graphs
            GraphTo : DijtoParty.Node_Graph := DijtoParty.makeGraph 
                                                       (Edges => lairsTo);
            GraphFrom : DijfromParty.Node_Graph := DijfromParty.makeGraph 
                                                       (Edges => lairsFrom);
            
            DisThere : DijtoParty.distance_list(0..N-1); -- distance arrays
            DisBack : DijfromParty.distance_list(0..N-1);
            
            MaxDis : Integer := 0;
            arrayPos : Integer := 0;
        begin

            -- find dis from source to lairs
            DisBack := DijfromParty.disFromNode(GraphFrom, X, N);

            -- find dis from lairs to source
            for lair in 1..N loop
                DisThere(arrayPos) := DijtoParty.pathDistance(GraphTo, lair, X);
                arrayPos := arrayPos + 1;
            end loop;

            -- calculate Max distance walked from arrays
            for I in 0..N-1 loop
                if (DisBack(I) + DisThere(I)) > MaxDis then
                    MaxDis := DisBack(I) + DisThere(I);
                end if;
            end loop;
         
            Put_Line("Maximum walk distance:" & Integer'image(MaxDis));
        end;
    end;
    --Close (Input);
end panther;
