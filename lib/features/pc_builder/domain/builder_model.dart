// lib/features/pc_builder/domain/builder_model.dart

enum ComponentType {
  cpu,
  gpu,
  motherboard,
  ram,
  storage,
  cooling,
  psu,
  pcCase,  // Renamed from 'case'
}

enum CpuBrand { intel, amd }

class Component {
  final String id;
  final String name;
  final String description;
  final double price;
  final ComponentType type;
  final CpuBrand? brand;
  final String? imageUrl;
  final Map<String, String>? specs;

  const Component({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    this.brand,
    this.imageUrl,
    this.specs,
  });
}

class BuildConfiguration {
  final String id;
  final String name;
  final DateTime createdAt;
  final Component? cpu;
  final Component? gpu;
  final Component? motherboard;
  final Component? ram;
  final Component? storage;
  final Component? cooling;
  final Component? psu;
  final Component? pcCase;

  const BuildConfiguration({
    required this.id,
    required this.name,
    required this.createdAt,
    this.cpu,
    this.gpu,
    this.motherboard,
    this.ram,
    this.storage,
    this.cooling,
    this.psu,
    this.pcCase,
  });

  double get totalPrice {
    double total = 0;
    if (cpu != null) total += cpu!.price;
    if (gpu != null) total += gpu!.price;
    if (motherboard != null) total += motherboard!.price;
    if (ram != null) total += ram!.price;
    if (storage != null) total += storage!.price;
    if (cooling != null) total += cooling!.price;
    if (psu != null) total += psu!.price;
    if (pcCase != null) total += pcCase!.price;
    return total;
  }

  int get completedComponents {
    int count = 0;
    if (cpu != null) count++;
    if (gpu != null) count++;
    if (motherboard != null) count++;
    if (ram != null) count++;
    if (storage != null) count++;
    if (cooling != null) count++;
    if (psu != null) count++;
    if (pcCase != null) count++;
    return count;
  }

  BuildConfiguration copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    Component? cpu,
    Component? gpu,
    Component? motherboard,
    Component? ram,
    Component? storage,
    Component? cooling,
    Component? psu,
    Component? pcCase,
  }) {
    return BuildConfiguration(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      cpu: cpu ?? this.cpu,
      gpu: gpu ?? this.gpu,
      motherboard: motherboard ?? this.motherboard,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      cooling: cooling ?? this.cooling,
      psu: psu ?? this.psu,
      pcCase: pcCase ?? this.pcCase,
    );
  }

  Map<String, dynamic> toDbJson() {
    return {
      'build_id': id,
      'name': name,
      'created_at': createdAt.millisecondsSinceEpoch,
      'cpu_id': cpu?.id,
      'gpu_id': gpu?.id,
      'motherboard_id': motherboard?.id,
      'ram_id': ram?.id,
      'storage_id': storage?.id,
      'cooling_id': cooling?.id,
      'psu_id': psu?.id,
      'case_id': pcCase?.id,
    };
  }

  factory BuildConfiguration.fromDbJson(Map<String, dynamic> json) {
    return BuildConfiguration(
      id: json['build_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Build',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int? ?? 0),
      cpu: null, // Load separately if needed
      gpu: null,
      motherboard: null,
      ram: null,
      storage: null,
      cooling: null,
      psu: null,
      pcCase: null,
    );
  }
}

class BuilderState {
  final BuildConfiguration? currentBuild;
  final List<BuildConfiguration> savedBuilds;
  final bool isLoading;
  final String? error;
  final ComponentType? selectingComponentType;

  const BuilderState({
    this.currentBuild,
    this.savedBuilds = const [],
    this.isLoading = false,
    this.error,
    this.selectingComponentType,
  });

  BuilderState copyWith({
    BuildConfiguration? currentBuild,
    List<BuildConfiguration>? savedBuilds,
    bool? isLoading,
    String? error,
    ComponentType? selectingComponentType,
  }) {
    return BuilderState(
      currentBuild: currentBuild ?? this.currentBuild,
      savedBuilds: savedBuilds ?? this.savedBuilds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectingComponentType: selectingComponentType ?? this.selectingComponentType,
    );
  }
}