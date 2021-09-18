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

  private lazy var context = persistentContainer.viewContext

  // MARK: - Initializers
  private init() { }

  // MARK: - Public Methods

  func saveMatches(response: [MatchResponse]) {
    backgroundContext.perform { [weak self] in
      guard let self = self else { return }

      let leagueObject = LeagueObject(context: self.backgroundContext)
      // Все матчи из одной лиги, поэтому за пределами цикла
      guard let league = response.first?.league else { return }

      leagueObject.id = Int64(league.id)
      leagueObject.name = league.name
      leagueObject.logoPath = league.logo

      response.forEach { response in
        let matchObject = MatchObject(context: self.backgroundContext)
        let match = response.match

        matchObject.league = leagueObject
        matchObject.id = Int64(match.id)
        matchObject.date = Date(timeIntervalSince1970: match.timestamp)
        leagueObject.addToMatches(matchObject)

        let teams = response.teams
        let goals = response.goals
        let homeTeamObject = self.createTeamObject(team: teams.home, goals: goals.home)
        matchObject.home = homeTeamObject
        homeTeamObject.away = matchObject
        let awayTeamObject = self.createTeamObject(team: teams.away, goals: goals.away)
        matchObject.away = awayTeamObject
        awayTeamObject.away = matchObject
      }

      do {
        try self.backgroundContext.save()
      } catch {
        print("CoreDataError: ", error)
      }

    }
  }

  func leagues(completion: @escaping ([LeagueObject]) -> Void) {
    context.performAndWait {
      let request = NSFetchRequest<LeagueObject>(entityName: "LeagueObject")
      do {
        let result = try request.execute()
        completion(result)
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

// MARK: - Private Methods
private extension CoreDataContainer {
  func createTeamObject(team: Team, goals: Int?) -> TeamObject {
    let teamObject = TeamObject(context: self.backgroundContext)
    teamObject.id = Int64(team.id)
    teamObject.goals = Int64(goals ?? 0)
    teamObject.logoPath = team.logo
    teamObject.name = team.name
    return teamObject
  }

}
