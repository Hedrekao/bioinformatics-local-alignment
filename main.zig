const std = @import("std");

const AminoAcid = enum(u5) {
    A = 0,
    R = 1,
    N = 2,
    D = 3,
    C = 4,
    Q = 5,
    E = 6,
    G = 7,
    H = 8,
    I = 9,
    L = 10,
    K = 11,
    M = 12,
    F = 13,
    P = 14,
    S = 15,
    T = 16,
    W = 17,
    Y = 18,
    V = 19,
};

// BLOSUM62 scoring matrix
const Blosum62 = struct {
    matrix: [20][20]i8,

    pub inline fn getScore(self: Blosum62, aa1: AminoAcid, aa2: AminoAcid) i32 {
        return @intCast(self.matrix[@intFromEnum(aa1)][@intFromEnum(aa2)]);
    }

    fn init() Blosum62 {
        var m: [20][20]i8 = undefined;

        // Row A
        m[@intFromEnum(AminoAcid.A)] = .{ 4, -1, -2, -2, 0, -1, -1, 0, -2, -1, -1, -1, -1, -2, -1, 1, 0, -3, -2, 0 };
        // Row R
        m[@intFromEnum(AminoAcid.R)] = .{ -1, 5, 0, -2, -3, 1, 0, -2, 0, -3, -2, 2, -1, -3, -2, -1, -1, -3, -2, -3 };
        // Row N
        m[@intFromEnum(AminoAcid.N)] = .{ -2, 0, 6, 1, -3, 0, 0, 0, 1, -3, -3, 0, -2, -3, -2, 1, 0, -4, -2, -3 };
        // Row D
        m[@intFromEnum(AminoAcid.D)] = .{ -2, -2, 1, 6, -3, 0, 2, -1, -1, -3, -4, -1, -3, -3, -1, 0, -1, -4, -3, -3 };
        // Row C
        m[@intFromEnum(AminoAcid.C)] = .{ 0, -3, -3, -3, 9, -3, -4, -3, -3, -1, -1, -3, -1, -2, -3, -1, -1, -2, -2, -1 };
        // Row Q
        m[@intFromEnum(AminoAcid.Q)] = .{ -1, 1, 0, 0, -3, 5, 2, -2, 0, -3, -2, 1, 0, -3, -1, 0, -1, -2, -1, -2 };
        // Row E
        m[@intFromEnum(AminoAcid.E)] = .{ -1, 0, 0, 2, -4, 2, 5, -2, 0, -3, -3, 1, -2, -3, -1, 0, -1, -3, -2, -2 };
        // Row G
        m[@intFromEnum(AminoAcid.G)] = .{ 0, -2, 0, -1, -3, -2, -2, 6, -2, -4, -4, -2, -3, -3, -2, 0, -2, -2, -3, -3 };
        // Row H
        m[@intFromEnum(AminoAcid.H)] = .{ -2, 0, 1, -1, -3, 0, 0, -2, 8, -3, -3, -1, -2, -1, -2, -1, -2, -2, 2, -3 };
        // Row I
        m[@intFromEnum(AminoAcid.I)] = .{ -1, -3, -3, -3, -1, -3, -3, -4, -3, 4, 2, -3, 1, 0, -3, -2, -1, -3, -1, 3 };
        // Row L
        m[@intFromEnum(AminoAcid.L)] = .{ -1, -2, -3, -4, -1, -2, -3, -4, -3, 2, 4, -2, 2, 0, -3, -2, -1, -2, -1, 1 };
        // Row K
        m[@intFromEnum(AminoAcid.K)] = .{ -1, 2, 0, -1, -3, 1, 1, -2, -1, -3, -2, 5, -1, -3, -1, 0, -1, -3, -2, -2 };
        // Row M
        m[@intFromEnum(AminoAcid.M)] = .{ -1, -1, -2, -3, -1, 0, -2, -3, -2, 1, 2, -1, 5, 0, -2, -1, -1, -1, -1, 1 };
        // Row F
        m[@intFromEnum(AminoAcid.F)] = .{ -2, -3, -3, -3, -2, -3, -3, -3, -1, 0, 0, -3, 0, 6, -4, -2, -2, 1, 3, -1 };
        // Row P
        m[@intFromEnum(AminoAcid.P)] = .{ -1, -2, -2, -1, -3, -1, -1, -2, -2, -3, -3, -1, -2, -4, 7, -1, -1, -4, -3, -2 };
        // Row S
        m[@intFromEnum(AminoAcid.S)] = .{ 1, -1, 1, 0, -1, 0, 0, 0, -1, -2, -2, 0, -1, -2, -1, 4, 1, -3, -2, -2 };
        // Row T
        m[@intFromEnum(AminoAcid.T)] = .{ 0, -1, 0, -1, -1, -1, -1, -2, -2, -1, -1, -1, -1, -2, -1, 1, 5, -2, -2, 0 };
        // Row W
        m[@intFromEnum(AminoAcid.W)] = .{ -3, -3, -4, -4, -2, -2, -3, -2, -2, -3, -2, -3, -1, 1, -4, -3, -2, 11, 2, -3 };
        // Row Y
        m[@intFromEnum(AminoAcid.Y)] = .{ -2, -3, -2, -3, -2, -1, -2, -3, 2, -1, -1, -2, -1, 3, -3, -2, -2, 2, 7, -1 };
        // Row V
        m[@intFromEnum(AminoAcid.V)] = .{ 0, -3, -3, -3, -1, -2, -2, -3, -3, 3, 1, -2, 1, -1, -2, -2, 0, -3, -1, 4 };

        return .{ .matrix = m };
    }
};

