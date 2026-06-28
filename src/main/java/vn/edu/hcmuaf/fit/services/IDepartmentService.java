package vn.edu.hcmuaf.fit.services;

import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.DepartmentModel;
import vn.edu.hcmuaf.fit.model.UniversityModel;
import java.util.List;

public interface IDepartmentService {
    // Trường
    List<UniversityModel> findAllUniversities();
    UniversityModel findUniversityById(int idUniversity);

    // Khoa
    List<DepartmentModel> findAllDepartments();
    DepartmentModel findDepartmentById(int idDepartment);
    List<DepartmentModel> findDepartmentsByUniversity(int idUniversity);

    // Sách
    // idUniversity=0 & idDepartment=0  → tất cả sách giáo trình
    // idUniversity>0 & idDepartment=0  → theo trường
    // idDepartment>0                   → theo khoa
    List<BookModel> findBooks(int idUniversity, int idDepartment);
}
