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
                List(matchedAPIs, id: \.self) { item in
                    VStack {
                        Text(item.name)
                            .font(.headline)
                            .bold()
                            .padding(.top)
                            ForEach(item.reasons, id: \.self) { reason in
                                HStack {
                                    Text(reason.id)
                                        .bold()
                                        .frame(width: 50)
                                    Text(reason.info)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }.padding()
                            }
                    }
                    .background(Rectangle()
                        .cornerRadius(8.0)
                        .foregroundColor(.gray)
                        .opacity(0.2)
                    )
                    .frame(minHeight: 30.0)
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
