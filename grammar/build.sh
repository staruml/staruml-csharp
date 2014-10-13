#!/bin/bash

jison "$PWD/csharp.jison" "$PWD/csharp.jisonlex"  -t -p lalr > jisonOutput.txt
