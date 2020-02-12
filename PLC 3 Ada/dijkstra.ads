--  Author: Cole Clements, cclements2016@my.fit.edu
--  Course: CSE 4250, Spring 2019
--  Project: Proj3, Panther Party
--  'gnat --version':  (GCC) 7.3.1 20180524 (for GNAT Community 2018 (20180523-73))
with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Ordered_Maps;
generic
    type node is (<>);
package Dijkstra is
    
    type node_graph is limited private;
    
    -- record for initial data acceptence
    type Edge is record
        Start_Node : node;
        End_Node   : node;
        Time       : Integer;
    end record;
    
    -- array of initial data fro graph creation
    type EdgeList is array (Integer range <>) of Edge; 
    
    -- func to create graph using above data
    function makeGraph (Edges : in EdgeList) return node_graph;
    
    type distance_list is array (Integer range<>) of Integer;
    -- func to find distance from node to origin
    function pathDistance (Graph : in out node_graph; 
                           Start_Node, End_Node : node) return Integer;
    
    -- func to find distance from origin to all nodes in graph
    function disFromNode (Graph : in out node_graph; 
                          Start_Node : node; len : Integer) return distance_list;
    
    private
        -- actual Graph definition
    package NextNodeList is new Ada.Containers.Ordered_Maps 
                             (Key_Type => node ,Element_Type => Integer);
        type node_info is record
            nextNodes : NextNodeList.Map;       -- Map of next nodes
            distance : Integer := Integer'Last; -- distance from origin
            visited : Boolean := False;         -- node has been visisted
            self : Node;
        end record;
        type node_graph is array (node) of node_info;

end Dijkstra;
