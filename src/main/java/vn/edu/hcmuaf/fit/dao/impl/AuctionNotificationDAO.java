package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IAuctionNotificationDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionNotificationModel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuctionNotificationDAO implements IAuctionNotificationDAO {

    // PHẦN 6 - THÔNG BÁO CHO USER (đọc thông báo của mình)

    // Thêm thông báo mới
    @Override
    public int sendNotification(int userId, int auctionId, String title, String content) {
        String sql = "INSERT INTO auction_notifications (user_id, auction_id, title, content) VALUES (?, ?, ?, ?)";
        try (Connection con = JDBCConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, auctionId);
            ps.setString(3, title);
            ps.setString(4, content);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Đếm số thông báo CHƯA ĐỌC của một user.
     * Dùng để hiển thị badge đỏ trên icon thông báo.
     */
    @Override
    public int countUnreadNotifications(int userId) {
        String sql = "SELECT COUNT(*) FROM auction_notifications WHERE user_id=? AND is_read=0";
        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return 0;
    }

    /**
     * Lấy tất cả thông báo của một user (mới nhất lên đầu).
     */
    @Override
    public List<AuctionNotificationModel> getNotificationsByUser(int userId) {
        List<AuctionNotificationModel> list = new ArrayList<>();
        String sql = "SELECT n.*, CONCAT(c.first_name,' ',c.last_name) AS user_name " +
                "FROM auction_notifications n " +
                "JOIN customer c ON n.user_id = c.id_user " +
                "WHERE n.user_id = ? " +
                "ORDER BY n.created_at DESC";
        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                AuctionNotificationModel n = new AuctionNotificationModel();
                n.setId(rs.getInt("id"));
                n.setUserId(rs.getInt("user_id"));
                n.setAuctionId(rs.getInt("auction_id"));
                n.setTitle(rs.getString("title"));
                n.setContent(rs.getString("content"));
                n.setIsRead(rs.getInt("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                n.setUserName(rs.getString("user_name"));
                list.add(n);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return list;
    }

    /**
     * Đánh dấu đã đọc một thông báo.
     */
    @Override
    public int markNotificationRead(int notificationId, int userId) {
        // Thêm AND user_id=? để tránh user khác đọc thông báo của mình
        String sql = "UPDATE auction_notifications SET is_read=1 WHERE id=? AND user_id=?";
        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            closeAll(con, ps, null);
        }
    }

    /** Đóng Connection, PreparedStatement, ResultSet an toàn */
    private void closeAll(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs  != null) rs.close();
            if (ps  != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
