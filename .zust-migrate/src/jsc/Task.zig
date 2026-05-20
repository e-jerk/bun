/// To add a new task to the task queue:
/// 1. Add the type to the TaggedPointerUnion
/// 2. Update the switch statement in tickQueueWithCount() to run the task
pub const Task = TaggedPointerUnion(.{
    Access,
    AnyTask,
    AppendFile,
    ArchiveExtractTask,
    ArchiveBlobTask,
    ArchiveWriteTask,
    ArchiveFilesTask,
    AsyncGlobWalkTask,
    AsyncImageTask,
    AsyncTransformTask,
    bun.bake.DevServer.HotReloadEvent,
    bun.bundle_v2.DeferredBatchTask,
    shell.Interpreter.Builtin.Yes.YesTask,
    Chmod,
    Chown,
    Close,
    CopyFile,
    CopyFilePromiseTask,
    CppTask,
    Exists,
    Fchmod,
    FChown,
    Fdatasync,
    FetchTasklet,
    Fstat,
    FSWatchTask,
    Fsync,
    FTruncate,
    Futimes,
    GetAddrInfoRequestTask,
    HotReloadTask,
    ImmediateObject,
    JSCDeferredWorkTask,
    Lchmod,
    Lchown,
    Link,
    Lstat,
    Lutimes,
    ManagedTask,
    Mkdir,
    Mkdtemp,
    napi_async_work,
    NapiFinalizerTask,
    NativePromiseContextDeferredDerefTask,
    NativeBrotli,
    NativeZlib,
    NativeZstd,
    Open,
    PollPendingModulesTask,
    PosixSignalTask,
    ProcessWaiterThreadTask,
    Read,
    Readdir,
    ReaddirRecursive,
    ReadFile,
    ReadFileTask,
    Readlink,
    Readv,
    FlushPendingFileSinkTask,
    Realpath,
    RealpathNonNative,
    Rename,
    Rm,
    Rmdir,
    RuntimeTranspilerStore,
    S3HttpDownloadStreamingTask,
    S3HttpSimpleTask,
    ServerAllConnectionsClosedTask,
    ShellAsync,
    ShellAsyncSubprocessDone,
    ShellCondExprStatTask,
    ShellCpTask,
    ShellGlobTask,
    ShellIOReaderAsyncDeinit,
    ShellIOWriterAsyncDeinit,
    ShellIOWriter,
    ShellLsTask,
    ShellMkdirTask,
    ShellMvBatchedTask,
    ShellMvCheckTargetTask,
    ShellRmDirTask,
    ShellRmTask,
    ShellTouchTask,
    Stat,
    StatFS,
    StreamPending,
    Symlink,
    ThreadSafeFunction,
    TimeoutObject,
    Truncate,
    Unlink,
    Utimes,
    Write,
    WriteFile,
    WriteFileTask,
    Writev,
});

