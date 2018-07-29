#!/usr/bin/env bash

jupyter notebook --config=/work/config/jupyter-config.py /work &
jupyter lab --port=8889 --config=/work/config/jupyter-config.py /work &
wait
