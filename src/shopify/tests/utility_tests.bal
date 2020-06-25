import ballerina/test;
import ballerina/time;

const CAMEL_CASE_VALUE = "fullNameWithInitials";
const UNDERSCORE_CASE_VALUE = "full_name_with_initials";

@test:Config{}
function camelCaseConverterTest() {
    string camelCaseValue = convertToCamelCase(UNDERSCORE_CASE_VALUE);
    test:assertEquals(camelCaseValue, CAMEL_CASE_VALUE);
}

@test:Config{}
function underscoreCaseConvertedTest() {
    string underscoreCaseValue = convertToUnderscoreCase(CAMEL_CASE_VALUE);
    test:assertEquals(underscoreCaseValue, UNDERSCORE_CASE_VALUE);
}

@test:Config{}
function jsonToRecordKeyConversionTest() {
    json inputJson = {
        full_name: "John Doe",
        age: 20,
        courses: [
            {
                course_id: "CE 101",
                course_name: "Introduction to Programming"
            },
            {
                course_id: "EM 101",
                course_name: "Engineering Mathematics"
            }
        ]
    };

    json expectedJson = {
        fullName: "John Doe",
        age: 20,
        courses: [
            {
                courseId: "CE 101",
                courseName: "Introduction to Programming"
            },
            {
                courseId: "EM 101",
                courseName: "Engineering Mathematics"
            }
        ]
    };

    json actualJson = convertJsonKeysToRecordKeys(inputJson);
    test:assertEquals(actualJson, expectedJson);
}

@test:Config{}
function timeParsingTest() {
    string timeString = "2020-06-10T04:27:07-04:00";
    var parsedTime = getTimeRecordFromTimeString(timeString);
    if (parsedTime is Error) {
        test:assertFail("Time conversion failed. " + parsedTime.toString());
    }
}

@test:Config{}
function timeStringTest() {
    string timeString = "2020-06-10T04:27:07-04:00";
    var parsedTime = getTimeRecordFromTimeString(timeString);
    if (parsedTime is Error) {
        test:assertFail("Time conversion failed. " + parsedTime.toString());
    }
    time:Time time = <time:Time>parsedTime;
    string convertedTimeString = getTimeStringFromTimeRecord(time);
    test:assertEquals(convertedTimeString, timeString);
}
