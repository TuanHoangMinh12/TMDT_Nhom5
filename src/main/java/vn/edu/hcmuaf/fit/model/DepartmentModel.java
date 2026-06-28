package vn.edu.hcmuaf.fit.model;

public class DepartmentModel extends AbstractModel<DepartmentModel> {
    private int idDepartment;
    private String name;
    private int idUniversity;

    // Lấy thêm tên trường khi JOIN
    private String universityName;
    private String universityShortName;

    public DepartmentModel() {}

    public int getIdDepartment() { return idDepartment; }
    public void setIdDepartment(int idDepartment) { this.idDepartment = idDepartment; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getIdUniversity() { return idUniversity; }
    public void setIdUniversity(int idUniversity) { this.idUniversity = idUniversity; }

    public String getUniversityName() { return universityName; }
    public void setUniversityName(String universityName) { this.universityName = universityName; }

    public String getUniversityShortName() { return universityShortName; }
    public void setUniversityShortName(String universityShortName) { this.universityShortName = universityShortName; }
}