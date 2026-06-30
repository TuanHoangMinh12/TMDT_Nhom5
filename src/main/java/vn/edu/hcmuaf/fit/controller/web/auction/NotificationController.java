package vn.edu.hcmuaf.fit.controller.web.auction;

import vn.edu.hcmuaf.fit.dao.IAuctionNotificationDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionNotificationDAO;
import vn.edu.hcmuaf.fit.model.AuctionNotificationModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/notification/read")
public class NotificationController extends HttpServlet {

    private final IAuctionNotificationDAO notificationDAO =
            new AuctionNotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        CustomerModel user =
                (CustomerModel) request.getSession()
                        .getAttribute("USERMODEL");

        if(user == null){
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }

        int id =
                Integer.parseInt(request.getParameter("id"));

        AuctionNotificationModel notification =
                notificationDAO.findById(id);

        if(notification != null){

            notificationDAO.markNotificationRead(
                    id,
                    user.getIdUser()
            );

            response.sendRedirect(
                    request.getContextPath()
                            +"/auction-detail?id="
                            +notification.getAuctionId()
            );

        }else{

            response.sendRedirect(
                    request.getContextPath()+"/auction"
            );

        }

    }
}