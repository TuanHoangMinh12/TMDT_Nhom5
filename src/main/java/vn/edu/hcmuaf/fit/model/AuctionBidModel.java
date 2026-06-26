package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

public class AuctionBidModel {

    private int id;

    private int auctionId;

    private int userId;

    private double bidPrice;

    private Timestamp bidTime;

    // dùng để hiển thị tên người bid
    private CustomerModel customer;

    public AuctionBidModel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAuctionId() {
        return auctionId;
    }

    public void setAuctionId(int auctionId) {
        this.auctionId = auctionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getBidPrice() {
        return bidPrice;
    }

    public void setBidPrice(double bidPrice) {
        this.bidPrice = bidPrice;
    }

    public Timestamp getBidTime() {
        return bidTime;
    }

    public void setBidTime(Timestamp bidTime) {
        this.bidTime = bidTime;
    }

    public CustomerModel getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerModel customer) {
        this.customer = customer;
    }
}