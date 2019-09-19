//
//  HomeView.swift
//  Dashboard
//
//  Created by Patrick Gatewood on 9/11/19.
//  Copyright © 2019 Patrick Gatewood. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.editMode) var mode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: PersistenceClient.allServicesFetchRequest()) var services: FetchedResults<ServiceModel>
//    @EnvironmentObject var serviceList: ServiceList
    
    @State var showingAddServices = false
    @State var serviceToEdit: ServiceModel?

    
    var addServiceButton: some View {
        Button(action: { self.showingAddServices.toggle() }) {
            Image(systemName: "plus.circle")
                .scaledToFit()
                .accessibility(label: Text("Add Service"))
                .imageScale(.large)
                .frame(width: 25, height: 25)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(services, id: \.url) { service in
                    ServiceRow(name: service.name, url: service.url, image: service.image, statusImage: service.statusImage)
                        .contextMenu {
                            Button(action: {
                                self.serviceToEdit = service
                                self.showingAddServices.toggle() })
                            {
                                Text("Edit Service")
                            }
                    }
                }
                .onDelete(perform: deleteService)
            }
            .navigationBarTitle("My Services")
            .navigationBarItems(leading: EditButton(),
                                trailing: addServiceButton)
                .sheet(isPresented: $showingAddServices) {
                    AddServiceHostView(serviceToEdit: self.serviceToEdit)
                        .onDisappear() {
                            self.serviceToEdit = nil
                    }
            }
        }
    }
    
    func deleteService(at offsets: IndexSet) {
        guard let deletionIndex = offsets.first else {
            return
        }
        
        let service = services[deletionIndex]
        PersistenceClient.shared.delete(service)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = HomeViewModel(networkService: MockNetworkService())
//        
//        for i in 1...10 {
//            let serviceViewModel = ServiceRowViewModel(name: "Hello", url: "", image: UIImage(), status: .unknown)
//            
//            viewModel.services.append(serviceViewModel)
//        }
//                
//       return HomeView(viewModel: viewModel)
//    }
//}
