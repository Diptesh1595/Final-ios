

import Foundation
import CoreData
import UIKit

class CoreData {
    
    static let shared = CoreData()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func addANewTrip(trip: TripModel, completion: @escaping(Bool) -> Void) {
        
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Trip")
            fetchRequest.predicate = NSPredicate(format: "if = %@", trip.id as CVarArg)
            
            do {
                let entity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
                
                let data = NSManagedObject(entity: entity, insertInto: managedContext)
                data.setValue(trip.id, forKey: "id")
                data.setValue(trip.title, forKey: "title")
                data.setValue(trip.originLocation, forKey: "origin")
                data.setValue(trip.destination, forKey: "destination")
                data.setValue(trip.startDate, forKey: "startDate")
                data.setValue(trip.endDate, forKey: "endDate")
                data.setValue(trip.toDoList, forKey: "todo")
                
                try managedContext.save()
                
                completion(true)
            } catch {
                print("Error while saving data")
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    func fetchAllTrips() -> [TripModel] {
        
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
            
            do {
                let trips = try managedContext.fetch(fetchRequest)
                var listOfTrips: [TripModel] = []
                
                for trip in trips {
                    let id = trip.value(forKey: "id") as? UUID ?? UUID()
                    let title = trip.value(forKey: "title") as? String ?? ""
                    let origin = trip.value(forKey: "origin") as? String ?? ""
                    let destination = trip.value(forKey: "destination") as? String ?? ""
                    let startDate = trip.value(forKey: "startDate") as? Date ?? Date()
                    let endDate = trip.value(forKey: "endDate") as? Date ?? Date()
                    let todoList = trip.value(forKey: "todo") as? String ?? ""
                    
                    let item = TripModel(id: id, title: title, originLocation: origin, destination: destination, startDate: startDate, endDate: endDate, toDoList: todoList)
                    
                    listOfTrips.append(item)
                }
                
                return listOfTrips
            } catch {
                print("Error while saving data")
            }
        }
        return []
    }
    
    func deleteTrip(with id: UUID) {
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Trip")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                if let result = result as? [NSManagedObject], let entity = result.first {
                    managedContext.delete(entity)
                }
                
                try managedContext.save()
            } catch {
                print("Error while deleting data")
            }
        }
    }
    
    func addNewExpense(expense: TripExpenseModel, completion: @escaping(Bool) -> Void) {
        
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Expense")
            fetchRequest.predicate = NSPredicate(format: "if = %@", expense.Id as CVarArg)
            
            do {
                let entity = NSEntityDescription.entity(forEntityName: "Expense", in: managedContext)!
                
                let data = NSManagedObject(entity: entity, insertInto: managedContext)
                data.setValue(expense.Id, forKey: "id")
                data.setValue(expense.title, forKey: "title")
                data.setValue(expense.amount, forKey: "amount")
                
                try managedContext.save()
                
                completion(true)
            } catch {
                print("Error while saving data")
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    func fetchAllExpenses(for expenseId: UUID) -> [TripExpenseModel] {
        
        if let managedContext = appDelegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Expense")
            
            do {
                let expenses = try managedContext.fetch(fetchRequest)
                var allExpenses: [TripExpenseModel] = []
                
                for expense in expenses {
                    let id = expense.value(forKey: "id") as? UUID ?? UUID()
                    let title = expense.value(forKey: "title") as? String ?? ""
                    let amount = expense.value(forKey: "amount") as? Double ?? 0.0
                    
                    let expenseData = TripExpenseModel(Id: id, title: title, amount: amount)
                    
                    if id == expenseId {
                        allExpenses.append(expenseData)
                    }
                }
                
                return allExpenses
            } catch {
                print("Error while saving data")
            }
        }
        
        return []
    }
    
}
