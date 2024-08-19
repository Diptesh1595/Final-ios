

import Foundation

func formate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM"
    let month = formatter.string(from: date)
    formatter.dateFormat = "dd"
    let day = formatter.string(from: date)
    
    return "\(day)/\(month)"
}
