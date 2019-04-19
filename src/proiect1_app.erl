%% @author Mochi Media <dev@mochimedia.com>
%% @copyright proiect1 Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the proiect1 application.

-module(proiect1_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for proiect1.
start(_Type, _StartArgs) ->
    proiect1_deps:ensure(),
    proiect1_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for proiect1.
stop(_State) ->
    ok.
