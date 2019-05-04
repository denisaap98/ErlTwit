-module(twit).
-include("../priv/records.hrl").
-compile(export_all).

create_twit(undefined, Twit = #twit{user = User, mesaj = Mesaj, data = Data, likes = Likes, shares = Shares}) ->
    % Accounts = mochiglobal:get(account),
    % SearchUser = search_byUser(User, Accounts),
    % case length(SearchUser) of
    % 0 ->
    %   rec2json:msg2json(error, "The username doesn't exist!");
    % _ ->
    %   NewTwits = [Twit],
    %   mochiglobal:put(twit, NewTwits),
    %   generate_body(Twit)
% end.
    
    NewTwits = [Twit],
    mochiglobal:put(twit, NewTwits),
    generate_body(Twit);

      
  

create_twit(Twits, Twit = #twit{user = User, mesaj = Mesaj, data = Data, likes = Likes, shares = Shares}) ->
    Accounts = mochiglobal:get(account),
    SearchUser = search_byUser(User, Accounts),
    case length(SearchUser) of
    0 ->
      rec2json:msg2json(error, "The username doesn't exist!");
    _ ->
       NewTwits = [Twit|Twits],
       mochiglobal:put(twit, NewTwits),
       generate_body(Twit)
end.




    
   

generate_body(undefined) ->
   rec2json:msg2json(error, "Twit not found!");
generate_body([]) ->
   rec2json:msg2json(error, "Twit not found!");
generate_body(#twit{user = _, mesaj = Mesaj, data = _, likes = _, shares = _}) ->
   rec2json:msg2json(["Mesaj"], [Mesaj]);
generate_body(Twits) when is_list(Twits) ->
generate_body(hd(Twits)).



search_byUser(User, Accounts)->
    lists:filter(fun({id, username, date, followers, following }) -> username == User end, Accounts).