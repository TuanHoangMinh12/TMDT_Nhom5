package vn.edu.hcmuaf.fit.controller.web.products;

import vn.edu.hcmuaf.fit.model.BookModel;
import vn.edu.hcmuaf.fit.model.DepartmentModel;
import vn.edu.hcmuaf.fit.model.UniversityModel;
import vn.edu.hcmuaf.fit.services.IDepartmentService;
import vn.edu.hcmuaf.fit.services.impl.DepartmentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * URL: /products/giao-trinh
 *
 * Tham số GET hỗ trợ:
 *   (không có)               → tất cả sách giáo trình
 *   ?university=1            → lọc theo trường (id_university)
 *   ?department=3            → lọc theo khoa  (id_department)
 *   ?university=1&department=3 → lọc theo cả trường lẫn khoa
 *                               (department đã xác định trường → dùng department là đủ,
 *                                nhưng university được giữ lại để sidebar highlight đúng)
 */
@WebServlet(name = "ProductFindDepartmentController", value = "/products/giao-trinh")
public class ProductFindDepartmentController extends HttpServlet {

    IDepartmentService iDepartmentService = new DepartmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String universityParam  = request.getParameter("university");
        String departmentParam  = request.getParameter("department");

        int idUniversity = 0;
        int idDepartment = 0;

        try {
            if (universityParam != null && !universityParam.isEmpty())
                idUniversity = Integer.parseInt(universityParam);
        } catch (NumberFormatException ignored) {}

        try {
            if (departmentParam != null && !departmentParam.isEmpty())
                idDepartment = Integer.parseInt(departmentParam);
        } catch (NumberFormatException ignored) {}

        // --- Luôn load sidebar: danh sách trường + tất cả khoa ---
        List<UniversityModel> universityList = iDepartmentService.findAllUniversities();
        List<DepartmentModel> departmentList = iDepartmentService.findAllDepartments();
        request.setAttribute("universityList", universityList);
        request.setAttribute("departmentList", departmentList);

        // --- Khi chọn trường: load danh sách khoa con để hiển thị sub-filter ---
        if (idUniversity > 0) {
            List<DepartmentModel> deptsByUniversity =
                    iDepartmentService.findDepartmentsByUniversity(idUniversity);
            UniversityModel currentUniversity =
                    iDepartmentService.findUniversityById(idUniversity);
            request.setAttribute("deptsByUniversity", deptsByUniversity);
            request.setAttribute("currentUniversity",  currentUniversity);
        }

        // --- Khi chọn khoa: load thêm thông tin khoa đó ---
        if (idDepartment > 0) {
            DepartmentModel currentDepartment =
                    iDepartmentService.findDepartmentById(idDepartment);
            request.setAttribute("currentDepartment", currentDepartment);

            // Nếu chưa có idUniversity thì suy ra từ khoa
            if (idUniversity == 0 && currentDepartment != null) {
                idUniversity = currentDepartment.getIdUniversity();
                UniversityModel currentUniversity =
                        iDepartmentService.findUniversityById(idUniversity);
                List<DepartmentModel> deptsByUniversity =
                        iDepartmentService.findDepartmentsByUniversity(idUniversity);
                request.setAttribute("currentUniversity",  currentUniversity);
                request.setAttribute("deptsByUniversity",  deptsByUniversity);
            }
        }

        // --- Lấy sách theo filter ---
        List<BookModel> books = iDepartmentService.findBooks(idUniversity, idDepartment);
        request.setAttribute("list12Book", books);

        // --- Tiêu đề trang ---
        String title = "Sách Giáo Trình";
        if (idDepartment > 0) {
            DepartmentModel d = (DepartmentModel) request.getAttribute("currentDepartment");
            if (d != null) title = "Sách Giáo Trình - " + d.getUniversityShortName()
                    + " - " + d.getName();
        } else if (idUniversity > 0) {
            UniversityModel u = (UniversityModel) request.getAttribute("currentUniversity");
            if (u != null) title = "Sách Giáo Trình - " + u.getName();
        }
        request.setAttribute("title", title);
        request.setAttribute("currentPage", 1);

        // Giữ lại id đang chọn để JSP highlight sidebar
        request.setAttribute("selectedUniversity", idUniversity);
        request.setAttribute("selectedDepartment", idDepartment);

        request.getRequestDispatcher("/views/web/product.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}