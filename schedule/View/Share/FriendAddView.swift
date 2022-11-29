//
//  FriendAddView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/22.
//
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FriendAddView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State var users = [UserSample]()
    @State var isShowingDialog = false
    //@State var user = [UserSample]()
    @State var userID: String?
    @State var userMail: String?
    @State var user = Auth.auth().currentUser?.uid
    @State var name:String?
    
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1)
            ScrollView(.vertical) {
                ForEach(users) { user in
                    VStack {
                        Button {
                            isShowingDialog = true
                            userID = user.id
                            userMail = user.mail
                            name = user.name
                        } label: {
                            Text("\(user.id ?? "nill")")
                            .foregroundColor(.black)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .confirmationDialog("フレンド申請しますか？", isPresented: $isShowingDialog) {
                            Button {
                                sendUserData(id:Auth.auth().currentUser?.uid ?? "err", name: name ?? "err")
                            } label: {
                                Text("申請する")
                            }
                            Button("キャンセルする", role: .cancel) {
                                
                            }
                        }
                    }
                    .padding()
                }
            }
            //            .toolbar {
            //                ToolbarItem(placement: .navigationBarTrailing) {
            //                    Button {
            //                        Task {
            //                            users = await viewModel.getUserInfo()
            //                            users.removeAll(where: {$0.id == user})
            //                        }
            //                    } label: {
            //                        Image(systemName: "goforward")
            //                    }
            //                }
            //            }
            .onAppear{
                Task {
                    users = await viewModel.getUserInfo()
                    users.removeAll(where: {$0.id == user})
                }
            }
            
        }
        .navigationTitle("フレンド追加")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendUserData(id: String, name: String) {
        do {
            let data = UserSample(id: id)
            try Firestore.firestore().collection("users").document(userID ?? "err").collection("group").document(Auth.auth().currentUser?.uid ?? "err").setData(from: data)
        } catch {
            print(error)
        }
    }
//    func releasePermission(bool: Bool) {
//        do {
//            let data = ReleaseBool(bool: bool)
//            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document(Bindingでやる).collection(releaseSelection).document().setData(from: data)
//        } catch {
//            print(error)
//        }
//    }
}


