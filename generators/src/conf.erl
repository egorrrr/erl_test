-module(conf).
-export([get_config/1]).

default_config() -> {100, 1000, 100}.		
get_values(Settings) -> 
              Set = {lists:keysearch(sMAX_VALUE,    1, Settings), 
			         lists:keysearch(sSEED_TIMEOUT, 1, Settings), 
				     lists:keysearch(sMIN_TIMEOUT,  1, Settings)},
              case Set of			         
					 {{value, {sMAX_VALUE,    MAX_VALUE}}, 
					  {value, {sSEED_TIMEOUT, SEED_TIMEOUT}}, 
					  {value, {sMIN_TIMEOUT,  MIN_TIMEOUT }}}  ->  {MAX_VALUE, SEED_TIMEOUT, MIN_TIMEOUT};
                                                            _  ->  io:format("Error read 'settings.ini': ~p~n", [Set]),
				                                                   default_config()
			  end.        

get_config(IniFile) ->  
        case file:consult(IniFile) of
		  {ok, Settings} ->  get_values(Settings);
		  _              ->  default_config()
		end. 