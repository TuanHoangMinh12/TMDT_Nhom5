package vn.edu.hcmuaf.fit.dao;

import vn.edu.hcmuaf.fit.model.AuctionNotificationModel;

import java.util.List;

public interface IAuctionNotificationDAO {
    int sendNotification(int userId, int auctionId, String title, String content);
    int countUnreadNotifications(int userId);

    // Lấy tất cả thông báo của một user (mới nhất lên đầu).
    List<AuctionNotificationModel> getNotificationsByUser(int userId);
    int markNotificationRead(int notificationId, int userId);
    List<AuctionNotificationModel> getLatestNotifications(int userId, int limit);
    AuctionNotificationModel findById(int id);
}
