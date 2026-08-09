/*====================================================
           BLINKIT BUSINESS ANALYSIS
======================================================*/

/*=========================================================
			CUSTOMER PURCHASE BEHAVIOUR ANALYSIS
===========================================================*/

/*
Business Question 1: Which payment methods are preferred by different customer segments?

Objective: Analyze the payment preferences of each customer segment to understand customer purchasing behaviour and identify
		   opportunities for targeted payment promotions.

Tables Used: • customers 
             • orders
*/

-- SQL Query

Select customer_segment,payment_method,COUNT(order_id) AS total_orders
FROM customers
JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY customer_segment, payment_method
ORDER BY customer_segment, total_orders DESC; 

/*
Key Finding: • Payment preferences are relatively balanced across all customer segments. 
             • While slight variations exist no payment method showed a clear dominance within any customer segment.
             
Business Interpretation: • The analysis suggests that customer segment alone is not a strong indicator of payment method preference. 
                         • Customers across all segments appear comfortable using multiple payment options, with differences in usage being relatively small.
                         
Recommendation: • Maintain support and promotional offers across all major payment methods.
                • Instead of analyzing segment-based payment consider analyzing payment preferences based on other factors such as order value, purchase frequency,
                  location, or time of purchase, which may reveal stronger behavioural patterns influencing payment method preference.
*/

/* =========================================================
                 REVENUE ANALYSIS
   ========================================================= 

Business Question 1: Which brands contribute the highest revenue to the business?

Objective: To identify highest revenue generating brands to support and prioritize various business operations

Tables Used: • order_items 
             • products
*/

-- SQL Query:

Select products.brand as Brand_Name , Sum(order_items.quantity*order_items.unit_price) as Revenue from products 
join  order_items 
on products.product_id = order_items.product_id
group by products.brand 
order by Revenue Desc
Limit 10;
/* 
Key Finding: • Chahal Group generated the highest revenue (₹18,807.72), followed by Sundaram Inc (₹16,962.66) and Gole-Doshi (₹16,931.66).
             • While the top few brands lead in revenue generation, the remaining brands have relatively closer revenue figures, indicating a competitive
			   distribution among them.

Business Interpretation: • A small set of high-performing brands contributes significantly to Blinkit's overall revenue.
						 • These brands represent valuable business partners and should receive greater focus during inventory planning, supplier management, and
						   promotional activities.
Recommendation: • Prioritize inventory availability for high-revenue brands to minimize stock-outs.
                • Strengthen partnerships with top-performing brands through exclusive promotions and inventory preferences to maximize revenue potential.
*/
/* 
Business Question 2 : Which high-revenue brands also offer high profit margins?

Objective: To identify high revenue generating brands having highest profit margin from available dataset

Tables Used: • products
             • order_items
*/
 -- SQL Query
  
Select products.brand as Brand_Name , Sum(order_items.quantity*order_items.unit_price) as Revenue, Avg(margin_percentage) as Profit_Margin from products 
join  order_items 
on products.product_id = order_items.product_id
group by products.brand 
order by Revenue Desc , Profit_Margin Desc
Limit 10;

/* 
Key Findings: • Chahal Group generated the highest revenue (₹18,807.72) but operates with a relatively low average profit margin of 20%.
			  • Bahl-Pau ranks among the top revenue-generating brands while maintaining a significantly higher average profit margin of 35%.
              • Most of the top revenue-generating brands have average profit margins ranging between 20% and 30%, 
                indicating that higher revenue does not always correspond to higher profitability.
	
Business Interpretation: • Revenue alone should not be the only metric for evaluating brand performance.
                         • Brands generating strong revenue with higher profit margins contribute more effectively to overall business profitability 
                         and should receive greater attention when planning business operations.
                         
Recommendation: • While maintaining strong relationships with the highest revenue-generating brands, 
				  Blinkit should also prioritize brands that combine decent revenue but higher profit margins.
                • Marketing and inventory investments should consider both revenue contribution and profit margins instead of solely relying on sales performance.
*/
/*
Business Question 3 : Do brands offering higher average discounts also achieve higher revenue contribution, or do they sacrifice profitability?

Objective: To identify average discounts by brands and how is it impacting their revenue contribution and profitability

Tables Used: • products 
             • order_items
*/
 
 -- SQL Query
  
