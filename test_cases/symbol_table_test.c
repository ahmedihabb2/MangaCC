int x;
print(x);
int y = 5;
print(y);

x = y;
print(x);

{
    float x = 8.3;
    print(x);
        {
            print(x);
            int x = 5;
            print(x);
        }
    print(x);
}

print(x);
print(y);
