//
//  RecordPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import Foundation

protocol RecordPresenterInput {
    func showErrorAlert(error: NSError?)
    func fetchRecords()
    var userId: String { get }
    var records: [RecordModel] { get }
}

protocol RecordPresenterOutput {
    func showErrorAlert(code: String, message: String)
}


final class RecordPresenter {
    private var output: RecordPresenterOutput!
    
    private var _userId: String
    var userId: String {
        get {
            return _userId
        }
    }
    
    private var _records: [RecordModel] = []
    var records: [RecordModel] {
        get {
            return _records
        }
    }
    
    init(output: RecordPresenterOutput) {
        let userId = AuthService.shared.getCurrentUserId()
        self._userId = userId ?? ""
        self.output = output
    }
}

extension RecordPresenter: RecordPresenterInput {
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func fetchRecords() {
        DatabaseService.shared.getCollection(userId: userId) { records, error in
            print("Recordを取得")
            print(records)
            self.showErrorAlert(error: error)
            
            if records.isEmpty {
                // recordsがない場合、howToViewを表示する
                // self._showEmptyView.accept(!records.isEmpty)
                // return
            }
            
            self._records = records
            // self._loading.accept(false)
            // self._updateMemoModels.accept(memos)
            return
        }
    }
}
