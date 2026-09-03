pub const Box = struct {
    pub const HorizSep: []const u8 = "\u{2500}";
    pub const VertSep: []const u8 = "\u{2502}";
    pub const LJunc: []const u8 = "\u{251C}";
    pub const RJunc: []const u8 = "\u{2524}";
    pub const FJunc: []const u8 = "\u{253C}";
    pub const TJunc: []const u8 = "\u{252C}";
    pub const BJunc: []const u8 = "\u{2534}";
    pub const LUpCor: []const u8 = "\u{250C}";
    pub const RUpCor: []const u8 = "\u{2510}";
    pub const LBotCor: []const u8 = "\u{2514}";
    pub const RBotCor: []const u8 = "\u{2518}";
};

pub const Tree = struct {
    pub const Blank: []const u8 = "    ";
    pub const Branch: []const u8 = "\u{2502}   ";
    pub const Leaf: []const u8 = "\u{2500}\u{2500}";
};
