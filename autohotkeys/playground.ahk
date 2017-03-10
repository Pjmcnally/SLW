; This file is where I do experimental or fun stuff in Autohotkey.

^!t::
; testing 

array := [1, 2, 3, 4, 5]
shuffle(array)
msgbox % "[" . array[1] . ", " array[2] . ", " array[3] . ", " array[4] . ", " array[5] . "]"


testRandDict(num) {
    dict := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0}
    i = 0
    while (i < num) {
        Random, rand, 0.0, 1.0
        rand_num := Ceil(rand * 5)
        dict[rand_num] := dict[rand_num] + 1
        i += 1
    }
    return dict
}


genRandomArray(array) {
    ; This is an implementation of the Fischer-Yates shuffle where the original array is undisturbed.
    a := array.clone()  ; Copy of array so original is not changed

    i := array.length()  ; Arrays are 1-indexed so I dont need to -1 here.
    while (i > 1) {  ; Dont need to swap the last element with itself.
        Random, rand, 0.0, 1.0  ; Get random float between 0 and 1
        j := Ceil(rand * i)  ; Turn float to int between 1 and i (currently unrandomized digits)
        temp := a[i], a[i] := a[j], a[j] := temp  ; swap values at i and j in array
        i -= 1
    }
    return a
}


shuffle(a) {
    ; This is an implementation of the Fischer-Yates shuffle (in place)
    i := a.length()  ; Arrays are 1-indexed so I dont need to -1 here.
    while (i > 1) {  ; Dont need to swap the last element with itself.
        Random, rand, 0.0, 1.0  ; Get random float between 0 and 1
        j := Ceil(rand * i)  ; Turn float to int between 1 and i (currently unrandomized digits)
        temp := a[i], a[i] := a[j], a[j] := temp  ; swap values at i and j in array
        i -= 1
    }
    return a
}
