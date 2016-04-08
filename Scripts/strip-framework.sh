#!/bin/sh
#
#
# OrangeTrustBadge
#
# File name:   strip-framework.sh
# Created:     07/04/2016
# Created by:  Marc Beaudoin
#
# Copyright 2016 Orange
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

OUTPUT_DIR="${DWARF_DSYM_FOLDER_PATH}/strip"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

INPUT_FRAMEWORK_BINARY=‘find ${DWARF_DSYM_FOLDER_PATH}/${FRAMEWORKS_FOLDER_PATH}/ -type f -name OrangeTrustBadge‘
OUTPUT_FRAMEWORK_BINARY="${OUTPUT_DIR}/OrangeTrustBadge"

# remove simulator arch form the release binaire
if [ "$CONFIGURATION" == "Release" ]; then
    if [  "$CURRENT_ARCH" != "x86_64" ]; then
        lipo -remove x86_64  -remove i386 "${INPUT_FRAMEWORK_BINARY}" -output "${OUTPUT_FRAMEWORK_BINARY}"
        cp -f "${OUTPUT_FRAMEWORK_BINARY}" "${INPUT_FRAMEWORK_BINARY}"
        rm -rf "$OUTPUT_DIR"
    fi
fi

exit 0

