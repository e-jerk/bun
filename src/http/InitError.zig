pub const InitError = error{
    FailedToOpenSocket,
    LoadCAFile,
    InvalidCAFile,
    InvalidCA,
};

const safe = @import("safe");