select brand as BRAND , Sum(order_items.quantity*order_items.unit_price) as Revenue ,  avg(((mrp - price)/mrp)*100) as Average_Discount, avg(margin_percentage) as Profit_Margin from products join order_items 
on products.product_id = order_items.product_id
group by BRAND
order by  Revenue Desc , Average_Discount desc 
limit 10;
/* 
Key Findings: • Chahal Group generated the highest revenue (₹18,807.72) while maintaining an average discount of 20% and a profit margin of 20%.
              • Bahl-Pau generated the fourth-highest revenue despite offering a significantly higher average discount (35%) and maintaining a similar profit margin (35%).
			  • Among the top revenue-generating brands, discount percentages vary from 20% to 35%, indicating that successful brands follow different pricing strategies.
              
Business Interpretation: • The analysis suggests that higher discounts do not necessarily guarantee the highest revenue generation.
                         • Some brands have higher revenues with relatively lower discounts while others rely on higher discounts to remain competitive.
					     • Pricing strategy alone is insufficient to explain revenue performance; factors such as product demand, brand popularity and customer preferences 
						   also likely to influence sales.
                         
Recommendation: • Blinkit should avoid relying solely on discounting as a revenue growth strategy.
                • Pricing decisions should be evaluated alongside customer demand, brand strength and profitability to maximize long-term business performance.
                • Further analysis using sales volume and customer purchase behaviour is recommended before making pricing decisions.
*/

/* =========================================================
                    INVENTORY ANALYSIS
   ========================================================= 

Business Question 1: Which products experience the highest damaged stock?

Objective: Identify products with the highest damaged inventory to help reduce inventory losses and improve warehouse handling practices.

Tables Used: • products  
             • inventory

*/

-- SQL QUERY

select products.product_name, products.category as Product_Category,  sum(inventory.damaged_stock) as Number_of_Damaged_Stock from products join inventory 
on products.product_id = inventory.product_id
group by Product_Category, products.product_name
order by Number_of_Damaged_Stock Desc
limit 10;

/*
Key Findings: • Pet Treats recorded the highest damaged inventory (126 units), followed by Toilet Cleaner (116 units) and Dish Soap (114 units).
              • Household Care products appear twice in the top three damaged products, indicating that this category experiences relatively higher inventory losses.
              • Damage is not limited to perishable products, as non-food categories such as Household Care and Personal Care also report significant damaged stock.

Business Interpretation: • High damaged stock directly increases inventory holding costs and reduces overall profitability.
                         • The concentration of damaged products in Household Care suggests that storage, packaging, or handling practices for this category may require improvement.
                         • Frequent damage in high-demand products can also lead to stock shortages and reduced customer satisfaction 
                           if inventory is not replenished promptly.

Recommendations: • Conduct a root-cause analysis for products with consistently high damaged stock, particularly Pet Treats and Household Care items.
				 • Improve warehouse handling procedures and packaging standards for damage-prone products.
				 • Monitor damaged inventory regularly and establish category-specific quality control measures to minimize inventory losses.
*/

/*
Business Question 2: Which products have the smallest inventory buffer and are most vulnerable to stock shortages?

Objective: To identify products with the smallest inventory buffer so that inventory planners can reduce the risk of stockouts and improve product availability.
 
Tables Used: • products
			 • inventory

*/

-- SQL Query 

SELECT product_name,category,SUM(stock_received) AS Total_Stock_Received,SUM(damaged_stock) AS Total_Damaged_Stock,SUM(stock_received) - SUM(damaged_stock) AS Available_Stock,min_stock_level,max_stock_level,(max_stock_level - min_stock_level) AS Inventory_Buffer
FROM products
JOIN inventory
ON products.product_id = inventory.product_id
GROUP BY product_name, category,min_stock_level,max_stock_level
ORDER BY Inventory_Buffer Asc
LIMIT 10;

