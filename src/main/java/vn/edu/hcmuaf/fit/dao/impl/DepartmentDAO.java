package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IDepartmentDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.DepartmentModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO implements IDepartmentDAO {

    // Lấy khoa
    @Override
    public List<DepartmentModel> findAll() {
        List<DepartmentModel> results = new ArrayList<>();
        String sql = "SELECT d.id_department, d.name, d.id_university, " +
                "u.name AS university_name, u.short_name " +
                "FROM department d " +
                "LEFT JOIN university u ON d.id_university = u.id_university " +
                "ORDER BY u.name, d.name";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) results.add(mapDept(rs));
                return results;
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }
    // Lấy 1 khoa theo id
    @Override
    public DepartmentModel findById(int idDepartment) {
        String sql = "SELECT d.id_department, d.name, d.id_university, " +
                "u.name AS university_name, u.short_name " +
                "FROM department d " +
                "LEFT JOIN university u ON d.id_university = u.id_university " +
                "WHERE d.id_department = ?";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idDepartment);
                rs = ps.executeQuery();
                if (rs.next()) return mapDept(rs);
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }

    // Lấy danh sách khoa theo trường
    @Override
    public List<DepartmentModel> findByUniversity(int idUniversity) {
        List<DepartmentModel> results = new ArrayList<>();
        String sql = "SELECT d.id_department, d.name, d.id_university, " +
                "u.name AS university_name, u.short_name " +
                "FROM department d " +
                "LEFT JOIN university u ON d.id_university = u.id_university " +
                "WHERE d.id_university = ? " +
                "ORDER BY d.name";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idUniversity);
                rs = ps.executeQuery();
                while (rs.next()) results.add(mapDept(rs));
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
    public List<BookModel> findBooks(int idUniversity, int idDepartment) {
        List<BookModel> listBook = new ArrayList<>();
        String sql;

        if (idDepartment > 0) {
            sql = "SELECT DISTINCT b.id_book, b.name, a.name, " +
                    "b.price - b.price * b.discount_price AS giagiam, " +
                    "b.price, b.discount_price * 100 AS giam, " +
                    "IF(v_rate.`start` IS NULL, 0, v_rate.`start`) AS `start`, " +
                    "IF(v_comment.sl_comment IS NULL, 0, v_comment.sl_comment) AS sl_comment, " +
                    "b.id_pc, b.id_p, db2.note " +
                    "FROM book b " +
                    "INNER JOIN department_book db2 ON b.id_book = db2.id_book " +
                    "LEFT JOIN author a ON b.id_author = a.id_author " +
                    "LEFT JOIN v_rate ON b.id_book = v_rate.id_book " +
                    "LEFT JOIN v_comment ON b.id_book = v_comment.id_book " +
                    "WHERE db2.id_department = ? AND b.isActive = 1";
        } else if (idUniversity > 0) {
            sql = "SELECT DISTINCT b.id_book, b.name, a.name, " +
                    "b.price - b.price * b.discount_price AS giagiam, " +
                    "b.price, b.discount_price * 100 AS giam, " +
                    "IF(v_rate.`start` IS NULL, 0, v_rate.`start`) AS `start`, " +
                    "IF(v_comment.sl_comment IS NULL, 0, v_comment.sl_comment) AS sl_comment, " +
                    "b.id_pc, b.id_p, NULL AS note " +
                    "FROM book b " +
                    "INNER JOIN department_book db2 ON b.id_book = db2.id_book " +
                    "INNER JOIN department d ON db2.id_department = d.id_department " +
                    "LEFT JOIN author a ON b.id_author = a.id_author " +
                    "LEFT JOIN v_rate ON b.id_book = v_rate.id_book " +
                    "LEFT JOIN v_comment ON b.id_book = v_comment.id_book " +
                    "WHERE d.id_university = ? AND b.isActive = 1";
        } else {
            sql = "SELECT DISTINCT b.id_book, b.name, a.name, " +
                    "b.price - b.price * b.discount_price AS giagiam, " +
                    "b.price, b.discount_price * 100 AS giam, " +
                    "IF(v_rate.`start` IS NULL, 0, v_rate.`start`) AS `start`, " +
                    "IF(v_comment.sl_comment IS NULL, 0, v_comment.sl_comment) AS sl_comment, " +
                    "b.id_pc, b.id_p, NULL AS note " +
                    "FROM book b " +
                    "INNER JOIN department_book db2 ON b.id_book = db2.id_book " +
                    "LEFT JOIN author a ON b.id_author = a.id_author " +
                    "LEFT JOIN v_rate ON b.id_book = v_rate.id_book " +
                    "LEFT JOIN v_comment ON b.id_book = v_comment.id_book " +
                    "WHERE b.id_catalog = 12 AND b.isActive = 1";
        }

        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                if (idDepartment > 0) {
                    ps.setInt(1, idDepartment);
                } else if (idUniversity > 0) {
                    ps.setInt(1, idUniversity);
                }
                rs = ps.executeQuery();
                while (rs.next()) listBook.add(mapBook(rs));
                return listBook;
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }

    private DepartmentModel mapDept(ResultSet rs) throws SQLException {
        DepartmentModel m = new DepartmentModel();
        m.setIdDepartment(rs.getInt("id_department"));
        m.setName(rs.getString("name"));
        m.setIdUniversity(rs.getInt("id_university"));
        m.setUniversityName(rs.getString("university_name"));
        m.setUniversityShortName(rs.getString("short_name"));
        return m;
    }

    private BookModel mapBook(ResultSet rs) throws SQLException {
        BookModel b = new BookModel();
        b.setIdBook(rs.getInt(1));
        b.setName(rs.getString(2));
        b.setNameAuthor(rs.getString(3));
        b.setPriceDiscount(rs.getDouble(4));
        b.setPrice(rs.getDouble(5));
        b.setDiscount(rs.getInt(6));
        b.setQuantityStart(rs.getInt(7));
        b.setQuantityComment(rs.getInt(8));
        b.setIdCP(rs.getString(9));
        b.setIdP(rs.getString(10));
        b.setCatalog(rs.getString(11));
        b.setImage(findImageById(b.getIdBook()));
        return b;
    }


    private String findImageById(int idBook) {
        String sql = "SELECT image FROM image_book WHERE id_book = ? LIMIT 1";
        Connection conn = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        if (conn != null) {
            try {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idBook);
                rs = ps.executeQuery();
                if (rs.next()) return rs.getString("image");
            } catch (SQLException e) {
                return null;
            } finally {
                closeAll(conn, ps, rs);
            }
        }
        return null;
    }

    private void closeAll(Connection c, PreparedStatement s, ResultSet r) {
        try {
            if (c != null) c.close();
            if (s != null) s.close();
            if (r != null) r.close();
        } catch (SQLException ignored) {}
    }
}