-- Setup Script
-- Step 1: Create the seeds table 🌸🌿
CREATE OR REPLACE TABLE seed_packs (
    gardener STRING,
    seeds ARRAY
);

-- Step 2: Insert your spring options🌼🌼
INSERT INTO seed_packs 
SELECT 'Luna', ARRAY_CONSTRUCT(5, 10, 15)
UNION ALL
SELECT 'Sol', ARRAY_CONSTRUCT(7, 8, 9)
UNION ALL
SELECT 'Anna', ARRAY_CONSTRUCT(4, 12, 18)
UNION ALL
SELECT 'Daniel', ARRAY_CONSTRUCT(6, 8, 2);

select * from seed_packs;

-- This was my first thought, but it doesn't work. 
-- 000002 (0A000): Unsupported feature 'spread argument with non-constant array input'.
select gardener, SUM(seeds) from seed_packs;

-- How to simply sum? The "old" way
-- could also use `gardener` col to agg back to rows but the SEQ8() will work if there's no pk
WITH numbered AS (
  SELECT
    SEQ8() AS row_num,
    gardener,
    seeds
  FROM seed_packs
)
SELECT
  gardener,
  seeds,
  SUM(f.value::INTEGER) AS array_sum
FROM numbered,
     LATERAL FLATTEN(input => seeds) f
GROUP BY 1,2;

-- Can we solve it the requested way, using ** ?  
CREATE OR REPLACE FUNCTION my_udf(a FLOAT, b FLOAT, c FLOAT)
RETURNS FLOAT
AS
$$
  a + b + c
$$;

-- This now works with the spread operator:
SELECT MY_UDF(**ARRAY_CONSTRUCT(1, 2, 3));

-- And this works:
select my_udf(seeds[0], seeds[1], seeds[2])
from seed_packs;

-- But this fails with the same error as before 
select gardener, MY_UDF(**seeds) from seed_packs;


-- real life solution:
SELECT gardener, seeds, SUM(f.value::FLOAT) AS array_sum
FROM seed_packs,
     LATERAL FLATTEN(input => seeds) f
GROUP BY 1,2;



