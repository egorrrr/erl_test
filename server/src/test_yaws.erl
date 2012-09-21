-module(test_yaws).
-export([answer/1]).


-include("yaws_api.hrl").

parse_clidata(CliData) ->  
         AllData =  binary_to_list(CliData),	 
	     Pos = string:str(AllData, "value="), 
	     case Pos of 1 ->  StrN =  string:sub_string(AllData, 7),	   		 
	                       string:to_integer(StrN);
	                 _ ->  error
	     end.
	  
	        
	  

put_req(Args) -> 	
    if(Args#arg.pathinfo == "/number/") 	       
	       ->  Res =  parse_clidata(Args#arg.clidata),			   
               case Res of 
			        error  -> {html, io_lib:format("PUT Request Format Error: Wrong clidata~n", [])};
			      {N, []}  ->  Answer = test_server:put(N),
					        {html, io_lib:format("Ok. ~p", [Answer])};
						_  -> {html, io_lib:format("PUT Request Format Error: Wrong clidata~n", [])}
                end;
	  true ->  {html, io_lib:format("PUT Request Format Error: Wrong pathinfo~n", [])}
    end.				
				
get_req(Args) ->  Value = Args#arg.pathinfo,
                  if(Value == "/numbers/") 
				         -> {"get", SEQs} = test_server:get(),
		                    {html, io_lib:format("GET Sequences:<BR /> ~s", [view(SEQs)])};
				    true -> {html, io_lib:format("GET Request Format Error", [])}
				  end.
				  
answer(Args) -> Req  = Args#arg.req,
             case Req of
			       {http_request, 'GET' , _, _}  -> get_req(Args);				 
				   {http_request, 'PUT', _, _}   -> put_req(Args);
				                               _ -> {html, io_lib:format("Type Reqest Error: ~p~n", [Req])}
            											   
			 end.
			 
%%---------------------------------------------
%%----------------------------------------
%% Формирование строки для вывода в браузер


view(SEQs) -> SortForLength = lists:sort(fun(L1, L2) -> length(L1) > length(L2) end, SEQs),
              StrNumSEQs    = lists:map(fun(Elem) -> listNumToListStr(Elem) end, SortForLength),
              StrListSEQs   = lists:map(fun(Elem) -> listList2ListStr(Elem) end, StrNumSEQs),
			  View =  lists:foldr(fun(Elem, Acc) -> Elem ++ "<BR />" ++ Acc end, "", StrListSEQs),
			  View.			 


int2str(Num) -> [Answer] = io_lib:format("~.10B", [Num]),
                Answer.
                 
listNumToListStr(Seq) -> lists:map(fun(Elem) -> int2str(Elem) end, Seq).	

listList2ListStr(Seq) -> lists:foldl(fun(Elem, Acc) ->  Acc ++ " " ++ Elem end, "\n", Seq).
	


				
				