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
    container.loadPersistentStores { _, error in
      if let error = error { print(error) }
    }
    return container
  }()

  private lazy var backgroundContext: NSManagedObjectContext = {
    let context = persistentContainer.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }()

  // MARK: - Initializers
  private init() { }

  // MARK: - Public Methods
  func saveLeagues(response: [LeagueResponse]) {
    backgroundContext.perform { [weak self] in
      guard let self = self else { return }
      response.forEach { response in
        let league = LeagueObject(context: self.backgroundContext)
        league.id = Int64(response.league.id)
        league.name = response.league.name
        league.logoPath = response.league.logo!
      }

      do {
        try self.backgroundContext.save()
      } catch {
        print("CoreDataError: ", error)
      }
    }
  }

  func getLeagues() {
    backgroundContext.performAndWait {
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
    if backgroundContext.hasChanges {
      do {
        try backgroundContext.save()
      } catch {
        print(error)
      }
    }
  }

}
