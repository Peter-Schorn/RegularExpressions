import Foundation


public extension URL {

    /// Returns a new url with the specified query item appended to it.
    func appending(
        _ queryItem: URLQueryItem
    ) -> URL {

        guard var urlComponents = URLComponents(string: self.absoluteString) else {
            fatalError("trying to append query item: couldn't get url components from url")
        }

        // Create array of existing query items
        var currentQueryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        // let queryItem = URLQueryItem(name: queryItem, value: value)
        
        currentQueryItems.append(queryItem)

        // Append the new query item in the existing query items array
        // currentQueryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = currentQueryItems

        // Returns the url from new url components
        return urlComponents.url!
    }
    
    func appending(page: Int) -> URL {
        return self.appending(URLQueryItem(name: "page", value: String(page)))
    }

    mutating func append(page: Int) {
        self = self.appending(page: page)
    }
    
    /// Appends a query item to the url
    mutating func append(_ queryItem: URLQueryItem) {
        self = self.appending(queryItem)
    }
    
    /// The last component of the path excluding the file extension.
    /// Calls self.lastPathComponent and strips all text after the last period.
    var lastPathName: String {
        return self.lastPathComponent.strip(.fileExt)
    }
    
    
    /// You tell me what the cannonical path is.
    @available(macOS 10.12, *)
    func cannonicalPath() throws -> URL? {
        let resourceValues = try self.resourceValues(forKeys: [.canonicalPathKey])
        if let path = resourceValues.canonicalPath {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
}


/// If the url is an alias, returns the path that the alias points to.
/// Throws an error if the file doesn't exist.
public func resolveAlias(at url: URL) throws -> URL {

    let resourceValues = try url.resourceValues(forKeys: [.isAliasFileKey])
    if resourceValues.isAliasFile ?? false {
        let original = try URL(resolvingAliasFileAt: url)
        return original
    }
    return url
}

