## Varaibels and Const

-  <type> <name> = <value> 
    -  int x =5
- const <type> <name> = <value> 
    -   const int x = 5

## Mathematical and Logical expressions

- +, -, *, /, %, , ==, !=, >, <, >=, <=

- and , or , not , xor 

## Assignment statement

-  <name> = <value> 
    - x = 5

## If else statement

- if (<condition>) {
    <statement>
} endif;

- if (<condition>) {
    <statement>
} else {
    <statement>
}

## While loop

- while (<condition>) {
    <statement>
}

## Repeat until

- repeat {
    <statement>
} until (<condition>);

## For loop

- for (<initialization>; <condition>; <increment>) {
    <statement>
}

## Switch case

- switch (<variable>) {
    case <value>:
        <statement>
        break;
    case <value>:
        <statement>
        break;
    default:
        <statement>
}

## Block structure

- {
    <statement>
    {
        <statement>
    }
}

## Function

- <type> <name>(<parameters>) {
    <statement>
    return <value>;
}

## Enum

- enum <name> {
    <value>,
    <value>,
    <value>
};


# TODOs 
- Bison work with left recursion  
    - stmt_list : stmt stmt_list 
          | stmt
          ;
    Will be
    - stmt_list : stmt stmt_list 
          | stmt
          ;

