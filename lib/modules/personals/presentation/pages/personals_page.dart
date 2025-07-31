import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/stats_header.dart';
import '../../../../core/providers/providers.dart';
import '../controllers/personal_controller.dart';
import '../pages/personal_card.dart';
import '../pages/personal_details_page.dart';
import '../pages/my_appointments_page.dart';
import '../../domain/entities/personal.dart';

class PersonalsPage extends ConsumerStatefulWidget {
  const PersonalsPage({super.key});

  @override
  ConsumerState<PersonalsPage> createState() => _PersonalsPageState();
}

class _PersonalsPageState extends ConsumerState<PersonalsPage> {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  String _selectedSpecialty = 'Todos';

  final List<String> _specialties = [
    'Todos',
    'Emagrecimento',
    'Hipertrofia',
    'Funcional',
    'Musculação',
    'Treinamento Online'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(personalControllerProvider.notifier).loadPersonals();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await ref.read(personalControllerProvider.notifier).loadPersonals();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(personalControllerProvider);
    final controller = ref.read(personalControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('PersonalFit'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyAppointmentsPage(),
                ),
              );
            },
          ),
        ]
            .animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.3, duration: 600.ms),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de pesquisa e filtros
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Campo de pesquisa
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textLight),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar personais...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _selectedSpecialty = 'Todos';
                                });
                                ref.read(personalControllerProvider.notifier).searchPersonals('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      // Limpar seleção de filtro quando buscar
                      if (value.isNotEmpty && _selectedSpecialty != 'Todos') {
                        setState(() {
                          _selectedSpecialty = 'Todos';
                        });
                      }
                      ref.read(personalControllerProvider.notifier).searchPersonals(value);
                    },
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.3, duration: 400.ms),
                
                const SizedBox(height: 8),
                
                // Chips de especialidade
                SizedBox(
                  height: 32,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._specialties.map((specialty) {
                        final isSelected = _selectedSpecialty == specialty;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSpecialty = specialty;
                              });
                              // Se selecionar "Todos", passar string vazia para mostrar todos
                              final filterValue = specialty == 'Todos' ? '' : specialty;
                              ref.read(personalControllerProvider.notifier).filterBySpecialty(filterValue);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primary 
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected 
                                      ? AppColors.primary 
                                      : AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                specialty,
                                style: TextStyle(
                                  color: isSelected 
                                      ? Colors.white 
                                      : AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 400.ms)
                    .slideX(begin: 0.3, duration: 400.ms, delay: 400.ms),
              ],
            ),
          ),
          
          // Lista de personais
          Expanded(
            child: state.isLoading
                ? _buildLoadingList()
                : state.error != null
                    ? _buildErrorWidget(state.error!, controller)
                    : state.filteredPersonals.isEmpty
                        ? _buildEmptyWidget()
                        : _buildPersonalsList(state.filteredPersonals, state.personals),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: const ShimmerCard(),
        );
      },
    );
  }

  Widget _buildErrorWidget(String error, PersonalController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 24),
            
            Text(
              'Erro ao carregar personais',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms),
            
            const SizedBox(height: 8),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),
            
            const SizedBox(height: 24),
            
            ElevatedButton.icon(
              onPressed: () {
                controller.clearError();
                controller.loadPersonals();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 600.ms)
                .slideY(begin: 0.3, duration: 400.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.textLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.textLight,
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 24),
            
            Text(
              AppConstants.noPersonalsMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms),
            
            const SizedBox(height: 8),
            
            Text(
              'Tente ajustar os filtros ou a busca',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalsList(List<Personal> filteredPersonals, List<Personal> allPersonals) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      header: const WaterDropHeader(),
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 4,
        ),
        children: [
          // Header com estatísticas - apenas quando "Todos" estiver selecionado
          if (_selectedSpecialty == 'Todos')
            StatsHeader(
              totalPersonals: allPersonals.length,
              availablePersonals: allPersonals.where((p) => p.rating >= 4.0).length,
              averageRating: allPersonals.isNotEmpty 
                  ? allPersonals.map((p) => p.rating).reduce((a, b) => a + b) / allPersonals.length
                  : 0.0,
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.2, duration: 300.ms),
          
          // Lista de personais
          ...filteredPersonals.map((personal) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PersonalCard(
              personal: personal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalDetailsPage(personal: personal),
                  ),
                );
              },
              onFavorite: () {
                // Implementar favoritar
              },
              isFavorite: false,
            ),
          )).toList(),
        ],
      ),
    );
  }
} 