//
//  PostStorageClass.swift
//  FirstCourseFinalTask
//
//  Created by Vladimir Banushkin on 24.04.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//


import FirstCourseFinalTaskChecker

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
