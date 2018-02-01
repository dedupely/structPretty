# structPretty
Dlang Pretty Print Output for Structs

```
import structPretty;
import std.stdio;

struct Test {
  int a;
  int b;
  string hello;
}

Test t = Test(1, 2, "blah");

writeln(structPrettyPrint(t));
```
