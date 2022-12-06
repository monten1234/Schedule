//
//  Post.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/03.
//

import FirebaseFirestoreSwift
import Firebase

// Post Model...
struct SInfo: Identifiable,Codable{
    @DocumentID var id: String?
    var date: Date
    var title: String?
    var memo: String?
    var members: [String]?
    
    enum CodingKeys: String,CodingKey{
        case id
        case date
        case title
        case memo
        case members
    }
}

struct UserSample: Identifiable,Codable{
    @DocumentID var id: String?
    var name: String?
    var mail: String?
    
    enum CodingKeys: String,CodingKey{
        case id
        case name
        case mail
    }
}

struct ReleaseBool: Identifiable,Codable{
    @DocumentID var id: String?
    var isCheck: Bool
    
    enum CodingKeys: String,CodingKey{
        case id
        case isCheck
    }
}

struct PermissionBool: Identifiable,Codable{
    @DocumentID var id: String?
    var isCheck: Bool
    
    enum CodingKeys: String,CodingKey{
        case id
        case isCheck
    }
}

// Date Value Model...
struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}







