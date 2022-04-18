//
//  ReviewListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/17.
//

import SwiftUI

enum DateRange: String, CaseIterable, Identifiable {
    case now = "现在"
    case inOneDay = "1天内"
    case inOneWeek = "1周内"
    case inOneMonth = "1月内"
    case inSixMonth = "6月内"
    case far = "最远"
    
    var id: String {
        rawValue
    }
}

struct ReviewListView: View {
    @State var reviewList: [Review] = []
    @State var startSelection = DateRange.now
    @State var endSelection = DateRange.far
    var body: some View {
        List {
            Picker("起始", selection: $startSelection) {
                ForEach(DateRange.allCases){ dateRange in
                    Text(dateRange.rawValue).tag(dateRange)
                }
            }
            .pickerStyle(.segmented)
            
            Picker("结束", selection: $endSelection) {
                ForEach(DateRange.allCases){ dateRange in
                    Text(dateRange.rawValue).tag(dateRange)
                }
            }
            .pickerStyle(.segmented)
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
