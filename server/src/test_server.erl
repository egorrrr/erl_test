-module(test_server).
-behaviour(gen_server).

-export([start_link/0, get/0, put/1, config/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("settings.hrl").

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).                 			

init([]) ->  process_flag(trap_exit, true),
             io:format("~p starting~n" ,[?MODULE]),			 
			 COUNT_VIEW = test_settings:update_settings(?SETTINGS),
			 io:format("COUNT_VIEW = ~.10B~n" ,[COUNT_VIEW]),
             {ok, {{ets:new(?MODULE,[ordered_set]), 0}, {[], 0}, COUNT_VIEW}}.

config()  ->  gen_server:call(?MODULE, {config}).

get()     ->  gen_server:call(?MODULE, {get}).
put(Next) ->  gen_server:call(?MODULE, {put, Next}).


handle_call({config}, _From, {{Tab, ETS_SIZE}, {SEQ, SEQ_SIZE}, COUNT_VIEW}) ->                                         
                                      NEW_COUNT_VIEW = test_settings:update_settings(?SETTINGS),	
									  {NewTab, NEW_ETS_SIZE} = test_utils:update_ets(?MODULE, Tab, ETS_SIZE, COUNT_VIEW, NEW_COUNT_VIEW),	                                      								 
									  {reply, {"config", NEW_COUNT_VIEW}, {{NewTab, NEW_ETS_SIZE}, {SEQ, SEQ_SIZE}, NEW_COUNT_VIEW}};
									  

handle_call({get}, _From, {{Tab, ETS_SIZE}, {SEQ, SEQ_SIZE}, COUNT_VIEW}) -> 
                                  Res = test_utils:get(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW),							  
                                  {reply, {"get", Res}, {{Tab, ETS_SIZE}, {SEQ, SEQ_SIZE}, COUNT_VIEW}};

handle_call({put, Value}, _From,  {{Tab, ETS_SIZE}, {SEQ, SEQ_SIZE}, COUNT_VIEW}) -> 
                            {NEW_ETS_SIZE, {NEW_SEQ, NEW_SEQ_SIZE}} = test_utils:put(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW, Value),                            
			                {reply, {"put", Value}, {{Tab, NEW_ETS_SIZE}, {NEW_SEQ, NEW_SEQ_SIZE}, COUNT_VIEW}}.		 

												
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) ->  io:format("~p stopping~n" ,[?MODULE]), ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

