package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IUniversityDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.UniversityModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UniversityDAO implements IUniversityDAO {

    @Override
    public List<UniversityModel> findAll() {
        List<UniversityModel> results = new ArrayList<>();
        String sql = "SELECT id_university, name, short_name, address FROM university ORDER BY name";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) results.add(map(rs));
                return results;
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }

    @Override
    public UniversityModel findById(int idUniversity) {
        String sql = "SELECT id_university, name, short_name, address FROM university WHERE id_university = ?";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idUniversity);
                rs = ps.executeQuery();
                if (rs.next()) return map(rs);
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }

    private UniversityModel map(ResultSet rs) throws SQLException {
        UniversityModel m = new UniversityModel();
        m.setIdUniversity(rs.getInt("id_university"));
        m.setName(rs.getString("name"));
        m.setShortName(rs.getString("short_name"));
        m.setAddress(rs.getString("address"));
        return m;
    }

    private void closeAll(Connection c, PreparedStatement s, ResultSet r) {
        try {
            if (c != null) c.close();
            if (s != null) s.close();
            if (r != null) r.close();
        } catch (SQLException ignored) {}
    }
}