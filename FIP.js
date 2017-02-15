// Main function to check a group of references in fip starting with a "#" seperated list.
// use https://convert.town/column-to-comma-separated-list to generate list from excel column.
function checkRefs(nums) {
    var numArray = nums.split("#");
    var tds = document.getElementsByTagName("td");
    var checked = [];
    var unchecked = [];
    
    for (var i = 0; i < numArray.length; i++) {
        if (searchElems(numArray[i], tds)) {
            checked.push(numArray[i]);
        } else {
            unchecked.push(numArray[i]);
        }
    }
    return [checked, unchecked];
}


// function to take a given value and search an array of elems for value.
// Returns true (and also calls check function) if found.  Returns false otherwise.
function searchElems(value, elems) {
    for (var i = 0; i < elems.length; i++) {
        if (elems[i].textContent.indexOf(value) != -1) {
            elems[i].parentElement.firstChild.click();
            return true;
        }
    }
    return false;
}


// function to select an arbitrary number of patent references in fip (starts from the top).
function checkPatRow(num) {
    boxes = document.getElementsByClassName("patent_checkRow");
    for (var i = 0; i < num; i++) {
        boxes[i].click();
    }
}


// function to select an arbitrary number of npl references in fip (starts from the top).
function checkPubRow(num) {
    boxes = document.getElementsByClassName("pub_checkRow");
    for (var i = 0; i < num; i++) {
        boxes[i].click();
    }
}


// function to select (and return a count of) all foreign patent docs in the references screen
function checkForeignPat() {
    var count = 0;
    var rows = document.querySelectorAll("input.patent_checkRow");
    for (var i=0; i < rows.length; i++) {
        var parent = rows[i].parentNode.parentNode;
        if (parent.children[6].textContent != "US") {
            parent.firstChild.click();
            count += 1;
        }
    }
    return count;
}

// function to select (and return a count of) all uncited US relatd matters on the related matters screen
function checkUSRelated() {
    var count = 0;
    var rows = document.querySelectorAll("input.check_family");
    for (var i=0; i < rows.length; i++) {
        var parent = rows[i].parentNode.parentNode;
        if (parent.children[2].textContent.indexOf("US") > -1 && 
            parent.children[10].textContent.indexOf("Yes") === -1
        ) {
            parent.firstChild.click();
            count += 1;
        }
    }
    return count;
}


// Function return a sorted list of all related matter families.
function getUniqueRelated() {
    var res_set = new Set();
    var rows = document.querySelectorAll("input.check_family");
    for (var i=0; i < rows.length; i++) {
        var parent = rows[i].parentNode.parentNode;
        var matterNum = parent.children[2].textContent;
        if (matterNum) {
            var family = matterNum.split(".")[1].substr(0, 3);
            res_set.add(family);
        }
    }
    results = Array.from(res_set);
    results.sort();
    return results;
}