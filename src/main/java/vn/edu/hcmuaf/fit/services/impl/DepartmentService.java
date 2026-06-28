package vn.edu.hcmuaf.fit.services.impl;

import vn.edu.hcmuaf.fit.dao.IDepartmentDAO;
import vn.edu.hcmuaf.fit.dao.IUniversityDAO;
import vn.edu.hcmuaf.fit.dao.impl.DepartmentDAO;
import vn.edu.hcmuaf.fit.dao.impl.UniversityDAO;
import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.DepartmentModel;
import vn.edu.hcmuaf.fit.model.UniversityModel;
import vn.edu.hcmuaf.fit.services.IDepartmentService;
import java.util.List;

public class DepartmentService implements IDepartmentService {

    IUniversityDAO  iUniversityDAO  = new UniversityDAO();
    IDepartmentDAO  iDepartmentDAO  = new DepartmentDAO();

    @Override
    public List<UniversityModel> findAllUniversities() {
        return iUniversityDAO.findAll();
    }

    @Override
    public UniversityModel findUniversityById(int idUniversity) {
        return iUniversityDAO.findById(idUniversity);
    }

    @Override
    public List<DepartmentModel> findAllDepartments() {
        return iDepartmentDAO.findAll();
    }

    @Override
    public DepartmentModel findDepartmentById(int idDepartment) {
        return iDepartmentDAO.findById(idDepartment);
    }

    @Override
    public List<DepartmentModel> findDepartmentsByUniversity(int idUniversity) {
        return iDepartmentDAO.findByUniversity(idUniversity);
    }

    @Override
    public List<BookModel> findBooks(int idUniversity, int idDepartment) {
        return iDepartmentDAO.findBooks(idUniversity, idDepartment);
    }
}