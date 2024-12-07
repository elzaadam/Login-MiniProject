// dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState {
  final List<String> stories;
  final List<String> posts;
  DashboardState({this.stories = const [], this.posts = const []});
}

class Story {
  final String image;
  final String username;

  Story({required this.image, required this.username});
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState());

  // Fetch random stories (URLs or image data)
  void fetchStories() {
    // Fetch your story data (you can get images from https://picsum.photos)
    List<String> stories =
        List.generate(10, (index) => 'https://picsum.photos/200?random=$index');
    emit(DashboardState(stories: stories, posts: state.posts));
  }

  // Fetch random posts
  void fetchPosts() {
    // Fetch your post data (again, use https://picsum.photos)
    List<String> posts = List.generate(
        10, (index) => 'https://picsum.photos/500/300?random=$index');
    emit(DashboardState(stories: state.stories, posts: posts));
  }
}
