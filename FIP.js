// This JS file is not intended to be used as a JS file for a website.  Each
// Function below is something I wrote to paste into the console of FIP.
// Each function automates or expidites a frequently repeated tasks

// Main function to check a group of references in fip starting with a "#" seperated list.
// use https://convert.town/column-to-comma-separated-list to generate list from excel column.
function checkRefs(nums) {
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
checkRefs(nums)


// function to select an arbitrary number of patent references in fip (starts from the top).
function checkPatRow(num) {
    boxes = document.getElementsByClassName("patent_checkRow");
    for (var i = 0; i < num; i++) {
        boxes[i].click();
    }
}
checkPatRow(num)


// function to select an arbitrary number of npl references in fip (starts from the top).
function checkPubRow(num) {
    boxes = document.getElementsByClassName("pub_checkRow");
    for (var i = 0; i < num; i++) {
        boxes[i].click();
    }
}
checkPubRow(num)


// function to select (and return a count of) all foreign patent docs in the references screen
(function checkForeignPat() {
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
}())


// function to select all references to be downloaded for submission with IDS/SIDS
(function checkDownload(){
    function checkAttach() {
        var results = []

        // Select all matching lines in the patent section
        var patent_rows = document.querySelectorAll("input.patent_checkRow");
        for (var i=0; i < patent_rows.length; i++) {
            var parent = patent_rows[i].parentNode.parentNode;
            if (parent.children[2].childElementCount < 2) {
                results.push(parent.children[1].firstChild.firstChild.textContent);
            }
        }

        // Select all matching lines in the NPL section 
        var pub_rows = document.querySelectorAll("input.pub_checkRow")
        for (var j=0; j < pub_rows.length; j++) {
            var parent = pub_rows[j].parentNode.parentNode;
            if (parent.children[2].childElementCount < 2) {
                results.push(parent.children[1].firstChild.firstChild.textContent);
            }
        }
        return results
    }

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

    function checkNPL() {
        var count = 0;
        var rows = document.querySelectorAll("input.pub_checkRow");
        for (var i=0; i < rows.length; i++) {
            var parent = rows[i].parentNode.parentNode;
            parent.firstChild.click();
            count += 1;
            }
        return count;
    }
    var noFile = checkAttach()
    if (noFile.length == 0) {
        noFile = 0
    }
    var forCount = checkForeignPat()
    var nplCount = checkNPL()
    console.log("Refs missing attachments: " + noFile + ".\n" + forCount + " Foreign and " + nplCount + " NPL refs checked and ready to download.")    
}())


// function to select (and return a count of) all uncited US relatd matters on the related matters screen
(function checkUSRelated() {
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
}())



// Function return a sorted list of all related matter families.
(function getUniqueRelated() {
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
    console.log("Number of related families =", results.length);
    return results;
}())



// Function to check all references cited on an arbitray date (01-01-01)
(function selectTempMarked() {
    var count = 0;

    // Select all matching lines in the patent section
    var patent_rows = document.querySelectorAll("input.patent_checkRow");
    var date = " Jan 1, 2001"
    for (var i=0; i < patent_rows.length; i++) {
        var parent = patent_rows[i].parentNode.parentNode;
        if (parent.children[11].textContent === date) {
            parent.firstChild.click();
            count += 1;
        }
    }

    // Select all matching lines in the NPL section 
    var pub_rows = document.querySelectorAll("input.pub_checkRow")
    for (var j=0; j < pub_rows.length; j++) {
        var parent = pub_rows[j].parentNode.parentNode;
        if (parent.children[11].textContent === date) {
            parent.firstChild.click();
            count += 1;
        }
    }
    return count;
}())


// Function to return list of any reference missing an attachment.
(function checkAttach() {
    var results = []

    // Select all matching lines in the patent section
    var patent_rows = document.querySelectorAll("input.patent_checkRow");
    for (var i=0; i < patent_rows.length; i++) {
        var parent = patent_rows[i].parentNode.parentNode;
        if (parent.children[2].childElementCount < 2) {
            results.push(parent.children[1].firstChild.firstChild.textContent);
        }
    }

    // Select all matching lines in the NPL section 
    var pub_rows = document.querySelectorAll("input.pub_checkRow")
    for (var j=0; j < pub_rows.length; j++) {
        var parent = pub_rows[j].parentNode.parentNode;
        if (parent.children[2].childElementCount < 2) {
            results.push(parent.children[1].firstChild.firstChild.textContent);
        }
    }
    return results
}())
