package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AuctionBidDAO {

    // ===========================
    // Thêm lượt đấu giá
    // ===========================
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

    // ===========================
    // Lịch sử đấu giá theo phiên
    // ===========================
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

    // ===========================
    // Giá cao nhất của phiên
    // ===========================
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

}