package dao.impl;

import java.util.List;

import configs.JPAConfig;
import dao.IProductDao;
import entity.Product;
import jakarta.persistence.*;

public class ProductDao implements IProductDao{

	@Override
	public void insert(Product product) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.persist(product);
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	
	}

	@Override
	public void update(Product product) {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			enma.merge(product);
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	}

	@Override
	public void delete(int productId) throws Exception {
		EntityManager enma = JPAConfig.getEntityManager();
		EntityTransaction trans = enma.getTransaction();
		try {
			trans.begin();
			Product product = enma.find(Product.class, productId);
			if (product != null) {
				enma.remove(product);
			} else {
				throw new Exception("Product is not founded!!!");
			}
			trans.commit();
		} catch (Exception e) {
			e.printStackTrace();
			trans.rollback();
			throw e;
		} finally {
			enma.close();
		}
	}

	@Override
	public Product findById(int productId) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			return enma.find(Product.class, productId);
		} finally {
			enma.close();
		}
	}
	
	@Override
	public List<Product> findAll() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Product> query = enma.createNamedQuery("Product.findAll", Product.class);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}
	
	
	//page: 0-indexed
	@Override
	public List<Product> findAll(int page, int pagesize) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Product> query = enma.createNamedQuery("Product.findAll", Product.class);
			query.setFirstResult(page * pagesize);
			query.setMaxResults(pagesize);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public List<Product> findLatest(int limit) {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			TypedQuery<Product> query = enma.createNamedQuery("Product.findLatest", Product.class);
			query.setMaxResults(limit);
			return query.getResultList();
		} finally {
			enma.close();
		}
	}

	@Override
	public int count() {
		EntityManager enma = JPAConfig.getEntityManager();
		try {
			Query query = enma.createNamedQuery("Product.countAll");
			return ((Long) query.getSingleResult()).intValue();
		} finally {
			enma.close();
		}
	}

	@Override
	public int countByCategory(int categoryId) {
		EntityManager enma = JPAConfig.getEntityManager();
	    try {
	        Query query = enma.createQuery("SELECT COUNT(p) FROM Product p WHERE p.category.categoryId = :cid");
	        query.setParameter("cid", categoryId);
	        return ((Long) query.getSingleResult()).intValue();
	    } finally {
	        enma.close();
	    }
	}

	@Override
	public List<Product> findByCategory(int categoryId) {
		EntityManager enma = JPAConfig.getEntityManager();
	    try {
	        TypedQuery<Product> query = enma.createQuery(
	            "SELECT p FROM Product p WHERE p.category.categoryId = :cid ORDER BY p.productId DESC", Product.class);
	        query.setParameter("cid", categoryId);
	        return query.getResultList();
	    } finally {
	        enma.close();
	    }
	}

	@Override
	public Product findByName(String productName) {
	    EntityManager enma = JPAConfig.getEntityManager();
	    try {
	        TypedQuery<Product> query = enma.createQuery(
	            "SELECT p FROM Product p WHERE p.productName = :name", Product.class);
	        query.setParameter("name", productName);
	        return query.getSingleResult();
	    } catch (NoResultException e) {
	        return null; // Không có sản phẩm trùng tên
	    } finally {
	        enma.close();
	    }
	}
	
	@Override
	public boolean checkExistByNameAndCategory(String productName, int categoryId) {
	    EntityManager enma = JPAConfig.getEntityManager();
	    try {
	        TypedQuery<Long> query = enma.createQuery(
	            "SELECT COUNT(p) FROM Product p WHERE p.productName = :name AND p.category.categoryId = :cid", Long.class);
	        query.setParameter("name", productName);
	        query.setParameter("cid", categoryId);
	        
	        Long count = query.getSingleResult();
	        return count > 0; // Trả về true nếu đã tồn tại >= 1 sản phẩm
	    } finally {
	        enma.close();
	    }
	}

}
