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
x = true;
y = 6;
print(x);
print(y);


void main()
{
    int x = 5;
    print(x);
    {
        int x = 6.6;
        print(x);
    }
    print(x);
}
print(x);
print(y);

int func(float x, float y)
{
    x = 5.6;
    y = false;
    print(x);
    print(y);
    return x + y;
}
print(x);
print(y);