pub fn tickQueueWithCount(this: *EventLoop, virtual_machine: *VirtualMachine, counter: *u32) bun.JSTerminated!void {
    var global = this.global;
    const global_vm = global.vm();

    if (comptime Environment.isDebug) {
        if (this.debug.js_call_count_outside_tick_queue > this.debug.drain_microtasks_count_outside_tick_queue) {
            if (this.debug.track_last_fn_name) {
                bun.Output.panic(
                    \\<b>{d} JavaScript functions<r> were called outside of the microtask queue without draining microtasks.
                    \\
                    \\Last function name: {f}
                    \\
                    \\Use EventLoop.runCallback() to run JavaScript functions outside of the microtask queue.
                    \\
                    \\Failing to do this can lead to a large number of microtasks being queued and not being drained, which can lead to a large amount of memory being used and application slowdown.
                ,
                    .{
                        this.debug.js_call_count_outside_tick_queue - this.debug.drain_microtasks_count_outside_tick_queue,
                        this.debug.last_fn_name,
                    },
                );
            } else {
                bun.Output.panic(
                    \\<b>{d} JavaScript functions<r> were called outside of the microtask queue without draining microtasks. To track the last function name, set the BUN_TRACK_LAST_FN_NAME environment variable.
                    \\
                    \\Use EventLoop.runCallback() to run JavaScript functions outside of the microtask queue.
                    \\
                    \\Failing to do this can lead to a large number of microtasks being queued and not being drained, which can lead to a large amount of memory being used and application slowdown.
                ,
                    .{this.debug.js_call_count_outside_tick_queue - this.debug.drain_microtasks_count_outside_tick_queue},
                );
            }
        }
    }

    while (this.tasks.readItem()) |task| {
        log("run {s}", .{@tagName(task.tag())});
        defer counter.* += 1;
        switch (task.tag()) {
            @field(Task.Tag, @typeName(ArchiveExtractTask)) => {
                var archive_task: *ArchiveExtractTask = if (task.get(ArchiveExtractTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try archive_task.runFromJS();
            },
            @field(Task.Tag, @typeName(ArchiveBlobTask)) => {
                var archive_task: *ArchiveBlobTask = if (task.get(ArchiveBlobTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try archive_task.runFromJS();
            },
            @field(Task.Tag, @typeName(ArchiveWriteTask)) => {
                var archive_task: *ArchiveWriteTask = if (task.get(ArchiveWriteTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try archive_task.runFromJS();
            },
            @field(Task.Tag, @typeName(ArchiveFilesTask)) => {
                var archive_task: *ArchiveFilesTask = if (task.get(ArchiveFilesTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try archive_task.runFromJS();
            },
            @field(Task.Tag, @typeName(ShellAsync)) => {
                var shell_ls_task: *ShellAsync = if (task.get(ShellAsync)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellAsyncSubprocessDone)) => {
                var shell_ls_task: *ShellAsyncSubprocessDone = if (task.get(ShellAsyncSubprocessDone)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellIOWriterAsyncDeinit)) => {
                var shell_ls_task: *ShellIOWriterAsyncDeinit = if (task.get(ShellIOWriterAsyncDeinit)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellIOWriter)) => {
                var shell_io_writer: *ShellIOWriter = if (task.get(ShellIOWriter)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_io_writer.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellIOReaderAsyncDeinit)) => {
                var shell_ls_task: *ShellIOReaderAsyncDeinit = if (task.get(ShellIOReaderAsyncDeinit)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellCondExprStatTask)) => {
                var shell_ls_task: *ShellCondExprStatTask = if (task.get(ShellCondExprStatTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellCpTask)) => {
                var shell_ls_task: *ShellCpTask = if (task.get(ShellCpTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellTouchTask)) => {
                var shell_ls_task: *ShellTouchTask = if (task.get(ShellTouchTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellMkdirTask)) => {
                var shell_ls_task: *ShellMkdirTask = if (task.get(ShellMkdirTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellLsTask)) => {
                var shell_ls_task: *ShellLsTask = if (task.get(ShellLsTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_ls_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellMvBatchedTask)) => {
                var shell_mv_batched_task: *ShellMvBatchedTask = if (task.get(ShellMvBatchedTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_mv_batched_task.task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellMvCheckTargetTask)) => {
                var shell_mv_check_target_task: *ShellMvCheckTargetTask = if (task.get(ShellMvCheckTargetTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_mv_check_target_task.task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellRmTask)) => {
                var shell_rm_task: *ShellRmTask = if (task.get(ShellRmTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_rm_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellRmDirTask)) => {
                var shell_rm_task: *ShellRmDirTask = if (task.get(ShellRmDirTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_rm_task.runFromMainThread();
            },
            @field(Task.Tag, @typeName(ShellGlobTask)) => {
                var shell_glob_task: *ShellGlobTask = if (task.get(ShellGlobTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                shell_glob_task.runFromMainThread();
                shell_glob_task.deinit();
            },
            @field(Task.Tag, @typeName(FetchTasklet)) => {
                var fetch_task: *Fetch.FetchTasklet = if (task.get(Fetch.FetchTasklet)) |value| {
    value
} else {
    return error.NullPointer;
};
                try fetch_task.onProgressUpdate();
            },
            @field(Task.Tag, @typeName(S3HttpSimpleTask)) => {
                var s3_task: *S3HttpSimpleTask = if (task.get(S3HttpSimpleTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try s3_task.onResponse();
            },
            @field(Task.Tag, @typeName(S3HttpDownloadStreamingTask)) => {
                var s3_task: *S3HttpDownloadStreamingTask = if (task.get(S3HttpDownloadStreamingTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                s3_task.onResponse();
            },
            @field(Task.Tag, @typeName(AsyncGlobWalkTask)) => {
                var globWalkTask: *AsyncGlobWalkTask = if (task.get(AsyncGlobWalkTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer globWalkTask.deinit();
                try globWalkTask.runFromJS();
            },
            @field(Task.Tag, @typeName(AsyncImageTask)) => {
                var image_task: *AsyncImageTask = if (task.get(AsyncImageTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer image_task.deinit();
                try image_task.runFromJS();
            },
            @field(Task.Tag, @typeName(AsyncTransformTask)) => {
                var transform_task: *AsyncTransformTask = if (task.get(AsyncTransformTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                try transform_task.runFromJS();
            },
            @field(Task.Tag, @typeName(CopyFilePromiseTask)) => {
                var transform_task: *CopyFilePromiseTask = if (task.get(CopyFilePromiseTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                try transform_task.runFromJS();
            },
            @field(Task.Tag, @typeName(bun.api.napi.napi_async_work)) => {
                const transform_task: *bun.api.napi.napi_async_work = if (task.get(bun.api.napi.napi_async_work)) |value| {
    value
} else {
    return error.NullPointer;
};
                transform_task.runFromJS(virtual_machine, global);
            },
            @field(Task.Tag, @typeName(ThreadSafeFunction)) => {
                var transform_task: *ThreadSafeFunction = task.as(ThreadSafeFunction);
                transform_task.onDispatch();
            },
            @field(Task.Tag, @typeName(ReadFileTask)) => {
                var transform_task: *ReadFileTask = if (task.get(ReadFileTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                try transform_task.runFromJS();
            },
            @field(Task.Tag, @typeName(JSCDeferredWorkTask)) => {
                var jsc_task: *JSCDeferredWorkTask = if (task.get(JSCDeferredWorkTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                jsc.markBinding(@src());
                try jsc_task.run();
            },
            @field(Task.Tag, @typeName(WriteFileTask)) => {
                var transform_task: *WriteFileTask = if (task.get(WriteFileTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                try transform_task.runFromJS();
            },
            @field(Task.Tag, @typeName(HotReloadTask)) => {
                const transform_task: *HotReloadTask = if (task.get(HotReloadTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                transform_task.run();
                // special case: we return
                // hot reload runs immediately so it should not drain microtasks
                counter[0] = 0;
                return;
            },
            @field(Task.Tag, @typeName(bun.bake.DevServer.HotReloadEvent)) => {
                const hmr_task: *bun.bake.DevServer.HotReloadEvent = if (task.get(bun.bake.DevServer.HotReloadEvent)) |value| {
    value
} else {
    return error.NullPointer;
};
                hmr_task.run();
            },
            @field(Task.Tag, @typeName(FSWatchTask)) => {
                var transform_task: *FSWatchTask = if (task.get(FSWatchTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer transform_task.deinit();
                transform_task.run();
            },
            @field(Task.Tag, @typeName(AnyTask)) => {
                var any: *AnyTask = if (task.get(AnyTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.run() catch |err| try reportErrorOrTerminate(global, err);
            },
            @field(Task.Tag, @typeName(ManagedTask)) => {
                var any: *ManagedTask = if (task.get(ManagedTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.run() catch |err| try reportErrorOrTerminate(global, err);
            },
            @field(Task.Tag, @typeName(CppTask)) => {
                var any: *CppTask = if (task.get(CppTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.run(global) catch |err| try reportErrorOrTerminate(global, err);
            },
            @field(Task.Tag, @typeName(PollPendingModulesTask)) => {
                virtual_machine.modules.onPoll();
            },
            @field(Task.Tag, @typeName(GetAddrInfoRequestTask)) => {
                if (Environment.os == .windows) @panic("This should not be reachable on Windows");
                var any: *GetAddrInfoRequestTask = if (task.get(GetAddrInfoRequestTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                defer any.deinit();
                try any.runFromJS();
            },
            @field(Task.Tag, @typeName(Stat)) => {
                var any: *Stat = if (task.get(Stat)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Lstat)) => {
                var any: *Lstat = if (task.get(Lstat)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Fstat)) => {
                var any: *Fstat = if (task.get(Fstat)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Open)) => {
                var any: *Open = if (task.get(Open)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(ReadFile)) => {
                var any: *ReadFile = if (task.get(ReadFile)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(WriteFile)) => {
                var any: *WriteFile = if (task.get(WriteFile)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(CopyFile)) => {
                var any: *CopyFile = if (task.get(CopyFile)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Read)) => {
                var any: *Read = if (task.get(Read)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Write)) => {
                var any: *Write = if (task.get(Write)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Truncate)) => {
                var any: *Truncate = if (task.get(Truncate)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Writev)) => {
                var any: *Writev = if (task.get(Writev)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Readv)) => {
                var any: *Readv = if (task.get(Readv)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Rename)) => {
                var any: *Rename = if (task.get(Rename)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(FTruncate)) => {
                var any: *FTruncate = if (task.get(FTruncate)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Readdir)) => {
                var any: *Readdir = if (task.get(Readdir)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(ReaddirRecursive)) => {
                var any: *ReaddirRecursive = if (task.get(ReaddirRecursive)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Close)) => {
                var any: *Close = if (task.get(Close)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Rm)) => {
                var any: *Rm = if (task.get(Rm)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Rmdir)) => {
                var any: *Rmdir = if (task.get(Rmdir)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Chown)) => {
                var any: *Chown = if (task.get(Chown)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(FChown)) => {
                var any: *FChown = if (task.get(FChown)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Utimes)) => {
                var any: *Utimes = if (task.get(Utimes)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Lutimes)) => {
                var any: *Lutimes = if (task.get(Lutimes)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Chmod)) => {
                var any: *Chmod = if (task.get(Chmod)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Fchmod)) => {
                var any: *Fchmod = if (task.get(Fchmod)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Link)) => {
                var any: *Link = if (task.get(Link)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Symlink)) => {
                var any: *Symlink = if (task.get(Symlink)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Readlink)) => {
                var any: *Readlink = if (task.get(Readlink)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Realpath)) => {
                var any: *Realpath = if (task.get(Realpath)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(RealpathNonNative)) => {
                var any: *RealpathNonNative = if (task.get(RealpathNonNative)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Mkdir)) => {
                var any: *Mkdir = if (task.get(Mkdir)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Fsync)) => {
                var any: *Fsync = if (task.get(Fsync)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Fdatasync)) => {
                var any: *Fdatasync = if (task.get(Fdatasync)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Access)) => {
                var any: *Access = if (task.get(Access)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(AppendFile)) => {
                var any: *AppendFile = if (task.get(AppendFile)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Mkdtemp)) => {
                var any: *Mkdtemp = if (task.get(Mkdtemp)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Exists)) => {
                var any: *Exists = if (task.get(Exists)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Futimes)) => {
                var any: *Futimes = if (task.get(Futimes)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Lchmod)) => {
                var any: *Lchmod = if (task.get(Lchmod)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Lchown)) => {
                var any: *Lchown = if (task.get(Lchown)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(Unlink)) => {
                var any: *Unlink = if (task.get(Unlink)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(NativeZlib)) => {
                var any: *NativeZlib = if (task.get(NativeZlib)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(NativeBrotli)) => {
                var any: *NativeBrotli = if (task.get(NativeBrotli)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(NativeZstd)) => {
                var any: *NativeZstd = if (task.get(NativeZstd)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(ProcessWaiterThreadTask)) => {
                bun.markPosixOnly();
                var any: *ProcessWaiterThreadTask = if (task.get(ProcessWaiterThreadTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(RuntimeTranspilerStore)) => {
                var any: *RuntimeTranspilerStore = if (task.get(RuntimeTranspilerStore)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread(this, global, virtual_machine);
            },
            @field(Task.Tag, @typeName(ServerAllConnectionsClosedTask)) => {
                var any: *ServerAllConnectionsClosedTask = if (task.get(ServerAllConnectionsClosedTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread(virtual_machine);
            },
            @field(Task.Tag, @typeName(bun.bundle_v2.DeferredBatchTask)) => {
                var any: *bun.bundle_v2.DeferredBatchTask = if (task.get(bun.bundle_v2.DeferredBatchTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runOnJSThread();
            },
            @field(Task.Tag, @typeName(PosixSignalTask)) => {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                PosixSignalTask.runFromJSThread(@intCast(task.asUintptr()), global);
            },
            @field(Task.Tag, @typeName(NapiFinalizerTask)) => {
                var any: *NapiFinalizerTask = if (task.get(NapiFinalizerTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runOnJSThread();
            },
            @field(Task.Tag, @typeName(NativePromiseContextDeferredDerefTask)) => {
// safe-transpile: @intCast requires manual review — consider safe.CheckedInt(T).init(@intCast)
                NativePromiseContextDeferredDerefTask.runFromJSThread(@intCast(task.asUintptr()));
            },
            @field(Task.Tag, @typeName(StatFS)) => {
                var any: *StatFS = if (task.get(StatFS)) |value| {
    value
} else {
    return error.NullPointer;
};
                try any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(FlushPendingFileSinkTask)) => {
                var any: *FlushPendingFileSinkTask = if (task.get(FlushPendingFileSinkTask)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },
            @field(Task.Tag, @typeName(StreamPending)) => {
                var any: *StreamPending = if (task.get(StreamPending)) |value| {
    value
} else {
    return error.NullPointer;
};
                any.runFromJSThread();
            },

            // YesTask / ImmediateObject / TimeoutObject are declared in the
            // tagged union but never dispatched here; the `else` arm covers
            // them along with unnamed (non-exhaustive) variants. Using `else`
            // instead of explicit `.@"<typeName>"` arms avoids hard-coding
            // path-derived `@typeName(T)` strings that change when files move.
            else => {
                bun.Output.panic("Unexpected Task tag: {d}", .{@intFromEnum(task.tag())});
            },
        }

        try this.drainMicrotasksWithGlobal(global, global_vm);
    }

    this.tasks.head = if (this.tasks.count == 0) 0 else this.tasks.head;
}

pub fn reportErrorOrTerminate(global: *jsc.JSGlobalObject, proof: bun.JSError) bun.JSTerminated!void {
    @branchHint(.cold);
    if (proof == error.JSTerminated) return error.JSTerminated;
    const vm = global.vm();
    const ex = if (global.takeException(proof).asException(vm)) |value| {
    value
} else {
    return error.NullPointer;
};
    const is_termination_exception = vm.isTerminationException(ex);
    if (is_termination_exception) return error.JSTerminated;
    _ = global.reportUncaughtException(ex);
}

// const PromiseTask = JSInternalPromise.Completion.PromiseTask;

// const ShellIOReaderAsyncDeinit = shell.Interpreter.IOReader.AsyncDeinit;
const ProcessWaiterThreadTask = if (Environment.isPosix) bun.spawn.process.WaiterThread.ProcessQueue.ResultTask else opaque {};

const log = bun.Output.scoped(.Task, .hidden);

const JSCScheduler = @import("../jsc/JSCScheduler.zig");
const JSCDeferredWorkTask = JSCScheduler.JSCDeferredWorkTask;

const Fetch = @import("../runtime/webcore/fetch.zig");
const FetchTasklet = Fetch.FetchTasklet;

const bun = @import("bun");
const Async = bun.Async;
const Environment = bun.Environment;
const TaggedPointerUnion = bun.TaggedPointerUnion;
const shell = bun.shell;
const FlushPendingFileSinkTask = bun.webcore.FileSink.FlushPendingTask;
const ServerAllConnectionsClosedTask = bun.api.server.ServerAllConnectionsClosedTask;
const CopyFilePromiseTask = bun.webcore.Blob.copy_file.CopyFilePromiseTask;
const GetAddrInfoRequestTask = bun.api.dns.GetAddrInfoRequest.Task;
const ReadFileTask = bun.webcore.Blob.read_file.ReadFileTask;
const WriteFileTask = bun.webcore.Blob.write_file.WriteFileTask;
const FSWatchTask = bun.api.node.fs.Watcher.FSWatchTask;
const ShellGlobTask = shell.interpret.Interpreter.Expansion.ShellGlobTask;

const S3 = bun.S3;
const S3HttpDownloadStreamingTask = S3.S3HttpDownloadStreamingTask;
const S3HttpSimpleTask = S3.S3HttpSimpleTask;

const NapiFinalizerTask = bun.api.napi.NapiFinalizerTask;
const ThreadSafeFunction = bun.api.napi.ThreadSafeFunction;
const napi_async_work = bun.api.napi.napi_async_work;

const AsyncFS = bun.api.node.fs.Async;
const Access = AsyncFS.access;
const AppendFile = AsyncFS.appendFile;
const Chmod = AsyncFS.chmod;
const Chown = AsyncFS.chown;
const Close = AsyncFS.close;
const CopyFile = AsyncFS.copyFile;
const Exists = AsyncFS.exists;
const FChown = AsyncFS.fchown;
const FTruncate = AsyncFS.ftruncate;
const Fchmod = AsyncFS.fchmod;
const Fdatasync = AsyncFS.fdatasync;
const Fstat = AsyncFS.fstat;
const Fsync = AsyncFS.fsync;
const Futimes = AsyncFS.futimes;
const Lchmod = AsyncFS.lchmod;
const Lchown = AsyncFS.lchown;
const Link = AsyncFS.link;
const Lstat = AsyncFS.lstat;
const Lutimes = AsyncFS.lutimes;
const Mkdir = AsyncFS.mkdir;
const Mkdtemp = AsyncFS.mkdtemp;
const Open = AsyncFS.open;
const Read = AsyncFS.read;
const ReadFile = AsyncFS.readFile;
const Readdir = AsyncFS.readdir;
const ReaddirRecursive = AsyncFS.readdir_recursive;
const Readlink = AsyncFS.readlink;
const Readv = AsyncFS.readv;
const Realpath = AsyncFS.realpath;
const RealpathNonNative = AsyncFS.realpathNonNative;
const Rename = AsyncFS.rename;
const Rm = AsyncFS.rm;
const Rmdir = AsyncFS.rmdir;
const Stat = AsyncFS.stat;
const StatFS = AsyncFS.statfs;
const Symlink = AsyncFS.symlink;
const Truncate = AsyncFS.truncate;
const Unlink = AsyncFS.unlink;
const Utimes = AsyncFS.utimes;
const Write = AsyncFS.write;
const WriteFile = AsyncFS.writeFile;
const Writev = AsyncFS.writev;

const jsc = bun.jsc;
const AnyTask = jsc.AnyTask;
const CppTask = jsc.CppTask;
const EventLoop = jsc.EventLoop;
const ManagedTask = jsc.ManagedTask;
const PosixSignalTask = jsc.PosixSignalTask;
const VirtualMachine = jsc.VirtualMachine;
const HotReloadTask = jsc.hot_reloader.HotReloader.Task;
const StreamPending = jsc.WebCore.streams.Result.Pending;

const NativeBrotli = jsc.API.NativeBrotli;
const NativeZlib = jsc.API.NativeZlib;
const NativeZstd = jsc.API.NativeZstd;
const AsyncImageTask = jsc.API.Image.AsyncImageTask;
const NativePromiseContextDeferredDerefTask = jsc.API.NativePromiseContext.DeferredDerefTask;
const AsyncGlobWalkTask = jsc.API.Glob.WalkTask.AsyncGlobWalkTask;
const AsyncTransformTask = jsc.API.JSTranspiler.TransformTask.AsyncTransformTask;

const ArchiveBlobTask = jsc.API.Archive.BlobTask;
const ArchiveExtractTask = jsc.API.Archive.ExtractTask;
const ArchiveFilesTask = jsc.API.Archive.FilesTask;
const ArchiveWriteTask = jsc.API.Archive.WriteTask;

const Timer = jsc.API.Timer;
const ImmediateObject = Timer.ImmediateObject;
const TimeoutObject = Timer.TimeoutObject;

const RuntimeTranspilerStore = jsc.ModuleLoader.RuntimeTranspilerStore;
const PollPendingModulesTask = jsc.ModuleLoader.AsyncModule.Queue;

const ShellAsync = shell.Interpreter.Async;
const ShellIOReaderAsyncDeinit = shell.Interpreter.AsyncDeinitReader;
const ShellIOWriter = shell.Interpreter.IOWriter;
const ShellIOWriterAsyncDeinit = shell.Interpreter.AsyncDeinitWriter;
const ShellAsyncSubprocessDone = shell.Interpreter.Cmd.ShellAsyncSubprocessDone;
const ShellCondExprStatTask = shell.Interpreter.CondExpr.ShellCondExprStatTask;
const ShellCpTask = shell.Interpreter.Builtin.Cp.ShellCpTask;
const ShellLsTask = shell.Interpreter.Builtin.Ls.ShellLsTask;
const ShellMkdirTask = shell.Interpreter.Builtin.Mkdir.ShellMkdirTask;
const ShellTouchTask = shell.Interpreter.Builtin.Touch.ShellTouchTask;

const ShellMvBatchedTask = shell.Interpreter.Builtin.Mv.ShellMvBatchedTask;
const ShellMvCheckTargetTask = shell.Interpreter.Builtin.Mv.ShellMvCheckTargetTask;

const ShellRmTask = shell.Interpreter.Builtin.Rm.ShellRmTask;
const ShellRmDirTask = shell.Interpreter.Builtin.Rm.ShellRmTask.DirTask;
