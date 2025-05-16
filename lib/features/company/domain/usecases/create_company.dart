import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/repositories/company_repository.dart';

class CreateCompany {
  final CompanyRepository repository;

  CreateCompany(this.repository);

  Future<void> call(Company company) async {
    return repository.createCompany(company);
  }
}
