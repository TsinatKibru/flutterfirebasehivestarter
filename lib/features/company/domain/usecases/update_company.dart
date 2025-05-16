import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/repositories/company_repository.dart';

class UpdateCompany {
  final CompanyRepository repository;

  UpdateCompany(this.repository);

  Future<void> call(Company company) async {
    return repository.updateCompany(company);
  }
}
