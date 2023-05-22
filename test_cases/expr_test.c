int x = 5;
int y = 3;
// float y = 13.0;

if (x < y) {
    print("x is less than y");
} endif

int func(int z, float y, bool x, string s) {
    print(z);
    print("inside func");
}

func(44, 8.3, true, "hello");


// print(x);
// print(y);

// x%y;
// print(x);
// print(y);

// print(x == y);
// print(x != y);
// print(x > y);
// print(x < y);
// print(x >= y);
// print(x <= y);



print(x+y);
print(x-y);
print(x*y);
print(x/y);
x = (x + 9);
print(x);
print(x%y);
print(x);


bool b = true;
bool c = false;
bool d = true;
bool e = false;

print(b);
print(c);
print(b and c);
print(b and d);
print(b or c);
print(b or d);
print(b == c);
print(b == d);

print(b != c);
print(b != d);

print(b xor c);
print(b xor d);


int t = 3;
int f = 5;

print(t + f);