//
//  ApprovalView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

struct PermissionView: View {
    @State var viewModel = ScheduleViewModel()
    @State var sentUserData: [UserSample] = []
//    @State var sentUserDatas: [UserData] = []
    @State var isShowingDialog: Bool = false
    @State var userID: String?
    @State var name: String?

    
    var body: some View {
//        NavigationView {
        ZStack {
            Color.green.opacity(0.1)
            ScrollView(.vertical) {
                    ForEach(sentUserData) { user in
                        VStack {
                            Button {
                                isShowingDialog = true
                                userID = user.id
                                name = user.name
                            } label: {
                                Text("\(user.id ?? "nill")")
    //                                .foregroundColor(.black)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .confirmationDialog("許可しますか？", isPresented: $isShowingDialog) {
                                Button {
                                    sendGroupSelf(id: userID ?? "err", name: name ?? "err")
                                    sendGroupAnother(id: Auth.auth().currentUser?.uid ?? "err", name: name ?? "err")
                                } label: {
                                    Text("許可する")
                                }
                                Button("削除する", role: .destructive) {

                                }
                                Button("キャンセルする", role: .cancel) {

                                }
                            }
    //                        Text(user.id ?? "nill")
    //                        Text(user.mail ?? "nill")
                        }
                        .padding()
                    }
                }
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    Button {
    //                        Task {
    //                            sentUserData = await sentUserData()
    //                        }
    //                    } label: {
    //                        Image(systemName: "goforward")
    //                    }
    //                }
    //            }
                .onAppear{
                    Task {
                        sentUserData = await sentUserData()
                    }
                }
            .navigationTitle("フレンド依頼一覧")
        }
//        }
    }
    func sentUserData() async -> [UserSample] {
        do {
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("permission")
            let iron = try await db.getDocuments()
            self.sentUserData = iron.documents.compactMap({ item in
                return try? item.data(as: UserSample.self)
            })
        } catch {
            print(error.localizedDescription)
        }
        return sentUserData
    }
    func sendGroupSelf(id: String, name: String) {
        do {
            let data = UserSample(id: id, name: name)
            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group").document(userID ?? "err").setData(from: data)
        } catch {
            print(error)
        }
    }
    func sendGroupAnother(id: String, name: String) {
        do {
            let data = UserSample(id: id, name: name)
            try Firestore.firestore().collection("users").document(userID ?? "err").collection("group").document(Auth.auth().currentUser?.uid ?? "err").setData(from: data)
        } catch {
            print(error)
        }
    }
}



//
//func getUserInfo() async -> [UserSample] {
//    do {
//        let db = Firestore.firestore().collection("users")
//        let iron = try await db.getDocuments()
//        self.user = iron.documents.compactMap({ item in
//            return try? item.data(as: UserSample.self)
//        })
//    } catch {
//        print(error.localizedDescription)
//    }
//    return user
//}
