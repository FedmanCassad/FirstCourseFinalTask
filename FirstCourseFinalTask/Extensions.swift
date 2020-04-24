//
//  Extensions.swift
//  FirstCourseFinalTask
//
//  Created by Vladimir Banushkin on 24.04.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import FirstCourseFinalTaskChecker

extension UserStorage {
  var castedUsers: [UserProtocol] {
    get {
      var returnArray:[UserProtocol] = []
      for i in self.users {
        var currentUserIsFollowedByThisUser: Bool {
          return followers
            .first(where: {$0.0 == i.id && $0.1 == currentUserID}) != nil
        }
        var currentUserIsFollowsThisUser: Bool {
          return followers
            .first(where: {$0.0 == currentUserID && $0.1 == i.id}) != nil
        }
        var followsCount: Int {
          return followers
            .filter({$0.0 == i.id}).count
        }
        var followedBy: Int {
          return followers
            .filter({$0.1 == i.id}).count
        }
        let user = User(id: i.id , username: i.username, fullName: i.fullName, avatarURL: nil, currentUserFollowsThisUser: currentUserIsFollowsThisUser, currentUserIsFollowedByThisUser: currentUserIsFollowedByThisUser, followsCount: followsCount, followedByCount: followedBy)
        returnArray.append(user)
      }
      return returnArray
    }
  }
}

extension PostsStorage {
  var castedPosts: [PostProtocol] {
    get {
      var resultingArray: [PostProtocol] = []
      for i in self.posts {
        var currentUserLikesThisPost:Bool {
          return self.likes
            .contains(where: {$0.0 == currentUserID && $0.1 == i.id})
        }
        var likedByCount: Int {
          return self.likes
            .filter({$0.1 == i.id}).count
        }
        resultingArray.append(Post(id: i.id, author: i.author, description: i.description, imageURL: i.imageURL, createdTime: i.createdTime, currentUserLikesThisPost: currentUserLikesThisPost, likedByCount: likedByCount))
      }
      return resultingArray
    }
    
  }
}
