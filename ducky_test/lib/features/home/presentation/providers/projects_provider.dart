import 'dart:async';

import 'package:ducky_test/features/authorization/presentation/providers/auth_provider.dart';
import 'package:ducky_test/features/home/data/models/project.dart';
import 'package:ducky_test/features/home/data/projects_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/projects_repository_impl.dart';
import '../../data/remote/comments_remote_data_source.dart';
import '../../data/remote/issues_remote_data_source.dart';
import '../../data/remote/projects_remote_data_source.dart';

class ProjectNotifier
    extends StateNotifier<AsyncValue<List<Project>>> {
  final ProjectsRepository projectsRepository;
  Timer? _pollingTimer;

  ProjectNotifier(this.projectsRepository)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await getProjects();
    startPolling();
  }

  void startPolling() {
    _pollingTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) {
      refreshProjects();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> getProjects() async {
    state = const AsyncValue.loading();
    try {
      final projects =
          await projectsRepository.getProjects();
      state = AsyncValue.data(projects);
      this.projects = projects;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  List<Project> projects = [];

  void refreshProjects() async {
    try {
      final projects =
          await projectsRepository.getProjects();

      if (_hasProjectsChanged(projects)) {
        state = AsyncValue.data(projects);
        return;
      }

      if (_hasIssuesOrCommentsChanged(projects)) {
        state = AsyncValue.data(projects);
      }
    } catch (e, stackTrace) {
    }
  }

  bool _hasProjectsChanged(List<Project> projects) {
    return projects.length != state.value?.length;
  }

  bool _hasIssuesOrCommentsChanged(List<Project> projects) {
    for (int i = 0; i < projects.length; i++) {
      if (projects[i].issues.length !=
          state.value?[i].issues.length) {
        return true;
      }

      for (int j = 0; j < projects[i].issues.length; j++) {
        if (projects[i].issues[j].comments.length !=
            state.value?[i].issues[j].comments.length) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

final projectsRepositoryProvider =
    Provider<ProjectsRepository>((ref) {
  final projectsDataSource = ProjectsRemoteDataSource(ref);
  final issuesDataSource = IssuesRemoteDataSource(ref);
  final commentsDataSource = CommentsRemoteDataSource(ref);
  final user = ref.watch(authProvider);

  return user.when(
    data: (userData) => ProjectsRepositoryImpl(
      projectsDataSource,
      issuesDataSource,
      commentsDataSource,
      userId: userData?.id,
    ),
    loading: () => ProjectsRepositoryImpl(
      projectsDataSource,
      issuesDataSource,
      commentsDataSource,
    ),
    error: (_, __) => ProjectsRepositoryImpl(
      projectsDataSource,
      issuesDataSource,
      commentsDataSource,
    ),
  );
});

final projectsProvider = StateNotifierProvider<
    ProjectNotifier, AsyncValue<List<Project>>>((ref) {
  final projectsRepository =
      ref.watch(projectsRepositoryProvider);
  return ProjectNotifier(projectsRepository);
});
