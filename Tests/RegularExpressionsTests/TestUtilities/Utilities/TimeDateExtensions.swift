
import Foundation


/// Wraps around the sleep function.
public func sleep<N: BinaryInteger>(_ interval: N) {
    sleep(UInt32(interval))
}


public func currentTime() -> String {
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.timeStyle = .medium
    let dateTimeString = timeFormatter.string(from: date)
    return dateTimeString + "\n"
}


public extension Date {
    
    /// Alias for `timeIntervalSince1970`
    var unixTime: Double {
        return self.timeIntervalSince1970
    }
    
    /**
     Alias for
     `.init(timeIntervalSince1970: Double)`
     */
    init(unixTime: Double) {
        self.init(timeIntervalSince1970: unixTime)
    }
    
    /// Returns the difference between the dates in seconds
    static func - (lhs: Date, rhs: Date) -> Double {
        return lhs.unixTime - rhs.unixTime
    }
    
    /// Adds the unix time for the dates together
    static func + (lhs: Date, rhs: Date) -> Double {
        return lhs.unixTime - rhs.unixTime
    }
    
}



public func timeTrial(repeat r: Int, _ trial: () -> Void) -> Double {
    let stopWatch = StopWatch(startNow: true)
    for _ in 0..<r {
        trial()
    }
    return stopWatch.timeElapsed
}


public enum TimeUnit {
    case second(Double)
    case minute(Double)
    case hour(Double)
    case day(Double)
    case week(Double)
    case month(Double, days: Int)
    case year(Double)
    
    private static func add(unit: TimeUnit, num: Double) -> TimeUnit {
        let seconds = timeUnit(unit) + timeUnit(.second(num))
        return .second(seconds)
    }
    
    public static func +(lhs: TimeUnit, rhs: Double) -> TimeUnit {
        return add(unit: lhs, num: rhs)
    }
    
    public static func +(lhs: Double, rhs: TimeUnit) -> TimeUnit {
        return add(unit: rhs, num: lhs)
    }
    
    public static func +(lhs: TimeUnit, rhs: TimeUnit) -> TimeUnit {
        let seconds = timeUnit(lhs, rhs)
        return .second(seconds)
    }
    
}

/**
 Converts a time unit to seconds.
 Allows for representing them in a more human-readable manner
 
 For example:
 ```
 timeUnit(.hour(1), .minute(2), .second(5)) == 3725.0
 ```
 Accepts this enum:
 ```
 public enum TimeUnits {
     case second(Double)
     case minute(Double)
     case hour(Double)
     case day(Double)
     case week(Double)
     case month(Double, days: Int)
     case year(Double)
 }
 ```
 */
public func timeUnit(_ timeUnits: TimeUnit...) -> Double {
    
    var result: Double = 0
    
    for unit in timeUnits {
        switch unit {
            case .second(let t):
                result += t
            case .minute(let t):
                result += t * 60
            case .hour(let t):
                result += t * 3_600
            case .day(let t):
                result += t * 86_400
            case .week(let t):
                result += t * 604_800
            case .month(let t, days: let d):
                result += t * Double(d) * 86_400
            case .year(let t):
                result += t * 31_536_000
        }
    }
    return result
}


// MARK: - StopWatch -

open class StopWatch {

    public private(set) var startTime: Date?
    public private(set) var isPaused = true
    private var _timeElapsed: Double
    
    /**
     If startNow is set to true (false by default), then the stopwatch
     is started upon instantiation.
     By default, the stopwatch starts counting from 0 seconds,
     but this can be customized by passing in a passing a number
     to `stargingAt`
     */
    public init(startNow: Bool = false, startingAt: Double = 0) {
        self._timeElapsed = startingAt
        if startNow {
            self.resume()
        }
    }
    
    /// Returns the amount of time on the stopwatch.
    /// This method can be called when the stopwatch is running
    /// and when it is paused.
    open var timeElapsed: Double {
        if self.isPaused {
            return self._timeElapsed
        }
        if let start = self.startTime {
            return self._timeElapsed - start.timeIntervalSinceNow
        }
        return 0
    }
    
    /// Resumes the stopwatch. By default, the stopwatch is instantiated
    /// in a paused state. Calling resume for the first time
    /// starts the stopwatch. If the stopwatch was not paused, then
    /// this method has no effect.
    open func resume() {
        if self.isPaused {
            self.startTime = Date()
            self.isPaused = false
        }
    }
    
    /// Pauses the stopwatch. If the stopwatch was already paused,
    /// then this method has no effect.
    open func pause() {
        if !self.isPaused {
            if let start = self.startTime {
                self._timeElapsed -= start.timeIntervalSinceNow
            }
            self.isPaused = true
        }
    }
    
    /// Toggles the stopwatch between paused and unpaused.
    open func toggle() {
        if self.isPaused {
            self.resume()
        }
        else {
            self.pause()
        }
    }
    
    /// sets timeElapsed to 0 and pauses the stopwatch.
    open func reset() {
        self.startTime = nil
        self._timeElapsed = 0
        self.isPaused = true
    }
    
    /// Adds the specified number of seconds to the stopwatch.
    /// Negative numbers can be passed in to remove time.
    open func addTime(_ seconds: Double) {
        self._timeElapsed += seconds
    }
    
    
    
    
}

