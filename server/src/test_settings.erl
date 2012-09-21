-module(test_settings).
-export([update_settings/1]).

default_settings() -> 10.

get_settings(Settings) -> 
              case lists:keysearch(sCOUNT_VIEW, 1, Settings) of
			    {value, {sCOUNT_VIEW, COUNT_VIEW}} -> COUNT_VIEW;				
                                                _  ->  io:format("Error read 'settings.ini'~n"),
				                                       default_settings()
			  end.            					  			 

update_settings(IniFile) -> 
        case file:consult(IniFile) of
		  {ok, Settings} ->  get_settings(Settings);
		  _              ->  default_settings()
		end.
