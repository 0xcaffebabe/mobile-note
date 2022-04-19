//
//  ReviewListView.swift
//  MobileNote
//
//  Created by mymac on 2022/4/17.
//

import SwiftUI

enum DateRange: Int, CaseIterable, Identifiable {
    case now = 0
    case inOneDay = 1
    case inOneWeek = 2
    case inOneMonth = 3
    case inSixMonth = 4
    case far = 5
    
    var id: String {
        String(rawValue)
    }
}

enum Sort: String, CaseIterable, Identifiable {
    case asc = "正序"
    case desc = "倒序"
    
    var id: String {rawValue}
}

let rangeDict: [Int: String] = [0: "现在", 1: "1天内", 2:"1周内", 3: "1月内", 4:"6月内", 5: "最远"]
// 编号: 天数
let rangeDayDict: [Int: Int] = [0:0, 1:1, 2:7, 3:30, 4:180, 5:36000]

struct ReviewListView: View {
    @State var reviewList: [Review] = []
    @State var startSelection = DateRange.now
    @State var endSelection = DateRange.far
    @State var sortSelection = Sort.desc
    
    var filteredReviewList: [Review] {
        // 计算开始时间及结束的绝对秒数
        // 判断review的提交时间是否在这个时间段内
        let current = Date()
        let left = rangeDayDict[startSelection.rawValue]!
        let right = rangeDayDict[endSelection.rawValue]!
        debugPrint(current.timeIntervalSince1970)
        let startTime = Int64(current.timeIntervalSince1970) - Int64(left) * Int64(3600 * 24)
        let endTime = Int64(current.timeIntervalSince1970) - Int64(right) * Int64(3600 * 24)
        
        let dateFormatter = ISO8601DateFormatter()
        let list = reviewList.filter { review in
            if let commitInfo = review.commitInfo {
                let time = Int64(dateFormatter.date(from: commitInfo.date)?.timeIntervalSince1970 ?? 0)
                return time >= endTime && time <= startTime
            }
            return false
        }
        if sortSelection == Sort.asc {
            return list.reversed()
        }
        return list
    }
    var body: some View {
        List {
            Picker("排序", selection: $sortSelection) {
                ForEach(Sort.allCases) { sort in
                    Text(sort.rawValue).tag(sort)
                }
            }
            .pickerStyle(.menu)
            Picker("起始", selection: $startSelection) {
                ForEach(DateRange.allCases){ dateRange in
                    if dateRange.rawValue < endSelection.rawValue {
                        Text(rangeDict[dateRange.rawValue]!).tag(dateRange)
                    }
                }
            }
            .pickerStyle(.segmented)
            
            Picker("结束", selection: $endSelection) {
                ForEach(DateRange.allCases){ dateRange in
                    if dateRange.rawValue > startSelection.rawValue {
                        Text(rangeDict[dateRange.rawValue]!).tag(dateRange)
                    }
                }
            }
            .pickerStyle(.segmented)
            ForEach(filteredReviewList) { review in
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
