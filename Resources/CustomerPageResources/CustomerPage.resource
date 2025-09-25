*** Settings ***
Library    ../../Library/CustomLibrary.py
Variables  ../../Variables/customerpage.py
Resource   ../App.resource
Resource   Task_1.resource
Resource   Task_2.resource
Resource   Task_3.resource
Resource   Task_4.resource
Resource   Task_5.resource


*** Keywords ***
TASK 1: ADD FIRST 5 CUSTOMERS
    ${customers}    Get Random Customers
    Set Suite Variable    ${customers}
    Go To Customers Page

    ${Verified_Customers}    Create List
    Set Suite Variable    ${Verified_Customers}

    FOR    ${customer}    IN    @{customers}
        Create Customer    ${customer}
        Verify Customer Input    ${customer}
    END


TASK 2: VERIFY TABLE DISPLAY
    ${Verified_Customers}    Create List
    Set Suite Variable    ${Verified_Customers}

    ${total}    Get Length    ${customers}
    ${end}      Evaluate    ${total} + 1
    FOR    ${index}    IN RANGE    1    ${end}
        ${customer_index}    Evaluate    ${total} - ${index}
        ${customer}    Set Variable    ${customers}[${customer_index}]
        Verify Customer Data    ${customer}    ${index}
    END

TASK 3: UPDATE EXISTING CUSTOMERS
    ${customers}    Get Random Customers    5    5   
    Update Customer Table    ${customers}

TASK 4: LOG TABLE DATA
    Get Table Row Data

TASK 5: ANALYZE USER SPENDING
    Get Expense Report