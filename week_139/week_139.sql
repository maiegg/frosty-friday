select id
, student
, rating
, snowflake.cortex.ENTITY_SENTIMENT(review_text,['Overall','Content','Teaching']) as sentiment
from week_139
limit 10;