package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.UniversityModel;
import java.util.List;

public interface IUniversityDAO {
    List<UniversityModel> findAll();
    UniversityModel findById(int idUniversity);
}
