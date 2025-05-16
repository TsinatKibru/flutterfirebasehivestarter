import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/usecases/create_company.dart';
import 'package:stockpro/features/company/domain/usecases/get_company_by_id.dart';
import 'package:stockpro/features/company/domain/usecases/get_company_by_secret.dart';
import 'package:stockpro/features/company/domain/usecases/update_company.dart';
part 'company_event.dart';
part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CreateCompany createCompany;
  final GetCompanyById getCompanyById;
  final GetCompanyBySecret getCompanyBySecret;
  final UpdateCompany updateCompany;

  CompanyBloc({
    required this.createCompany,
    required this.getCompanyById,
    required this.getCompanyBySecret,
    required this.updateCompany,
  }) : super(CompanyInitial()) {
    on<CreateCompanyEvent>(_onCreateCompany);
    on<GetCompanyByIdEvent>(_onGetCompanyById);
    on<GetCompanyBySecretEvent>(_onGetCompanyBySecret);
    on<ResetCompanyStateEvent>(_onResetState);
    on<UpdateCompanyEvent>(_onUpdateCompany);
  }

  Future<void> _onCreateCompany(
    CreateCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    print("_onCreateCompany: ");
    emit(CompanyLoading());
    try {
      await createCompany(event.company);
      emit(CompanyCreated(event.company)); // Emit Created State
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  Future<void> _onUpdateCompany(
    UpdateCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    try {
      await updateCompany(event.company);
      // emit(CompanyLoaded(event.company)); // Emit Created State
      add(GetCompanyByIdEvent(event.company.id));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  // Future<void> _onGetCompanyById(
  //   GetCompanyByIdEvent event,
  //   Emitter<CompanyState> emit,
  // ) async {
  //   if (event.id == "") {
  //     emit(const CompanyError(" "));
  //     return; // Important to return here to prevent further execution
  //   }

  //   emit(CompanyLoading());
  //   try {
  //     final company = await getCompanyById(event.id);
  //     emit(CompanyLoaded(company));
  //   } catch (e) {
  //     emit(CompanyError(e.toString()));
  //   }
  // }
  Future<void> _onGetCompanyById(
    GetCompanyByIdEvent event,
    Emitter<CompanyState> emit,
  ) async {
    if (event.id.isEmpty) {
      emit(const CompanyError(" "));
      return;
    }

    emit(CompanyLoading());
    await emit.forEach<Company>(
      getCompanyById(event.id),
      onData: (company) => CompanyLoaded(company),
      onError: (error, _) => CompanyError(error.toString()),
    );
  }

  Future<void> _onGetCompanyBySecret(
    GetCompanyBySecretEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    try {
      final company = await getCompanyBySecret(event.secret);
      emit(CompanyBySecretLoaded(company));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  void _onResetState(
    ResetCompanyStateEvent event,
    Emitter<CompanyState> emit,
  ) {
    emit(CompanyInitial()); // Emit the initial state
  }
}
