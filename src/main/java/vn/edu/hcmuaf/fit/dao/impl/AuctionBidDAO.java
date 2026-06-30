package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IAuctionBidDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuctionBidDAO implements IAuctionBidDAO {

    // ===========================
    // Thêm lượt đấu giá
    // ===========================
    @Override
    public boolean insertBid(AuctionBidModel bid) {

        String sql =
                "INSERT INTO auction_bid(auction_id,user_id,bid_price) VALUES(?,?,?)";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, bid.getAuctionId());
            ps.setInt(2, bid.getUserId());
            ps.setDouble(3, bid.getBidPrice());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    // Lịch sử đấu giá
    @Override
    public List<AuctionBidModel> findByAuctionId(int auctionId) {

        List<AuctionBidModel> list = new ArrayList<>();

        String sql =
                "SELECT ab.id,ab.auction_id,ab.user_id," +
                        "ab.bid_price,ab.bid_time," +
                        "c.first_name,c.last_name " +
                        "FROM auction_bid ab " +
                        "INNER JOIN customer c " +
                        "ON ab.user_id=c.id_user " +
                        "WHERE ab.auction_id=? " +
                        "ORDER BY ab.bid_time DESC";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, auctionId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                AuctionBidModel bid = new AuctionBidModel();

                bid.setId(rs.getInt("id"));
                bid.setAuctionId(rs.getInt("auction_id"));
                bid.setUserId(rs.getInt("user_id"));
                bid.setBidPrice(rs.getDouble("bid_price"));
                bid.setBidTime(rs.getTimestamp("bid_time"));

                CustomerModel customer = new CustomerModel();
                customer.setIdUser(rs.getInt("user_id"));
                customer.setFirstName(rs.getString("first_name"));
                customer.setLastName(rs.getString("last_name"));

                bid.setCustomer(customer);

                list.add(bid);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // Giá cao nhất
    @Override
    public AuctionBidModel findHighestBid(int auctionId) {

        String sql =
                "SELECT * FROM auction_bid " +
                        "WHERE auction_id=? " +
                        "ORDER BY bid_price DESC, bid_time ASC " +
                        "LIMIT 1";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, auctionId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                AuctionBidModel bid = new AuctionBidModel();

                bid.setId(rs.getInt("id"));
                bid.setAuctionId(rs.getInt("auction_id"));
                bid.setUserId(rs.getInt("user_id"));
                bid.setBidPrice(rs.getDouble("bid_price"));
                bid.setBidTime(rs.getTimestamp("bid_time"));

                return bid;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ===========================
    // Danh sách đấu giá của user
    // ===========================
    // Lấy các lượt đấu giá của một user
    @Override

    public List<AuctionBidModel> findByUserId(int userId) {

        List<AuctionBidModel> list = new ArrayList<>();

        String sql =
                "SELECT * FROM auction_bid " +
                        "WHERE user_id=? " +
                        "ORDER BY bid_time DESC";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                AuctionBidModel bid = new AuctionBidModel();

                bid.setId(rs.getInt("id"));
                bid.setAuctionId(rs.getInt("auction_id"));
                bid.setUserId(rs.getInt("user_id"));
                bid.setBidPrice(rs.getDouble("bid_price"));
                bid.setBidTime(rs.getTimestamp("bid_time"));

                list.add(bid);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // Tuấn làm

    /**
     * Lấy TOÀN BỘ lịch sử bid của một phiên.
     * Admin dùng để xem chi tiết từng lượt đặt, kiểm tra spam.
     */
    @Override
    public List<AuctionBidModel> getBidsByAuctionId(int auctionId) {
        List<AuctionBidModel> list = new ArrayList<>();
        String sql =
                "SELECT ab.*, CONCAT(c.first_name,' ',c.last_name) AS user_name, c.email AS user_email " +
                        "FROM auction_bid ab " +
                        "JOIN customer c ON ab.user_id = c.id_user " +
                        "WHERE ab.auction_id = ? " +
                        "ORDER BY ab.bid_time DESC";    // Mới nhất lên đầu

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, auctionId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBid(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return list;
    }

    /**
     * Lấy lịch sử bid của MỘT NGƯỜI DÙNG CỤ THỂ (tất cả phiên).
     * Admin dùng để điều tra hành vi spam/gian lận.
     */
    @Override
    public List<AuctionBidModel> getBidsByUserId(int userId) {
        List<AuctionBidModel> list = new ArrayList<>();
        String sql =
                "SELECT ab.*, CONCAT(c.first_name,' ',c.last_name) AS user_name, c.email AS user_email " +
                        "FROM auction_bid ab " +
                        "JOIN customer c ON ab.user_id = c.id_user " +
                        "WHERE ab.user_id = ? " +
                        "ORDER BY ab.bid_time DESC";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToBid(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return list;
    }

    /**
     * Đếm số lần bid của một user trong một phiên cụ thể.
     * Dùng để phát hiện spam (bid quá nhiều lần).
     */
    @Override
    public int countBidByUserInAuction(int userId, int auctionId) {
        String sql = "SELECT COUNT(*) FROM auction_bid WHERE user_id=? AND auction_id=?";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, auctionId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return 0;
    }

    // 2. Lấy danh sách người tham gia
    @Override
    public List<Integer> getParticipantIds(int auctionId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT DISTINCT user_id FROM auction_bid WHERE auction_id=?";
        try (Connection con = JDBCConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, auctionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rs.getInt("user_id"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Đọc một dòng ResultSet -> AuctionBidModel */
    private AuctionBidModel mapRowToBid(ResultSet rs) throws SQLException {
        AuctionBidModel b = new AuctionBidModel();
        b.setId(rs.getInt("id"));
        b.setAuctionId(rs.getInt("auction_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setBidPrice(rs.getDouble("bid_price"));
        b.setBidTime(rs.getTimestamp("bid_time"));

        b.setUserName(rs.getString("user_name"));
        b.setUserEmail(rs.getString("user_email"));
        return b;
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