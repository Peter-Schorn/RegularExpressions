import Foundation

public func isExistingDirectory(_ path: URL) -> Bool {
    
    return (try? path.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    
}

public func isExistingFile(_ path: URL) -> Bool {
    
    if FileManager.default.fileExists(atPath: path.path) {
        let isDir = (try? path.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
        return !(isDir ?? false)
        
    }
    return false
}


/// Wrapper for FileManager.default.createDirectory
public func makeFolder(
    _ path: URL,
    makeIntermediates: Bool = true,
    attributes: [FileAttributeKey:Any]? = nil
) throws {

    try FileManager.default.createDirectory(
        at: path,
        withIntermediateDirectories: makeIntermediates,
        attributes: attributes
    )
    
}

/// Renames a file or folder.
/// Equivalent to calling FileManager.default.moveItem(at:to:),
/// but only changing the last component of the path.
public func renameFile(_ path: URL, to newName: String) throws {
    
    var newPath = path.deletingLastPathComponent()
    newPath.appendPathComponent(newName)
    
    try FileManager.default.moveItem(at: path, to: newPath)
    
}


public enum DeleteOptions {
    case afterClosure
    case useHandler
}

// MARK: - macOS -
// #if os(macOS)

/**
 Creates a temporary directory and passes the URL for it and a handler for deleting
 it into a closure.

 See `FileManager.default.url(for:in:appropriateFor:create:)` for
 a disucssion of the directory, domain, and url parameters, which are
 forwarded through to that function. The default values for these parameters
 should be sufficient for the majority of use cases.
 
 
 - Parameters:
   - deleteOptions:
     - .afterClosure: Deletes the directory immediately after the closure
           returns and sets `delelteClosure` to nil.
     - .useHandler: Provides `delelteClosure`, which deletes the directory.
           This is useful for asynchronous code.
   - closure: Executes after the temporary directory is created.
         If deleteOptions == .afterClosure, then `delelteClosure` is nil
   - tempDir: The URL for the temporary directory
   - delelteClosure: Deletes the directory when called. `() -> Void`
 - Returns: The URL of the directory, which may have already been deleted,
       depending on the options specified above.
 - Throws: If an error is encountered when creating the directory.
       **Errors encountered when deleting the directory are silently ignored.**
 */
@available(iOS 10.0, macOS 10.12, *)
@discardableResult
public func withTempDirectory(
   for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
   in domain: FileManager.SearchPathDomainMask = .userDomainMask,
   appropriateFor url: URL = FileManager.default.temporaryDirectory,
   deleteOptions: DeleteOptions = .afterClosure,
   closure: (_ tempDir: URL, _ delelteClosure: (() -> Void)?) -> Void
) throws -> URL {

    let tempDir = try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
    let deletionClosure = {
        do {
            try FileManager.default.removeItem(at: tempDir)

        } catch { }
    }
    
    switch deleteOptions {
        case .afterClosure:
            closure(tempDir, nil)
            deletionClosure()
        case .useHandler:
            closure(tempDir, deletionClosure)
    }
    
    return tempDir
}

/// Creates a Temporary directory for the current user.
@available(iOS 10.0, macOS 10.12, *)
public func createTempDirectory(
    for directory: FileManager.SearchPathDirectory = .itemReplacementDirectory,
    in domain: FileManager.SearchPathDomainMask = .userDomainMask,
    appropriateFor url: URL = FileManager.default.temporaryDirectory
) throws -> URL {
 
    return try FileManager.default.url(
        for: directory,
        in: domain,
        appropriateFor: url,
        create: true
    )
    
}
