part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyCreated extends CompanyState {
  final Company company;

  const CompanyCreated(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyLoaded extends CompanyState {
  final Company company;

  const CompanyLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyBySecretLoaded extends CompanyState {
  final Company? company;

  const CompanyBySecretLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);

  @override
  List<Object?> get props => [message];
}
