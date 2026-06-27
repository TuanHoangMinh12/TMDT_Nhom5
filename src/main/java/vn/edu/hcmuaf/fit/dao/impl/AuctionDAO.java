package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO {

    // Lấy tất cả phiên đấu giá
    public List<AuctionModel> findAll() {
        List<AuctionModel> list = new ArrayList<>();

        String sql =
                "SELECT a.*, b.id_book, b.name, b.image, b.price " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id=b.id_book";

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
    public AuctionModel findById(int id) {

        String sql =
                "SELECT a.*, b.id_book, b.name, b.image, b.price " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id = b.id_book " +
                        "WHERE a.id=?";

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

                Product product = new Product();

                product.setIdBook(rs.getInt("id_book"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setPrice(rs.getDouble("price"));

                auction.setProduct(product);

                return auction;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm phiên đấu giá
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

    // Cập nhật giá hiện tại
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
}