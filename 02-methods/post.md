# Methods

> I have corrected some small inacuracies in the first post and uploaded the code to [GitHub](https://github.com/Arya-Elfren/zig-tree-tutorial).

Let's make our binary tree structure also encode some behaviour.

## Namespaced functions

Functions placed in a struct, or in a file (as we saw they're equivalent), are namespaced within that struct. For example, the `std.testing.expect` function we used in our tests last time. This is a convenient and logical place to put functions related to our data structures. So let's use this to implement some simple traversals for our binary tree.

So, in our `Node.zig` file let's create a function that writes the preorder representation of our tree to a buffer.
```zig
pub fn traversePreorderToBuffer(self: *Node, buf: []?u8) void {}
```
We take a pointer to our current `Node` and a slice of nullable `u8`s. This is so that we can go through (without an index) and find where we should insert the next item.

For preorder we first append our current data to the buffer. We do so by looping over it and finding the first slot that isn't `null`. We set this to the data in our current node and break. Then we recurse on the left and right subtrees, if they're there.
```zig
pub fn traversePreorderToBuffer(self: *Node, buf: []?u8) void {
    for (buf) |*slot| if (slot.*) |_| {} else {
        slot.* = self.data;
        break;
    };
    if (self.left) |left| Node.traversePreorderToBuffer(left, buf);
    if (self.right) |right| Node.traversePreorderToBuffer(right, buf);
}
```

Let's write a test to see how to use this:
```zig
const expectEqual = @import("std").testing.expectEqual;

test "traversals" {
    var left = Node{ .data = 0 };
    var right = Node{ .data = 2 };
    var root = Node{
        .data = 1,
        .left = &left,
        .right = &right,
    };

    { // isolate the preorder test so we can add other traversals later
        var out = [_]?u8{null} ** 3;
        Node.traversePreorderToBuffer(&root, out[0..]);
        try expectEqual(out[0], 1);
        try expectEqual(out[1], 0);
        try expectEqual(out[2], 2);
    }
}
```

First we create the binary tree `(1 (0) (2))` and a length 3 buffer to store the output. Then we call the `traversePreorderToBuffer` function from the `Node` namespace, pass a reference to our root node and a [slice](https://ziglang.org/documentation/master/#Slices) of our buffer. We then use the `testing.expectEqual` to check our result (instead of `expect(a == b)` from last time, we just do `expectEqual(a, b)`).

## Method syntax sugar

As I mentioned at the start, this is the most convenient and logical place to put functions that use our struct. It turns out that we frequently want to implement functions that look like this:
`Node.zig`
```zig
pub fn traversePreorderToBuffer(self: *Node, buf: []?u8) void {}
pub fn traverseInorderToBuffer(node: Node, buf: []?u8) void {}
pub fn traversePostorderToBuffer(node: *const Node, buf: []?u8) void {}
```

However, it's a pain to always write `Type.function(instance, ...)` or having to import and rename every function to shorten it. Especially since we know it will always be `@TypeOf(instance).function(instance)` (or `@TypeOf(instance.*).function(instance)`).

Zig lets you call these functions with dot syntax as if they were methods. Effectively, if the first argument to a function that is namespaced in a container is that container (or a pointer to it) you can use the instance as the namespace.

So, for example, we can call `traversePostorderToBuffer` like this (in the above test):
```zig
{
    var out = [_]?u8{null} ** 4;
    root.traversePostorderToBuffer(out[0..]);
    try expectEqual(out[0], 0);
    try expectEqual(out[1], 2);
    try expectEqual(out[2], 1);
    try expectEqual(out[3], null);
}
```

## Conclusion

This time we learned how to give our binary tree behaviour and how to easily access it through dot notation.