/*
Key Findings: • Dog Food has the smallest inventory buffer (23 units), making it the most vulnerable product to stock shortages.
			  • Multiple Cola product variants appear among the top 10, with some variants showing negative available stock (-3 and -4 units)
                indicating inventory deficits.
              • Cough Syrup also has negative available stock (-1 unit), suggesting that damaged stock exceeded inventory received during the observed period.
              • Several essential products such as Bread, Carrots, Onions and Lotion operate with relatively small inventory buffers (25–28 units)
				which can lead to limited supply in times of high demand
			
Business Interpretation: • Products with a small inventory buffer need closer monitoring because they can reach low stock levels faster than others.
                         • Negative available stock may indicate inventory recording issues or high product damage, which should be checked by the inventory team.
                         • Maintaining very low inventory for regularly purchased products can affect product availability if demand suddenly increases.
				
Recommendations: • Increase the safety stock for products that have a consistently small inventory buffer.
                 • Review products showing negative available stock to identify inventory or operational issues.
                 • Track inventory levels regularly and replenish stock before products reach their minimum stock level.
*/
/*
Business Question 3: Which brands receive the highest inventory replenishment and does higher replenishment also result in higher available stock?

Objective: To analyze inventory replenishment across brands and understand whether brands receiving more stock also maintain higher available inventory.

Tables Used: • products 
             • inventory
*/

-- SQL Query
select brand, SUM(stock_received) as Total_Stock_Recieved, sum(damaged_stock) as Total_Damaged_Stock , (SUM(stock_received) - sum(damaged_stock)) as Available_Stock 
from products
join inventory
on products.product_id = inventory.product_id
group by brand
order by Available_Stock Desc
limit 10;
/*
Key Findings: • Suresh, Bose and Bajwa has the highest available stock (31 units) after accounting for damaged inventory.
              • Ranganathan-Peri, Deo-Kamdar and Karan, Bandi and Acharya also maintain relatively high available stock despite inventory losses.
              • Some brands received a high amount of stock but also experienced higher damaged stock, reducing the final available inventory.
              
Business Interpretation: • Higher stock received does not always result in higher available stock, as damaged inventory also affects the final stock available for sale.
                         • Brands with consistently higher available stock are less likely to face immediate inventory shortages.

Recommendations: • Monitor both stock received and damaged stock together instead of tracking only inventory replenishment.
                 • Focus on reducing damaged inventory so that a larger proportion of received stock remains available for customers.
                 
*/

/* 
Business Question 4: Which product categories experience the highest inventory loss due to damaged stock?

Objective: To identify product categories with the highest percentage of damaged inventory so that inventory losses can be reduced.

Tables Used: • products 
             • inventory
*/

-- SQL Query

SELECT category,SUM(stock_received) AS Total_Stock_Received,SUM(damaged_stock) AS Total_Damaged_Stock,ROUND((SUM(damaged_stock) * 100.0 / SUM(stock_received)),2) AS Damage_Percentage
from products
join inventory
on products.product_id = inventory.product_id
Group by category
Order by Damage_Percentage desc
limit 10;

/*

Key Findings: • Personal Care has the highest inventory damage rate at 68.62%, indicating that more than two-thirds of the received stock was damaged.
              • Snacks & Munchies (62.27%) and Household Care (60.96%) also show high inventory damage percentages.
			  • Even the category with the lowest damage rate (Pet Care) records over 50% damaged inventory, suggesting consistently high inventory losses across all categories.

Business Interpretation: • Certain product categories are experiencing significantly higher inventory losses, which directly reduces the stock available for customers.
                         • Since all categories have damage rates above 50%, inventory handling and storage practices may require improvement
                           across the supply chain rather than in just one category.

Recommendations: • Review storage and handling procedures for categories with the highest damage percentages, especially Personal Care and Snacks & Munchies.
                 • Conduct regular inventory audits to identify the main causes of damaged stock and implement preventive measures to reduce inventory losses.
                 
*/
/* =========================================================
			   CUSTOMER FEEDBACK ANALYSIS
   ========================================================= 
   
   Business Question 1 : Which feedback categories receive the lowest average customer ratings?
   
   Objective: To identify the feedback categories with the lowest average customer ratings so that improvement efforts can be focused 
              on the areas causing the greatest customer dissatisfaction.
              
   Tables Used: customer_feedback
   
*/

-- SQL QUERY

select feedback_category, Count(*) as Total_Feedback , Avg(rating) as Average_Rating from customer_feedback
group by feedback_category
order by Average_Rating ASC;

