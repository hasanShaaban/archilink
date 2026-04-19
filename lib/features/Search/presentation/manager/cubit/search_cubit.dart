import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void updateQuery(String query) {
    emit(state.copyWith(query: query));
  }

  void clearQuery() {
    emit(state.copyWith(query: ''));
  }
}
