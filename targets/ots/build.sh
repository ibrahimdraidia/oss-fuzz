#!/bin/bash -eu
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

cd /src/ots

# Build the target.
./autogen.sh
./configure

#export LDFLAGS=$FUZZER_LDFLAGS
make libots.a libwoff2.a libbrotli.a

# Build the fuzzer.
$CXX $CXXFLAGS -std=c++11 -Iinclude \
    /src/ots_fuzzer.cc -o /out/ots_fuzzer \
    -lfuzzer -lz /src/ots/libots.a /src/ots/libwoff2.a /src/ots/libbrotli.a \
    $FUZZER_LDFLAGS

cp /src/ots_fuzzer.options /out/
zip /out/ots_fuzzer_seed_corpus.zip /src/seed_corpus/*
