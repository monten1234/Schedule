//
//  ReleaseSelectionView.swift
//  schedule
//
//  Created by 足立　岳大 on 2022/11/09.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ReleaseSelectionView: View {
    @StateObject var viewModel = ScheduleViewModel()
    @State var sentGroupDatas: [ReleaseBool] = []
    var title: String
    var date: Date
    var memo: String
    @State var members: [String] = []
    @State var friendIDs:[ReleaseBool] = []
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(friendIDs) { item in
                ReleaseSelectionCell(item: item.id ?? "", members: $members)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    save(title: title, date: date, memo: memo, members: members)
                    print(members)
                    self.presentation.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
                
            }
        }
        .onAppear{
            Task {
                await getFriendID()
            }
        }
    }
//    func setMembers(members: [String]) {
//        do {
//            let membersID:[String] = []
//            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document().setData(from: membersID)
//        } catch {
//            print(error)
//        }
//    }
    func save(title: String, date: Date, memo: String, members: [String]) {
        do {
            let schedule = SInfo(date: date, title: title, memo: memo, members: members)
            try Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("schedule").document().setData(from: schedule)
        } catch {
            print(error)
        }
    }

    //    func sentGroupData() async{
    //        do {
    //            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group")
    //            let sentGroupDatas = try await db.getDocuments()
    //            self.sentGroupDatas = sentGroupDatas.documents.compactMap({ item in
    //                return try? item.data(as: ReleaseBool.self)
    //            })
    //            print(self.sentGroupDatas)
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //
    //    }
    func getFriendID() async {
        do {
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group").whereField("isCheck", isEqualTo: true)
            let friendIDs = try await db.getDocuments()
            self.friendIDs = friendIDs.documents.compactMap({ friendID in
                return try? friendID.data(as: ReleaseBool.self)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    struct ReleaseSelectionCell: View {
        @State var isReleaseParsonal : Bool = true
        let item: String
        @Binding var members: [String]
        //    @State var friendName: [String]
        
        var body: some View {
            VStack{
                HStack {
                    Text("\(item)")
                        .foregroundColor(.black)
                    Button {
                        isReleaseParsonal.toggle()
                        if isReleaseParsonal {
                            members.append(item)
                        } else {
                            if let i = members.firstIndex(of: item) {
                                members.remove(at: i)
                            }
                            //                        members.removeAll(where: {item.id.contains($0)})
                        }
                    } label: {
                        Text(isReleaseParsonal ? "公開する":"公開しない")
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .font(.title)
            .padding()
            .onAppear{
                members.append(item)
            }
        }
        //    func getFriendName() async {
        //        do {
        //            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group").whereField("isCheck", isEqualTo: true)
        //            let friendName = try await db.getDocuments()
        //            self.friendName = friendName.documents.compactMap({ item in
        //                return try? item.data(as: String.self)
        //            })
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        //    }
    }
}



