package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.dao.IAuctionNotificationDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionNotificationDAO;
import vn.edu.hcmuaf.fit.model.AuctionNotificationModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationListController extends HttpServlet {

    private final IAuctionNotificationDAO notificationDAO =
            new AuctionNotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        CustomerModel user =
                (CustomerModel) request.getSession()
                        .getAttribute("USERMODEL");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<AuctionNotificationModel> listNotification =
                notificationDAO.getNotificationsByUser(user.getIdUser());

        request.setAttribute("listNotification", listNotification);
        request.getRequestDispatcher("/views/web/notifications.jsp")
                .forward(request, response);
    }
}