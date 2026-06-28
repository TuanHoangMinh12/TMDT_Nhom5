package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.DepartmentModel;
import java.util.List;

public interface IDepartmentDAO {
    List<DepartmentModel> findAll();
    DepartmentModel findById(int idDepartment);
    List<DepartmentModel> findByUniversity(int idUniversity);
    List<BookModel> findBooks(int idUniversity, int idDepartment);
}