const BLOSUM62: Blosum62 = .init();

// we use affine gap penalty where opening the gap has a high penalty and extending the gap a lower one
var GAP_OPEN_PENALTY: i32 = -11;
var GAP_EXTEND_PENALTY: i32 = -1;

// at each position of alignment we either have a match/mismatch, an insertion or a deletion. We can represent these with an enum and store the type of alignment along with the score and the index of the previous cell in the matrix to allow traceback for building the final alignment.
const AlignmentType = union(enum) {
    MatchMismatch: usize,
    Insertion: usize,
    Deletion,
};

// entry in the dynamic programming matrix during global alignment process with affine gap penalty
const MatrixState = enum { M, I, D };
const Entry = struct { score: i32, prev_idx: usize, prev_matrix: MatrixState, alignment_type: AlignmentType };

const Alignment = []AlignmentType;

// result of global alignment containing the final score and the alignment itself
const AlignmentResult = struct {
    score: i32,
    alignment: Alignment,
};

// the star sequence is the sequence that has the highest total score when aligned to all other sequences. We store the index of the star sequence, its alignments to all other sequences and the maximum score for later use in building the multi-alignment.
const StarSequence = struct {
    idx: usize,
    alignments: []Alignment,
    max_score: i32,
};

// global aligment with affine gap penalty following Gotoh's algorithm' (more optimized version of Smith-Waterman that works better with affine gap penalty)
fn globalAlignment(allocator: std.mem.Allocator, query: []const u8, subj: []const u8) !AlignmentResult {
    const query_len = query.len + 1;
    const subj_len = subj.len + 1;

    const neg_inf: i32 = -999999;

    // we maintain three matrices M, I, D
    // M[i][j] = best score for aligning query[0..i] and subj[0..j] ending in a match/mismatch
    // I[i][j] = best score for aligning query[0..i] and subj[0..j] ending in an insertion (gap in query)
    // D[i][j] = best score for aligning query[0..i] and subj[0..j] ending in a deletion (gap in subj)
    var M = try allocator.alloc(Entry, query_len * subj_len);
    defer allocator.free(M);

    var I = try allocator.alloc(Entry, query_len * subj_len);
    defer allocator.free(I);

    var D = try allocator.alloc(Entry, query_len * subj_len);
    defer allocator.free(D);

    // 1. Initialize Top-Left Cell (i=0, j=0)
    M[0] = .{ .score = 0, .prev_idx = 0, .prev_matrix = .M, .alignment_type = .{ .MatchMismatch = 0 } };
    I[0] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .I, .alignment_type = .{ .Insertion = 0 } };
    D[0] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .D, .alignment_type = .Deletion };

    // 2. Initialize Top Boundary (j > 0, i=0)
    for (1..query_len) |j| {
        const idx = 0 * query_len + j;
        const gap_penalty = GAP_OPEN_PENALTY + @as(i32, @intCast(j - 1)) * GAP_EXTEND_PENALTY;

        // just a placeholder as deletions only matter in actual deletion matrix
        M[idx] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .M, .alignment_type = .Deletion };
        I[idx] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .I, .alignment_type = .{ .Insertion = 0 } };

        D[idx] = .{ .score = gap_penalty, .prev_idx = j - 1, .prev_matrix = if (j == 1) .M else .D, .alignment_type = .Deletion };
    }

    for (1..subj_len) |i| {
        const idx = i * query_len + 0;
        const gap_penalty = GAP_OPEN_PENALTY + @as(i32, @intCast(i - 1)) * GAP_EXTEND_PENALTY;

        // just a placeholder as insertions only matter in actual insertion matrix
        M[idx] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .M, .alignment_type = .{ .MatchMismatch = 0 } };
        D[idx] = .{ .score = neg_inf, .prev_idx = 0, .prev_matrix = .D, .alignment_type = .Deletion };

        I[idx] = .{ .score = gap_penalty, .prev_idx = (i - 1) * query_len, .prev_matrix = if (i == 1) .M else .I, .alignment_type = .{ .Insertion = i - 1 } };
    }

    // Fill the matrices - dynamic programming step
    for (1..subj_len) |i| {
        for (1..query_len) |j| {
            const current_idx = i * query_len + j;
            const diag_idx = (i - 1) * query_len + (j - 1);
            const up_idx = (i - 1) * query_len + j;
            const left_idx = i * query_len + (j - 1);

            const aa1 = std.meta.stringToEnum(AminoAcid, &[_]u8{query[j - 1]}).?;
            const aa2 = std.meta.stringToEnum(AminoAcid, &[_]u8{subj[i - 1]}).?;
            const blosum_score = BLOSUM62.getScore(aa1, aa2);

            // fill matrix M
            {
                const m_from_m = M[diag_idx].score + blosum_score;
                const m_from_i = I[diag_idx].score + blosum_score;
                const m_from_d = D[diag_idx].score + blosum_score;

                var m_max = m_from_m;
                var m_prev_mat = MatrixState.M;

                if (m_from_i > m_max) {
                    m_max = m_from_i;
                    m_prev_mat = .I;
                }
                if (m_from_d > m_max) {
                    m_max = m_from_d;
                    m_prev_mat = .D;
                }

                M[current_idx] = .{
                    .score = m_max,
                    .prev_idx = diag_idx,
                    .prev_matrix = m_prev_mat,
                    .alignment_type = .{ .MatchMismatch = i - 1 },
                };
            }

            // fill matrix I
            {
                const i_from_m = M[up_idx].score + GAP_OPEN_PENALTY;
                const i_from_i = I[up_idx].score + GAP_EXTEND_PENALTY;

                var i_max = i_from_m;
                var i_prev_mat = MatrixState.M;

                if (i_from_i > i_max) {
                    i_max = i_from_i;
                    i_prev_mat = .I;
                }

                I[current_idx] = .{
                    .score = i_max,
                    .prev_idx = up_idx,
                    .prev_matrix = i_prev_mat,
                    .alignment_type = .{ .Insertion = i - 1 },
                };
            }

            // fill matrix D
            {
                const d_from_m = M[left_idx].score + GAP_OPEN_PENALTY;
                const d_from_d = D[left_idx].score + GAP_EXTEND_PENALTY;

                var d_max = d_from_m;
                var d_prev_mat = MatrixState.M;

                if (d_from_d > d_max) {
                    d_max = d_from_d;
                    d_prev_mat = .D;
                }

                D[current_idx] = .{
                    .score = d_max,
                    .prev_idx = left_idx,
                    .prev_matrix = d_prev_mat,
                    .alignment_type = .Deletion,
                };
            }
        }
    }

    // traceback to find optimal alignment
    const final_idx = (subj_len - 1) * query_len + (query_len - 1);

    // first we need to find which of the three matrices has the highest score at the bottom-right cell to start the traceback from there
    var current_matrix = MatrixState.M;
    var final_score = M[final_idx].score;

    if (I[final_idx].score > final_score) {
        final_score = I[final_idx].score;
        current_matrix = .I;
    }
    if (D[final_idx].score > final_score) {
        final_score = D[final_idx].score;
        current_matrix = .D;
    }

    var alignment_al: std.ArrayList(AlignmentType) = .empty;

    // traceback in 3D space of the three matrices, at each step we append the type of alignment to the alignment list and move to the previous cell in the matrix according to the prev_idx and prev_matrix stored in the current cell until we reach the top-left cell of the matrix
    var current_idx = final_idx;
    while (current_idx > 0) {
        switch (current_matrix) {
            .M => {
                try alignment_al.append(allocator, M[current_idx].alignment_type);
                current_matrix = M[current_idx].prev_matrix;
                current_idx = M[current_idx].prev_idx;
            },
            .I => {
                try alignment_al.append(allocator, I[current_idx].alignment_type);
                current_matrix = I[current_idx].prev_matrix;
                current_idx = I[current_idx].prev_idx;
            },
            .D => {
                try alignment_al.append(allocator, D[current_idx].alignment_type);
                current_matrix = D[current_idx].prev_matrix;
                current_idx = D[current_idx].prev_idx;
            },
        }
    }

    // because we were iterating from final cell to start cell, we need to reverse the alignment list to get the correct order of the alignment
    std.mem.reverse(AlignmentType, alignment_al.items);

    return .{
        .score = final_score,
        .alignment = try alignment_al.toOwnedSlice(allocator),
    };
}

