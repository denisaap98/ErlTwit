-module(twit).
-include("../priv/records.hrl").
-compile(export_all).

create_twit(Twit = #twit{user = User, mesaj = Mesaj, data = Data, likes = Likes, shares = Shares}) ->
    Accounts = mochiglobal:get(account),
    %SearchUser = search_byUser(User, Accounts),
   %  case length(SearchUser) of
   %  0 ->
   %    rec2json:msg2json(error, "The username doesn't exist!");
   %  _ ->
      %  NewTwits = [Twit|Twits],
       mochiglobal:put(twit, Twit),
      %  Twit_proplist = rec2json:to_proplist(Twit),
      %  io:format("Twit proplist: ~p", [Twit_proplist]),
      %  mochijson2:encode(Twit_proplist),
      %  Twit_proplist.
      generate_body(Twit).




    
   

generate_body(undefined) ->
   rec2json:msg2json(error, "Twit not found!");
generate_body([]) ->
   rec2json:msg2json(error, "Twit not found!");
generate_body(#twit{user = User, mesaj = Mesaj, data = Data, likes = Likes, shares = Shares}) ->
   rec2json:msg2json(["User", "Mesaj", "Data", "Likes", "Shares"], [User, Mesaj, Data, Likes, Shares]);
generate_body(Twits) when is_list(Twits) ->
generate_body(hd(Twits)).



search_byUser(User, Accounts)->
    lists:filter(fun({id, username, date, followers, following }) -> username == User end, Accounts).