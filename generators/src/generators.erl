-module(generators).
-export([startOne/3, stopOne/1]).
-export([start/2, stop/1]).
  
seed(HostAndPath, MaxValue, TimeOut, IoDevice) -> 
            {A1,A2,A3} = now(),
            random:seed(A1, A2, A3),
			inets:start(),
            loop(HostAndPath, MaxValue, TimeOut, IoDevice).
  
loop(HostAndPath, MaxValue, TimeOut, IoDevice) ->
       receive
              cancel -> stop
       after TimeOut -> send(HostAndPath, MaxValue, IoDevice),
	                    loop(HostAndPath, MaxValue, TimeOut, IoDevice)
       end.

send(HostAndPath, MaxValue, IoDevice) -> 
                N = random:uniform(MaxValue),                  	
                StrN = io_lib:format("~.10B", [N]),                
				CliData = list_to_binary("value=" ++ StrN),
                Response = httpc:request(put, {HostAndPath, [], [], CliData}, [], []),			
                Now = calendar:local_time(),  				
				case Response of
				     {ok, {_, _, Body}} -> io:format(IoDevice, "[~p] ~p~n", [Now, Body]);							                       
				                      _ -> io:format(IoDevice, "[~p] No Response: ~p~n", [Now, Response])
				end.
				
                        												
startOne(HostAndPath, MaxValue, TimeOut) ->                           
				   Now = calendar:datetime_to_gregorian_seconds(calendar:local_time()), 
                   FileName = io_lib:format("../logs/Gen~.10B.log", [Now rem 10000]),										 
				   Res = file:open(FileName, write),
				   case Res of
						{ok, IoDevice}  -> io:format("Create generator with TimeOut = ~.10B, LogFile: ~s ~n", [TimeOut, FileName]),
						                   io:format(IoDevice, "TimeOut = ~p ~n", [TimeOut]),
						                   Pid = spawn(fun() -> seed(HostAndPath, MaxValue, TimeOut, IoDevice) end),
						  				   {Pid, IoDevice};
						{error, Reason} -> io:format("Error create file for log: ~s~n", [Reason]),
										   io:format("Generator create error~n", []),
										   error
				   end.
						
stopOne(Pid) -> Pid ! cancel,
                io:format("Stop generator with Pid = ~p~n", [Pid]).

start(HostAndPath, Count) -> file:make_dir("../logs"), 
                             start(HostAndPath, Count, Count, []).

start(_HostAndPath, _Count, 0, Pids) -> Pids;
start(HostAndPath, Count, Iterator, PidsAndHandle) ->   
                        {MAX_VALUE, SEED_TIMEOUT, MIN_TIMEOUT} = conf:get_config("../include/settings.ini"), 
						io:format("Config: ~p~n", [{MAX_VALUE, SEED_TIMEOUT, MIN_TIMEOUT}]),
                        TimeOut = random:uniform(SEED_TIMEOUT) + MIN_TIMEOUT,													
                        Res = startOne(HostAndPath, MAX_VALUE, TimeOut),						
						timer:sleep(1000),
						case Res of
						     {Pid, IoDevice} ->  start(HostAndPath, Count, Iterator - 1, [ {Pid, IoDevice} | PidsAndHandle]);							                     
							           error ->  error
					    end.
						

stop([]) -> ok;
stop([{Pid, IoDevice} | Tail]) ->  stopOne(Pid),
                           file:close(IoDevice),                           					  
                           stop(Tail). 
						   
						   
					  