// To find the star sequence, we iterate through each sequence and perform global alignment against all other sequences, summing the scores. We keep track of the sequence with the highest total score and its alignments to the other sequences.
fn findStarSequence(allocator: std.mem.Allocator, sequences: [][]const u8) !StarSequence {
    var star_seq: StarSequence = .{ .idx = 0, .alignments = undefined, .max_score = std.math.minInt(i32) };

    for (0..sequences.len) |i| {
        var sum_score: i32 = 0;
        var alignments = try allocator.alloc(Alignment, sequences.len - 1);
        var count: usize = 0;
        for (0..sequences.len) |j| {
            if (i == j) continue; // skip self-alignment

            const result = try globalAlignment(allocator, sequences[i], sequences[j]);
            sum_score += result.score;
            alignments[count] = result.alignment;
            count += 1;
        }
        // if this sequence has the highest sum of scores, update the star sequence and keep its alignments
        // otherwise, free the memory of the alignments for this sequence
        if (sum_score > star_seq.max_score) {
            const best_alignments = try allocator.dupe(Alignment, alignments);
            star_seq = .{ .idx = i, .alignments = best_alignments, .max_score = sum_score };
        } else {
            // free mem of alignments as this sequence is not the star sequence
            for (0..count) |k| {
                allocator.free(alignments[k]);
            }
        }
        allocator.free(alignments);
    }

    return star_seq;
}

