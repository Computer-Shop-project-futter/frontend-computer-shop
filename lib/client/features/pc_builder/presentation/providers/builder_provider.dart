// lib/features/builder/presentation/providers/builder_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/builder_repository_hybrid.dart';
import '../../domain/builder_model.dart';

final builderRepositoryProvider = Provider<BuilderRepositoryHybrid>((ref) {
  return BuilderRepositoryHybrid();
});

final builderProvider = StateNotifierProvider<BuilderNotifier, BuilderState>((ref) {
  return BuilderNotifier(ref.read(builderRepositoryProvider));
});

class BuilderNotifier extends StateNotifier<BuilderState> {
  final BuilderRepositoryHybrid _repository;

  BuilderNotifier(this._repository) : super(const BuilderState()) {
    loadSavedBuilds();
    _createNewBuild();
  }

  Future<void> loadSavedBuilds() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      print('DEBUG: Loading saved builds from repository');
      final builds = await _repository.getSavedBuilds();
      state = state.copyWith(savedBuilds: builds, isLoading: false);
      print('INFO: Saved builds loaded successfully - ${builds.length} builds');
    } catch (e) {
      print('ERROR: Failed to load saved builds: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load saved builds: ${e.toString()}',
      );
    }
  }

  void _createNewBuild() {
    state = state.copyWith(
      currentBuild: BuildConfiguration(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New Build ${DateTime.now().year}',
        createdAt: DateTime.now(),
      ),
    );
  }

  void updateBuildName(String name) {
    if (state.currentBuild != null) {
      state = state.copyWith(
        currentBuild: state.currentBuild!.copyWith(name: name),
      );
    }
  }

// lib/features/pc_builder/presentation/providers/builder_provider.dart

void selectComponent(Component component) {
  if (state.currentBuild == null) return;

  BuildConfiguration updated;
  switch (component.type) {
    case ComponentType.cpu:
      updated = state.currentBuild!.copyWith(cpu: component);
      break;
    case ComponentType.gpu:
      updated = state.currentBuild!.copyWith(gpu: component);
      break;
    case ComponentType.motherboard:
      updated = state.currentBuild!.copyWith(motherboard: component);
      break;
    case ComponentType.ram:
      updated = state.currentBuild!.copyWith(ram: component);
      break;
    case ComponentType.storage:
      updated = state.currentBuild!.copyWith(storage: component);
      break;
    case ComponentType.cooling:
      updated = state.currentBuild!.copyWith(cooling: component);
      break;
    case ComponentType.psu:
      updated = state.currentBuild!.copyWith(psu: component);
      break;
    case ComponentType.pcCase:  // Changed from 'case' to 'pcCase'
      updated = state.currentBuild!.copyWith(pcCase: component);
      break;
  }
  
  state = state.copyWith(
    currentBuild: updated,
    selectingComponentType: null,
  );
}

void startComponentSelection(ComponentType type) {
  state = state.copyWith(selectingComponentType: type);
}

  void clearComponentSelection() {
    state = state.copyWith(selectingComponentType: null);
  }

  Future<void> saveCurrentBuild() async {
    if (state.currentBuild == null) {
      state = state.copyWith(
        error: 'No build to save',
      );
      return;
    }
    
    try {
      state = state.copyWith(isLoading: true, error: null);
      print('DEBUG: Saving build - ID: ${state.currentBuild!.id}, Name: ${state.currentBuild!.name}');
      
      final saved = await _repository.saveBuild(state.currentBuild!);
      
      final updatedBuilds = [...state.savedBuilds, saved];
      state = state.copyWith(
        savedBuilds: updatedBuilds,
        isLoading: false,
      );
      print('INFO: Build saved successfully');
    } catch (e) {
      print('ERROR: Failed to save build: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save build: ${e.toString()}',
      );
    }
  }

  Future<void> deleteBuild(String buildId) async {
    try {
      print('DEBUG: Deleting build - ID: $buildId');
      await _repository.deleteBuild(buildId);
      final updatedBuilds = state.savedBuilds.where((b) => b.id != buildId).toList();
      state = state.copyWith(savedBuilds: updatedBuilds, error: null);
      print('INFO: Build deleted successfully');
    } catch (e) {
      print('ERROR: Failed to delete build: $e');
      state = state.copyWith(
        error: 'Failed to delete build: ${e.toString()}',
      );
    }
  }

  void loadBuildForEdit(BuildConfiguration build) {
    state = state.copyWith(currentBuild: build);
  }
}