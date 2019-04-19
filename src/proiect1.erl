%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc proiect1.

-module(proiect1).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the proiect1 server.
start() ->
    proiect1_deps:ensure(),
    ensure_started(crypto),
    application:start(proiect1).


%% @spec stop() -> ok
%% @doc Stop the proiect1 server.
stop() ->
    application:stop(proiect1).
