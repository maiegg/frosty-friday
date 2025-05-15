# The Snowpark package is required for Python Worksheets. 
# You can add more packages by selecting them using the Packages control and then importing them.

import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
import pandas as pd 

def main(session: snowpark.Session): 

    stmt1 = 'We Love Frosty Friday'.split(' ')
    stmt2 = 'Python Worksheets Are Cool'.split(' ')

    df = session.create_dataframe(
        tuple(zip(stmt1, stmt2))
        , schema=["STATEMENT1", "STATEMENT2"]
      )
    
    return df 