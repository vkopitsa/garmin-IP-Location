import Toybox.Lang;
import Toybox.Test;

function arrayToString(elements as Array<String>) as String {
    var s = elements.size() > 0 ? elements[0] : "";
    for (var i = 1; i < elements.size(); i++) {
       s += ", " + elements[i];
    }

    return s;
}

(:test)
function arrayToStringTest(logger as Logger) as Boolean {

    Test.assert(arrayToString(["1", "2", "3"]).equals("1, 2, 3"));
    Test.assert(arrayToString(["1"]).equals("1"));
    Test.assert(arrayToString([]).equals(""));

    return true;
}
