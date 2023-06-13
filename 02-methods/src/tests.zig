const expect = @import("std").testing.expect;
const expectEqual = @import("std").testing.expectEqual;

const Node = @import("Node.zig");

test "basic init" {
    var a = Node{
        .data = 1,
    };
    try expect(a.data == 1);
    try expect(a.left == null);
    try expect(a.right == null);

    // can also be created using an anonymous struct
    // if the result type is known
    const b: Node = .{
        .data = 2,
        .left = &a,
    };

    try expect(b.data == 2);
    // have to unwrap the optional pointer with `.?`
    // which is equivalent to `(b.left orelse unreachable)`
    try expect(b.left.? == &a);
    try expect(a.right == null);
}

test "traversals" {
    var left = Node{ .data = 0 };
    var right = Node{ .data = 2 };
    var root = Node{
        .data = 1,
        .left = &left,
        .right = &right,
    };

    { // isolate the preorder test in a block so that we can add other traversals later
        var out = [_]?u8{null} ** 3;
        Node.traversePreorderToBuffer(&root, out[0..]);
        try expectEqual(out[0], 1);
        try expectEqual(out[1], 0);
        try expectEqual(out[2], 2);
    }
    {
        var out = [_]?u8{null} ** 3;
        Node.traverseInorderToBuffer(root, out[0..]);
        try expectEqual(out[0], 0);
        try expectEqual(out[1], 1);
        try expectEqual(out[2], 2);
    }
    {
        var out = [_]?u8{null} ** 4;
        root.traversePostorderToBuffer(out[0..]);
        try expectEqual(out[0], 0);
        try expectEqual(out[1], 2);
        try expectEqual(out[2], 1);
        try expectEqual(out[3], null);
    }
}
