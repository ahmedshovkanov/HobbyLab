import Foundation

extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func formatted(style: String = "short") -> String {
        let formatter = DateFormatter()
        switch style {
        case "short":
            formatter.dateStyle = .short
        case "medium":
            formatter.dateStyle = .medium
        case "long":
            formatter.dateStyle = .long
        case "time":
            formatter.timeStyle = .short
        default:
            formatter.dateStyle = .medium
        }
        return formatter.string(from: self)
    }
    
    func daysAgo() -> Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
}
