import SwiftUI
import FirebaseFunctions

struct ContentView: View {
    @State private var queryBible: String = ""
    @State private var response: String = ""
    @State private var errorMessage: String = ""
    private let functions = Functions.functions()
    init() {
        #if DEBUG
        functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        #endif
    }
    
    var body: some View {
        VStack {
            Image("cross")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            Text("Word of Light")
                .font(.largeTitle.bold())
                .foregroundColor(.blue)
                .padding(.bottom, 10)
            
            TextField("Enter your question", text: $queryBible)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            Button("Ask") {
                callFirebaseFunction(query: queryBible)
            }
            .font(.system(size: 25).bold())
            .frame(width: 150, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !response.isEmpty {
                Text(response)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
        }
        .padding()
    }
    
    func callFirebaseFunction(query: String) {
        guard !query.isEmpty else {
            print("Error: Query is empty")
            errorMessage = "Error: Query cannot be empty."
            return
        }
        
        errorMessage = "" // Reset error message
        response = "" // Reset response
        
        functions.httpsCallable("fetchBibleAnswer").call(["query": query]) { result, error in
            if let error = error as NSError? {
                print("Error calling function: \(error.localizedDescription)")
                self.errorMessage = "Error: \(error.localizedDescription)"
                return
            }
            if let data = result?.data as? [String: Any],
               let response = data["result"] as? String {
                print("Response from function: \(response)")
                self.response = response
            } else {
                print("Unexpected response format")
                self.errorMessage = "Unexpected response format"
            }
        }
    }
}

#Preview {
    ContentView()
}
