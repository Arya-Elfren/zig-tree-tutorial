// We use the expect function from the standard library.
// It takes a boolean and returns an error if it is false.
// Documented here: https://ziglang.org/documentation/master/std/#A;std:testing.expect
const expect = @import("std").testing.expect;

const Node = @import("Node.zig");

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
