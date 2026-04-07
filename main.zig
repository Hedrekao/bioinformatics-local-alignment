const std = @import("std");

const Reason = enum {
    Deletion,
    Insertion,
    Match,
    Mismatch,

    pub fn chars(self: Reason, q_char: u8, s_char: u8) [3]u8 {
        return switch (self) {
            .Match => .{ q_char, '|', s_char },
            .Mismatch => .{ q_char, '*', s_char },
            .Insertion => .{ '-', ' ', s_char },
            .Deletion => .{ q_char, ' ', '-' },
        };
    }
};

const Entry = struct { score: i32, prev_idx: usize, reason: Reason };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3) {
        std.debug.print("Usage: {s} <query dna> <subj dna>\n", .{args[0]});
        return;
    }

    const query = args[1];
    const subj = args[2];

    const query_len = query.len + 1;
    const subj_len = subj.len + 1;

    var matrix = try allocator.alloc(Entry, query_len * subj_len);
    defer allocator.free(matrix);

    @memset(matrix, .{ .score = 0, .prev_idx = 0, .reason = .Match });

    var best_score: i32 = 0;
    var best_idx: usize = 0;

    for (1..subj_len) |i| {
        for (1..query_len) |j| {
            const score_up = matrix[(i - 1) * query_len + j].score - 1;
            const score_left = matrix[i * query_len + (j - 1)].score - 1;
            const score_diag = matrix[(i - 1) * query_len + (j - 1)].score + if (query[j - 1] == subj[i - 1]) @as(i32, 2) else @as(i32, -1);

            var max_score = score_diag;
            var prev_idx = (i - 1) * query_len + (j - 1);
            var reason: Reason = if (query[j - 1] == subj[i - 1]) .Match else .Mismatch;

            if (score_up > max_score) {
                max_score = score_up;
                prev_idx = (i - 1) * query_len + j;
                reason = .Insertion;
            }
            if (score_left > max_score) {
                max_score = score_left;
                prev_idx = i * query_len + (j - 1);
                reason = .Deletion;
            }

            max_score = @max(0, max_score);

            const current_idx = i * query_len + j;
            if (max_score > best_score) {
                best_score = max_score;
                best_idx = current_idx;
            }

            matrix[current_idx] = .{
                .score = max_score,
                .prev_idx = prev_idx,
                .reason = reason,
            };
        }
    }

    std.debug.print("Final score: {d}\n", .{best_score});

    var indices = std.ArrayList(usize).empty;
    defer indices.deinit(allocator);

    var current_idx = best_idx;
    while (matrix[current_idx].score > 0) {
        try indices.append(allocator, current_idx);
        current_idx = matrix[current_idx].prev_idx;
    }

    std.mem.reverse(usize, indices.items);

    inline for (0..3) |i| {
        print_alignment(matrix, query, subj, indices.items, i);
    }
}

pub fn print_alignment(matrix: []const Entry, query: []const u8, subj: []const u8, indices: []const usize, line: comptime_int) void {
    for (indices) |idx| {
        const entry = matrix[idx];
        const q_idx = idx % (query.len + 1);
        const s_idx = idx / (query.len + 1);

        const char = entry.reason.chars(query[q_idx - 1], subj[s_idx - 1])[line];
        std.debug.print("{c}", .{char});
    }
    std.debug.print("\n", .{});
}
