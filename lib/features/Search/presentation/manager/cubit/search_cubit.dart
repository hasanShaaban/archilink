import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void toggleAccountTypeFocus() {
    final shouldFocus = !state.focusedOnAccountType;
    emit(
      state.copyWith(
        focusedOnAccountType: shouldFocus,
        focusedOnServices: false,
        focusedOnLocation: false,
      ),
    );
  }

  void toggleServicesFocus() {
    final shouldFocus = !state.focusedOnServices;
    emit(
      state.copyWith(
        focusedOnServices: shouldFocus,
        focusedOnAccountType: false,
        focusedOnLocation: false,
      ),
    );
  }

  void toggleLocationFocus() {
    final shouldFocus = !state.focusedOnLocation;
    emit(
      state.copyWith(
        focusedOnLocation: shouldFocus,
        focusedOnAccountType: false,
        focusedOnServices: false,
      ),
    );
  }

  void selectAccountType(String accountType) {
    if (!SearchState.accountTypeOptions.contains(accountType)) return;
    final nextSelection = state.selectedAccountType == accountType
        ? ''
        : accountType;
    emit(state.copyWith(selectedAccountType: nextSelection));
  }

  void selectLocation(String location) {
    if (!SearchState.locationOptions.contains(location)) return;
    final nextSelection = state.selectedLocation == location ? '' : location;
    emit(state.copyWith(selectedLocation: nextSelection));
  }

  void toggleServiceSelection(String service) {
    if (!SearchState.serviceOptions.contains(service)) return;
    final updated = List<String>.from(state.selectedServices);
    if (updated.contains(service)) {
      updated.remove(service);
    } else {
      updated.add(service);
    }
    emit(state.copyWith(selectedServices: updated));
  }

  void toggleTagSelection(String tag) {
    if (!SearchState.suggestedTags.contains(tag)) return;
    final updated = List<String>.from(state.selectedTags);
    if (updated.contains(tag)) {
      updated.remove(tag);
    } else {
      updated.add(tag);
    }
    emit(state.copyWith(selectedTags: updated));
  }

  void updateQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void clearQuery() {
    emit(state.copyWith(query: ''));
  }
}