/*
 Key Findings: • Product Quality received the lowest average customer rating (3.32), making it the most critical area for improvement.
               • Delivery (3.33) also received relatively low ratings, indicating that delivery experience continues to influence customer satisfaction.
               • Customer Service recorded the highest average rating (3.37), although the difference compared to other categories is relatively small.
			   • The average ratings across all feedback categories are close to each other (3.31–3.37), suggesting that customer satisfaction is fairly consistent across different service areas.
               
Business Interpretation: • Product Quality and Delivery should be prioritized for improvement as they receive comparatively lower customer ratings.
                         • Since the differences in ratings are small, improving even one aspect of the customer experience could positively impact overall customer satisfaction.
                         
Recommendations: • Regularly monitor customer feedback related to Product Quality and Delivery to identify recurring issues.
                 • Use detailed customer comments to understand the specific reasons behind lower ratings and implement corrective actions.
*/
/*
Business Question 2: How does delivery status affect customer ratings?

Objective: To analyze whether delivery performance has an impact on customer satisfaction.

Tables Used:• customer_feedback
            • delivery_performance
*/
-- SQL Query
SELECT
    delivery_performance.delivery_status,
    COUNT(*) AS Total_Feedback,
    ROUND(AVG(customer_feedback.rating),2) AS Average_Rating

FROM customer_feedback
JOIN delivery_performance
ON customer_feedback.order_id = delivery_performance.order_id

GROUP BY delivery_performance.delivery_status

ORDER BY Average_Rating ASC;
/*
Key Findings: • Orders that were significantly delayed received the lowest average customer rating (3.17).
              • Orders delivered on time received the highest average rating (3.41).
              • Slightly delayed orders (3.40) received ratings very close to on-time deliveries
              suggesting that minor delays have a limited impact on customer satisfaction.

Business Interpretation: • Significant delivery delays have a noticeable negative impact on customer satisfaction.
                         • Customers appear to be more accepting of small delays, but longer delays are more likely to reduce their overall experience.

Recommendations: • Focus on reducing significantly delayed deliveries by improving delivery planning and route management.
				 • Prioritize identifying the causes of major delivery delays, as reducing them can directly improve customer satisfaction.
*/                 
/*
Business Question 3: How does customer sentiment relate to customer ratings?

Objective: To analyze whether customer sentiment aligns with the ratings provided by customers.

Tables Used: customer_feedback
*/

-- SQL Query

select sentiment, count(*) AS Total_Feedback, AVG(rating) AS Average_Rating
from customer_feedback
group by sentiment
order by Average_Rating ASC;

/*
Key Findings: • Positive feedback has the highest average rating (4.50), while negative feedback has the lowest average rating (2.01).
              • Neutral feedback has an average rating of 3.52, falling between positive and negative responses.
              • The average ratings closely align with the assigned sentiment labels, indicating consistency in customer feedback. 
			
Business Interpretation: • Customer sentiment accurately reflects the ratings given by customers, making it a reliable indicator of customer satisfaction.
                         • Since negative feedback is associated with significantly lower ratings, 
                         analyzing negative customer comments can help identify areas requiring immediate attention.

Recommedations: • Regularly monitor negative customer feedback to identify recurring issues and improve customer experience.
                • Use sentiment analysis alongside customer ratings to prioritize service improvements and measure the impact of corrective actions.
	
/* =========================================================
                  MARKETING ANALYSIS
   ========================================================= 
   
Business Question 1: Which marketing channels generate the highest Return on Ad Spend (ROAS)?

Objective:To identify the most effective marketing channels based on their Return on Ad Spend (ROAS) so that marketing budget can be allocated more efficiently.

Tables Used: marketing_performance
*/
-- SQL QUERY

select channel, round(AVG(roas),2) as Average_ROAS,round(sum(spend),2) as Total_Spend, round(sum(revenue_generated),2) as Total_Revenue
from marketing_performance
group by channel
order by Average_ROAS desc;
/*
Key Findings: • App and SMS campaigns recorded the highest average ROAS (2.78), making them the best performing marketing channels.
			  • Email generated the highest total revenue (₹14,58,893), even though its average ROAS (2.74) was slightly lower than App and SMS.
              • Social Media had the lowest average ROAS (2.70) among all channels.
              • The difference in ROAS across all marketing channels is relatively small, indicating that all channels perform at a similar level.
			
Business Interpretation: • No single marketing channel clearly outperforms the others in terms of ROAS.
                         • Email contributes the highest revenue, while App and SMS provide slightly better returns for every rupee spent.
						 • Since the performance differences are small, marketing decisions should also consider campaign objectives and 
                           target audience instead of relying only on ROAS.
						
Recommendations: • Continue investing across all marketing channels while regularly monitoring their performance.
                 • Optimize Social Media campaigns to improve their return on ad spend.
				 • Evaluate both revenue generation and ROAS before allocating future marketing budgets.
*/
/*
Business Question 2: Which marketing campaigns achieve the highest conversion rate?

Objective: To identify campaigns that convert the highest percentage of clicks into customers.

Tables Used: marketing_performance

 */
 -- SQL QUERY
 
