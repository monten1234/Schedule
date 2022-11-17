//
//  ShareView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FriendView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State var sentGroupDatas: [UserSample] = []
    @EnvironmentObject var userID: usersID
    @State var page : Int? = 0
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.1)
                ScrollView(.vertical) {
                    ForEach(sentGroupDatas) { user in
                        VStack {
                            Button {
                                userID.userID = user.id ?? "err"
                                page = 3
                            } label: {
                                Text("\(user.name ?? "nill")")
                            }
                            .padding()
                            NavigationLink(destination : ShareCalendarView(),
                                           tag: 3, selection: $page) { EmptyView() }
                        }
                    }
                    .padding()
                }
                .navigationTitle("フレンド")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    Button {
    //                        Task {
    //                            sentGroupDatas = await sentGroupData()
    //                        }
    //                    } label: {
    //                        Image(systemName: "goforward")
    //                    }
    //                }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: PermissionView()) {
                           Image(systemName: "folder.badge.plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: FriendAddView()) {
                            Image(systemName: "person.crop.circle.badge.plus")
                        }
                    }
                }
                .onAppear{
                    Task {
                        sentGroupDatas = await sentGroupData()
                    }
                }
            }
        }
    }
    
    func sentGroupData() async -> [UserSample] {
        do {
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group")
            let iron = try await db.getDocuments()
            self.sentGroupDatas = iron.documents.compactMap({ item in
                return try? item.data(as: UserSample.self)
            })
        } catch {
            print(error.localizedDescription)
        }
        return sentGroupDatas
    }
}


