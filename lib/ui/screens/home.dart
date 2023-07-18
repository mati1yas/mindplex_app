import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/auth_controller/auth_controller.dart';
import '../../routes/app_routes.dart';

AuthController authController = Get.put(AuthController());

final posts = <Widget>[];

const articlePr =
    'roses are red, violets are blue, i\'m training to be a hacker and i still do...';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;

  static const List<Tab> pageTabs = <Tab>[
    Tab(text: 'Popular'),
    Tab(text: 'Most Recent'),
    Tab(text: 'Trending'),
    Tab(text: 'Editor\'s pick'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    for (int i = 0; i < 5; i++) {
      posts.add(
        const PostWidget(
            name: 'Tristan Harris',
            date: 'Jan 19 2018',
            balance: 511,
            avatarImage: 'assets/images/woman.png',
            title: 'article title',
            articlePreview: articlePr,
            minutesWatch: 11,
            totalViews: 19.9),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  final Text? userText = const Text('Tristan Harris',
      style: TextStyle(
        fontSize: 18,
      ));
  final Text? userEmail = const Text('@tris_harris',
      style: TextStyle(
        fontSize: 18,
      ));
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.203),
          child: AppBar(
            title: Image.asset('assets/images/logo.png'),
            titleSpacing: 120,
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/woman.png')),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }),
            backgroundColor: const Color.fromARGB(255, 0, 50, 71),
            bottom: TabBar(
              controller: _tabController,
              tabs: pageTabs,
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 50, 71),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: userText,
                  accountEmail: userEmail,
                  currentAccountPicture: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/woman.png')),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 50, 71),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    Get.offAllNamed(AppRoutes.profilePage);
                    // ...
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: const Text(
                    'Upgrade',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onTap: () {
                    // ...
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 0, 50, 71)),
          child: TabBarView(
            controller: _tabController,
            children: pageTabs.map((tab) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 19),
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) => Container(
                    child: posts[index],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
}

class PostWidget extends StatelessWidget {
  const PostWidget(
      {super.key,
      required this.name,
      required this.date,
      required this.balance,
      required this.avatarImage,
      required this.title,
      required this.articlePreview,
      required this.minutesWatch,
      required this.totalViews});

  final String name;
  final String date;
  final int balance;
  final String avatarImage;
  final String title;
  final String articlePreview;
  final int minutesWatch;
  final double totalViews;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 4, 77, 100),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.222,
          width: MediaQuery.of(context).size.width * 0.915,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(avatarImage),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(name,
                      style: GoogleFonts.barlowCondensed(
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                    color: Color.fromARGB(255, 131, 255, 203),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                articlePreview,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              Text(
                '$minutesWatch min watch . ${totalViews}k views',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}
