# Testing and Files as Structs

Let's build a binary tree in Zig.

## Setup

- Get [Zig master](https://ziglang.org/download/)
- Create a folder for this project
- In that folder run `zig init-lib`

Now our folder has a `build.zig` file and a `src` directory with `main.zig` in it. This is a good default structure for your code.

`build.zig` is written in Zig, but it constructs a declarative build graph for your project. It can be invoked with `zig build`. By default it also sets up tests for you which we will use later.

## Struct

We want to create a data structure, that's what a `struct` is for! So let's create one:

```zig
const Node = struct {};
```

We capitalize `Node` [because](https://ziglang.org/documentation/0.10.1/#Names) it is a type. It is `const` because we have no reason to modify a type after we create it.

This will represent one node in our binary tree, so it needs to contain a piece of data and two children. We're not going to use generics yet so let us choose to store a `u8`.

If we made the children `Node`s then this definition would be recursive and we couldn't determine its size. So instead we store pointers to other nodes. This is still not perfect as it doesn't let any `Node` be a leaf node. It forces every `Node` to have two children which would require an infinite tree, so let us make those pointers optional, resulting in `?*Node`.

```zig
const Node = struct {
    data: u8,
    left: ?*Node,
    right: ?*Node,
};
```

## Testing

To make a unit-test we use a `test` block structured like so:

```zig
test "name" {
    // if any code placed here returns an error then
    // the test fails, if not it succeeds
}
```

So let's make a small test that creates a `Node` or two.

```zig
// We use the expect function from the standard library.
// It takes a boolean and returns an error if it is false.
// Documented here: https://ziglang.org/documentation/master/std/#A;std:testing.expect
const expect = @import("std").testing.expect;

test "basic init" {
    var a = Node{
        .data = 1,
        .left = null,
        .right = null,
    };
    try expect(a.data == 1);
    try expect(a.left == null);
    try expect(a.right == null);

    // can also be created using an anonymous struct
    // if the result type is known
    const b: Node = .{
        .data = 2,
        .left = &a,
        .right = null,
    };

    try expect(b.data == 2);
    // have to unwrap the optional pointer with `.?`
    // which is equivalent to `(b.left orelse unreachable)`
    try expect(b.left.? == &a);
    try expect(a.right == null);
}
```

We can run the test with `zig build test`, it passes.

## Simplifying with defaults

Writing null every time we want to initialise our `Node` is unnecessary, so we default the children to initialise as `null`.

```zig
const Node = struct {
    data: u8,
    left: ?*Node = null,
    right: ?*Node = null,
};
```

This makes our initialisation of `Node` `a` from the test above just:

```zig
var a = Node{ .data = 1 };
```

## Files are structs

The above code currently looks like this:

`main.zig`
```zig
const expect = @import("std").testing.expect;

const Node = struct {
    data: u8
    left: ?*Node = null,
    right: ?*Node = null,
};

test "basic init" {
    // snip
}
```

If we wanted to separate our `Node` into a different file we could just copy it, but then our import would be `const Node = @import("Node.zig").Node` which is repetitive. Here we can use the fact that files are structs to remove a level of indentation from our definition. The above code is equivalent to this:

`main.zig`
```zig
const expect = @import("std").testing.expect;

const Node = @import("Node.zig");

test "basic init" {
    // snip
}
```

`Node.zig`
```zig
const Node = @import("Node.zig");

data: u8,
left: ?*Node = null,
right: ?*Node = null,
```

Here we do need to import the file from within the file, so that we can give our struct a name, `Node`, to use in the recursive pointers.

There is another more general way to do this which we will cover later.

## Conclusion

We've created the structure of a binary tree in Zig, next we'll give it some methods and do some other things to make it more useful.
