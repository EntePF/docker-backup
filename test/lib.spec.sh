#!/bin/bash

. ./src/lib.sh

testdescription=""
passed=0;
failed=0;
function startTest() { local description="$1";
	testdescription="$description";
}

function pass() {
	echo "PASS: $testdescription";
	passed=$(expr $passed + 1);
}

function fail() {
	echo "FAIL: $testdescription";
	failed=$(expr $failed + 1);
}

function endTests() {
	local total=$(expr $passed + $failed);
	if [ $failed -gt 0 ]
	then
		echo "$failed/$total tests failed";
		exit 1;
	else
		echo "Passed $total tests";
		exit 0;
	fi;
}

function assertEqual() { local a="$1"; local b="$2";
	if [ "$a" == "$b" ]
	then
		pass;
	else 
		fail;
	fi;
}

startTest "log message should output message to console";
output="";
expected="test message";
log="test-environment/$testdescription.log";

actual=$(log "$expected" "$log");

assertEqual "$expected" "$actual";

startTest "log message should output message to log";
output="";
expected="test message";
log="test-environment/$testdescription.log";
rm "$log";

log "$expected" "$log" > /dev/null;

actual=$(cat "$log");
assertEqual "$expected" "$actual";

endTests;
