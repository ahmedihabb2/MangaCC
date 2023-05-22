int x = 0 ;
const int y  = 3 ;

int z = 556 + y ;

int main2() {
      return 0 ;
}

int main() {
    if (x < 0) {
        x = -1 ;
        while(x > 0) {
            x = x - 1 ;
            main2();
        }
    }endif
    print(z);
    return 0 ;
}


