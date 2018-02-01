module structPretty;

import std.json;
import std.traits;
import std.conv;

string tabLevels(int l) {
  string nls;
  
  for(int i = 0; i < l; i++)  nls ~= "  ";
  
  return nls;
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if((isIntegral!T || isFloatingPoint!T) && isBuiltinType!T) {
  
  return tabLevels(tabs) ~ (!hideLabel ? (hideType ? "" : typeid(T).toString()) ~ " " ~ name ~ ": " : "") ~ to!string(t);
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if(isSomeString!T) {
  
  return tabLevels(tabs) ~ (!hideLabel ? (hideType ? "" : "string") ~ " " ~ name ~ ": " : "") ~ "\"" ~ t ~ "\"";
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if(isBoolean!T) {
  
  return tabLevels(tabs) ~ (!hideLabel ? (hideType ? "" : typeid(T).toString()) ~ " " ~ name ~ ": " : "") ~ (t ? "true" : "false");
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if(isArray!T && !isSomeString!T) {
    string tarr;
    
    foreach(a; t) {
      tarr ~= structPrettyPrint(a, "", true, true, tabs + 1) ~ "\n";
    }
    
  return tabLevels(tabs) ~ (!hideLabel ? (hideType ? "" : typeid(T).toString()) ~ " " ~ name ~ ": " : "") ~ "[\n" ~ tarr ~ tabLevels(tabs) ~ "]";
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if(isAssociativeArray!T) {
    string tarr;
    
    foreach(key, a; t) {
      tarr ~= structPrettyPrint(a, `"` ~ key ~ `"`, false, true, tabs + 1) ~ "\n";
    }
    
  return tabLevels(tabs) ~ (!hideLabel ? (hideType ? "" : typeid(T).toString()) ~ " " ~ name ~ ": " : "") ~ "[\n" ~ tarr ~ tabLevels(tabs) ~ "]";
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0)
  if(!isBuiltinType!T && 
    !isAssociativeArray!T && 
    !isBasicType!T &&
    !isFunction!T &&
    !isCallable!T &&
    !is(T == JSONValue)) {
    import std.string;
    
    string output = tabLevels(tabs) ~ (hideType ? "" : typeid(T).toString) ~ " {\n";
    
    foreach(fname; __traits(allMembers, T)) {
      static if(!isCallable!(mixin("T." ~ fname)) && !isFunction!(mixin("T." ~ fname)) && !__traits(isTemplate, mixin("T." ~ fname)))
        output ~= structPrettyPrint(mixin("t." ~ fname), fname, false, false, tabs + 1) ~ "\n";
    }

    return output.replace(`immutable(char)[]`, "string") ~ tabLevels(tabs) ~ "}\n";
}

string structPrettyPrint(T)(T t, string name = null, bool hideLabel = false, bool hideType = false, int tabs = 0) if( 
    isFunction!T ||
    isCallable!T ||
    is(T == JSONValue)) {
      return to!string(t);
}
