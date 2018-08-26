#!/usr/bin/env bash

if [ "$EXTRA_PIP_PACKAGES" ]; then
    echo "EXTRA_PIP_PACKAGES environment variable found.  Installing".
    /opt/conda/bin/pip install $EXTRA_PIP_PACKAGES
fi
jupyter notebook --config=/work/config/jupyter-config.py /work &
jupyter lab --port=8889 --config=/work/config/jupyter-config.py /work &
wait
