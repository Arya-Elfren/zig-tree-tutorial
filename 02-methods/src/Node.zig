const Node = @import("Node.zig");
const std = @import("std");

data: u8,
left: ?*Node = null,
right: ?*Node = null,

pub fn traversePreorderToBuffer(self: *Node, buf: []?u8) void {
    for (buf) |*slot| if (slot.*) |_| {} else {
        slot.* = self.data;
        break;
    };
    if (self.left) |left| Node.traversePreorderToBuffer(left, buf);
    if (self.right) |right| Node.traversePreorderToBuffer(right, buf);
}

pub fn traverseInorderToBuffer(node: Node, buf: []?u8) void {
    if (node.left) |left| left.traverseInorderToBuffer(buf);

    for (buf) |*slot| if (slot.*) |_| {} else {
        slot.* = node.data;
        break;
    };

    if (node.right) |right| right.traverseInorderToBuffer(buf);
}

pub fn traversePostorderToBuffer(node: *const Node, buf: []?u8) void {
    if (node.left) |left| left.traversePostorderToBuffer(buf);
    if (node.right) |right| right.traversePostorderToBuffer(buf);

    for (buf) |*slot| if (slot.*) |_| {} else {
        slot.* = node.data;
        break;
    };
}
