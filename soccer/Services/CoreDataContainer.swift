//
//  CoreDataContainer.swift
//  soccer
//
//  Created by Mikhail Andreev on 15.09.2021.
//

import CoreData

final class CoreDataContainer {

  // MARK: - Internal Properties
  static let shared = CoreDataContainer()

  // MARK: - Private Properties
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataBase")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error { print(error) }
    })
    return container
  }()

  private lazy var context: NSManagedObjectContext = {
    let context = persistentContainer.viewContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }()

  // MARK: - Initializers
  private init() { }

  // MARK: - Public Methods
  func saveLeagues(response: [LeagueResponse]) {
    context.perform { [weak self] in
      guard let self = self else { return }
      response.forEach { response in
        let league = LeagueObject(context: self.context)
        league.id = Int64(response.league.id)
        league.name = response.league.name
        league.logoPath = response.league.logo!
      }

      do {
        try self.context.save()
      } catch {
        print("CoreDataError: ", error)
      }
    }
  }

  func getLeagues() {
    context.performAndWait {
      let request = NSFetchRequest<LeagueObject>(entityName: "LeagueObject")
      do {
        let result = try request.execute()
        print("leagues:", result.count)
      } catch {
        print("getLeagues", error)
      }
    }
  }

  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print(error)
      }
    }
  }

}
