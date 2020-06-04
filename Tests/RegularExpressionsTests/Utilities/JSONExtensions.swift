import Foundation



public extension Bundle {
    
    /**
     Loads Json data from bundle.
     - Parameters:
       - file: File name excluding extension
       - ext: The extension of the file
       - type: The type that the json will be converted to
     - Returns: The object initialized according to the specified type
     
     Example:
     ```
     let menu = Bundle.main.decode("menu.json", [String].self)
     ```
     `menu` is now an array of strings loaded from the Json file
     */
    func decode<T: Decodable>(_ file: String, ext: String? = nil, type: T.Type) -> T {
        
        guard let url = self.url(forResource: file, withExtension: ext) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}


public func loadJSONFromFile<T: Decodable>(
    url: URL, type typ: T.Type
) throws -> T {
    
    let data = try Data(contentsOf: url)
    
    let loadedData = try JSONDecoder().decode(T.self, from: data)
    
    return loadedData
}

public func saveJSONToFile<T: Encodable>(
    url: URL, data: T
) throws {
    
    let data = try JSONEncoder().encode(data)
    try data.write(to: url)
    
}
