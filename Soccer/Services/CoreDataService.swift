//
//  CoreDataService.swift
//  soccer
//
//  Created by Mikhail Andreev on 18.09.2021.
//

import CoreData
import FirebaseAnalytics

final class CoreDataService {

  // MARK: - Internal Properties
  static let shared = CoreDataService()

  // MARK: - Private Properties
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataModel")
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

  private lazy var context = persistentContainer.viewContext

  // MARK: - Initializers
  private init() { }

  // MARK: - Public Methods

  func saveTeam(response: TeamResponse) {
    backgroundContext.perform { [weak self] in
      guard let self = self else { return }

      let teamMO = MOTeam(context: self.backgroundContext)
      let team = response.team
      teamMO.id = Int64(team.id)
      teamMO.country = team.country
      teamMO.name = team.name
      teamMO.logoPath = team.logo

      let stadium = response.stadium
      if let stadiumID = stadium.id {
        let stadiumMO = MOStadium(context: self.backgroundContext)
        stadiumMO.id = Int64(stadiumID)
        stadiumMO.name = stadium.name
        stadiumMO.address = stadium.address
        stadiumMO.city = stadium.city
        stadiumMO.team = teamMO
        teamMO.stadium = stadiumMO
      }

      if let players = response.players {
        let playerMO = MOPlayer(context: self.backgroundContext)
        players.forEach { player in
          playerMO.id = Int64(player.id)
          playerMO.name = player.name
          playerMO.age = Int64(player.age ?? 0)
          playerMO.number = Int64(player.number ?? 0)
          playerMO.position = player.position
          playerMO.photoPath = player.photo
          playerMO.team = teamMO
          teamMO.addToPlayers(playerMO)
        }
      }

      do {
        try self.backgroundContext.save()
      } catch {
        Analytics.logEvent("Save teams", parameters: ["save error": error])
      }

    }

  }

  func teams(completion: @escaping ([MOTeam]) -> Void) {
    context.performAndWait {
      let request: NSFetchRequest<MOTeam> = MOTeam.fetchRequest()
      do {
        let result = try request.execute()
        completion(result)
      } catch {
        Analytics.logEvent("Fetch teams", parameters: ["fetch error": error])
      }
    }
  }

  func removeTeam(id: Int) {
    backgroundContext.perform {
      let request: NSFetchRequest<MOTeam> = MOTeam.fetchRequest()
      request.predicate = NSPredicate(format: "id == \(id)")
      do {
        guard let result = try request.execute().first else { return }
        self.backgroundContext.delete(result)
        try self.backgroundContext.save()
      } catch {
        Analytics.logEvent("Remove object", parameters: ["removing error": error])
      }
    }
  }

  func saveContext() {
    if backgroundContext.hasChanges {
      do {
        try backgroundContext.save()
      } catch {
        Analytics.logEvent("Save context", parameters: ["context error": error])
      }
    }
  }

}
