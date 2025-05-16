// lib/features/company/presentation/bloc/company_event.dart

part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object?> get props => [];
}

class CreateCompanyEvent extends CompanyEvent {
  final Company company;

  const CreateCompanyEvent(this.company);

  @override
  List<Object?> get props => [company];
}

class GetCompanyByIdEvent extends CompanyEvent {
  final String id;

  const GetCompanyByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetCompanyBySecretEvent extends CompanyEvent {
  final String secret;

  const GetCompanyBySecretEvent(this.secret);

  @override
  List<Object?> get props => [secret];
}

class UpdateCompanyEvent extends CompanyEvent {
  final Company company;

  const UpdateCompanyEvent(this.company);

  @override
  List<Object?> get props => [company];
}

class ResetCompanyStateEvent extends CompanyEvent {}
