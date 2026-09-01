package dao;

import java.util.List;

import entity.Product;

public interface IProductDao {
	void insert(Product product);
	void update(Product product);
	void delete(int productId) throws Exception;
	Product findById(int productId);
	List<Product> findAll();
	List<Product> findAll(int page, int pagesize);
	List<Product> findLatest(int limit);
	int count();
	
	int countByCategory(int categoryId);
	List<Product> findByCategory(int categoryId);
}
