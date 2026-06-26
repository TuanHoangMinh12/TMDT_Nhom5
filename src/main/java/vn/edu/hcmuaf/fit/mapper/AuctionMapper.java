//package vn.edu.hcmuaf.fit.mapper;
//
//import org.jdbi.v3.core.mapper.RowMapper;
//import org.jdbi.v3.core.statement.StatementContext;
//import vn.edu.hcmuaf.fit.model.AuctionModel;
//
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//public class AuctionMapper implements RowMapper<AuctionModel> {
//
//    @Override
//    public AuctionModel mapRow(ResultSet rs) {
//        try {
//
//            AuctionModel a = new AuctionModel();
//
//            a.setId(rs.getInt("id"));
//            a.setBookId(rs.getInt("book_id"));
//            a.setStartPrice(rs.getDouble("start_price"));
//            a.setCurrentPrice(rs.getDouble("current_price"));
//            a.setMinIncrement(rs.getDouble("min_increment"));
//
//            a.setStartTime(rs.getTimestamp("start_time"));
//            a.setEndTime(rs.getTimestamp("end_time"));
//
//            a.setWinnerId((Integer) rs.getObject("winner_id"));
//
//            a.setStatus(rs.getString("status"));
//
//            a.setCreatedAt(rs.getTimestamp("created_at"));
//
//            return a;
//
//        } catch (SQLException e) {
//            return null;
//        }
//    }
//
//    @Override
//    public AuctionModel map(ResultSet rs, StatementContext ctx) throws SQLException {
//        return null;
//    }
//}