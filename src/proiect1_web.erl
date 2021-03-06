%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc Web server for proiect1.

-module('proiect1_web').

-author("Mochi Media <dev@mochimedia.com>").

-export([loop/2, start/1, stop/0]).

-include("../priv/records.hrl").

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) -> (?MODULE):loop(Req, DocRoot) end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop}
			 | Options1]).

stop() -> mochiweb_http:stop(?MODULE).

%% OTP 21 is the first to define OTP_RELEASE and the first to support
%% EEP-0047 direct stack trace capture.
-ifdef(OTP_RELEASE).

-if((?OTP_RELEASE) >= 21).

-define(HAS_DIRECT_STACKTRACE, true).

-endif.

-endif.

-ifdef(HAS_DIRECT_STACKTRACE).

- define ( CAPTURE_EXC_PRE ( Type , What , Trace ) , Type : What : Trace ) .


-define(CAPTURE_EXC_GET(Trace), Trace).

-else.

-define(CAPTURE_EXC_PRE(Type, What, Trace), Type:What).

-define(CAPTURE_EXC_GET(Trace),
	erlang:get_stacktrace()).

-endif.





loop ( Req , DocRoot ) -> 
    "/" ++ Path = Req : get ( path ) , 

        try case Req : get ( method ) of
         Method when 
            Method =:= 'GET' ;  Method =:= 'HEAD' -> 
                handle_get(Path, Req, DocRoot);
            'POST' -> 
                handle_post(Path, Req, DocRoot);
            Other ->
                io:format("501 ~p",[Other]), 
                Req : respond ( { 501 , [ ] , [ ] } ) 
            end 
        catch ? CAPTURE_EXC_PRE ( Type , What , Trace ) -> 
            Report = [ "web request failed" , { path , Path } , { type , Type } , { what , What } , { trace , ? CAPTURE_EXC_GET ( Trace ) } ] , 
            error_logger : error_report ( Report ) , 
            Req : respond ( { 500 , [ { "Content-Type" , "text/plain" } ] , "request failed, sorry\n" }  ) 
        end .


handle_get("hello_world", Req, _) ->
   error_logger:info_msg("[GET]: Hello World"),
   Body = rec2json:msg2json(msg, "Hello World!"),
   Req:respond({200, [{"Content-Type", "text/plain"}], Body});


handle_get("get_twits", Req, _) ->
   error_logger:info_msg("[GET]: Get twits"),
   Twits = mochiglobal:get(twit),
   Body = twit:generate_body(Twits),
   Body2 = "{" ++
       " \" twits \" " ++ ":" ++  [Body] ++
   "}",
   %Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "text/plain"}], Body});
   Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "application/json"}], Body});

handle_get("get_accounts", Req, _) ->
   error_logger:info_msg("[GET]: Get accounts"),
   Accounts = mochiglobal:get(account),
   Body = twit:generate_body(Accounts),
   Req:respond({200, [{"Content-Type", "text/plain"}], Body});
   %Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "application/json"}], Body});

handle_get(Path, Req, DocRoot) ->
   error_logger:info_msg("[GET]: Other"),
   Req:serve_file(Path, DocRoot).



handle_post("create", Req, _) ->
   error_logger:info_msg("[POST]: Create"),
   [Id, Username, Date] = get_params(Req),
   Account = #account{id = Id, username = Username, date = Date, followers = [], following = []},
   Accounts = mochiglobal:get(account),
   Body = account:create_account(Accounts, Account),
   %Req:respond({200, [{"Content-Type", "text/plain"}], Body});
   Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "application/json"}], Body});
   
handle_post("post_twit", Req, _) ->
   error_logger:info_msg("[POST]: Post twit"),
   [Data, Likes, Mesaj, Shares, User] = get_params(Req),
   Twit = #twit{user = User, mesaj = Mesaj, data = Data, likes = Likes, shares = Shares},
   %Twit = #twit{user = _, mesaj = Mesaj, data = _, likes = _, shares = _},
   %Twits = mochiglobal:get(twit),
   Body = twit:create_twit(Twit),
   io:format("Post twit: ~p", [Body]),
  % Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "text/plain"}], Body});
    Req:respond({200, [{"Access-Control-Allow-Origin", "http://localhost:4200"},{"Content-Type", "application/json"}], Body});
   

handle_post(_Path, Req, _DocRoot) ->
   error_logger:info_msg("[POST]: Other"),
Req:not_found().

get_params(Req) ->
   QueryData = Req:parse_qs(),
   QueryKeys = lists:sort(proplists:get_keys(QueryData)),
   lists:map(fun(X) -> proplists:get_value(X, QueryData) end, QueryKeys).

%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options),
     proplists:delete(Option, Options)}.

%%
%% Tests
%%
-ifdef(TEST).

-include_lib("eunit/include/eunit.hrl").

you_should_write_a_test() ->
    ?assertEqual("No, but I will!",
		 "Have you written any tests?"),
    ok.

-endif.
