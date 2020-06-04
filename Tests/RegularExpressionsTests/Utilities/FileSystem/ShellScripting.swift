import Foundation

#if os(macOS)


public extension Pipe {
    
    func asString(encoding: String.Encoding = .utf8) -> String? {
        let data = self.fileHandleForReading.readDataToEndOfFile()
        let string = String(data: data, encoding: encoding)
        return string?.strip()
    }
    
}


public func setupShellScript(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe = Pipe(),
    stderror: Pipe = Pipe()
) -> Process {
    
    // Create a Task instance
    let task = Process()

    // Set the task parameters
    task.launchPath = launchPath
    task.arguments = args
     
    // Create Pipes
    task.standardOutput = stdout
    task.standardError  = stderror
    
    return task
}


/**
 Runs a shell script and returns the output.
 
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
   - stdout: Pipe for the standard output. Default is a new pipe.
   - stderror: Pipe for standard error. Default is a new pipe.
 - Returns: A tuple containing the process, stdout as String?, and stderror as String?
 
 - Warning: Stdout and stderror are more likely to be empty strings than nil if no
 output is expected. Use process.terminationStatus to access the exit code.
 
 Usage:
 ```
 let output = runShellScript(args: ["echo", "hello"])
 print(output)
 // (stdout: Optional("hello"), stderror: Optional(""), exitCode: 0)
 ```
 */
public func runShellScript(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe = Pipe(),
    stderror: Pipe = Pipe()
) -> (process: Process, stdout: String?, stderror: String?) {

    let task = setupShellScript(
        args: args,
        launchPath: launchPath,
        stdout: stdout,
        stderror: stderror
    )

    // Launch the task
    task.launch()
    task.waitUntilExit()
    
    return (
        process: task,
        stdout: (task.standardOutput as! Pipe).asString(),
        stderror: (task.standardError as! Pipe).asString()
    )
    
}

/**
 Runs a shell script and registers a completion handler.
 
 - Parameters:
   - args: a list of arguments to run
   - launchPath: the path from which to launch the script. Default is /usr/bin/env
   - stdout: Pipe for the standard output. Default is a new pipe.
   - stderror: Pipe for standard error. Default is a new pipe.
   - terminationHandler: Passes in the process, stdout as String?, and stderror
         as String?. Executed upon completion of the process. Can be set to nil.
 
 - Warning: Stdout and stderror are more likely to be empty strings than nil if no
     output is expected. Use process.terminationStatus from within the
     terminationHandler to check if the process exited normally.
 
 Usage:
 ```
 runShellScriptAsync(args: ["echo", "hello"]) { process, stdout, stderror in
     
     print("stdout:", stdout)
     print("stderror:", stderror)
     print("exit code:", process.terminationStatus)
 }
 // stdout: Optional("hello")
 // stderror: Optional("")
 // exit code: 0
 ```
 */
public func runShellScriptAsync(
    args: [String],
    launchPath: String = "/usr/bin/env",
    stdout: Pipe = Pipe(),
    stderror: Pipe = Pipe(),
    terminationHandler: ((Process, _ stdout: String?, _ stderror: String?) -> Void)?
) {

    let task = setupShellScript(
        args: args,
        launchPath: launchPath,
        stdout: stdout,
        stderror: stderror
    )

    if let hanlder = terminationHandler {
        task.terminationHandler = { process in
            let stdout   = (process.standardOutput as! Pipe).asString()
            let stderror = (process.standardError  as! Pipe).asString()
            hanlder(process, stdout, stderror)
        }
    }
    
    // Launch the task
    task.launch()
    
}


#endif
