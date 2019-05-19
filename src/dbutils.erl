-module(dbutils).
-include("../priv/records.hrl").
-compile(export_all).

install() ->
    Nodes = [node()],
    ok = mnesia:create_schema(Nodes),
    application:start(mnesia),
    mnesia:create_table(account,
    [{attributes, record_info(fields, account)},
    {disc_copies, Nodes}]).

insert_user(Id, Username, Date, Followers, Following) ->
  Insert =
    fun() ->
      mnesia:write(
        #account{
          id = Id, 
          username = Username, 
          date = Date, 
          followers = Followers, 
          following = Following
        })
    end,
  {atomic, Results} = mnesia:transaction(Insert). 

% insert_twit(User, Mesaj, Data, Likes, Shares) ->
%   Insert =
%     fun() ->
%       mnesia:write(
%         #twit{
%           id=Id, 
%           user = User, 
%           data = Data, 
%           likes = Likes, 
%           shares = Shares
%         })
%     end,
%   {atomic, Results} = mnesia:transaction(Insert). 