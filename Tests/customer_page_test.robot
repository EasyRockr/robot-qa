*** Settings ***
Library   ../Library/CustomLibrary.py
Resource  ../Resources/Login.resource
Resource  ../Resources/App.resource
Resource  ../Resources/CustomerPageResources/CustomerPage.resource

Suite Setup   Launch Browser
Suite Teardown   Close All Browsers


*** Test Cases ***
TEST-000001
   [Documentation]    TASK 1 & TASK 2: Login to React Admin demo site, add 5 random customers, verify data.
   Login User
   Sleep    5s
   # In case of a "Google Password Breach Warning" prompt, kindly use either (whichever works best po): Sleep    10s OR     Wait Until Element Is Visible    ${dashboard_hdr}    10s
   TASK 1: ADD FIRST 5 CUSTOMERS
   TASK 2: VERIFY TABLE DISPLAY
 
TEST-000002
   [Documentation]    TASK 3: Update existing customers with new random data and verify
   TASK 3: UPDATE EXISTING CUSTOMERS

TEST-000003
   [Documentation]    TASK 4: Log table data for each row (Name, Last seen, Orders, etc.)
   TASK 4: LOG TABLE DATA

TEST-000004
   [Documentation]    TASK 5: Analyze user spending and validate threshold
   TASK 5: ANALYZE USER SPENDING