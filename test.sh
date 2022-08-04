#!/bin/bash

ANTLR_JAR="antlr-4.10.1-complete.jar"

GRAMMAR="Ralph"
START_RULE="sourceUnit"
TEST_FILE="test.ral"
# ERROR_PATTERN="mismatched|extraneous"
ERROR_PATTERN="extraneous"

if [ ! -e "$ANTLR_JAR" ]; then
  curl https://www.antlr.org/download/antlr-4.10.1-complete.jar -o "$ANTLR_JAR"
fi

mkdir -p target/

# java -jar $ANTLR_JAR $GRAMMAR.g4 -o src/
java -jar $ANTLR_JAR *.g4 -o src/
#java -jar $ANTLR_JAR *.g4 -o src/
javac -classpath $ANTLR_JAR src/*.java -d target/

java -classpath $ANTLR_JAR:target/ org.antlr.v4.gui.TestRig "$GRAMMAR" "$START_RULE" < "$TEST_FILE" 2>&1 |
  grep -qE "$ERROR_PATTERN" && echo "TESTS FAIL!" || echo "TESTS PASS!"

