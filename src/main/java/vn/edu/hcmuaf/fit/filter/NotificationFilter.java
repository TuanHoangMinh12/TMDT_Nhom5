package vn.edu.hcmuaf.fit.filter;

import vn.edu.hcmuaf.fit.dao.IAuctionNotificationDAO;
import vn.edu.hcmuaf.fit.dao.impl.AuctionNotificationDAO;
import vn.edu.hcmuaf.fit.model.AuctionNotificationModel;
import vn.edu.hcmuaf.fit.model.CustomerModel;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class NotificationFilter implements Filter {

    private IAuctionNotificationDAO notificationDAO =
            new AuctionNotificationDAO();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        HttpSession session = req.getSession(false);

        if (session != null) {

            CustomerModel user =
                    (CustomerModel) session.getAttribute("USERMODEL");

            if (user != null) {

                int unread =
                        notificationDAO.countUnreadNotifications(user.getIdUser());

                List<AuctionNotificationModel> latest =
                        notificationDAO.getLatestNotifications(user.getIdUser(), 5);

                req.setAttribute("unreadNotifications", unread);

                req.setAttribute("latestNotifications", latest);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}