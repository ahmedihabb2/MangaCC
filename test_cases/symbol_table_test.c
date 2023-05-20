int x;
int ahmed = 1;
print(x);
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
y = 6;
print(x);
print(y);


void main()
{
    int x = 5;
    print(x);
    {
        int x = 6;
        print(x);
    }
    print(x);
}
print(x);
print(y);

int func(float x, float y)
{
    x = 5.6;
    print(x);
    print(y);
    return x + y;
}
print(x);
print(y);