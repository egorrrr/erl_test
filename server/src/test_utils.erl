-module(test_utils).
-export([put/6, get/5, update_ets/5]).

%%------------------------------------------------------------------------------------		 
%%------------------------------------------------------------------------------------
%% Обработка PUT запроса

addList(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW) ->
    if(COUNT_VIEW > ETS_SIZE) -> ets:insert(Tab, {{SEQ_SIZE, ETS_SIZE + 1}, SEQ}),
	                             ETS_SIZE + 1;
                         true  -> {FIRST_SIZE, FIRST_ID} = ets:first(Tab),
                                 if(FIRST_SIZE > SEQ_SIZE) ->  ETS_SIZE;	
                        							   true ->  ets:delete(Tab, {FIRST_SIZE,  FIRST_ID}),
													            ets:insert(Tab, {{SEQ_SIZE, FIRST_ID}, SEQ}),
																ETS_SIZE
					             end
	end.
	
put(_Tab, ETS_SIZE, [], 0, _COUNT_VIEW, Value) -> { ETS_SIZE,  {[Value], 1} };
put(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW, Value) ->
         LAST_IN_LIST = lists:last(SEQ),		 
		 if (LAST_IN_LIST =< Value) -> {ETS_SIZE, {SEQ ++ [Value], SEQ_SIZE + 1}};
			                  true  ->  NEW_ETS_SIZE = addList(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW), 
							           { NEW_ETS_SIZE,  {[Value], 1} }
         end.
		 
%%------------------------------------------------------------------------------------		 
%%------------------------------------------------------------------------------------
%% Обработка GET запроса

tabToList(Tab, Iterator, Res) ->        
	   Next  = ets:next(Tab, Iterator),
       case Next of 
	        '$end_of_table'  -> Res;
			             _   -> [{Next, SeqVal}] = ets:lookup(Tab, Next),
						        tabToList(Tab, Next, [SeqVal| Res])
		end.
		 		 	
get(Tab, ETS_SIZE, SEQ, SEQ_SIZE, COUNT_VIEW) -> 
     First = ets:first(Tab),     
     case First of 
	     '$end_of_table'         -> [SEQ];
	     {FIRST_SIZE, _FIRST_ID} -> if(COUNT_VIEW > ETS_SIZE)  
		                                 -> 
		                                    [{First, SeqVal}] = ets:lookup(Tab, First),		                             
             								Res = tabToList(Tab, First, [SeqVal]),											
											[SEQ | Res];
		                            true -> 
							                if(FIRST_SIZE > SEQ_SIZE) 
											     -> 
											        [{First, SeqVal}] = ets:lookup(Tab, First),
													tabToList(Tab, First, [SeqVal]);
											true -> Res = tabToList(Tab, First, []),	 
											        [SEQ | Res]
											end
											
						            end
	 end.

%%------------------------------------------------------------------------------------
%%------------------------------------------------------------------------------------
%% Функции форматирования Tab при смене конфигураций

update_ets(ModuleName, Tab, ETS_SIZE, OLD_COUNT_VIEW, NEW_COUNT_VIEW) -> 	
      if(OLD_COUNT_VIEW =< NEW_COUNT_VIEW) 
	         -> {Tab, ETS_SIZE};
		true -> erase(Tab, OLD_COUNT_VIEW - NEW_COUNT_VIEW, 0),
                {NewTab, NEW_ETS_SIZE} = index(Tab, ets:first(Tab), 1, ets:new(ModuleName, [ordered_set])),
				ets:delete(Tab),
                {NewTab, NEW_ETS_SIZE}				
	  end.	


%%------------------------------------------------------------------------------------
%% Удаление Count самых коротких последовательностей 

erase(Tab, Count, Iterator) -> 
      if(Count > Iterator) 
	         -> First = ets:first(Tab),     
			    case First of 
	                '$end_of_table' -> Tab;
					             _  -> ets:delete(Tab, First),
								       erase(Tab, Count, Iterator + 1)
			    end;
   	    true -> Tab
	  end.

%%------------------------------------------------------------------------------------	  
%% Переиндексация оставшихся элементов по порядку
	  
index(Tab, Iterator, NextIndex, NewTab) ->     
     case Iterator of 
	                    '$end_of_table' -> {NewTab, NextIndex - 1};
	      {Iterator_SIZE, _Iterator_ID}  -> [{Iterator, Value}] = ets:lookup(Tab, Iterator),
		                                   ets:insert(NewTab, { {Iterator_SIZE, NextIndex} , Value}), 
										   index(Tab, ets:next(Tab, Iterator), NextIndex + 1, NewTab)
     end.
	  
	  
	  
	     
    