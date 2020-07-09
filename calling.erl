%% @author nesaralam
%% @doc @todo Add description to calling.


-module(calling).

-export([messagePass/3,send_message/2,time_stamp/3]).

messagePass(From,Sender,Receiver) ->
	time_stamp(Sender,Receiver,self()),
	Mid = From,
	Lst1 = [{Mid,Sender}],
	M1 = maps:from_list(Lst1),
 	send_message(From,M1).

send_message(From,M1) ->
	    receive
        {knock,Head,Tail,Time,MessagePass_id} -> 
			timer:sleep(random:uniform(100)),
			From ! {intro,Head,Tail,Time},
			MessagePass_id ! {respond,Head,Tail,Time};
		{respond,Head,Tail,Time} ->
			timer:sleep(random:uniform(100)),
			From ! {reply,Head,Tail,Time}
	    after 5000 -> 
			 Fid = From, 
			 H= maps:get(Fid, M1),
			 io:fwrite("~nProcess ~w has received no calls for ~w seconds, ending...~n",[H,5]),
			 exit(0)
		
        end,
	    send_message(From,M1).
		
time_stamp(Head,Tail,MessagePass_id) ->   
	Function = fun(X)-> {_,_,Time} = erlang:now(), MessagePass_id ! {knock,Head,X,Time,MessagePass_id}  end,
	lists:foreach(Function,Tail).
    
	

