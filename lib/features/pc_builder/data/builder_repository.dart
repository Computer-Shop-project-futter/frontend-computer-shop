// lib/features/builder/data/builder_repository.dart

import '../domain/builder_model.dart';

class BuilderRepository {
  // Mock components database
  static const List<Component> _mockComponents = [
    // Intel CPUs
    Component(
      id: 'cpu_1',
      name: 'Core i9-14900K',
      description: '24 Cores, 6.0GHz Max',
      price: 589.00,
      type: ComponentType.cpu,
      brand: CpuBrand.intel,
      specs: {'Cores': '24', 'Threads': '32', 'Max Boost': '6.0GHz'},
    ),
    Component(
      id: 'cpu_2',
      name: 'Ryzen 9 7950X3D',
      description: '16 Cores, 5.7GHz',
      price: 699.00,
      type: ComponentType.cpu,
      brand: CpuBrand.amd,
      specs: {'Cores': '16', 'Threads': '32', 'Cache': '128MB'},
    ),
    Component(
      id: 'cpu_3',
      name: 'Core i7-14700K',
      description: '20 Cores, 5.6GHz',
      price: 401.00,
      type: ComponentType.cpu,
      brand: CpuBrand.intel,
      specs: {'Cores': '20', 'Threads': '28', 'Max Boost': '5.6GHz'},
    ),
    Component(
      id: 'cpu_4',
      name: 'Ryzen 7 7800X3D',
      description: '8 Cores, 5.0GHz',
      price: 349.00,
      type: ComponentType.cpu,
      brand: CpuBrand.amd,
      specs: {'Cores': '8', 'Threads': '16', 'Cache': '96MB'},
    ),
    Component(
      id: 'cpu_5',
      name: 'Core i5-13600K',
      description: '14 Cores, 5.1GHz',
      price: 283.00,
      type: ComponentType.cpu,
      brand: CpuBrand.intel,
      specs: {'Cores': '14', 'Threads': '20', 'Max Boost': '5.1GHz'},
    ),
    
    // GPUs
    Component(
      id: 'gpu_1',
      name: 'Visionary RTX 4080',
      description: '16GB GDDR6X, 4K Gaming',
      price: 1199.00,
      type: ComponentType.gpu,
    ),
    Component(
      id: 'gpu_2',
      name: 'Visionary RTX 4070 Ti',
      description: '12GB GDDR6X, 1440p Gaming',
      price: 799.00,
      type: ComponentType.gpu,
    ),
    
    // Storage
    Component(
      id: 'storage_1',
      name: 'SwiftDrive 2TB',
      description: 'NVMe Gen4, 7000MB/s',
      price: 251.00,
      type: ComponentType.storage,
    ),
    Component(
      id: 'storage_2',
      name: 'SwiftDrive 1TB',
      description: 'NVMe Gen4, 5000MB/s',
      price: 129.00,
      type: ComponentType.storage,
    ),
  ];

  Future<List<Component>> getComponentsByType(ComponentType type, {CpuBrand? brand}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    var components = _mockComponents.where((c) => c.type == type).toList();
    
    if (brand != null && type == ComponentType.cpu) {
      components = components.where((c) => c.brand == brand).toList();
    }
    
    return components;
  }

  Future<List<BuildConfiguration>> getSavedBuilds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      BuildConfiguration(
        id: 'build_1',
        name: 'STEALTH WORKSTATION V2',
        createdAt: DateTime(2023, 12, 24),
        cpu: _mockComponents.firstWhere((c) => c.id == 'cpu_1'),
        gpu: _mockComponents.firstWhere((c) => c.id == 'gpu_1'),
        storage: _mockComponents.firstWhere((c) => c.id == 'storage_1'),
      ),
      BuildConfiguration(
        id: 'build_2',
        name: 'BUDGET GAMING TIER 1',
        createdAt: DateTime(2023, 9, 12),
        cpu: _mockComponents.firstWhere((c) => c.id == 'cpu_5'),
        gpu: _mockComponents.firstWhere((c) => c.id == 'gpu_2'),
        storage: _mockComponents.firstWhere((c) => c.id == 'storage_2'),
      ),
    ];
  }

  Future<BuildConfiguration> saveBuild(BuildConfiguration build) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return build;
  }

  Future<void> deleteBuild(String buildId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}