fn starMethod(allocator: std.mem.Allocator, sequences: [][]const u8, sequences_names: [][]const u8) ![]std.ArrayList(u8) {
    const star_seq = try findStarSequence(allocator, sequences);
    std.debug.print("Best sequence: name={s}, index={d} with score {d}\n", .{sequences_names[star_seq.idx], star_seq.idx, star_seq.max_score });

    // align to the star sequence and build the multi-alignment by iterating through the alignments of the star sequence and inserting gaps as needed
    var pointers = try allocator.alloc(usize, sequences.len - 1);
    @memset(pointers, 0);
    const alignments = star_seq.alignments;
    var star_seq_idx: usize = 0;

    const multi_alignment = try allocator.alloc(std.ArrayList(u8), sequences.len);
    for (0..sequences.len) |i| {
        multi_alignment[i] = .empty;
    }

    // we keep pointer to index in each alignment of the star sequence
    // and iterate through the simultaneously
    while (true) {
        var found_insertion = false;
        var done = true;

        // check if any alignment has an insertion at the current pointer position,
        // if so we need to insert a gap in all other sequences at this position and move the pointer of the sequence with insertion forward
        for (0..alignments.len) |i| {
            const alignment = alignments[i];
            const pointer = pointers[i];

            // we also check if the pointer is within bounds of the alignment
            // if all pointers are already at the end of their respective alignments, we are done building the multi-alignment
            if (pointer < alignment.len) {
                done = false;

                if (alignment[pointer] == .Insertion) {
                    found_insertion = true;
                    break;
                }
            }
        }

        if (done) break;

        // iterate all alignments plus the star sequence
        var i: usize = 0;
        for (0..sequences.len) |j| {
            const seq = sequences[j];
            // for the star sequence we just take the next character from the sequence if there is no insertion at this position,
            // otherwise we insert a gap and move to the next position in the star sequence for the next iteration
            if (j == star_seq.idx) {
                if (found_insertion) {
                    try multi_alignment[j].append(allocator, '-');
                } else if (star_seq_idx < seq.len) {
                    try multi_alignment[j].append(allocator, seq[star_seq_idx]);
                    star_seq_idx += 1;
                } else {
                    try multi_alignment[j].append(allocator, '-'); // Pad with gap if exhausted
                }
            } else {
                // for other sequences if we have deletion at this position we insert a gap,
                // if we have match/mismatch we take the next character from the sequence and move the pointer forward,
                // if we have insertion we take the next character from the sequence and move the pointer forward
                // if the pointer is already at the end of the alignment we just insert gaps until we are done building the multi-alignment
                // if we found an insertion in any of the alignments at this position, we need to insert a gap for all other sequences that do not have an insertion at this position BUT we do not move the pointer
                defer i += 1;
                const alignment = alignments[i];
                const pointer = pointers[i];
                if (pointer > alignment.len - 1) {
                    try multi_alignment[j].append(allocator, '-'); // Pad with gap if exhausted
                    continue;
                }

                if (found_insertion) {
                    if (alignment[pointer] == .Insertion) {
                        try multi_alignment[j].append(allocator, seq[alignment[pointer].Insertion]);
                        pointers[i] += 1;
                    } else {
                        try multi_alignment[j].append(allocator, '-');
                    }
                } else {
                    if (alignment[pointer] == .Deletion) {
                        try multi_alignment[j].append(allocator, '-');
                    } else {
                        const align_type = alignment[pointer];
                        try multi_alignment[j].append(allocator, seq[align_type.MatchMismatch]);
                    }
                    pointers[i] += 1;
                }
            }
        }
    }

    return multi_alignment;
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const io = init.io;

    // get input file name from command line
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len < 2) {
        std.debug.print("Usage: {s} <input_file> [gap_open_penalty] [gap_extend_penalty] \n", .{args[0]});
        return;
    }

    // extract input sequences from the file into a list of sequences
    var buffer: [1024]u8 = undefined;
    const file_content = try std.Io.Dir.cwd().readFile(io, args[1], &buffer);
    var lines = std.mem.splitScalar(u8, file_content, '\n');
    var sequences_al = std.ArrayList([]const u8).empty;
    var sequences_names_al = std.ArrayList([]const u8).empty;
    while (lines.next()) |line| {
        if (line.len == 0) continue; // skip empty lines
        if (line[0] == '>') {
            try sequences_names_al.append(allocator, line[1..]); // store sequence name without '>'
            continue;
        }
        try sequences_al.append(allocator, line); // store sequence
    }
    const sequences = try sequences_al.toOwnedSlice(allocator);
    const sequence_names = try sequences_names_al.toOwnedSlice(allocator);

    // If user provided custom gap penalties, parse them from command line arguments
    if (args.len < 4) {
        std.debug.print("Using default gap penalties: GAP_OPEN_PENALTY = {d}, GAP_EXTEND_PENALTY = {d}\n", .{GAP_OPEN_PENALTY, GAP_EXTEND_PENALTY});
    } else {
        GAP_OPEN_PENALTY = try std.fmt.parseInt(i32, args[2], 10);
        GAP_EXTEND_PENALTY = try std.fmt.parseInt(i32, args[3], 10);
        std.debug.print("Using custom gap penalties: GAP_OPEN_PENALTY = {d}, GAP_EXTEND_PENALTY = {d}\n", .{GAP_OPEN_PENALTY, GAP_EXTEND_PENALTY});
    }

    // Perform the star method to get the multi-alignment of the sequences
    const multi_alignment = try starMethod(allocator, sequences, sequence_names);

    // find the longest sequence name for formatting the output later
    var longest_name_len: usize = 0;
    for (sequence_names) |name| {
        if (name.len > longest_name_len) {
            longest_name_len = name.len;
        }
    }

    // Write the multi-alignment results to an output file
    var sb = std.ArrayList(u8).empty;
    for (multi_alignment, 0..) |alignment, i| {
        defer allocator.free(alignment.items);
        const name = sequence_names[i];
        try sb.appendSlice(allocator, name);

        // add spaces to align the sequence names in the output + 5 spaces of padding
        const padding_len = longest_name_len - name.len + 5;
        try sb.appendNTimes(allocator, ' ', padding_len);

        try sb.appendSlice(allocator, alignment.items);
        try sb.append(allocator, '\n');
    }

    const output_string = try sb.toOwnedSlice(allocator);
    std.debug.print("\nMulti-alignment results:\n\n{s}", .{output_string});
    try std.Io.Dir.cwd().writeFile(io, .{
        .sub_path = "alignment_results.txt",
        .data = output_string,
    });

}
