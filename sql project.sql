	use draugs 
    
    select* from regactiondate;
select * from DocType_Lookup;

---  Determine the number of drugs approved each year and provide insights into the yearly trends.
SELECT 
    YEAR(ActionDate) AS approval_year,
    COUNT(*) AS num_drugs_approved
FROM 
    Regactiondate
WHERE 
    ActionType = 'AP' 
GROUP BY 
    YEAR(ActionDate)
ORDER BY 
    approval_year ASC;
 
---- Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively

SELECT 
    YEAR(ActionDate) AS approval_year,
    COUNT(*) AS num_approvals
FROM 
    Regactiondate
WHERE 
    ActionType = 'AP' 
GROUP BY 
    YEAR(ActionDate)
ORDER BY 
    num_approvals ASC
Limit 3;    

SELECT 
    YEAR(ActionDate) AS approval_year,
    COUNT(*) AS num_drugs_approved
FROM 
    Regactiondate
WHERE 
    ActionType = 'AP' 
GROUP BY 
    YEAR(ActionDate)
ORDER BY 
    approval_year desc
Limit 3;   
 
---Explore approval trends over the years based on sponsors.
 
select* from Application;
SELECT 
    YEAR(r.ActionDate) AS approval_year,
    a.SponsorApplicant,
    COUNT(*) AS num_approvals
FROM 
    Regactiondate r
join
Application a on r.ApplNo = a.ApplNo   
WHERE 
    r.ActionType = 'AP'  
GROUP BY 
    YEAR(r.ActionDate),
    a.SponsorApplicant
ORDER BY 
    approval_year ASC,
    num_approvals DESC;

--- Rank sponsors based on the total number of approvals they received each year between 1939 and 1960

SELECT 
    YEAR(r.ActionDate) AS approval_year,
    a.SponsorApplicant,
    COUNT(*) AS num_approvals
FROM 
    Regactiondate r
join
Application a on r.ApplNo = a.ApplNo   
WHERE 
    r.ActionType = 'AP'  and year(r.ActionDate) between 1939 and 1960
GROUP BY 
    YEAR(r.ActionDate),
    a.SponsorApplicant
ORDER BY 
    approval_year ASC,
    num_approvals DESC;

select * from  Product;
--- Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
SELECT 
    ProductMktStatus,
    COUNT(*) AS num_products
FROM 
    product
GROUP BY 
    ProductMktStatus
ORDER BY 
    num_products DESC;

--- Calculate the total number of applications for each MarketingStatus year-wise after the year 2010. 
SELECT 
    YEAR(r.ActionDate) AS approval_year,
		p.ProductMktStatus,
    COUNT(*) AS num_applications
FROM 
    RegActionDate r
JOIN 
    Product p ON r.ApplNo = p.ApplNo
WHERE 
    YEAR(r.ActionDate) > 2010
GROUP BY 
    YEAR(r.ActionDate),
    p.ProductMktStatus
ORDER BY 
    approval_year ASC,
    num_applications DESC;

--- Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.-- Identify the top MarketingStatus with the maximum number of applications
SELECT 
    ProductMktStatus,
    COUNT(*) AS num_applications
FROM 
    Product P
JOIN 
    RegActionDate r ON P.ApplNO = r.ApplNO
GROUP BY 
    ProductMktStatus
ORDER BY 
    num_applications DESC
LIMIT 1;

-- Analyze the trend over time for the top MarketingStatus


SELECT
    ActionDate,
    COUNT(*) AS NumApplications
FROM
    RegActionDate r
 JOIN
    product p ON  r.ApplNo = p.ApplNo
GROUP BY
     ActionDate
ORDER BY
     ActionDate;



--- Categorize Products by dosage form and analyze their distribution.
SELECT 
    Dosage,
    COUNT(*) AS num_products
FROM 
    Product
GROUP BY 
    Dosage
ORDER BY 
    num_products DESC;
    
---- Calculate the total number of approvals for each dosage form and identify the most successful forms    
SELECT  Dosage,COUNT(*) AS num_products
FROM 
    Product
GROUP BY 
    Dosage
ORDER BY 
    num_products DESC
limit 1;    

---Investigate yearly trends related to successful forms. 
SELECT 
    YEAR(r.ActionDate) AS approval_year,
    p.Dosage,
    COUNT(*) AS num_approvals
FROM 
    Product p
JOIN 
    RegActionDAte r ON p.ApplNo = r.ApplNO
WHERE 
    p.Dosage = (
        SELECT 
		    Dosage
        FROM 
            (
            SELECT 
                Dosage,
                COUNT(*) AS num_approvals
            FROM 
                Product
            GROUP BY 
                Dosage
            ORDER BY 
                num_approvals DESC
            LIMIT 1
            ) AS successful_form
    )
GROUP BY 
    approval_year,
    p.Dosage
ORDER BY 
    approval_year ASC;
    
  --- Analyze drug approvals based on therapeutic evaluation code (TE_Code)  
    
 SELECT 
    YEAR(r.ActionDate) AS approval_year,
    d.TECode,
    COUNT(*) AS num_approvals
FROM 
    Product_TECode d
JOIN 
    RegActionDate r ON d.ApplNo = r.ApplNO
    where ActionType = 'AP'
GROUP BY 
    approval_year,
    d.TECode
ORDER BY 
    approval_year ASC, 
    num_approvals DESC;
   
  --- Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.

WITH ApprovalCounts AS (
    SELECT 
        YEAR(o.ActionDate) AS Year,
        d.TECode,
        COUNT(*) AS Approval_Count
    FROM 
	    Product_TECode d
    JOIN 
        RegActionDate o ON d.ApplNo = o.ApplNo
    GROUP BY 
        Year, d.TECode
)
SELECT 
    Year,
    TECode,
    Approval_Count
FROM 
    ApprovalCounts
WHERE 
    (Year, Approval_Count) IN (
        SELECT 
            Year,
            MAX(Approval_Count) AS Max_Approval_Count
        FROM 
            ApprovalCounts
        GROUP BY 
            Year
    )
ORDER BY 
    Year;
