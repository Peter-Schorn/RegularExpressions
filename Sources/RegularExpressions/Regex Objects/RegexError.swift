import Foundation

public enum RegexError: Error, LocalizedError {
    
    /// The number of capture groups in the pattern
    /// does not match the number of group names provided.
    case groupNamesCountDoesntMatch(
        captureGroups: Int, groupNames: Int
    )
    
    var localizedDescription: String {
        switch self {
            case.groupNamesCountDoesntMatch(
                let captureGroups, let groupNames
            ):
                return """
                    The number of capture groups (\(captureGroups)) \
                    doesn't match the number of group names (\(groupNames))
                    """
            
        }
    }
    
}
