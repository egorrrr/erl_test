-module(test_supervisor).
-behaviour(supervisor). 
-export([start/0, start_link/1, init/1]).

start_link(Args) -> supervisor:start_link({local,?MODULE}, ?MODULE, Args).

start() -> start_link([]). 

init([]) -> {ok,{
      				{one_for_one, 3, 10},
                    [{tag1, {test_server, start_link, []},  permanent, 10000, worker, [start_link]}]                                            					
				}
			}.