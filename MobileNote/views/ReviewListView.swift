//
//  ReviewListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/17.
//

import SwiftUI

struct ReviewListView: View {
    @State var reviewList: [Review] = []
    var body: some View {
        List {
            ForEach(reviewList) { review in
                if let review = review {
                    NavigationLink {
                        DocView(docId: review.docId)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(review.docId)
                            VStack {
                                if let commitInfo = review.commitInfo {
                                    HStack {
                                    Text(commitInfo.date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        Text(commitInfo.message)
                                            .font(.body)
                                    }
                                }else {
                                    HStack {
                                    Text("1999/2/17 12:00:00")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        Text("unknow commit")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                }
                    
                
            }
        }.onAppear {
            Api.defaultApi.getReviewList { reviewList in
                if let reviewList = reviewList {
                    self.reviewList = reviewList
                }
            }
        }
        
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView()
    }
}
