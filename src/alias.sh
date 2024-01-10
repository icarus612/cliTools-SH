#!/bin/bash

alias prun="poetry run python"

alias pclean="rm -rf $(poetry env info --path) && poetry install"