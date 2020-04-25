//
//  UserStorageClass.swift
//  FirstCourseFinalTask
//
//  Created by Vladimir Banushkin on 24.04.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

class UserStorage: UsersStorageProtocol {
    required init?(users: [UserInitialData], followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
      guard users
        .filter({$0.id == currentUserID}).count != 0 else {return nil}
      self.users = users
      self.followers = followers
      self.currentUserID = currentUserID
    }
    
    
    var count: Int  {
      return users.count
    }
    var users: [UserInitialData]
    var followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)]
    var currentUserID: GenericIdentifier<UserProtocol>
    
    func currentUser() -> UserProtocol {
      return castedUsers
        .first(where: {$0.id == currentUserID})!
      
    }
    
    func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
      return castedUsers
        .first(where: {$0.id == userID})
    }
    
    func findUsers(by searchString: String) -> [UserProtocol] {
      return castedUsers
        .filter({$0.id.rawValue == searchString
          || $0.fullName == searchString
          || $0.username == searchString
        })
    }
    
    func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
      guard castedUsers
        .contains(where: {$0.id == userIDToFollow}) || followers
          .contains(where: {$0.0 == currentUserID && $0.1 == userIDToFollow})
        else
      {return false}
      followers.append((currentUserID, userIDToFollow))
      return true
    }
    
    func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
      guard followers
        .contains(where: {$0.1 == userIDToUnfollow}) else {
          return false
      }
      followers.removeAll(where: {$0.0 == currentUserID && $0.1 == userIDToUnfollow})
      return true
    }
    func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
      guard castedUsers.contains(where: {$0.id == userID}) else
      {return nil}
      var followedUsers: [UserProtocol] = []
      let filteredUsers = followers.filter({$0.1 == userID})
      guard filteredUsers.count != 0 else {
        followedUsers.removeAll()
        return followedUsers
      }
      for userID in filteredUsers {
        castedUsers.forEach({
          if $0.id == userID.0 {
            followedUsers.append($0)
          }
        })
      }
      return followedUsers
    }
    
    func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
      var followedByUsers: [UserProtocol] = []
      guard castedUsers
        .contains(where: {$0.id == userID}) else
      {return nil}
      if followers
        .contains(where: {$0.0 == userID}) {
        let filteredFollows = followers
          .filter({$0.0 == userID})
        for userID in filteredFollows {
          castedUsers.forEach({
            if $0.id == userID.1 {
              followedByUsers.append($0)
            }
          })
        }
      }
      else {
        followedByUsers.removeAll()
        return followedByUsers
      }
      return followedByUsers
    }
    
  }
  


