//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation

import FirstCourseFinalTaskChecker
struct User: UserProtocol {
  var id: Self.Identifier
  
  var username: String
  
  var fullName: String
  
  var avatarURL: URL?
  
  var currentUserFollowsThisUser: Bool
  
  var currentUserIsFollowedByThisUser: Bool
  
  var followsCount: Int
  
  var followedByCount: Int
  
  
}
struct Post: PostProtocol {
  var id: Self.Identifier
  
  var author: GenericIdentifier<UserProtocol>
  
  var description: String
  
  var imageURL: URL
  
  var createdTime: Date
  
  var currentUserLikesThisPost: Bool
  
  var likedByCount: Int
}
  
  
  
  class PostsStorage: PostsStorageProtocol {
    
    required init(posts: [PostInitialData], likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
      self.posts = posts
      self.likes = likes
      self.currentUserID = currentUserID
    }
    
    var posts: [PostInitialData]
    var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
    var currentUserID: GenericIdentifier<UserProtocol>
    var somethingToReturn: [GenericIdentifier<UserProtocol>]?
    
    
    var count: Int {return posts.count}
    
    func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
      return self.castedPosts
        .first(where: {$0.id == postID})
    }
    
    func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
      return self.castedPosts.filter({$0.author == authorID})
    }
    
    func findPosts(by searchString: String) -> [PostProtocol] {
      return self.castedPosts.filter({ $0.description == searchString})
    }
    
    func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
      guard self.castedPosts.contains(where: {$0.id == postID})
        else {return false}
      if self.likes.contains(where: {$0.0 == currentUserID && $0.1 == postID}) {
        return true
      }
      else {
        self.likes.append((currentUserID, postID))
        return true
      }
    }
    
    func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
      guard self.castedPosts.contains(where: {$0.id == postID})
        else {return false}
      self.likes.removeAll(where: {$0.0 == currentUserID && $0.1 == postID})
      return true
    }
    
    func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
      guard self.posts
        .contains(where: {$0.id == postID})
        else {return nil}
      var resultingArray: [GenericIdentifier<UserProtocol>] = []
      self.likes
        .filter({$0.1 == postID})
        .forEach({resultingArray
          .append($0.0)
        })
      return resultingArray
    }
  }

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


let checker = Checker(usersStorageClass: UserStorage.self,
                      postsStorageClass: PostsStorage.self)
checker.run()


