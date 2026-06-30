package vn.edu.hcmuaf.fit.dao.impl;

import vn.edu.hcmuaf.fit.dao.IAuctionDAO;
import vn.edu.hcmuaf.fit.db.JDBCConnector;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.model.Product;
import vn.edu.hcmuaf.fit.dao.impl.CartDao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuctionDAO implements IAuctionDAO {


    /**
     * Mapping ResultSet -> AuctionModel
     */
    private AuctionModel mapAuction(ResultSet rs) throws SQLException {

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

    /**
     * Lấy tất cả phiên đấu giá
     */

    // Lấy tất cả phiên đấu giá
    @Override

    public List<AuctionModel> findAll() {

        List<AuctionModel> list = new ArrayList<>();

        String sql =
                "SELECT a.*, b.id_book, b.name, b.price, ib.image " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id = b.id_book " +
                        "LEFT JOIN image_book ib ON ib.id_book = b.id_book " +
                        "GROUP BY a.id " +
                        "ORDER BY a.created_at DESC";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                list.add(mapAuction(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    /**
     * Lấy phiên đấu giá theo id
     */

    // Tìm theo id
    @Override

    public AuctionModel findById(int id) {

        String sql =
                "SELECT a.*, b.id_book, b.name, b.price, ib.image " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id = b.id_book " +
                        "LEFT JOIN image_book ib ON ib.id_book = b.id_book " +
                        "WHERE a.id = ? " +
                        "GROUP BY a.id";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapAuction(rs);
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    /**
     * Thêm phiên đấu giá
     */

    @Override
    public AuctionModel findByBookId(int bookId) {
        return null;
    }

    // Thêm phiên đấu giá
    @Override

    public boolean insert(AuctionModel auction) {

        String sql =
                "INSERT INTO auction(book_id,start_price,current_price,min_increment,start_time,end_time,status) " +
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


    /**
     * Cập nhật giá hiện tại và người đang dẫn đầu
     */

    @Override
    public boolean update(AuctionModel auction) {
        return false;
    }

    // Cập nhật giá hiện tại
    @Override

    public boolean updateCurrentPrice(int auctionId,
                                      double price,
                                      int winnerId) {

        String sql =
                "UPDATE auction " +
                        "SET current_price=?, winner_id=? " +
                        "WHERE id=?";

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

    /**
     * Kết thúc phiên đấu giá
     */
    public boolean finishAuction(int auctionId) {

        String sql =
                "UPDATE auction " +
                        "SET status='FINISHED' " +
                        "WHERE id=?";

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
    @Override
    public void finishExpiredAuction() {

        try(
                Connection conn = JDBCConnector.getConnection()
        ){

            // ==========================
            // WAITING -> ACTIVE
            // ==========================
            String activeSql =
                    "UPDATE auction " +
                            "SET status='ACTIVE' " +
                            "WHERE status='WAITING' " +
                            "AND start_time<=NOW()";

            PreparedStatement psActive = conn.prepareStatement(activeSql);
            psActive.executeUpdate();
            psActive.close();

            // ==========================
            // ACTIVE -> FINISHED
            // ==========================
            String sql =
                    "SELECT id " +
                            "FROM auction " +
                            "WHERE status='ACTIVE' " +
                            "AND end_time<=NOW()";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){

                int auctionId = rs.getInt("id");

                AuctionBidModel highest =
                        new AuctionBidDAO().findHighestBid(auctionId);

                if(highest != null){

                    String update =
                            "UPDATE auction " +
                                    "SET status='FINISHED'," +
                                    "winner_id=?," +
                                    "current_price=? " +
                                    "WHERE id=?";

                    PreparedStatement ps2 =
                            conn.prepareStatement(update);

                    ps2.setInt(1, highest.getUserId());
                    ps2.setDouble(2, highest.getBidPrice());
                    ps2.setInt(3, auctionId);

                    ps2.executeUpdate();
                    ps2.close();

                    // Thêm sách vào giỏ hàng người thắng
                    AuctionModel auction = findById(auctionId);

                    new CartDao().addAuctionBook(
                            highest.getUserId(),
                            auction.getBookId()
                    );
                    AuctionNotificationDAO notificationDAO = new AuctionNotificationDAO();

                    notificationDAO.sendNotification(
                            highest.getUserId(),
                            auctionId,
                            "🎉 Chúc mừng bạn đã thắng đấu giá!",
                            "Sách \"" + auction.getProduct().getName()
                                    + "\" đã được thêm vào giỏ hàng với giá "
                                    + highest.getBidPrice() + " đ."
                    );
                    AuctionBidDAO bidDAO = new AuctionBidDAO();

                    List<Integer> participants =
                            bidDAO.getParticipantIds(auctionId);

                    for(Integer userId : participants){

                        if(userId == highest.getUserId()){
                            continue;
                        }

                        notificationDAO.sendNotification(
                                userId,
                                auctionId,
                                "Phiên đấu giá đã kết thúc",
                                "Rất tiếc, bạn không phải là người chiến thắng trong phiên đấu giá \""
                                        + auction.getProduct().getName() + "\"."
                        );
                    }
                }else{

                    PreparedStatement ps2 =
                            conn.prepareStatement(
                                    "UPDATE auction SET status='FINISHED' WHERE id=?");

                    ps2.setInt(1, auctionId);
                    ps2.executeUpdate();
                    ps2.close();
                }
            }

            rs.close();
            ps.close();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
    @Override
    public List<AuctionModel> findWinnerAuctions(int userId) {

        List<AuctionModel> list = new ArrayList<>();

        String sql =
                "SELECT a.*, b.id_book, b.name, b.price, ib.image " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id=b.id_book " +
                        "LEFT JOIN image_book ib ON ib.id_book=b.id_book " +
                        "WHERE a.winner_id=? " +
                        "GROUP BY a.id " +
                        "ORDER BY a.end_time DESC";

        try(
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ){

            ps.setInt(1,userId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                list.add(mapAuction(rs));
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    // Tuấn làm

    // PHẦN 1 - CRUD PHIÊN ĐẤU GIÁ (bảng auction)
    /**
     * Lấy DANH SÁCH TẤT CẢ phiên đấu giá.
     * JOIN với book để lấy tên sách, JOIN với customer để lấy tên người thắng.
     * Admin dùng để xem toàn bộ danh sách.
     */
    @Override
    public List<AuctionModel> getAllAuctions() {
        List<AuctionModel> list = new ArrayList<>();
        // Đếm tổng bid bằng subquery để tránh GROUP BY phức tạp
        String sql =
                "SELECT a.*, b.name AS book_name, " +
                        "       (SELECT img.image FROM image_book img WHERE img.id_book = a.book_id LIMIT 1) AS book_image, " +
                        "       CONCAT(c.first_name,' ',c.last_name) AS winner_name, " +
                        "       c.email AS winner_email, " +
                        "       (SELECT COUNT(*) FROM auction_bid ab WHERE ab.auction_id = a.id) AS total_bids " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id = b.id_book " +
                        "LEFT JOIN customer c ON a.winner_id = c.id_user " +
                        "ORDER BY a.created_at DESC";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRowToAuction(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm một phiên đấu giá theo ID.
     * Dùng khi mở trang chi tiết phiên trong trang admin
     */
    @Override
    public AuctionModel findById2(int id) {
        String sql =
                "SELECT a.*, b.name AS book_name, " +
                        "       (SELECT img.image FROM image_book img WHERE img.id_book = a.book_id LIMIT 1) AS book_image, " +
                        "       CONCAT(c.first_name,' ',c.last_name) AS winner_name, " +
                        "       c.email AS winner_email, " +
                        "       (SELECT COUNT(*) FROM auction_bid ab WHERE ab.auction_id = a.id) AS total_bids " +
                        "FROM auction a " +
                        "JOIN book b ON a.book_id = b.id_book " +
                        "LEFT JOIN customer c ON a.winner_id = c.id_user " +
                        "WHERE a.id = ?";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToAuction(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * THÊM MỚI phiên đấu giá
     * Admin điền form -> gọi hàm này.
     * current_price ban đầu bằng start_price.
     *
     * @return số dòng bị ảnh hưởng (1 = thành công, 0 = thất bại)
     */
    @Override
    public int createAuction(int bookId, double startPrice, double minIncrement,
                             Timestamp startTime, Timestamp endTime) {
        String sql =
                "INSERT INTO auction (book_id, start_price, current_price, min_increment, start_time, end_time, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 'WAITING')";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.setDouble(2, startPrice);
            ps.setDouble(3, startPrice);    // current_price = start_price lúc đầu
            ps.setDouble(4, minIncrement);
            ps.setTimestamp(5, startTime);
            ps.setTimestamp(6, endTime);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * CẬP NHẬT thông tin phiên đấu giá.
     * Chỉ cho phép sửa khi phiên vẫn đang ở trạng thái WAITING.
     */
    @Override
    public int updateAuction(int id, double startPrice, double minIncrement,
                             Timestamp startTime, Timestamp endTime) {
        // Điều kiện AND status='WAITING' giúp tránh sửa phiên đang chạy
        String sql =
                "UPDATE auction " +
                        "SET start_price=?, current_price=?, min_increment=?, start_time=?, end_time=? " +
                        "WHERE id=? AND status='WAITING'";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setDouble(1, startPrice);
            ps.setDouble(2, startPrice);   // Reset current_price về start_price khi sửa
            ps.setDouble(3, minIncrement);
            ps.setTimestamp(4, startTime);
            ps.setTimestamp(5, endTime);
            ps.setInt(6, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Xóa phiên đấu giá
    @Override
    public int deleteAuction(int id) {
        String sql = "DELETE FROM auction WHERE id=? AND status='WAITING'";

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
        String sql = "UPDATE auction SET status=? WHERE id=?";

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

    /**
     * CHỐT PHIÊN ĐẤU GIÁ (Resolution).
     * Tìm bid cao nhất -> cập nhật winner_id + current_price + status = FINISHED.
     * Admin gọi sau khi phiên hết giờ.
     *
     * @return true nếu chốt thành công
     */
    @Override
    public boolean finalizeAuction(int auctionId) {
        // Bước 1: Tìm người bid cao nhất
        String sqlFindWinner =
                "SELECT user_id, bid_price FROM auction_bid " +
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
                        "UPDATE auction SET winner_id=?, current_price=?, status='FINISHED' " +
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
                String sqlNoWinner = "UPDATE auction SET status='FINISHED' WHERE id=?";
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

    /**
     * TỰ ĐỘNG đồng bộ trạng thái phiên dựa theo thời gian thực.
     * Gọi hàm này ở đầu mỗi request admin để status luôn đúng.
     *   - WAITING + đến giờ bắt đầu  -> ACTIVE
     *   - ACTIVE  + quá giờ kết thúc -> FINISHED
     */
    @Override
    public int countActiveAuction() {

        String sql =
                "SELECT COUNT(*) " +
                        "FROM auction " +
                        "WHERE status='ACTIVE'";

        try (
                Connection conn = JDBCConnector.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if(rs.next()){
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    @Override
    public void syncAuctionStatus() {
        String sqlToActive =
                "UPDATE auction SET status='ACTIVE' " +
                        "WHERE status='WAITING' AND start_time <= NOW()";
        String sqlToFinished =
                "UPDATE auction SET status='FINISHED' " +
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

    // PHẦN 4 - THỐNG KÊ (Statistics)
    /**
     * Tổng doanh thu từ các phiên đã thanh toán (status = PAID).
     */
    @Override
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(current_price), 0) FROM auction WHERE status='PAID'";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return 0.0;
    }

    /**
     * Đếm phiên theo từng trạng thái.
     * Trả về mảng int[4]: [WAITING, ACTIVE, FINISHED, PAID]
     */
    @Override
    public int[] countByStatus() {
        int[] counts = {0, 0, 0, 0};
        String sql = "SELECT status, COUNT(*) AS cnt FROM auction GROUP BY status";

        Connection con = JDBCConnector.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                int cnt = rs.getInt("cnt");
                if      ("WAITING" .equals(status)) counts[0] = cnt;
                else if ("ACTIVE"  .equals(status)) counts[1] = cnt;
                else if ("FINISHED".equals(status)) counts[2] = cnt;
                else if ("PAID"    .equals(status)) counts[3] = cnt;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
        return counts;
    }


    // Các hàm bổ sung
    /** Đọc một dòng ResultSet -> AuctionModel */
    private AuctionModel mapRowToAuction(ResultSet rs) throws SQLException {
        AuctionModel a = new AuctionModel();
        a.setId(rs.getInt("id"));
        a.setBookId(rs.getInt("book_id"));
        a.setStartPrice(rs.getDouble("start_price"));
        a.setCurrentPrice(rs.getDouble("current_price"));
        a.setMinIncrement(rs.getDouble("min_increment"));
        a.setStartTime(rs.getTimestamp("start_time"));
        a.setEndTime(rs.getTimestamp("end_time"));
        a.setStatus(rs.getString("status"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        // winner_id có thể NULL
        Object winnerObj = rs.getObject("winner_id");
        if (winnerObj != null) a.setWinnerId((Integer) winnerObj);
        // JOIN fields
        a.setBookName(rs.getString("book_name"));
        a.setBookImage(rs.getString("book_image"));
        a.setWinnerName(rs.getString("winner_name"));
        a.setWinnerEmail(rs.getString("winner_email"));
        a.setTotalBids(rs.getInt("total_bids"));
        return a;
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