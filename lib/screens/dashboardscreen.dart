// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project/bloc/dashboard_bloc.dart';
import 'package:mini_project/screens/login_page.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage(), // Replace NextScreen() with your desired screen widget
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => DashboardCubit()
          ..fetchStories()
          ..fetchPosts(),
        child: Column(
          children: [
            // Stories Section (Horizontal Scroll)
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return Container(
                    color: const Color.fromARGB(255, 56, 117, 152),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.stories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(state.stories[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Posts Section (Vertical Scroll)
            Expanded(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return Container(
                    color: const Color.fromARGB(
                        255, 142, 216, 225), // Set the background color here
                    child: ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(state.posts[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
