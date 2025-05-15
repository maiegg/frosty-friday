create or replace user wk32_user_1;
create or replace user wk32_user_2;


-- Set user 1 policy 
create or replace session policy wk32_user_1_policy 
    SESSION_UI_IDLE_TIMEOUT_MINS = 8
;

alter user wk32_user_1
set session policy wk32_user_1_policy;


-- Set user 2 policy 
create or replace session policy wk32_user_2_policy
    SESSION_IDLE_TIMEOUT_MINS = 10
;
alter user wk32_user_2
set session policy wk32_user_2_policy;

show session policies;
-- Seems like the policies are enforced/in place. 