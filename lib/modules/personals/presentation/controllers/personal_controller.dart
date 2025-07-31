import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/personal.dart';
import '../../domain/entities/contact_interest.dart';
import '../../domain/repositories/personal_repository.dart';

class PersonalController extends StateNotifier<PersonalState> {
  final PersonalRepository _repository;

  PersonalController(this._repository) : super(PersonalState.initial());

  Future<void> loadPersonals() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final personals = await _repository.getPersonals();
      state = state.copyWith(
        personals: personals,
        filteredPersonals: personals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void searchPersonals(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(filteredPersonals: state.personals);
      return;
    }

    state = state.copyWith(isLoading: true);
    
    try {
      final filteredPersonals = await _repository.searchPersonals(query);
      state = state.copyWith(
        filteredPersonals: filteredPersonals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void filterBySpecialty(String specialty) async {
    if (specialty.isEmpty) {
      state = state.copyWith(filteredPersonals: state.personals);
      return;
    }

    state = state.copyWith(isLoading: true);
    
    try {
      final filteredPersonals = await _repository.filterPersonalsBySpecialty(specialty);
      state = state.copyWith(
        filteredPersonals: filteredPersonals,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> sendContactInterest(ContactInterest contactInterest) async {
    state = state.copyWith(isSendingInterest: true);
    
    try {
      await _repository.sendContactInterest(contactInterest);
      state = state.copyWith(
        isSendingInterest: false,
        interestSent: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isSendingInterest: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void resetInterestSent() {
    state = state.copyWith(interestSent: false);
  }

  // Atualizar a nota de um personal específico
  void updatePersonalRating(String personalId, double newRating) {
    final updatedPersonals = state.personals.map((personal) {
      if (personal.id == personalId) {
        return personal.copyWith(rating: newRating);
      }
      return personal;
    }).toList();

    final updatedFilteredPersonals = state.filteredPersonals.map((personal) {
      if (personal.id == personalId) {
        return personal.copyWith(rating: newRating);
      }
      return personal;
    }).toList();

    state = state.copyWith(
      personals: updatedPersonals.cast<Personal>(),
      filteredPersonals: updatedFilteredPersonals.cast<Personal>(),
    );
  }
}

class PersonalState {
  final List<Personal> personals;
  final List<Personal> filteredPersonals;
  final bool isLoading;
  final bool isSendingInterest;
  final bool interestSent;
  final String? error;

  const PersonalState({
    required this.personals,
    required this.filteredPersonals,
    required this.isLoading,
    required this.isSendingInterest,
    required this.interestSent,
    this.error,
  });

  factory PersonalState.initial() {
    return const PersonalState(
      personals: [],
      filteredPersonals: [],
      isLoading: false,
      isSendingInterest: false,
      interestSent: false,
    );
  }

  PersonalState copyWith({
    List<Personal>? personals,
    List<Personal>? filteredPersonals,
    bool? isLoading,
    bool? isSendingInterest,
    bool? interestSent,
    String? error,
  }) {
    return PersonalState(
      personals: personals ?? this.personals,
      filteredPersonals: filteredPersonals ?? this.filteredPersonals,
      isLoading: isLoading ?? this.isLoading,
      isSendingInterest: isSendingInterest ?? this.isSendingInterest,
      interestSent: interestSent ?? this.interestSent,
      error: error,
    );
  }
} 