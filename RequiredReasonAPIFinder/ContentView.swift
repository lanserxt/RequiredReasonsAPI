//
//  ContentView.swift
//  RequiredReasonAPIFinder
//
//  Created by Anton Gubarenko on 03.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var fileURLs: [URL] = []
    
    @State
    private var matchedURLs: [DetectedUsage] = []
    
    @State
    private var apiInfoArray: [APIInfo] = []
    
    @State
    private var searchedOnce: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    searchWordInFiles()
                    searchedOnce = true
                }, label: {
                    Text("Check API usage")
                        .lineLimit(-1)
                        .multilineTextAlignment(.leading)
                })
                .padding()
                
                List(fileURLs, id: \.self) { url in
                    Text(url.path)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !fileURLs.isEmpty {
                    Button(action: {
                        fileURLs.removeAll()
                    }, label: {
                        Text("Clear all")
                    })
            }
                
                DropView(fileURLs: $fileURLs)
            }.frame(minWidth: 200.0)
            
            if !matchedURLs.isEmpty {
                VStack {
                    Text("Matching Files:")
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Group {
                    if fileURLs.isEmpty {
                        Text("Drag folders to search")
                    } else {
                        if searchedOnce {
                            Text("No plist changes reqiured")
                        } else {
                            Text("Press 'Check API usage'")
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            loadAPIInfo()
        }
        .padding()
        .navigationTitle("Reasoned API Finder")
    }
    
    func showInFinder(url: URL?) {
        guard let url = url else { return }
        
        if url.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
        
    private func searchWordInFiles() {
        for fileURL in fileURLs {
            if fileURL.isDirectory {
                searchWordInDirectory(fileURL)
            } else {
                searchWordInFile(fileURL)
            }
        }
    }
    
    private func searchWordInDirectory(_ directoryURL: URL) {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs {
                if fileURL.isDirectory {
                    searchWordInDirectory(fileURL)
                } else {
                    searchWordInFile(fileURL)
                }
            }
        } catch {
            print("Error reading directory: \(error.localizedDescription)")
        }
    }
    
    private func searchWordInFile(_ fileURL: URL) {
        do {
            let fileContent = try String(contentsOf: fileURL)
            
            print("Checking \(fileURL.lastPathComponent)")
            for api in apiInfoArray {
                if fileContent.containsAny(api.funcs) {
                    // Assuming the file contains the exact word 'getBuffSize'
                    matchedURLs.append(DetectedUsage(fileURL: fileURL, api: api))
                    print("Found \(api.name)")
                }
            }
            
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    
    struct DetectedUsage: Identifiable, Hashable {
        let fileURL: URL
        let api: APIInfo
        
        var id: String {
            fileURL.absoluteString
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(fileURL.absoluteString)
        }
    }
    
    //MARK: - Load Data
    
    private func loadAPIInfo() {
        // Get the URL for the JSON file in the app bundle
        if let url = Bundle.main.url(forResource: "APIReasons", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                apiInfoArray = try JSONDecoder().decode([APIInfo].self, from: jsonData)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found in the bundle.")
        }
    }
}

struct DropView: View {
    @Binding var fileURLs: [URL]
    
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.2))
            .overlay(Text("Drag & Drop Folders Here"))
            .onDrop(of: [.fileURL], isTargeted: nil) { providers -> Bool in
                if let provider = providers.first(where: { $0.canLoadObject(ofClass: URL.self) } ) {
                    let _ = provider.loadObject(ofClass: URL.self) { object, error in
                        if let url = object {
                            if url.isDirectory {
                                DispatchQueue.main.async {
                                    fileURLs.append(url)
                                }
                            }
                        }
                    }
                    return true
                }
                return false
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color.blue)
            )
            .frame(maxWidth: .infinity, maxHeight: 150)
            .padding()
    }
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

extension String {
    func containsAny(_ list: [String]) -> Bool {
        for item in list {
            if contains(item) {
                print("what: \(item)")
                return true
            }
        }
        return false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
