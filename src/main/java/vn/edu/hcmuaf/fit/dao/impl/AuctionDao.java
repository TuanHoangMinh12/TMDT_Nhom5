package vn.edu.hcmuaf.fit.dao.impl;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO {

    // Lấy tất cả phiên đấu giá
    public List<AuctionModel> findAll() {
        List<AuctionModel> list = new ArrayList<>();

        String sql = "SELECT * FROM auction ORDER BY created_at DESC";

        try {
            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapping(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy phiên đấu giá theo id
    public AuctionModel findById(int id) {

        String sql = "SELECT * FROM auction WHERE id=?";

        try {
            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapping(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Lấy phiên đấu giá theo sách
    public AuctionModel findByBookId(int bookId) {

        String sql = "SELECT * FROM auction WHERE book_id=?";

        try {
            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, bookId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapping(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm phiên đấu giá
    public boolean insert(AuctionModel auction) {

        String sql = "INSERT INTO auction(book_id,start_price,current_price,min_increment,start_time,end_time,winner_id,status) VALUES(?,?,?,?,?,?,?,?)";

        try {
            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, auction.getBookId());
            ps.setDouble(2, auction.getStartPrice());
            ps.setDouble(3, auction.getCurrentPrice());
            ps.setDouble(4, auction.getMinIncrement());
            ps.setTimestamp(5, auction.getStartTime());
            ps.setTimestamp(6, auction.getEndTime());

            if (auction.getWinnerId() == 0) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, auction.getWinnerId());
            }

            ps.setString(8, auction.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật giá hiện tại
    public boolean updateCurrentPrice(int auctionId, double price) {

        String sql = "UPDATE auction SET current_price=? WHERE id=?";

        try {

            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setDouble(1, price);
            ps.setInt(2, auctionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật người thắng tạm thời
    public boolean updateWinner(int auctionId, int winnerId) {

        String sql = "UPDATE auction SET winner_id=? WHERE id=?";

        try {

            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, winnerId);
            ps.setInt(2, auctionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Cập nhật trạng thái
    public boolean updateStatus(int auctionId, String status) {

        String sql = "UPDATE auction SET status=? WHERE id=?";

        try {

            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, auctionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa phiên đấu giá
    public boolean delete(int id) {

        String sql = "DELETE FROM auction WHERE id=?";

        try {

            Connection connection = JDBCConnector.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Mapping
    private AuctionModel mapping(ResultSet rs) throws SQLException {

        AuctionModel auction = new AuctionModel();

        auction.setId(rs.getInt("id"));
        auction.setBookId(rs.getInt("book_id"));
        auction.setStartPrice(rs.getDouble("start_price"));
        auction.setCurrentPrice(rs.getDouble("current_price"));
        auction.setMinIncrement(rs.getDouble("min_increment"));
        auction.setStartTime(rs.getTimestamp("start_time"));
        auction.setEndTime(rs.getTimestamp("end_time"));
        auction.setWinnerId(rs.getInt("winner_id"));
        auction.setStatus(rs.getString("status"));
        auction.setCreatedAt(rs.getTimestamp("created_at"));

        return auction;
    }

}