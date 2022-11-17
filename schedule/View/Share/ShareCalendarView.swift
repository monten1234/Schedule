//
//  ShareCalendarView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/07/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ShareCalendarView: View {
    @EnvironmentObject var userID : usersID
    @StateObject var viewModel = ScheduleViewModel()
    @State var infos = [SInfo]()
    @State var yotei:String = ""
    
    var body: some View {
//        NavigationView {
        ZStack {
            Color.green.opacity(0.1)
            ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(infos) { item in
                            VStack {
                                let current = Calendar.current
                                let day = current.component(.day, from: item.date)
                                let month = current.component(.month, from: item.date)
                                VStack (alignment: .leading){
                                    Text("\(month)月\(day)日")
                                        .font(.title)
                                }
                                Text("\(item.title ?? "")")
                                    .frame(width: 160, height: 40)
                                    .fixedSize()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                Text("\(item.memo ?? "nill")")
                                    .fixedSize()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                            .frame(width: 300)
                            .background(Color.green.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
    //                        .swipeActions(edge: .trailing){
    //                            Button(role: .destructive) {
    //                                viewModel.deleteAction(info: item)
    //                            } label: {
    //
    //                                Image(systemName: "trash")
    //                            }
    //                        }
                            .padding()
                        }
                    }
    //                .toolbar {
    //                    ToolbarItem(placement: .navigationBarTrailing) {
    //                        Button {
    //                            Task {
    //                                infos = await getFriendInfo()
    //                            }
    //                        } label: {
    //                            Image(systemName: "goforward")
    //                        }
    //
    //                    }
    //                }
                    .onAppear{
                        Task {
                            infos = await getFriendInfo()
                        }
                    }
            }
        }
            Spacer()
//        }
    }
    func getFriendInfo() async -> [SInfo] {
        do {
            let db = Firestore.firestore().collection("users").document(userID.userID ?? "err").collection("schedule")
            let iron = try await db.getDocuments()
            self.infos = iron.documents.compactMap({ item in
                return try? item.data(as: SInfo.self)
            })
        } catch {
            print(error.localizedDescription)
        }
        return infos
    }
}
