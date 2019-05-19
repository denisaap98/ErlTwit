-module(rec2json).
%% -export([to_json/1, from_record/1]).
-compile([debug_info, export_all]).

-define(JSON_WRAPPER(Proplist), {Proplist}).

-include("../priv/records.hrl").

to_json(Account) ->
	AccountList = tuple_to_list(Account),
	erlang:display(hd(AccountList)).

 to_proplist(Record) ->
 	to_proplist(Record, []).

 to_proplist(Type = #twit{}, []) ->
 	lists:zip(record_info(fields, twit), to_list(Type));




 to_proplist(Val, []) ->
 	Val;
 to_proplist([], Result) ->
 	lists:reverse(Result);
 to_proplist([H|T], Result) ->
 	to_proplist(T, [to_proplist(H,[]) | Result]).

 to_list(Type) ->
 	[to_proplist(L, []) || L <- tl(tuple_to_list(Type))].

% proplist2json(Proplist) ->
% 	proplist2json(Proplist, "{").

% proplist2json([], Acc) ->
% 	Acc ++ "}";
% proplist2json([{K,V}|T], Acc) when is_list(V) ->
% 	proplist2json(T, Acc ++ "\"" ++ lists:flatten(io_lib:format("~p", [K])) ++ ": [" ++ proplist2json(V, "") ++ "]");
% proplist2json([{K,V}|T], Acc) ->
% 	proplist2json(T, Acc ++ "\"" ++ lists:flatten(io_lib:format("~p", [K])) ++ ":" ++ "\"" ++ lists:flatten(io_lib:format("~p", [V])) ++ "\",").

% %% @spec from_list(json_proplist()) -> object().
% from_list([]) -> true; % new();
% from_list(L) when is_list(L) -> ?JSON_WRAPPER(L).

msg2json(msg, Msg) ->
	"{\n\t\t\"Happy\" : \"" ++ Msg ++ "\"\n}";

msg2json(error, Msg) ->
	"{\n\t\t\"error\" : \"" ++ Msg ++ "\"\n}";

msg2json(Key, Value) when is_list(Key), is_list(Value) ->
	T = lists:zipwith(fun(X, Y) -> "\t\t\"" ++ X ++ "\" : \"" ++ Y ++ "\",\n" end, Key, Value),
	Last = lists:last(T),
	NewElem = lists:droplast(lists:droplast(Last)),
	"{\n" ++ lists:droplast(T) ++ NewElem ++ "\n}";

msg2json(Key, Value) ->
	" {\n\t\t\" " ++ Key ++ " \" : \" " ++ Value ++ " \" \n}".

json2proplist(JSON) ->
	io:format("~p", JSON).

%  
% %% @spec recursive_from_proplist(any()) -> object().
% recursive_from_proplist([]) -> true; % new();
% recursive_from_proplist(List) when is_list(List) ->
%         case lists:all(fun is_integer/1, List) of
%             'true' -> List;
%             'false' ->
%                 from_list([{to_binary(K) ,recursive_from_proplist(V)}
%                                    || {K,V} <- List
%                                   ])
%         end;
%     recursive_from_proplist(Other) -> Other.
