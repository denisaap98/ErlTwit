-module(account).
-include("../priv/records.hrl").
-compile(export_all).

create_account(undefined, Account) ->
   NewAccounts = [Account],
   mochiglobal:put(account, NewAccounts),
   generate_body(Account);

create_account(Accounts, Account=#account{id=Id, username = Username, date = Date, followers = Followers, following = Following}) ->
   SearchAccount = search_account_byId(Id, Accounts),
   case length(SearchAccount) of
   0 ->
      NewAccounts = [Account|Accounts],
      mochiglobal:put(account, NewAccounts),
      generate_body(Account);
   _ ->
      rec2json:msg2json(error, "An account with this id already exists!")
end.

generate_body(undefined) ->
   ok;
generate_body([]) ->
   rec2json:msg2json(error, "Account not found!");
generate_body(#account{id = _, username = Username, date = _, followers = _, following = _}) ->
   rec2json:msg2json(["Username"], [Username]);
generate_body(Accounts) when is_list(Accounts) ->
generate_body(hd(Accounts)).


search_account_byId(_, _)->
    0.

% erl 
% cd("ebin")
% l(dbutils)
% dbutils:insert_user()
