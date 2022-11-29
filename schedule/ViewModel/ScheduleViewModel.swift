//
//  ScheduleViewModel.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


class ScheduleViewModel: ObservableObject {
    var infos: [SInfo] = []
    var user: [UserSample] = []
//    var userData: [UserData] = []
    var ids: [String]? = []
    var isCheck: Bool = true
    var data: [ReleaseBool]?
    
    
    func save(title: String, date: Date, memo: String) {
        do {
            let user = SInfo(date: date, title: title, memo: memo)
            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document().setData(from: user)
        } catch {
            print(error)
        }
    }
    
    func getInfo() async -> [SInfo] {
        do {
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule")
            let iron = try await db.getDocuments()
            self.infos = iron.documents.compactMap({ item in
                return try? item.data(as: SInfo.self)
            })
        } catch {
            print(error.localizedDescription)
        }
        return infos
    }
    
    func getUserInfo() async -> [UserSample] {
        do {
            let db = Firestore.firestore().collection("users")
            let iron = try await db.getDocuments()
            self.user = iron.documents.compactMap({ item in
                return try? item.data(as: UserSample.self)
            })
        } catch {
            print(error.localizedDescription)
        }
        return user
    }
    
//    func getSelfUserInfo() async throws -> [UserSample] {
//        do {
//            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err")
//            let iron = try await db.getDocument()
//            self.user = iron.compactMap({ item in
//                return try? item.data(as: UserSample.self)
//            })
//            db.getDocument{ (data, err) in
//                if err != nil {
//                    print("エラー")
//                }else {
//                    let data = data?.data()
//                    let user = UserSample.init()
//                }
//            }
//            return try? UserSample.self
//        } catch {
//            print(error.localizedDescription)
//        }
//        return user
//        let db = Firestore.firestore()
//        let iron = try await db.collection("users").document(Auth.auth().currentUser?.uid ?? "err").getDocument(as: UserSample.self)
//        print(document.name)
//        print(document.address)
//        print(document.age)
//        return iron
//    }
    
//    func sentUserData() async -> [UserData] {
//        do {
//            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule")
//            let iron = try await db.getDocuments()
//            self.infos = iron.documents.compactMap({ item in
//                return try? item.data(as: SInfo.self)
//            })
//        } catch {
//            print(error.localizedDescription)
//        }
//        return userData
//    }
    
    func deleteAction(info: SInfo){

//        guard let _ = infos else{return}

//        let index = infos.firstIndex(where: { currentPost in
        _ = infos.firstIndex(where: { currentPost in
            return currentPost.id == info.id
        }) ?? 0

        // deleting Post...
//        Firestore.firestore().collection("schedule").document(info.id ?? "").delete()
        Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document(info.id ?? "").delete()

//        withAnimation{infos.remove(at: index)}
    }
}

class usersID : ObservableObject {
    @Published var userID: String?
    
}

//class AppDelegate : UIResponder, UIApplicationDelegate {
//    @State var isShowLoginView: Bool = true
//
//    func application(_application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
//
//        //起動時の処理
//        LoginView(isPresentedLoginView: $isShowLoginView)
//
//        return true
//    }
//}
