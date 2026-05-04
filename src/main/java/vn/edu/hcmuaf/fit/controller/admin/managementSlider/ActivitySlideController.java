package vn.edu.hcmuaf.fit.controller.admin.managementSlider;

import vn.edu.hcmuaf.fit.bean.Log;
import vn.edu.hcmuaf.fit.model.CustomerModel;
import vn.edu.hcmuaf.fit.services.ISliderManagementService;
import vn.edu.hcmuaf.fit.utils.SessionUtil;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.InetAddress;

@WebServlet(name = "findSlideAvtivity", value = "/findSlideAvtivity")
public class ActivitySlideController extends HttpServlet {
    @Inject
    ISliderManagementService iSliderManagementService;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // title dung de active aside
        String id = request.getParameter("id");
        CustomerModel cus = (CustomerModel) SessionUtil.getInstance().getValue(request, "USERMODEL");
        InetAddress myIP=InetAddress.getLocalHost();
        String ip= myIP.getHostAddress();
        iSliderManagementService.activitySilde(id);
        Log log = new Log(Log.INFO,ip,"Quản lý slide",cus.getIdUser(),"Hiện slide",1);
        log.insert();

        request.setAttribute("message","Hiện thành công");
        response.sendRedirect(request.getContextPath() + "/admin-table-slider");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
