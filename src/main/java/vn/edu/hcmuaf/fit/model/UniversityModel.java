package vn.edu.hcmuaf.fit.model;

public class UniversityModel extends AbstractModel<UniversityModel> {
    private int idUniversity;
    private String name;
    private String shortName;
    private String address;

    public UniversityModel() {}

    public int getIdUniversity() { return idUniversity; }
    public void setIdUniversity(int idUniversity) { this.idUniversity = idUniversity; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getShortName() { return shortName; }
    public void setShortName(String shortName) { this.shortName = shortName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
 