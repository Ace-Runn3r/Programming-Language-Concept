--  Author: Cole Clements, cclements2016@my.fit.edu
--  Course: CSE 4250, Spring 2019
--  Project: Proj3, Panther Party
--  'gnat --version':  (GCC) 7.3.1 20180524 (for GNAT Community 2018 (20180523-73))

with Ada.Text_IO; use Ada.Text_IO; -- for debugging
with Ada.Containers.Synchronized_Queue_Interfaces; 
with Ada.Containers.Unbounded_Priority_Queues; use Ada.Containers;
package body Dijkstra is
    
    -- Create Graph
    function makeGraph (Edges : in EdgeList) return node_graph is
    begin
      return returnGraph : node_graph do
          for e of Edges loop
              returnGraph(e.Start_Node).nextNodes.Insert(e.End_Node, e.time);
              returnGraph(e.Start_Node).self := e.Start_Node;  
          end loop;   
      end return;     
    end makeGraph;
    
    procedure Dijkstra (Graph : in out node_graph; Start : node) is
        function Get_Priority (node : node_info) return Integer is -- func for PQ
        begin
            return node.distance;
        end Get_Priority;
        function Before (Left, Right : Integer) return Boolean is  -- func for PQ
        begin
            return Left < Right;
        end Before;
        
        -- creation of PQ
        package PRQ_Interface is 
                new Ada.Containers.Synchronized_Queue_Interfaces 
                      (Element_Type => node_info);
        package Unbounded_PRQ_Interface is 
                new Ada.Containers.Unbounded_Priority_Queues 
                 (Queue_Interfaces => PRQ_Interface, Queue_Priority => Integer);
        
        PRQ : Unbounded_PRQ_Interface.Queue;
        
        curNode : node_info;
    begin
        -- reset distances and visits for new path
        for node of Graph loop
            node.distance := Integer'Last;
            node.visited := False;
        end loop;
        
        -- mark frist node as visited and queue it
        Graph(Start).distance := 0;
        Graph(Start).visited := True;
        PRQ.Enqueue(Graph(Start));
        
        -- while nodes in pq go through graph
        while PRQ.Current_Use > 0 loop

            PRQ.Dequeue(curNode);
            Graph(curNode.self).visited := True;
            declare
                -- procedure used to interate over Map of next nodes for graph
                procedure Iterate_Map (Pos : in NextNodeList.Cursor) is
                    use NextNodeList;
                    N_node : node := Key (Pos); -- current neighbor of curNode
                    newDis : Integer;
                begin

                    newDis := Element(Pos) + curNode.distance; --cal new distance
                     
                    -- if smaller update node
                    if newDis <  Graph(N_node).distance then
                        Graph(N_node).distance := newDis;
                    end if;
                    
                    -- add instance of unvisited node
                    if not Graph(N_node).visited then 
                        PRQ.Enqueue(Graph(N_node));
                    end if;  
                end Iterate_Map;
            begin
                -- iterate and over next nodes and cal dis of neighbors
                curNode.nextNodes.Iterate(Iterate_Map'Access);
            end;
        end loop;
    end Dijkstra;
     
    
    function pathDistance (Graph : in out node_graph; 
                           Start_Node, End_Node : node) return Integer is
    begin
        Dijkstra(Graph, Start_Node);
        for node of Graph loop
            if node.self = End_Node then
                if ((node.distance > 1000000) or (node.distance < 0)) then
                    return path : Integer := 0;
                else
                    return path : Integer := node.distance;
                end if;
            end if;
        end loop;
        return path : Integer := 0;
    end pathDistance;
    
    function disFromNode (Graph : in out node_graph;
                          Start_Node: node; len : Integer) return distance_list is
        path : distance_list(0..len-1);
        pos : Integer := 0;
    begin
        Dijkstra(Graph, Start_Node);
        for node of Graph loop
            if ((node.distance > 1000000) or (node.distance < 0)) then
                path(pos) := 0;
            else
                path(pos) := node.distance;
            end if;
            pos := pos + 1;
        end loop;
        return path;
    end disFromNode;

end Dijkstra;
