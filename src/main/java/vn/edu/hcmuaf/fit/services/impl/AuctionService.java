package vn.edu.hcmuaf.fit.services.impl;

import vn.edu.hcmuaf.fit.dao.impl.AuctionBidDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionDAO;
import vn.edu.hcmuaf.fit.model.AuctionBidModel;
import vn.edu.hcmuaf.fit.model.AuctionModel;
import vn.edu.hcmuaf.fit.services.IAuctionService;

import java.sql.Timestamp;
import java.util.List;

public class AuctionService implements IAuctionService {

    private final AuctionDAO auctionDAO = new AuctionDAO();
    private final AuctionBidDAO bidDAO = new AuctionBidDAO();

    @Override
    public List<AuctionModel> getAllAuction() {
        return auctionDAO.findAll();
    }

    @Override
    public AuctionModel getAuctionById(int id) {
        return auctionDAO.findById(id);
    }

    @Override
    public String bid(int auctionId, int userId, double price) {

        AuctionModel auction = auctionDAO.findById(auctionId);

        if (auction == null)
            return "Không tìm thấy phiên đấu giá";

        Timestamp now = new Timestamp(System.currentTimeMillis());

        if (now.before(auction.getStartTime()))
            return "Phiên đấu giá chưa bắt đầu";

        if (now.after(auction.getEndTime()))
            return "Phiên đấu giá đã kết thúc";

        double minPrice =
                auction.getCurrentPrice() + auction.getMinIncrement();

        if (price < minPrice)
            return "Giá phải lớn hơn hoặc bằng " + minPrice;

        AuctionBidModel bid = new AuctionBidModel();

        bid.setAuctionId(auctionId);
        bid.setUserId(userId);
        bid.setBidPrice(price);

        bidDAO.insertBid(bid);

        auctionDAO.updateCurrentPrice(
                auctionId,
                price,
                userId
        );

        return "success";
    }

    @Override
    public AuctionModel findAuctionById(int id) {
        return auctionDAO.findById(id);
    }

    @Override
    public List<AuctionBidModel> getBidHistory(int auctionId) {
        return bidDAO.findByAuctionId(auctionId);
    }
}