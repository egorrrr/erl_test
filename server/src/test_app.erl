-module(test_app).
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, Args) -> test_supervisor:start_link(Args).
stop(_State) -> ok.

