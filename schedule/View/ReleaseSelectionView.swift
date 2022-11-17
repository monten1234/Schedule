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
    @State var sentGroupDatas: [UserSample] = []
    @State var isReleasePasonal : Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(sentGroupDatas) { user in
                HStack {
                    Text("\(user.name ?? "nill")")
                    
                    Button {
                        isReleasePasonal.toggle()
                    } label: {
                        if isReleasePasonal {
                            Text("公開する")
                                .foregroundColor(.white)
                                .background(Color.red.opacity(0.7))
                        } else {
                            Text("公開しない")
                                .foregroundColor(.white)
                                .background(Color.blue.opacity(0.7))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .font(.title)
                .padding()
            }
        }
        .onAppear{
            Task {
                sentGroupDatas = await sentGroupData()
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

//struct ReleaseSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseSelectionView()
//    }
//}
