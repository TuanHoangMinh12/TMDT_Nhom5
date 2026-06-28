package vn.edu.hcmuaf.fit.model;

import java.sql.Timestamp;

/**
 * Model tương ứng với bảng `auction_notifications`.
 * Dùng để gửi thông báo "Thắng/Thua" cho người dùng sau khi phiên kết thúc.
 */
public class AuctionNotificationModel {

    private int id;
    private int userId;
    private int auctionId;
    private String title;
    private String content;
    private int isRead;        // 0 = chưa đọc, 1 = đã đọc
    private Timestamp createdAt;

    // Trường JOIN thêm
    private String userName;

    public AuctionNotificationModel() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAuctionId() { return auctionId; }
    public void setAuctionId(int auctionId) { this.auctionId = auctionId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getIsRead() { return isRead; }
    public void setIsRead(int isRead) { this.isRead = isRead; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
