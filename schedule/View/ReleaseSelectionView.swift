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
    @State var isReleaseParsonal : Bool = true
    @State var ids:[ReleaseBool] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(0 ..< ids.count, id:\.self) { item in
                HStack {
                    Text("\(ids[item])")
                        .foregroundColor(.black)
                    Button {
                        isReleaseParsonal.toggle()
                    } label: {
                        if isReleaseParsonal {
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
                await sentGroupData()
                print(sentGroupDatas)
                for data in $sentGroupDatas {
                    if data.isCheck{
                        ids.id.append(data.id)
                    }
                }
                ForEach(sentGroupDatas) { data in
                    if data.isCheck{
                        ids.id.append(data.id)
                    }
                }
                print(ids)
            }

        }
    }
    func sentGroupData() async{
        do {
            let db = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "err").collection("group")
            let sentGroupDatas = try await db.getDocuments()
            self.sentGroupDatas = sentGroupDatas.documents.compactMap({ item in
                return try? item.data(as: ReleaseBool.self)
            })
//            print(self.sentGroupDatas)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    func getFriendID () {
//        for data in sentGroupDatas {
//            if data.isCheck!{
//                ids[0].append(contentsOf: data.id!)
//            }
//        }
    }
}

//struct ReleaseSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReleaseSelectionView()
//    }
//}
