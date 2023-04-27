if ( a > 5 ) {
  int k = a + b ;
}else {
   k = a - b ;
}

while ( a > 5 ) {
  int k = a + b ;

  if ( k > 10 ) {
    k = k + 1 ;
  }endif
  continue;
}

for ( int i = 0 ; i < 10 ; i = i+ 1) {
  int k = a + b ;

  if ( k > 10 ) {
    k = k + 1 ;
  }endif
  break;

}

enum color { red, green, blue };
int x  ; 


int add ( int a, int b ) {
  const int x = 5 ;
  return a + b ;
}

repeat {
  int k = a + b ;

  if ( k > 10 ) {
    k = k + 1 ;
  }endif
  break;
} until ( a > 5 ) ;

switch ( a ) {
  case 1: 
    int k = a + b ;
    break;
  case 2:
    int k = a + b ;
    break;
  default:
    int k = a + b ;
    break;
}