//
//  ResultsView.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 06.08.2023.
//

import SwiftUI

struct ResultsView: View {
    
    @Binding
    var fileURLs: [URL]
    
    @Binding
    var matchedURLs: [DetectedUsage]
    
    @Binding
    var matchedAPIs: [APIInfo]
    
    @Binding
    var searchedOnce: Bool
    
    
    enum ResultType: String, Equatable, CaseIterable {
        case list  = "Info"
        case code = "Code"

        var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    }
    
    @State
    private var switchIndex: ResultType = .list
    
    private let infoURL = URL(string: "https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api")!
    
    var body: some View {
        if !matchedURLs.isEmpty {
            VStack {
                HStack {
                    Button {
                        NSWorkspace.shared.open(infoURL)
                    } label: {
                        Image(systemName: "info")
                    }
                    Text("Matching Files")
                }
                List(matchedURLs, id: \.self) { item in
                    HStack {
                        Text(item.fileURL.lastPathComponent)
                        Spacer()
                        Text(item.api.name)
                            .bold()
                        Button {
                            showInFinder(url: item.fileURL)
                        } label: {
                            Image(systemName: "folder")
                        }
                        Button {
                            NSWorkspace.shared.open(item.fileURL)
                        } label: {
                            Image(systemName: "eye")
                        }
                    }
                    .frame(minHeight: 30.0)
                }
                HStack {
                    Text("Possible usage")
                }
                Picker("", selection: $switchIndex) {
                    ForEach(ResultType.allCases, id: \.self) { value in
                                        Text(value.localizedName)
                                            .tag(value)
                                    }
                    }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 200)
                if switchIndex == .list {
                    ResultsList(matchedAPIs: $matchedAPIs)
                } else {
                    ResultsCode(matchedAPIs: $matchedAPIs)
                        .frame(minHeight: 200.0)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Group {
                if fileURLs.isEmpty {
                    HStack {
                        Text("Drag folders to search")
                    }
                } else {
                    if searchedOnce {
                        Text("No plist changes required")
                    } else {
                        Text("Press 'Check API usage'")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func showInFinder(url: URL?) {
        guard let url = url else { return }
        
        if url.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(fileURLs: .constant([]),
                    matchedURLs: .constant([]),
                    matchedAPIs: .constant([]),
                    searchedOnce: .constant(false))
    }
}
