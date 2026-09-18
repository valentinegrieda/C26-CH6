import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    /*init() {
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemTeal
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
         
    }*/
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            
            
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
                .tag(1)
            
            
            AddView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "plus")
                }
                .tag(2)
            
            DraftView()
                .tabItem {
                    Image(systemName: "document.badge.plus.fill")
                }
                .tag(3)
            
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(4)
        }
        .tint(.teal)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.white.opacity(0.7), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}


/*
struct DraftView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Pengaturan Aplikasi ⚙️").font(.title).foregroundColor(.white)
        }
    }
}
*/

/*struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Pengaturan Aplikasi ⚙️").font(.title).foregroundColor(.white)
        }
    }
}*/

#Preview {
    MainTabView()
}
