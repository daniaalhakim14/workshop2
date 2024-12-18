//define routes and menu structure

const rootRoute = "/";

const postPageRouteName = "Post";
const postPageRoute = "/post";

const profilePageRouteName = "Profile";
const profilePageRoute = "/profile";

const logoutPageRouteName = "Logout";
const logoutPageRoute = "/login";

class MenuItem{

  final String name;
  final String route;

  MenuItem(this.name,this.route);

}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(postPageRouteName,postPageRoute),
  MenuItem(profilePageRouteName, profilePageRoute),
  MenuItem(logoutPageRouteName,logoutPageRoute),
];