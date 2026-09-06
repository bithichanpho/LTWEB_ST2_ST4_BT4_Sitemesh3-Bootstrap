package configs;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;

@PersistenceContext
public class JPAConfig {
	private static final EntityManagerFactory emf;
	static {
		try {
			emf = Persistence.createEntityManagerFactory("jpa-hibernate-sqlserver");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	
	private JPAConfig() {
		
	}
	
	public static EntityManager getEntityManager() {
		return emf.createEntityManager();
	}
}
 