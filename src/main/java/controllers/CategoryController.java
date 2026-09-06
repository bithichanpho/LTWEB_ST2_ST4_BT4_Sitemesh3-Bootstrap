package controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import configs.AppConfig;
import dao.ICategoryDao;
import dao.IProductDao;
import dao.impl.CategoryDao;
import dao.impl.ProductDao;
import entity.Category;
import entity.Product;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
@WebServlet(urlPatterns = { "/categories", "/category/add", "/category/insert",
        "/category/edit", "/category/update", "/category/delete", "/category/detail" })
public class CategoryController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ICategoryDao categoryDao = new CategoryDao();
    private IProductDao productDao = new ProductDao();
    private final String ROOT_DIR = AppConfig.ROOT_UPLOAD_DIR;

    // Thư mục cố định để lưu icon của Category (không còn phụ thuộc female/male/accessories nữa)
    private static final String CATEGORY_IMG_FOLDER = "categories";

    private boolean isAdmin(HttpServletRequest req) {
        User user = (User) req.getSession().getAttribute("currentUser");
        return user != null && "admin".equals(user.getRole());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String url = req.getRequestURI();

        if (url.contains("categories")) {
            List<Category> list = categoryDao.findAll();

            Map<Integer, Integer> countMap = new HashMap<>();
            Map<Integer, Integer> inStockMap = new HashMap<>();
            Map<Integer, Integer> outStockMap = new HashMap<>();
            int totalProducts = 0;

            for (Category c : list) {
                List<Product> products = productDao.findByCategory(c.getCategoryId());
                int total = products.size();
                int inStock = 0;
                for (Product p : products) {
                    if (p.getQuantity() > 0) {
                        inStock++;
                    }
                }
                int outStock = total - inStock;

                countMap.put(c.getCategoryId(), total);
                inStockMap.put(c.getCategoryId(), inStock);
                outStockMap.put(c.getCategoryId(), outStock);
                totalProducts += total;
            }

            req.setAttribute("cateList", list);
            req.setAttribute("countMap", countMap);
            req.setAttribute("inStockMap", inStockMap);
            req.setAttribute("outStockMap", outStockMap);
            req.setAttribute("totalProducts", totalProducts);
            req.getRequestDispatcher("/views/category-list.jsp").forward(req, resp);

        } else if (url.contains("category/add")) {
            if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/categories"); return; }
            req.getRequestDispatcher("/views/category-add.jsp").forward(req, resp);

        } else if (url.contains("category/edit")) {
            if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/categories"); return; }
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = categoryDao.findById(id);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/categories");
                return;
            }
            req.setAttribute("cate", category);
            req.getRequestDispatcher("/views/category-edit.jsp").forward(req, resp);

        } else if (url.contains("category/detail")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = categoryDao.findById(id);
            if (category == null) {
                resp.sendRedirect(req.getContextPath() + "/categories");
                return;
            }
            List<Product> products = productDao.findByCategory(id);
            req.setAttribute("cate", category);
            req.setAttribute("productList", products);
            req.getRequestDispatcher("/views/product-manage.jsp").forward(req, resp);

        } else if (url.contains("category/delete")) {
            if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/categories"); return; }
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                int soLuong = productDao.countByCategory(id);
                if (soLuong > 0) {
                    req.getSession().setAttribute("flashError",
                        "Không thể xóa: category này còn " + soLuong + " sản phẩm.");
                } else {
                    categoryDao.delete(id);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/categories");

        } else {
            resp.sendRedirect(req.getContextPath() + "/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/categories");
            return;
        }

        String url = req.getRequestURI();

        String uploadPath = req.getServletContext().getRealPath(AppConfig.ROOT_UPLOAD_DIR + "/categories");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        if (url.contains("insert")) {
            String name = req.getParameter("categoryname");

            Category existing = categoryDao.findByCategoryname(name);
            if (existing != null) {
                req.setAttribute("error", "Tên Category '" + name + "' đã tồn tại (ID=" + existing.getCategoryId() + ")");
                req.getRequestDispatcher("/views/category-add.jsp").forward(req, resp);
                return;
            }

            int status = Integer.parseInt(req.getParameter("status"));
            String dbImageValue = "";

            Part part = req.getPart("images");
            if (part != null && part.getSize() > 0) {
                String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String fileName = System.currentTimeMillis() + "_" + originalFileName;
                Path path = Paths.get(uploadPath, fileName);
                try (InputStream inputStream = part.getInputStream()) {
                    Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
                }
                dbImageValue = CATEGORY_IMG_FOLDER + "/" + fileName;
            }

            Category category = new Category();
            category.setCategoryname(name);
            category.setImages(dbImageValue);
            category.setStatus(status);

            categoryDao.insert(category);
            resp.sendRedirect(req.getContextPath() + "/categories");

        } else if (url.contains("update")) {
            int id = Integer.parseInt(req.getParameter("categoryId"));
            String name = req.getParameter("categoryname");

            Category existing = categoryDao.findByCategoryname(name);
            if (existing != null && existing.getCategoryId() != id) {
                req.setAttribute("error", "Tên Category '" + name + "' đã được dùng bởi ID=" + existing.getCategoryId());
                req.setAttribute("cate", categoryDao.findById(id));
                req.getRequestDispatcher("/views/category-edit.jsp").forward(req, resp);
                return;
            }

            int status = Integer.parseInt(req.getParameter("status"));
            Category category = new Category();
            category.setCategoryId(id);
            category.setCategoryname(name);
            category.setStatus(status);

            Part part = req.getPart("images");
            if (part != null && part.getSize() > 0) {
                String originalFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String fileName = System.currentTimeMillis() + "_" + originalFileName;
                Path path = Paths.get(uploadPath, fileName);
                try (InputStream inputStream = part.getInputStream()) {
                    Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
                }
                category.setImages(CATEGORY_IMG_FOLDER + "/" + fileName);
            } else {
                Category oldCate = categoryDao.findById(id);
                category.setImages(oldCate.getImages());
            }

            categoryDao.update(category);
            resp.sendRedirect(req.getContextPath() + "/categories");
        }
    }
}