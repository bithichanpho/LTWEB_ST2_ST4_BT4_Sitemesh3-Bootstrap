package dto;

import entity.Category;

/**
 * DTO gom số liệu thống kê của một Category cho trang Dashboard:
 * số sản phẩm, tổng số lượng đã bán, tổng doanh thu và tỷ trọng doanh thu
 * so với toàn cửa hàng (dùng để vẽ thanh bar % trên giao diện).
 */
public class CategoryStat {

	private Category category;
	private int productCount;
	private int totalSold;
	private double totalRevenue;
	private double revenuePercent; // 0 - 100, tỷ trọng so với tổng doanh thu toàn cửa hàng

	public CategoryStat(Category category) {
		this.category = category;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public int getProductCount() {
		return productCount;
	}

	public void setProductCount(int productCount) {
		this.productCount = productCount;
	}

	public int getTotalSold() {
		return totalSold;
	}

	public void setTotalSold(int totalSold) {
		this.totalSold = totalSold;
	}

	public double getTotalRevenue() {
		return totalRevenue;
	}

	public void setTotalRevenue(double totalRevenue) {
		this.totalRevenue = totalRevenue;
	}

	public double getRevenuePercent() {
		return revenuePercent;
	}

	public void setRevenuePercent(double revenuePercent) {
		this.revenuePercent = revenuePercent;
	}
}
