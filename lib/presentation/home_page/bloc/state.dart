import 'package:equatable/equatable.dart';
import '../../../domain/quote.dart';
import '../home_page.dart';

class HomeState extends Equatable {
  final Future<List<Quote>>? data;

  const HomeState({this.data});

  HomeState copyWith({Future<List<Quote>>? data}) => HomeState(data: data ?? this.data);

  @override
  List<Object?> get props => [data];
}
