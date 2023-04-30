if (a < b) {
    int k = 5;
} endif

if (a < b) {
    int k = 5;
} else {
    int k = 5;
}

if (a < b) {
    if (a < c) {
        int k = 5;
    } else {
        int k = 5;
    }
} else {
    if (b < c) {
        int k = 5;
    } else {
        int k = 5;
    }
}


if (a > b and a > c) {
    int k = 5;
} else if (b > c and b > a) {
    int k = 5;
}  else {
    int k = 5;
}

if (a > b or c > d) {
    int k = 5;
} else {
    int k = 5;
}


if (a < b) {
    // do something here
    int k = 5;
    // do something else here
} endif


if (a and b) {
    int k = 5;
} endif


if (not (a or b)) {
    int k = 5;
} endif


if (not (a or b)) {
    int k = 5;
} endif


if (a == b) {
    int k = 5;
} endif


if (1) {
    int k = 5;
} endif
 

// if (a > b) int k = 5;