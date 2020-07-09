%% @author nesaralam
%% @doc @todo Add description to erlangtut.


-module(exchange).

-export([start/0,send_list/3,post_feedback/0]).

start() ->
  io:fwrite(" *** Calls to be made ***\n"),
  {ok,List} = file:consult("calls.txt"),
  M_id=self(),
  [print_list(Person,Friends)||{Person,Friends}<-List],
  [send_list(Sender,Receiver,M_id)||{Sender,Receiver}<-List],
  io:fwrite("~n"),
  post_feedback().
  
print_list(Person,Friends) ->
    io:format("~w: ~w~n", [Person, Friends]).
    

send_list(Sender,Receiver,Master_id) ->
	spawn(calling,messagePass,[Master_id,Sender,Receiver]).
    

post_feedback() ->
	receive
		{intro,Head,Tail,Time} -> 
			io:fwrite("~w received intro message from ~w [~w]~n", [Tail,Head,Time]),
		    post_feedback();
		{reply,Head,Tail,Time} ->
			io:fwrite("~w received reply message from ~w [~w]~n",[Head,Tail,Time]),
	        post_feedback()
 	after 10000 -> io:fwrite("~nMaster has received no replies for ~w seconds, ending...~n",[10]),
				  halt(0)
	end.

