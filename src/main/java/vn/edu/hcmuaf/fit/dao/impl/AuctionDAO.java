package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IAuctionDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO implements IAuctionDAO {

    // Lấy tất cả phiên đấu giá
    @Override
    public List<AuctionModel> findAll() {
        List<AuctionModel> list = new ArrayList<>();

        String sql = "SELECT a.*, b.name " +
                "FROM auction a " +
                "JOIN book b ON a.book_id = b.id_book";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                AuctionModel auction = new AuctionModel();

                auction.setId(rs.getInt("id"));
                auction.setBookId(rs.getInt("book_id"));
                auction.setStartPrice(rs.getDouble("start_price"));
                auction.setCurrentPrice(rs.getDouble("current_price"));
                auction.setMinIncrement(rs.getDouble("min_increment"));
                auction.setStartTime(rs.getTimestamp("start_time"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setWinnerId((Integer) rs.getObject("winner_id"));
                auction.setStatus(rs.getString("status"));
                auction.setCreatedAt(rs.getTimestamp("created_at"));

                Product p = new Product();
                p.setIdBook(rs.getInt("book_id"));
                p.setName(rs.getString("name"));

                auction.setProduct(p);

                list.add(auction);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Tìm theo id
    @Override
    public AuctionModel findById(int id) {

        String sql = "SELECT * FROM auction WHERE id=?";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                AuctionModel auction = new AuctionModel();

                auction.setId(rs.getInt("id"));
                auction.setBookId(rs.getInt("book_id"));
                auction.setStartPrice(rs.getDouble("start_price"));
                auction.setCurrentPrice(rs.getDouble("current_price"));
                auction.setMinIncrement(rs.getDouble("min_increment"));
                auction.setStartTime(rs.getTimestamp("start_time"));
                auction.setEndTime(rs.getTimestamp("end_time"));
                auction.setWinnerId((Integer) rs.getObject("winner_id"));
                auction.setStatus(rs.getString("status"));
                auction.setCreatedAt(rs.getTimestamp("created_at"));

                return auction;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public AuctionModel findByBookId(int bookId) {
        return null;
    }

    // Thêm phiên đấu giá
    @Override
    public boolean insert(AuctionModel auction) {

        String sql = "INSERT INTO auction(book_id,start_price,current_price,min_increment,start_time,end_time,status) " +
                "VALUES(?,?,?,?,?,?,?)";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, auction.getBookId());
            ps.setDouble(2, auction.getStartPrice());
            ps.setDouble(3, auction.getCurrentPrice());
            ps.setDouble(4, auction.getMinIncrement());
            ps.setTimestamp(5, auction.getStartTime());
            ps.setTimestamp(6, auction.getEndTime());
            ps.setString(7, auction.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean update(AuctionModel auction) {
        return false;
    }

    // Cập nhật giá hiện tại
    @Override
    public boolean updateCurrentPrice(int auctionId,
                                      double price,
                                      int winnerId) {

        String sql = "UPDATE auction SET current_price=?, winner_id=? WHERE id=?";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setDouble(1, price);
            ps.setInt(2, winnerId);
            ps.setInt(3, auctionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Đóng phiên đấu giá
    public boolean finishAuction(int auctionId) {

        String sql = "UPDATE auction SET status='FINISHED' WHERE id=?";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, auctionId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }



    // Tuấn làm

    // Xóa phiên đấu giá
    @Override
    public int deleteAuction(int id) {
        String sql = "DELETE FROM auctions WHERE id=? AND status='WAITING'";

        try {
            Connection con = JDBCConnector.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Cập nhật STATUS của phiên đấu giá
    @Override
    public int updateStatus(int id, String newStatus) {
        String sql = "UPDATE auctions SET status=? WHERE id=?";

        try {
            Connection con = JDBCConnector.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

     // Chốt phiên đấu giá (Resolution).
     // Tìm bid cao nhất -> cập nhật winner_id + current_price + status = FINISHED.
     // Admin gọi sau khi phiên hết giờ = > trả về true nếu chốt thành công
    @Override
    public boolean finalizeAuction(int auctionId) {
        // Bước 1: Tìm người bid cao nhất
        String sqlFindWinner =
                "SELECT user_id, bid_price FROM auction_bids " +
                        "WHERE auction_id = ? " +
                        "ORDER BY bid_price DESC " +
                        "LIMIT 1";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sqlFindWinner);
            ps.setInt(1, auctionId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int winnerId = rs.getInt("user_id");
                double finalPrice = rs.getDouble("bid_price");

                // Bước 2: Cập nhật winner_id, current_price và status -> FINISHED
                String sqlUpdate =
                        "UPDATE auctions SET winner_id=?, current_price=?, status='FINISHED' " +
                                "WHERE id=?";
                PreparedStatement psUpdate = con.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, winnerId);
                psUpdate.setDouble(2, finalPrice);
                psUpdate.setInt(3, auctionId);
                int rows = psUpdate.executeUpdate();
                psUpdate.close();
                return rows > 0;
            } else {
                // Không có ai bid -> chỉ chuyển status sang FINISHED, không có winner
                String sqlNoWinner = "UPDATE auctions SET status='FINISHED' WHERE id=?";
                PreparedStatement psNo = con.prepareStatement(sqlNoWinner);
                psNo.setInt(1, auctionId);
                psNo.executeUpdate();
                psNo.close();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // TỰ ĐộNG đồng bộ trạng thái phiên dựa theo thời gian thực.
    // Gọi hàm này ở đầu mỗi request admin để status luôn đúng.
    //     *   - WAITING + đến giờ bắt đầu  -> ACTIVE
    //     *   - ACTIVE  + quá giờ kết thúc -> FINISHED
    @Override
    public void syncAuctionStatus() {
        String sqlToActive =
                "UPDATE auctions SET status='ACTIVE' " +
                        "WHERE status='WAITING' AND start_time <= NOW()";
        String sqlToFinished =
                "UPDATE auctions SET status='FINISHED' " +
                        "WHERE status='ACTIVE' AND end_time <= NOW()";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sqlToActive);
            ps.executeUpdate();
            ps.close();

            ps = con.prepareStatement(sqlToFinished);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /*
          LỊCH SỬ ĐẶT GIÁ (bảng auction_bids)
     */

    // Lấy TOÀN BỘ lịch sử bid của một phiên.
    //  Admin dùng để xem chi tiết từng lượt đặt, kiểm tra spam.


}