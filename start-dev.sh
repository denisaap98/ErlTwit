#!/bin/sh
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname proiect1_dev \
    -s proiect1 \
    -s reloader