select campaign_name, round((sum(conversions)/sum(clicks))*100,2) as Conversion_Rate,sum(clicks) as Total_Clicks, sum(conversions) as Total_Conversions
from marketing_performance
group by campaign_name
order by Conversion_Rate desc;
/*
Key Findings: • Referral Program achieved the highest conversion rate (11.02%), making it the most effective campaign in converting clicks into customers.
              • Weekend Special (10.71%) and Flash Sale (10.08%) also performed well with conversion rates above 10%.
              • Email Campaign recorded the lowest conversion rate (9.02%) among all campaigns.
			  • Overall, the conversion rates of all campaigns range between 9% and 11%, indicating fairly consistent campaign performance.
		
Business Interpretation: • Referral-based campaigns appear to be more effective in converting potential customers compared to other marketing campaigns.
                         • Since the difference in conversion rates is relatively small, factors such as campaign cost and revenue generated 
                           should also be considered while evaluating campaign performance.

Recommendations: • Continue using Referral Programs and Weekend Special campaigns as they deliver strong conversion performance.
                 • Review Email Campaign strategies to identify opportunities for improving customer engagement and conversions.
                 • Evaluate campaign performance using both conversion rate and ROAS before making future marketing decisions.
*/
/*
Business Question 3: Which target audience generates the highest revenue?

Objective: To identify the customer segments contributing the highest marketing revenue and support better campaign targeting.

Tables Used: marketing_performance
*/
-- SQL Query

select target_audience,round(sum(revenue_generated),2) as Total_Revenue,round(sum(spend),2) as Total_Spend,round(avg(roas),2) as Average_ROAS
from marketing_performance
group by  target_audience
order by Total_Revenue desc;
/*
Key Findings: • Inactive customers generated the highest revenue (₹14,11,006), making them the highest revenue contributing target audience.
              • The (All) audience segment recorded the highest average ROAS (2.80), indicating the best return on marketing spend.
              • Premium and New Users generated similar levels of revenue and ROAS.
              • Overall, the performance differences between the target audiences are relatively small.
              
Business Interpretation: • Different target audiences perform well on different metrics. While Inactive customers generate the highest revenue, campaigns targeting all customers provide the highest return on investment.
                         • Since the performance gap between audience groups is small, marketers should consider both campaign objectives and ROAS 
                           before selecting a target audience.

Recommendations: • Continue targeting inactive customers through re-engagement campaigns as they contribute the highest revenue.
                 • Use broader campaigns targeting all customers when the objective is to maximize return on marketing spend.
                 • Regularly compare campaign performance across different audience segments to improve marketing efficiency.
*/


/*
Business Question 3 : Does higher marketing spend always result in higher revenue generation?

Objective: To evaluate whether campaigns with higher marketing investment consistently generate higher revenue.

Tables Used: marketing_performance
*/

-- SQL QUERY

select campaign_name,round(sum(spend),2) as Total_Spend,round(sum(revenue_generated),2) as Total_Revenue,round(avg(roas),2) as Average_ROAS
from marketing_performance
group by campaign_name
Order by Total_Spend Desc;

/*
Key Findings: • Membership Drive recorded the highest marketing spend (₹3,33,124), but it did not generate the highest revenue.
              • Email Campaign achieved the highest ROAS (2.90) despite having lower marketing spend than several other campaigns.
              • Flash Sale and Membership Drive also performed well with a ROAS of 2.81.
              • The results show that campaigns with higher marketing spend do not always generate higher revenue or better returns.
              
Business Interpretation: • Increasing marketing spend alone does not guarantee better campaign performance.
                         • Campaign efficiency, measured through ROAS, plays an equally important role while evaluating marketing success.
                         
Recommendations: • Allocate future marketing budgets based on campaign performance rather than spending alone.
                 • Study the strategies used in high-ROAS campaigns such as Email Campaign and Flash Sale to improve the performance of other campaigns.
                 • Regularly monitor campaign ROAS to ensure marketing investments generate maximum returns.
                 
/*====================================================
		 ADVANCED SQL ANALYSIS SECTION
======================================================*/              

