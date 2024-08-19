

import Foundation

struct TripModel {
    var id: UUID = UUID()
    let title: String
    let originLocation: String
    let destination: String
    let startDate: Date
    let endDate: Date
    let toDoList: String
}


struct TripExpenseModel {
    let Id: UUID
    let title: String
    let amount: Double
}
