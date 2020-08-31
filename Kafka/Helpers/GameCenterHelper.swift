//
//  GameCenterHelper.swift
//  Kafka
//
//  Created by Ju on 31/08/2020.
//  Copyright © 2020 TroisYaourts. All rights reserved.
//

import GameKit

final class GameCenterHelper: NSObject, GKLocalPlayerListener {
    typealias CompletionBlock = (Error?) -> Void
    
    static let helper = GameCenterHelper()
  
    static var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }

    var viewController: UIViewController?
    
    enum GameCenterHelperError: Error {
        case matchNotFound
    }
    
    override init() {
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
          NotificationCenter.default.post(name: .authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)

          if GKLocalPlayer.local.isAuthenticated {
            GKLocalPlayer.local.register(self)
          } else if let vc = gcAuthVC {
            self.viewController?.present(vc, animated: true)
          }
          else {
            print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
          }
        }
      }
    
    func report(achievement id: String,  percent: Double)
    {
        let achievement = GKAchievement(identifier: id)
        achievement.percentComplete = percent
        GKAchievement.report([achievement]) { (error) in
            print("Error reporting achievement to GameCenter: \(error?.localizedDescription ?? "none")")
        }
        
    }

}

extension Notification.Name {
  static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
